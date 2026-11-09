#!/usr/bin/env python3
"""Differential test: run each reversible Janus program on many random inputs
and check its result against a trusted Python reference implementation.

This is the correctness oracle the PyJanus corpus does NOT provide (that
checks reversibility + interpreter agreement, not algorithmic correctness).

  PYJANUS=<path> python3 tools/reftest.py [--cases N] [--seed S]

Each algorithm registers: the procedure source file, a builder that emits a
`main()` for a given random input, an extractor that reads the answer from the
final store, a Python reference, and an input generator.
"""
from __future__ import annotations
import os, sys, argparse, random, io, contextlib

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PYJANUS = os.environ.get(
    "PYJANUS", os.path.join(os.path.dirname(REPO), "PyJanus"))  # sibling checkout
sys.path.insert(0, PYJANUS)
from jana_py.parser_jana2014 import parse_program
from jana_py.runtime import Runtime

def procs_of(relpath):
    """Return everything in a .j file except its main() procedure."""
    src = open(os.path.join(REPO, relpath)).read()
    idx = src.find("procedure main()")
    return src[:idx] if idx >= 0 else src

def run_store(src):
    prog = parse_program("<reftest>", src)
    rt = Runtime(prog); rt.run()
    out = {}
    for k, c in rt._root_frame.vars.items():
        v = c.value
        out[k] = list(v) if isinstance(v, (list, tuple)) else v
    return out

def inits(name, values):
    return "".join(f"  {name}[{i}] += {v}\n" for i, v in enumerate(values) if v)

# ---- reference implementations ---------------------------------------------
import math
def ref_lcs(x, y):
    m, n = len(x), len(y); L = [[0]*(n+1) for _ in range(m+1)]
    for i in range(1, m+1):
        for j in range(1, n+1):
            L[i][j] = L[i-1][j-1]+1 if x[i-1]==y[j-1] else max(L[i-1][j], L[i][j-1])
    return L[m][n]
def ref_edit(x, y):
    m, n = len(x), len(y); D = [[0]*(n+1) for _ in range(m+1)]
    for i in range(m+1): D[i][0] = i
    for j in range(n+1): D[0][j] = j
    for i in range(1, m+1):
        for j in range(1, n+1):
            D[i][j] = D[i-1][j-1] if x[i-1]==y[j-1] else 1+min(D[i-1][j], D[i][j-1], D[i-1][j-1])
    return D[m][n]

# ---- algorithm registry ----------------------------------------------------
ALGOS = {}
def register(name, **kw): ALGOS[name] = kw
# register(..., expect_fail="<one-line reason>") marks an algorithm that is
# KNOWN to diverge from its reference right now (a confirmed bug in the .j
# source, or a deliberate negative control). This keeps the registration --
# and thus the reftest coverage of that file -- instead of deleting it, which
# would make the corpus's L2 status for that file silently go back to
# "unregistered" (a検査していない state indistinguishable from "no bug found").
# Semantics (main(), below): fails==0 (all cases matched) is the ALARM case
# for an expect_fail entry -- it means the known bug seems to have vanished
# (fixed upstream, or this generator stopped exercising it) and is reported
# as XPASS / red, not silently accepted. fails>0 (the bug still reproduces)
# is XFAIL / green -- the expected, healthy state for a documented defect.

register("counting_sort",
    procs="csort/csort1.j",
    gen=lambda r: [r.randint(0, 7) for _ in range(r.randint(1, 10))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int b[{len(a)}]\n"
                     f"  int c[8]\n  int n\n  int k\n  n += {len(a)}\n  k += 8\n"
                     + inits("a", a) + "  call csort(a,n,b,c,k)\n"),
    extract=lambda s,inp: s["b"],
    ref=lambda a: sorted(a))

register("merge_sort",
    procs="msort/msort2.j",
    gen=lambda r: [r.randint(0, 20) for _ in range(r.choice([2,4,8]))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int ord[{len(a)}]\n"
                     f"  stack gbg\n  int gbfg\n  int p\n  int r\n"
                     + inits("a", a)
                     + "".join(f"  ord[{i}] += {i}\n" for i in range(len(a)) if i)
                     + f"  r += {len(a)-1}\n  call msort(a,p,r,ord)\n"),
    extract=lambda s,inp: s["a"],
    ref=lambda a: sorted(a))

register("gcd",
    procs="numeric/gcd.j",
    gen=lambda r: (lambda x, y: (max(x, y), min(x, y)))(r.randint(1, 200), r.randint(1, 200)),
    build=lambda ab: (f"procedure main()\n  int a\n  int b\n  stack log\n"
                      f"  a += {ab[0]}\n  b += {ab[1]}\n  call gcd(a,b,log)\n"),
    extract=lambda s,inp: s["a"],
    # subtractive Euclid loops forever if a==b at start; gen guarantees a>=b, and
    # a==b -> gcd immediately; reference matches math.gcd
    ref=lambda ab: math.gcd(ab[0], ab[1]),
    skip=lambda ab: ab[0] == ab[1])

register("lcs",
    procs="dp/lcs.j",
    gen=lambda r: ([r.randint(1,4) for _ in range(r.randint(1,7))],
                   [r.randint(1,4) for _ in range(r.randint(1,6))]),
    build=lambda xy: (lambda x, y, n:
        f"procedure main()\n  int x[{len(x)+1}]\n  int y[{len(y)+1}]\n  int m\n  int n\n"
        f"  int L[{(len(x)+1)*(len(y)+1)}]\n  m += {len(x)}\n  n += {len(y)}\n"
        + "".join(f"  x[{i+1}] += {v}\n" for i, v in enumerate(x))
        + "".join(f"  y[{j+1}] += {v}\n" for j, v in enumerate(y))
        + "  call lcs(x,m,y,n,L)\n")(xy[0], xy[1], len(xy[1])),
    extract=lambda s,inp: s["L"][len(inp[0])*(len(inp[1])+1) + len(inp[1])],
    ref=lambda xy: ref_lcs(xy[0], xy[1]))

register("edit_distance",
    procs="dp/edit_distance.j",
    gen=lambda r: ([r.randint(1,4) for _ in range(r.randint(1,6))],
                   [r.randint(1,4) for _ in range(r.randint(1,6))]),
    build=lambda xy: (lambda x, y:
        f"procedure main()\n  int x[{len(x)+1}]\n  int y[{len(y)+1}]\n  int m\n  int n\n"
        f"  int D[{(len(x)+1)*(len(y)+1)}]\n  m += {len(x)}\n  n += {len(y)}\n"
        + "".join(f"  x[{i+1}] += {v}\n" for i, v in enumerate(x))
        + "".join(f"  y[{j+1}] += {v}\n" for j, v in enumerate(y))
        + "  call edit_distance(x,m,y,n,D)\n")(xy[0], xy[1]),
    extract=lambda s,inp: s["D"][len(inp[0])*(len(inp[1])+1) + len(inp[1])],
    ref=lambda xy: ref_edit(xy[0], xy[1]))


register("disort",
    procs="isort/disort.j",
    gen=lambda r: r.sample(range(1, 40), r.randint(1, 8)),   # distinct keys
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int b[{len(a)}]\n  int n\n"
                     f"  n += {len(a)}\n" + inits("a", a) + "  call disort(a,n,b)\n"),
    extract=lambda s,inp: s["b"],
    ref=lambda a: sorted(a))

register("treesort",
    procs="treesort/treesort.j",
    gen=lambda r: [r.randint(1, 6) for _ in range(r.randint(1, 8))],  # duplicates ok
    build=lambda a: (lambda n:
        f"procedure main()\n  int a[{n}]\n  int b[{n}]\n  int key[{n+1}]\n"
        f"  int left[{n+1}]\n  int right[{n+1}]\n  int ht[{n+1}]\n  int cnt[{n+1}]\n"
        f"  int n\n  int root\n  int nfree\n  stack alog\n  stack hlog\n  stack rlog\n"
        f"  n += {n}\n  nfree += 1\n" + inits("a", a)
        + "  call treesort(a,n,b,key,left,right,ht,cnt,root,nfree,alog,hlog,rlog)\n")(len(a)),
    extract=lambda s,inp: s["b"],
    ref=lambda a: sorted(a))

def _rand_graph(r, V, p=0.45, wmax=9, directed=True):
    edges = []
    for u in range(V):
        for v in range(V):
            if u != v and r.random() < p:
                edges.append((u, v, r.randint(1, wmax)))
    return edges

def ref_bfs(adj, V, src):
    from collections import deque
    dist=[0]*V; vis=[0]*V; vis[src]=1; q=deque([src])
    while q:
        u=q.popleft()
        for v in range(V):
            if adj[u*V+v]==1 and not vis[v]:
                vis[v]=1; dist[v]=dist[u]+1; q.append(v)
    return dist, vis
def ref_floyd(path, V):
    d=[path[i*V:(i+1)*V] for i in range(V)]; d=[row[:] for row in d]
    for k in range(V):
        for i in range(V):
            for j in range(V):
                if d[i][k]+d[k][j] < d[i][j]: d[i][j]=d[i][k]+d[k][j]
    return [d[i][j] for i in range(V) for j in range(V)]
def ref_bellman(edges, V, src, INF):
    dist=[INF]*V; dist[src]=0
    for _ in range(V-1):
        for (u,v,w) in edges:
            if dist[u]<INF and dist[u]+w<dist[v]: dist[v]=dist[u]+w
    return dist

INF = 100000

def _gen_bfs(r):
    V = r.randint(3, 6); edges = _rand_graph(r, V, 0.4, 1)
    adj = [0]*(V*V)
    for (u,v,_) in edges: adj[u*V+v] = 1
    return {"V": V, "adj": adj}
register("bfs",
    procs="bfs/bfs.j",
    gen=_gen_bfs,
    build=lambda g: (lambda V, adj:
        f"procedure main()\n  int adj[{V*V}]\n  int v_n\n  int src\n  int dist[{V}]\n"
        f"  int visited[{V}]\n  int queue[{V}]\n  int head\n  int tail\n  stack blog\n"
        f"  v_n += {V}\n" + inits("adj", adj)
        + "  call bfs(adj,v_n,src,dist,visited,queue,head,tail,blog)\n")(g["V"], g["adj"]),
    extract=lambda s,g: (s["dist"], s["visited"]),
    ref=lambda g: ref_bfs(g["adj"], g["V"], 0))

def _gen_floyd(r):
    V = r.randint(3, 5); edges = _rand_graph(r, V, 0.5, 9)
    path = [0]*(V*V)
    for i in range(V):
        for j in range(V):
            if i != j: path[i*V+j] = INF
    for (u,v,w) in edges: path[u*V+v] = w
    return {"V": V, "path": path}
register("floyd_warshall",
    procs="floyd_warshall/floyd_warshall.j",
    gen=_gen_floyd,
    build=lambda g: (lambda V, path:
        f"procedure main()\n  int path[{V*V}]\n  int v_n\n  stack dlog\n  stack blog\n"
        f"  v_n += {V}\n" + inits("path", path)
        + "  call floyd_warshall(path,v_n,dlog,blog)\n")(g["V"], g["path"]),
    extract=lambda s,g: s["path"],
    ref=lambda g: ref_floyd(g["path"], g["V"]))

def _gen_bellman(r):
    V = r.randint(3, 5); edges = _rand_graph(r, V, 0.5, 9)
    return {"V": V, "edges": edges}
register("bellman_ford",
    procs="bellman_ford/bellman_ford.j",
    gen=_gen_bellman,
    build=lambda g: (lambda V, E:
        f"procedure main()\n  int e_n\n  int eu[{max(1,len(E))}]\n  int ev[{max(1,len(E))}]\n"
        f"  int ew[{max(1,len(E))}]\n  int v_n\n  int dist[{V}]\n  int pred[{V}]\n  int inf\n"
        f"  stack dlog\n  stack plog\n  stack rlog\n"
        f"  v_n += {V}\n  e_n += {len(E)}\n  inf += {INF}\n"
        + "".join(f"  eu[{i}] += {u}\n  ev[{i}] += {v}\n  ew[{i}] += {w}\n" for i,(u,v,w) in enumerate(E))
        + "".join(f"  dist[{i}] += {INF}\n" for i in range(1, V))
        + "".join(f"  pred[{i}] -= 1\n" for i in range(V))
        + ("  call bellman_ford(e_n,eu,ev,ew,v_n,dist,pred,inf,dlog,plog,rlog)\n" if E else ""))(g["V"], g["edges"]),
    extract=lambda s,g: s["dist"],
    ref=lambda g: ref_bellman(g["edges"], g["V"], 0, INF),
    skip=lambda g: len(g["edges"]) == 0)

register("bubble_sort",
    procs="bsort/bsort2.j",
    gen=lambda r: [r.randint(0, 30) for _ in range(r.randint(1, 8))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int sz\n  stack gb\n"
                     f"  sz += {len(a)}\n" + inits("a", a) + "  call bsort(a,sz,gb)\n"),
    extract=lambda s,inp: s["a"],
    ref=lambda a: sorted(a))

register("selection_sort",
    procs="ssort/ssort1.j",
    gen=lambda r: [r.randint(0, 30) for _ in range(r.randint(2, 8))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int n\n  int ftab[{len(a)}]\n"
                     f"  int p[{len(a)}]\n  n += {len(a)}\n" + inits("a", a)
                     + "  call ssort(a,n,ftab,p)\n"),
    extract=lambda s,inp: s["a"],
    ref=lambda a: sorted(a))

register("quick_sort",
    procs="qsort/qsort2.j",
    gen=lambda r: [r.randint(0, 30) for _ in range(r.randint(2, 8))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int ord[{len(a)}]\n  int p\n  int r\n"
                     + inits("a", a)
                     + "".join(f"  ord[{i}] += {i}\n" for i in range(len(a)) if i)
                     + f"  r += {len(a)-1}\n  call qsort(a,p,r,ord)\n"),
    extract=lambda s,inp: s["a"],
    ref=lambda a: sorted(a))

def _avl_valid(store, keys_expected):
    key, left, right, ht = store["key"], store["left"], store["right"], store["ht"]
    root = store["root"]
    order = []
    def inorder(u):
        if u == 0: return
        inorder(left[u]); order.append(key[u]); inorder(right[u])
    inorder(root)
    if order != sorted(set(keys_expected)): return False           # BST + exact key set
    def h(u): return 0 if u == 0 else 1 + max(h(left[u]), h(right[u]))
    def ok(u):
        if u == 0: return True
        if ht[u] != h(u): return False                             # heights consistent
        if abs(h(left[u]) - h(right[u])) > 1: return False         # AVL balance
        return ok(left[u]) and ok(right[u])
    return ok(root)

def _avl_procs():
    return procs_of("avl/avl_insert.j")
def _avl_build(keys, extra=""):
    K = len(keys) + 1
    body = (f"procedure main()\n  int key[{K}]\n  int left[{K}]\n  int right[{K}]\n"
            f"  int ht[{K}]\n  int root\n  int nfree\n  stack alog\n  stack hlog\n  stack rlog\n"
            f"  nfree += 1\n")
    for x in keys:
        body += f"  call insert(key,left,right,ht,root,{x},nfree,alog,hlog,rlog)\n"
    return body + extra
register("avl_insert",
    procs="avl/avl_insert.j",
    gen=lambda r: r.sample(range(1, 50), r.randint(1, 12)),   # distinct
    build=lambda keys: _avl_build(keys),
    extract=lambda s,keys: _avl_valid(s, keys),
    ref=lambda keys: True)

register("avl_delete",
    procs="avl/avl_delete.j",
    gen=lambda r: (lambda ks: (ks, r.sample(ks, r.randint(0, len(ks)))))(
                   r.sample(range(1, 50), r.randint(2, 12))),
    build=lambda kd: _avl_build(kd[0],
        "".join(f"  call delete(key,left,right,ht,root,{x},alog,hlog,rlog,dlog)\n" for x in kd[1])
        ).replace("  stack rlog\n", "  stack rlog\n  stack dlog\n"),
    extract=lambda s,kd: _avl_valid(s, [k for k in kd[0] if k not in set(kd[1])]),
    ref=lambda kd: True)

def _gen_apsp(r):
    g = _gen_floyd(r); V = g["V"]
    g["t"] = max(1, math.ceil(math.log2(max(2, V-1))))   # squarings so 2^t >= V-1
    return g
register("apsp",
    procs="apsp/apsp.j",
    gen=_gen_apsp,
    build=lambda g: (lambda V, t, path:
        f"procedure main()\n  int m_arr[{(t+1)*V*V}]\n  int v_n\n  int t_n\n  int inf\n"
        f"  v_n += {V}\n  t_n += {t}\n  inf += {INF}\n" + inits("m_arr", path)
        + "  call apsp(m_arr,t_n,v_n,inf)\n")(g["V"], g["t"], g["path"]),
    extract=lambda s,g: s["m_arr"][g["t"]*g["V"]*g["V"] : (g["t"]+1)*g["V"]*g["V"]],
    ref=lambda g: ref_floyd(g["path"], g["V"]))

# ---- avl_search: build a tree with avl_insert's procs, then search ----------
def _procs_avl_search():
    return procs_of("avl/avl_insert.j") + procs_of("avl/avl_search.j")
def _gen_avl_search(r):
    keys = r.sample(range(1, 50), r.randint(1, 12))
    x = r.choice(keys) if r.random() < 0.6 else r.randint(1, 60)  # ~present / absent
    return {"keys": keys, "x": x}
register("avl_search",
    procs="avl/avl_insert.j",                 # placeholder; real procs via _procs
    _procs=_procs_avl_search,
    gen=_gen_avl_search,
    build=lambda g: (lambda keys, x, K:
        f"procedure main()\n  int key[{K}]\n  int left[{K}]\n  int right[{K}]\n"
        f"  int ht[{K}]\n  int root\n  int nfree\n  int res\n"
        f"  stack alog\n  stack hlog\n  stack rlog\n  int dummy\n  nfree += 1\n"
        + "".join(f"  call insert(key,left,right,ht,root,{k},nfree,alog,hlog,rlog)\n" for k in keys)
        + f"  call avl_search(key,left,right,root,{x},res)\n")(g["keys"], g["x"], len(g["keys"])+1),
    extract=lambda s,g: s["res"],
    ref=lambda g: (g["keys"].index(g["x"])+1) if g["x"] in g["keys"] else 0)

register("heap_sort",
    procs="hsort/hsort2.j",
    gen=lambda r: [r.randint(0, 30) for _ in range(r.randint(2, 10))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)+1}]\n  int sz\n  stack gb\n"
                     f"  sz += {len(a)}\n"
                     + "".join(f"  a[{i+1}] += {v}\n" for i, v in enumerate(a) if v)
                     + "  call heapsort(a,sz,gb)\n"),
    extract=lambda s,a: s["a"][1:len(a)+1],
    ref=lambda a: sorted(a))

def _substr_flag(p, t):
    for i in range(len(t) - len(p) + 1):
        if t[i:i+len(p)] == p: return 1
    return 0
def _gen_strsearch(r):
    n = r.randint(4, 10); t = [r.randint(1, 3) for _ in range(n)]
    m = r.randint(1, 3)
    if r.random() < 0.5 and n >= m:          # embed a real occurrence half the time
        s = r.randint(0, n-m); p = t[s:s+m]
    else:
        p = [r.randint(1, 3) for _ in range(m)]
    return {"p": p, "t": t}
register("string_search",
    procs="string_search/Force_str_search1-c.j",
    gen=_gen_strsearch,
    build=lambda g: (lambda p, t:
        f"procedure main()\n  int p[{len(p)}]\n  int t[{len(t)}]\n  int m\n  int n\n  int r\n  stack g\n"
        f"  m += {len(p)}\n  n += {len(t)}\n"
        + inits("p", p) + inits("t", t) + "  call f_strmatch(p,t,m,n,r,g)\n")(g["p"], g["t"]),
    extract=lambda s,g: s["r"],
    ref=lambda g: _substr_flag(g["p"], g["t"]))

# ---- linear_search family: found/not-found flag over an array or stack -----
# Independent spec: "found" means key equals one of the n real input elements;
# the concrete flag encoding (0/1 vs -1/1) is read off each file's own local
# init value (the default the flag is left at when the not-found branch never
# touches it), not guessed -- verified against actual runs below.
def _gen_search_flat(r):
    n = r.randint(1, 10)
    vals = r.sample(range(1, 80), n)
    if r.random() < 0.5:
        key = r.choice(vals)
    else:
        while True:
            key = r.randint(1, 80)
            if key not in vals: break
    return {"vals": vals, "n": n, "key": key}

def _gen_search_sorted(r):
    n = r.randint(2, 9)
    vals = sorted(r.sample(range(1, 60), n))
    sentinel = vals[-1] + r.randint(5, 30)          # guaranteed >= any generated key
    if r.random() < 0.5:
        key = r.choice(vals)
    else:
        while True:
            key = r.randint(1, sentinel - 1)
            if key not in vals: break
    return {"vals": vals, "n": n, "sentinel": sentinel, "key": key}

def _ref_flag(found_val, not_found_val):
    return lambda g: found_val if g["key"] in g["vals"] else not_found_val

def _arr_direct_build(entry, extra_slot=False):
    def b(g):
        vals, n, key = g["vals"], g["n"], g["key"]
        arr = vals + [0] if extra_slot else vals
        size = n + 1 if extra_slot else n
        return (f"procedure main()\n  int k[{size}]\n  int key\n  int n\n  int f\n"
                + inits("k", arr) + f"  key += {key}\n  n += {n}\n"
                + f"  call {entry}(k,key,n,f)\n")
    return b

def _arr_wrapped_build(entry, extra_slot=False):
    def b(g):
        vals, n, key = g["vals"], g["n"], g["key"]
        arr = vals + [0] if extra_slot else vals
        size = n + 1 if extra_slot else n
        return (f"procedure main()\n  int k[{size}]\n  int key\n  int n\n  int f\n"
                + inits("k", arr) + f"  key += {key}\n  n += {n}\n"
                + "  local stack g = nil\n    local int x = 0\n"
                + f"      call {entry}(k,key,n,x,g)\n      f ^= x\n      uncall {entry}(k,key,n,x,g)\n"
                + "    delocal int x = 0\n  delocal stack g = nil\n")
    return b

def _arr_sorted_direct_build(entry):
    def b(g):
        vals, n, key, sentinel = g["vals"], g["n"], g["key"], g["sentinel"]
        return (f"procedure main()\n  int k[{n+1}]\n  int key\n  int n\n  int f\n"
                + inits("k", vals + [sentinel]) + f"  key += {key}\n  n += {n}\n"
                + f"  call {entry}(k,key,n,f)\n")
    return b

def _arr_sorted_wrapped_build(entry):
    def b(g):
        vals, n, key, sentinel = g["vals"], g["n"], g["key"], g["sentinel"]
        return (f"procedure main()\n  int k[{n+1}]\n  int key\n  int n\n  int f\n"
                + inits("k", vals + [sentinel]) + f"  key += {key}\n  n += {n}\n"
                + "  local stack g = nil\n    local int x = 0\n"
                + f"      call {entry}(k,key,n,x,g)\n      f ^= x\n      uncall {entry}(k,key,n,x,g)\n"
                + "    delocal int x = 0\n  delocal stack g = nil\n")
    return b

def _pushes(vals):
    return "".join(f"    x += {v}\n    push(x, s)\n" for v in vals)

_order_flat = lambda g: g["vals"]                                 # any order works
_order_sorted = lambda g: [g["sentinel"]] + list(reversed(g["vals"]))  # sentinel at bottom

def _stack_direct_build(entry, order_fn):
    def b(g):
        return (f"procedure main()\n  stack s\n  int key\n  int f\n  key += {g['key']}\n"
                + "  local int x = 0\n" + _pushes(order_fn(g)) + "  delocal int x = 0\n"
                + f"  call {entry}(s, key, f)\n")
    return b

def _stack_wrapped_t_build(entry, order_fn, y_init):
    def b(g):
        return (f"procedure main()\n  int key\n  int f\n  stack s\n  key += {g['key']}\n"
                + "  local int x = 0\n" + _pushes(order_fn(g)) + "  delocal int x = 0\n"
                + "  local stack g = nil\n    local stack t = nil\n"
                + f"      local int y = {y_init}\n"
                + f"        call {entry}(s, key, t, y, g)\n        f ^= y\n        uncall {entry}(s, key, t, y, g)\n"
                + f"      delocal int y = {y_init}\n    delocal stack t = nil\n  delocal stack g = nil\n")
    return b

def _stack_wrapped_g_build(entry, order_fn, y_init):
    def b(g):
        return (f"procedure main()\n  int key\n  int f\n  stack s\n  key += {g['key']}\n"
                + "  local int x = 0\n" + _pushes(order_fn(g)) + "  delocal int x = 0\n"
                + "  local stack g = nil\n"
                + f"    local int y = {y_init}\n"
                + f"      call {entry}(s, key, y, g)\n      f ^= y\n      uncall {entry}(s, key, y, g)\n"
                + f"    delocal int y = {y_init}\n  delocal stack g = nil\n")
    return b

# -- unsorted array/stack, no auxiliary sentinel element required -----------
register("lsearch1", procs="linear_search/Lsearch1.j", gen=_gen_search_flat,
    build=_arr_direct_build("linear2"), extract=lambda s,g: s["f"], ref=_ref_flag(1, 0))
register("lsearch2", procs="linear_search/Lsearch2.j", gen=_gen_search_flat,
    build=_arr_wrapped_build("linear1"), extract=lambda s,g: s["f"], ref=_ref_flag(1, 0))
register("lsearch3", procs="linear_search/Lsearch3.j", gen=_gen_search_flat,
    build=_arr_direct_build("a_linear2"), extract=lambda s,g: s["f"], ref=_ref_flag(1, 0))
register("lsearch4", procs="linear_search/Lsearch4.j", gen=_gen_search_flat,
    build=_stack_direct_build("search1", _order_flat), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("lsearch5", procs="linear_search/Lsearch5.j", gen=_gen_search_flat,
    build=_stack_direct_build("search1", _order_flat), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("lsearch6", procs="linear_search/Lsearch6.j", gen=_gen_search_flat,
    build=_stack_wrapped_t_build("search", _order_flat, -1), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("lsearch7", procs="linear_search/Lsearch7.j", gen=_gen_search_flat,
    build=_stack_wrapped_g_build("search", _order_flat, -1), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))

# -- unsorted array/stack WITH an injected sentinel (banpei family) ---------
register("sentinel1", procs="linear_search/sentinel1.j", gen=_gen_search_flat,
    build=_arr_direct_build("banpei2", extra_slot=True), extract=lambda s,g: s["f"], ref=_ref_flag(1, 0))
register("sentinel2", procs="linear_search/sentinel2.j", gen=_gen_search_flat,
    build=_arr_wrapped_build("banpei", extra_slot=True), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("sentinel3", procs="linear_search/sentinel3.j", gen=_gen_search_flat,
    build=_stack_direct_build("banpei1", _order_flat), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("sentinel4", procs="linear_search/sentinel4.j", gen=_gen_search_flat,
    build=_stack_wrapped_t_build("banpei", _order_flat, 0), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("sentinel5", procs="linear_search/sentinel5.j", gen=_gen_search_flat,
    build=_stack_wrapped_t_build("banpei", _order_flat, 0), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))

# -- sorted array/list WITH a real (value) sentinel appended at index n -----
register("list_sentinel1", procs="linear_search/list_sentinel1.j", gen=_gen_search_sorted,
    build=_arr_sorted_direct_build("aolinear2"), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("list_sentinel2", procs="linear_search/list_sentinel2.j", gen=_gen_search_sorted,
    build=_arr_sorted_wrapped_build("aosearch"), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("list_sentinel3", procs="linear_search/list_sentinel3.j", gen=_gen_search_sorted,
    build=_stack_direct_build("aolinear1", _order_sorted), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("list_sentinel4", procs="linear_search/list_sentinel4.j", gen=_gen_search_sorted,
    build=_stack_wrapped_t_build("aolinear", _order_sorted, -1), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))
register("list_sentinel5", procs="linear_search/list_sentinel5.j", gen=_gen_search_sorted,
    build=_stack_wrapped_g_build("aolinear", _order_sorted, -1), extract=lambda s,g: s["f"], ref=_ref_flag(1, -1))

def _mr_unrank(n, r):
    pi = list(range(n))
    def rec(n, r):
        if n > 0:
            pi[n-1], pi[r % n] = pi[r % n], pi[n-1]
            rec(n-1, r // n)
    rec(n, r); return pi
def _gen_perm(r):
    n = r.randint(2, 6); return {"n": n, "r": r.randint(0, math.factorial(n)-1)}
register("perm_unrank",
    procs="rank/rank_perm.j",
    gen=_gen_perm,
    build=lambda g: (lambda n, rr:
        f"procedure main()\n  int n\n  int r\n  int pi[{n}]\n"
        f"  n ^= {n}\n  r ^= {rr}\n" + "".join(f"  pi[{i}] ^= {i}\n" for i in range(n))
        + "  call unrank1(n,r,pi)\n")(g["n"], g["r"]),
    extract=lambda s,g: s["pi"],
    ref=lambda g: _mr_unrank(g["n"], g["r"]))

def _gen_dynarray(r):
    k = r.randint(2, 10); adds = [r.randint(1, 99) for _ in range(k)]
    ndel = r.randint(0, k)
    return {"adds": adds, "ndel": ndel}
register("dynamic_array",
    procs="dynarray/dynarray.j",
    gen=_gen_dynarray,
    build=lambda g: (lambda adds, ndel:
        f"procedure main()\n  int data[64]\n  int length\n  int cap\n  stack dbit\n  int e\n"
        + "".join(f"  int x{i}\n" for i in range(1, ndel+1))
        + "  cap += 1\n"
        + "".join(f"  e += {v}\n  call da_add(data,length,cap,dbit,e)\n  e -= {v}\n" for v in adds)
        + "".join(f"  call da_delete(data,length,cap,dbit,x{i})\n" for i in range(1, ndel+1)))(g["adds"], g["ndel"]),
    extract=lambda s,g: (s["data"][:s["length"]], [s[f"x{i}"] for i in range(1, g["ndel"]+1)]),
    ref=lambda g: (g["adds"][:len(g["adds"])-g["ndel"]],
                   [g["adds"][len(g["adds"])-1-i] for i in range(g["ndel"])]))

register("shell_sort",
    procs="others/examples/shell_sort1.j",
    # preconditions (see file header): len >= 10, and all elements > 0
    # (the zero-cleared cell doubles as the insertion loop's guard)
    gen=lambda r: [r.randint(1, 30) for _ in range(r.randint(10, 16))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int sz\n  stack gb\n"
                     f"  sz += {len(a)-1}\n" + inits("a", a)   # sorts a[0..sz] inclusive
                     + "  call shell_sort(a,sz,gb)\n"),
    extract=lambda s,inp: s["a"],
    ref=lambda a: sorted(a))

register("heap_sort_percolating",
    procs="hsort/hsort3.j",
    gen=lambda r: [r.randint(0, 30) for _ in range(r.randint(2, 10))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)+1}]\n  int n\n  stack gb\n"
                     f"  n += {len(a)}\n"
                     + "".join(f"  a[{i+1}] += {v}\n" for i, v in enumerate(a) if v)
                     + "  call heapsort(a,n,gb)\n"),
    extract=lambda s,a: s["a"][1:len(a)+1],
    ref=lambda a: sorted(a))

# ---- more sorting variants: independent spec is always "output equals the
# sorted input"; garbage/permutation/inversion-table side outputs (p, d, ord,
# inv, ...) are declared as the procedures require but deliberately NOT
# checked here (out of scope for this batch; see docs/reftest-additions.md).
def _id_perm_lit(name, n):
    return "".join(f"  {name}[{i}] += {i}\n" for i in range(n))

def _inplace_gb_build(entry):
    return lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int n\n  stack gb\n  n += {len(a)}\n"
                       + inits("a", a) + f"  call {entry}(a,n,gb)\n")

_gen_sortarr = lambda r: [r.randint(0, 60) for _ in range(r.randint(2, 9))]
_ref_sorted = lambda a: sorted(a)

register("bsort_code1", procs="bsort/code/bsort1.j", gen=_gen_sortarr,
    build=_inplace_gb_build("bsort1"), extract=lambda s,a: s["a"], ref=_ref_sorted)
register("bsort_code1_online", procs="bsort/code/bsort1_online.j", gen=_gen_sortarr,
    build=_inplace_gb_build("bsort1"), extract=lambda s,a: s["a"], ref=_ref_sorted)
register("bsort_code2", procs="bsort/code/bsort2.j", gen=_gen_sortarr,
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int b[{len(a)}]\n  int n\n  n += {len(a)}\n"
                     + inits("a", a) + "  call bsort2(a,n,b)\n"),
    extract=lambda s,a: s["a"], ref=_ref_sorted)   # b ends up == original input (garbage); a is the sorted output
register("bsort_code3", procs="bsort/code/bsort3.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + _id_perm_lit("p", n) + "  call bsort3(a,n,p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("bsort_code4", procs="bsort/code/bsort4.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int d[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + "  call bsort4(a,n,d)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("bsort_code5", procs="bsort/code/bsort5.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int d[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + "  call bsort5(a,d,n)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("bsort_inversiontable", procs="bsort/examples/bsort_inversiontable.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int inv[{n}]\n  int sz\n  sz += {n}\n"
                     + inits("a", a) + "  call bsort(a,inv,sz)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("bsort_inversiontable_r2l", procs="bsort/examples/bsort_inversiontable_r2l.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int inv[{n}]\n  int sz\n  sz += {n}\n"
                     + inits("a", a) + "  call bsort(a,inv,sz)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)

# precondition: hsort_code's uncall-based permutation trick (replaying the
# forward heap-sort's recorded control trace on an identity array p) only
# holds when the sort comparisons on `a` and on the distinct `p` agree, i.e.
# `a` has no ties -- verified empirically (0/200 fails with distinct inputs
# vs 2/40 with r.randint duplicates) before fixing the generator here.
_gen_1idx = lambda r: r.sample(range(0, 60), r.randint(2, 10))
def _hsort_build(entry):
    return lambda a: (f"procedure main()\n  int a[{len(a)+1}]\n  int p[{len(a)+1}]\n  int n\n  n += {len(a)}\n"
                       + "".join(f"  a[{i+1}] += {v}\n" for i, v in enumerate(a) if v)
                       + f"  call {entry}(a,p,n)\n")
register("hsort_code1", procs="hsort/code/hsort1.j", gen=_gen_1idx,
    build=_hsort_build("hsort1"), extract=lambda s,a: s["a"][1:len(a)+1], ref=_ref_sorted)
# hsort2 is marked "// Wrong!" by the author in the source -- registered as a
# negative control: if reftest reports a FAIL here it is a known, pre-existing
# defect, not a new finding.
register("hsort_code2_known_wrong", procs="hsort/code/hsort2.j", gen=_gen_1idx,
    build=_hsort_build("hsort2"), extract=lambda s,a: s["a"][1:len(a)+1], ref=_ref_sorted,
    expect_fail="source itself says \"// Wrong!\" -- negative control for the otimes/percolating step")

register("isort_code1", procs="isort/code/isort1.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + _id_perm_lit("p", n) + "  call isort1(a,n,p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort_code2", procs="isort/code/isort2.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + _id_perm_lit("p", n) + "  call isort2(a,n,p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort_code3", procs="isort/code/isort3.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int d[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + "  call isort3(a,n,d)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort_code1_old", procs="isort/code/isort1_old.j", gen=_gen_sortarr,
    build=_inplace_gb_build("isort1"), extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort_code2_old", procs="isort/code/isort2_old.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int b[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + "  call isort2(a,b,n)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)   # b ends up == original input (garbage), same pattern as bsort_code2
register("isort_code3_old", procs="isort/code/isort3_old.j", gen=_gen_sortarr,
    # isort3 calls id_perm(p,n) internally -- do NOT pre-init p here (double
    # init broke it: 4/40 with pre-init vs verified-OK once removed).
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + "  call isort3(a,p,n)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort_code4_old", procs="isort/code/isort4_old.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + _id_perm_lit("p", n) + "  call isort4(a,p,n)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort_dijkstra_a1", procs="isort/code/isort_dijkstra79_A1.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int p[{n}]\n  int y[{n}]\n  int m\n  m += {n}\n"
                     + inits("p", a) + "  call perm2fac_a1(p,y,m)\n")(len(a)),
    extract=lambda s,a: s["p"], ref=_ref_sorted)
register("isort5", procs="isort/isort5.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int sz\n  int gb[{n}]\n  sz += {n}\n"
                     + inits("a", a) + "  call isort(a,sz,gb)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort6", procs="isort/isort6.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int sz\n  int gb[{n}]\n  sz += {n}\n"
                     + inits("a", a) + "  call isort(a,sz,gb)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort7", procs="isort/isort7.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int sz\n  int ord[{n}]\n  sz += {n}\n"
                     + inits("a", a) + _id_perm_lit("ord", n) + "  call isort(a,sz,ord)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort8", procs="isort/isort8.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int inv[{n}]\n  int sz\n  sz += {n}\n"
                     + inits("a", a) + "  call isort_l2r(a,inv,sz)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("isort9", procs="isort/isort9.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int inv[{n}]\n  int sz\n  sz += {n}\n"
                     + inits("a", a) + "  call isort(a,inv,sz)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
# precondition: the value 0 among the keys triggers a genuine bug in the
# Hall (1994) loop (an "x == b[j]" from-assertion fails / b indexed to -1 --
# see docs/reftest-additions.md); distinctness alone is not enough (23/32
# permutations of {0,...,n-1} fail vs 0/32 of {1,...,n}, empirically). The
# file's own example is a positive-valued permutation, matching that scope.
register("isort_hall", procs="isort/isort_hall.j", gen=lambda r: r.sample(range(1, 60), r.randint(2, 9)),
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int b[{n+1}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + "  call isort_hall(a,b,n)\n")(len(a)),
    extract=lambda s,a: s["b"][0:len(a)], ref=_ref_sorted)

_gen_msort = lambda r: [r.randint(0, 200) for _ in range(r.randint(2, 8))]   # << 999 sentinel used by msort/code
register("msort_code", procs="msort/code/msort.j", gen=_gen_msort,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n  int n\n  n += {n}\n"
                     + inits("a", a) + _id_perm_lit("p", n) + "  call msort(a,n,p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("msort1", procs="msort/msort1.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  stack gbg\n  int p\n  int r\n  r += {n-1}\n"
                     + inits("a", a) + "  call msort(a,p,r,gbg)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)

register("counting_sort2",
    procs="others/examples/counting_sort.j",
    gen=lambda r: [r.randint(0, 7) for _ in range(r.randint(1, 10))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int b[{len(a)}]\n"
                     f"  int c[8]\n  int n\n  int k\n  n += {len(a)}\n  k += 8\n"
                     + inits("a", a) + "  call csort(a,n,b,c,k)\n"),
    # Checks the offset array c as well as the sorted output: the (now fixed)
    # dropped-a[0] bug corrupted both, and c alone would have caught it.
    extract=lambda s,inp: (s["b"], s["c"]),
    ref=lambda a: (sorted(a), [sum(a.count(u) for u in range(v)) for v in range(8)]))

_gen_qsort = lambda r: [r.randint(0, 30) for _ in range(r.randint(2, 8))]   # same range as quick_sort
register("qsort_code", procs="qsort/code/qsort.j", gen=_gen_qsort,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n"
                     + inits("a", a) + _id_perm_lit("p", n) + f"  call qsort(a,0,{n-1},p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("qsort1_code", procs="qsort/code/qsort1.j", gen=_gen_qsort,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int ord[{n}]\n"
                     + inits("a", a) + _id_perm_lit("ord", n) + f"  call qsort1(a,0,{n-1},ord)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)
register("qsort2_code", procs="qsort/code/qsort2.j", gen=_gen_qsort,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int p[{n}]\n"
                     + inits("a", a) + _id_perm_lit("p", n) + f"  call qsort2(a,0,{n-1},p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)

register("ssort_code", procs="ssort/code/ssort.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int n\n  int d[{n}]\n  int p[{n}]\n  n += {n}\n"
                     + inits("a", a) + "  call ssort(a,n,d,p)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)

register("factorial",
    procs="others/examples/fact.j",
    gen=lambda r: r.randint(0, 8),
    build=lambda n: (f"procedure main()\n  int n\n  int res1\n  int res2\n"
                     f"  n += {n}\n  call factR(n,res1)\n  call factI(n,res2)\n"),
    extract=lambda s,n: (s["res1"], s["res2"]),
    ref=lambda n: (math.factorial(n), math.factorial(n)))

register("combination",
    procs="others/examples/combination.j",
    gen=lambda r: (lambda n: (n, r.randint(0, n)))(r.randint(1, 8)),
    build=lambda nr: (f"procedure main()\n  int n\n  int r\n  int res\n"
                      f"  n += {nr[0]}\n  r += {nr[1]}\n  call combI(n,r,res)\n"),
    extract=lambda s,nr: s["res"],
    ref=lambda nr: math.comb(nr[0], nr[1]))

def _inv_table(a):
    # b[v] = number of elements greater than v appearing before v's position
    pos = {v: i for i, v in enumerate(a)}
    return [sum(1 for j in range(pos[v]) if a[j] > v) for v in range(len(a))]
register("perm_to_invtable",
    procs="perm/perm2invtab1.j",
    gen=lambda r: (lambda n: r.sample(range(n), n))(r.randint(2, 9)),
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int b[{len(a)}]\n"
                     f"  int x[{len(a)}]\n  int sz\n  sz ^= {len(a)}\n"
                     + "".join(f"  a[{i}] ^= {v}\n" for i, v in enumerate(a) if v)
                     + "  call perm2invtab(a,b,x,sz)\n"),
    extract=lambda s,a: s["b"],
    ref=_inv_table)

register("perm_rank2_roundtrip",
    procs="rank/rank_perm.j",
    gen=lambda r: (lambda n: (n, r.randint(0, math.factorial(n)-1)))(r.randint(2, 6)),
    build=lambda g: (lambda n, rr:
        f"procedure main()\n  int n\n  int r\n  int pi[{n}]\n  int pi_inv[{n}]\n  int res\n"
        f"  n ^= {n}\n  r ^= {rr}\n" + "".join(f"  pi[{i}] ^= {i}\n" for i in range(1, n))
        + "  call unrank2(n,r,pi)\n  call make_pi_inv(pi,pi_inv,n)\n"
        + "  call rank2(n,pi,pi_inv,res)\n")(g[0], g[1]),
    extract=lambda s,g: s["res"],
    ref=lambda g: g[1])   # rank2 must invert unrank2

def _lex_rank(pi):
    n = len(pi)
    return sum(sum(1 for j in range(i+1, n) if pi[j] < pi[i]) * math.factorial(n-1-i)
               for i in range(n))
register("perm_rank_lexicographic",
    procs="rank/rank_lexicographic.j",
    gen=lambda r: (lambda n: r.sample(range(n), n))(r.randint(2, 8)),
    build=lambda pi: (lambda n, K:
        f"procedure main()\n  int pi[{n+1}]\n  int t[{2*K}]\n  int n\n  int rank\n"
        f"  n ^= {n}\n"
        + "".join(f"  pi[{i+1}] ^= {v}\n" for i, v in enumerate(pi) if v)   # 1-indexed
        + "  call rank(pi,t,n,rank)\n")(len(pi), 2**math.ceil(math.log2(len(pi)))),
    extract=lambda s,pi: s["rank"],
    ref=_lex_rank)

register("ext_gcd",
    procs="numeric/ext_gcd.j",
    gen=lambda r: (r.randint(1, 300), r.randint(1, 300)),
    build=lambda ab: (f"procedure main()\n  int a\n  int b\n  int x0\n  int x1\n"
                      f"  int y0\n  int y1\n  stack qlog\n"
                      f"  a += {ab[0]}\n  b += {ab[1]}\n  x0 += 1\n  y1 += 1\n"
                      + "  call ext_gcd(a,b,x0,x1,y0,y1,qlog)\n"),
    extract=lambda s,ab: (s["a"], s["x0"]*ab[0] + s["y0"]*ab[1]),
    ref=lambda ab: (math.gcd(ab[0], ab[1]),)*2)   # g, and Bezout identity = g

register("ext_gcd_clean",
    procs="numeric/ext_gcd_clean.j",
    gen=lambda r: (r.randint(1, 300), r.randint(1, 300)),
    build=lambda ab: (f"procedure main()\n  int a\n  int b\n  int x0\n  int x1\n"
                      f"  int y0\n  int y1\n"
                      f"  a += {ab[0]}\n  b += {ab[1]}\n  x0 += 1\n  y1 += 1\n"
                      + "  call ext_gcd_clean(a,b,x0,x1,y0,y1)\n"),
    extract=lambda s,ab: (s["a"], s["x0"]*ab[0] + s["y0"]*ab[1]),
    ref=lambda ab: (math.gcd(ab[0], ab[1]),)*2)

register("gcd_clean",
    procs="numeric/gcd_clean.j",
    gen=lambda r: (lambda x, y: (max(x, y), min(x, y)))(r.randint(1, 200), r.randint(1, 200)),
    build=lambda ab: (f"procedure main()\n  int a\n  int b\n  int m11\n  int m12\n  int m21\n  int m22\n"
                      f"  a += {ab[0]}\n  b += {ab[1]}\n  m11 += 1\n  m22 += 1\n"
                      "  call gcd_clean(a,b,m11,m12,m21,m22)\n"),
    extract=lambda s,inp: s["a"],
    ref=lambda ab: math.gcd(ab[0], ab[1]),
    skip=lambda ab: ab[0] == ab[1])

register("modexp",
    procs="numeric/modexp.j",
    gen=lambda r: (r.randint(1, 20), r.randint(0, 255), r.randint(2, 30)),
    build=lambda g: (f"procedure main()\n  int base\n  int e\n  int m\n  int r\n"
                     f"  int p\n  int pw\n  stack g\n"
                     f"  base += {g[0]}\n  e += {g[1]}\n  m += {g[2]}\n"
                     + "  call modexp(base,e,m,r,p,pw,g)\n"),
    extract=lambda s,g: s["r"] % g[2],   # r=1*... note r starts 1; for m=1 impossible (m>=2)
    ref=lambda g: pow(g[0], g[1], g[2]))

def ref_knapsack(wt, val, cap):
    n = len(wt); K = [[0]*(cap+1) for _ in range(n+1)]
    for i in range(1, n+1):
        for w in range(cap+1):
            K[i][w] = K[i-1][w] if wt[i-1] > w else max(K[i-1][w], K[i-1][w-wt[i-1]]+val[i-1])
    return K[n][cap]
register("knapsack",
    procs="dp/knapsack.j",
    gen=lambda r: ([r.randint(1, 6) for _ in range(r.randint(1, 6))],
                   [r.randint(1, 9) for _ in range(6)], r.randint(1, 10)),
    build=lambda g: (lambda wt, val, cap, n:
        f"procedure main()\n  int wt[{n+1}]\n  int val[{n+1}]\n  int n\n  int cap\n"
        f"  int K[{(n+1)*(cap+1)}]\n  n += {n}\n  cap += {cap}\n"
        + "".join(f"  wt[{i+1}] += {w}\n  val[{i+1}] += {v}\n" for i,(w,v) in enumerate(zip(wt,val)))
        + "  call knapsack(wt,val,n,cap,K)\n")(g[0], g[1][:len(g[0])], g[2], len(g[0])),
    extract=lambda s,g: s["K"][len(g[0])*(g[2]+1) + g[2]],
    ref=lambda g: ref_knapsack(g[0], g[1][:len(g[0])], g[2]))

def ref_lis(a):
    L = []
    for i in range(len(a)):
        L.append(1 + max([L[j] for j in range(i) if a[j] < a[i]], default=0))
    return max(L, default=0)
register("lis",
    procs="dp/lis.j",
    gen=lambda r: [r.randint(1, 20) for _ in range(r.randint(1, 10))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int n\n  int L[{len(a)}]\n"
                     f"  int res\n  n += {len(a)}\n" + inits("a", a)
                     + "  call lis(a,n,L,res)\n"),
    extract=lambda s,a: s["res"],
    ref=ref_lis)

def ref_dijkstra(w, V, src, INF):
    dist = [INF]*V; dist[src] = 0; vis = [False]*V
    for _ in range(V):
        u = min((d, i) for i, d in enumerate(dist) if not vis[i])[1]
        vis[u] = True
        for v in range(V):
            if w[u*V+v] > 0 and not vis[v] and dist[u]+w[u*V+v] < dist[v]:
                dist[v] = dist[u]+w[u*V+v]
    return dist
def _gen_dijkstra(r):
    V = r.randint(3, 6); edges = _rand_graph(r, V, 0.5, 9)
    w = [0]*(V*V)
    for (u,v,wt) in edges: w[u*V+v] = wt
    return {"V": V, "w": w}
register("dijkstra",
    procs="dijkstra/dijkstra.j",
    gen=_gen_dijkstra,
    build=lambda g: (lambda V, w:
        f"procedure main()\n  int w[{V*V}]\n  int v_n\n  int dist[{V}]\n"
        f"  int visited[{V}]\n  int inf\n  stack dlog\n  stack blog\n"
        f"  v_n += {V}\n  inf += {INF}\n" + inits("w", w)
        + "".join(f"  dist[{i}] += {INF}\n" for i in range(1, V))
        + "  call dijkstra(w,v_n,dist,visited,inf,dlog,blog)\n")(g["V"], g["w"]),
    extract=lambda s,g: s["dist"],
    ref=lambda g: ref_dijkstra(g["w"], g["V"], 0, INF))

def _gen_dag(r):
    V = r.randint(3, 7)
    perm = r.sample(range(V), V)          # random topological labelling
    adj = [0]*(V*V)
    edges = []
    for i in range(V):
        for j in range(i+1, V):
            if r.random() < 0.4:
                adj[perm[i]*V+perm[j]] = 1
                edges.append((perm[i], perm[j]))
    return {"V": V, "adj": adj, "edges": edges}
def _topo_valid(order, g):
    V = g["V"]
    topo = list(reversed(order))          # reverse of post-order
    if sorted(topo) != list(range(V)): return False
    pos = {v: i for i, v in enumerate(topo)}
    return all(pos[u] < pos[v] for (u, v) in g["edges"])
register("toposort",
    procs="toposort/toposort.j",
    gen=_gen_dag,
    build=lambda g: (lambda V, adj:
        f"procedure main()\n  int adj[{V*V}]\n  int v_n\n  int visited[{V}]\n"
        f"  int order[{V}]\n  stack blog\n  v_n += {V}\n" + inits("adj", adj)
        + "  call toposort(adj,v_n,visited,order,blog)\n")(g["V"], g["adj"]),
    extract=lambda s,g: _topo_valid(s["order"], g),
    ref=lambda g: True)

register("closest_pair",
    procs="geometry/closest_pair.j",
    gen=lambda r: ([r.randint(0, 50) for _ in range(r.randint(2, 9))],
                   [r.randint(0, 50) for _ in range(9)]),
    build=lambda g: (lambda xs, ys, n:
        f"procedure main()\n  int x[{n}]\n  int y[{n}]\n  int n\n  int big\n  int res\n"
        f"  n += {n}\n  big += 1000000\n" + inits("x", xs) + inits("y", ys[:n])
        + "  call closest_pair(x,y,n,big,res)\n")(g[0], g[1], len(g[0])),
    extract=lambda s,g: s["res"],
    ref=lambda g: min((g[0][i]-g[0][j])**2 + (g[1][i]-g[1][j])**2
                      for i in range(len(g[0])) for j in range(i+1, len(g[0]))))


def _count_occ(p, t):
    return sum(1 for i in range(len(t)-len(p)+1) if t[i:i+len(p)] == p)
def _gen_kmp(r):
    n = r.randint(1, 12); t = [r.randint(1, 2) for _ in range(n)]   # binary: many overlaps
    m = r.randint(1, min(4, n)); p = [r.randint(1, 2) for _ in range(m)]
    return {"p": p, "t": t}
register("kmp_count",
    procs="string_search/kmp2.j",
    gen=_gen_kmp,
    build=lambda g: (lambda p, t:
        f"procedure main()\n  int p[{len(p)}]\n  int t[{len(t)}]\n  int f[{len(p)}]\n"
        f"  int m\n  int n\n  int cnt\n  stack gq\n  stack gb\n"
        f"  m += {len(p)}\n  n += {len(t)}\n"
        + inits("p", p) + inits("t", t)
        + "  call kmp_count(p,t,m,n,f,cnt,gq,gb)\n")(g["p"], g["t"]),
    extract=lambda s,g: s["cnt"],
    ref=lambda g: _count_occ(g["p"], g["t"]))

def _ref_next_perm(a):
    a = list(a); n = len(a)
    i = n-2
    while a[i] >= a[i+1]: i -= 1
    j = n-1
    while a[j] <= a[i]: j -= 1
    a[i], a[j] = a[j], a[i]
    a[i+1:] = reversed(a[i+1:])
    return a
register("next_perm",
    procs="inc_code/inc_perm.j",
    gen=lambda r: (lambda n: r.sample(range(n), n))(r.randint(2, 8)),
    build=lambda a: (f"procedure main()\n  int d[{len(a)}]\n  int n\n  stack glog\n"
                     f"  n += {len(a)}\n" + inits("d", a)
                     + "  call next_perm(d,n,glog)\n"),
    extract=lambda s,a: s["d"],
    ref=_ref_next_perm,
    skip=lambda a: a == sorted(a, reverse=True))   # precondition: not the last perm

# log-free rewrites (*_clean.j): same function as the original, no stack
register("next_perm_clean",
    procs="inc_code/inc_perm_clean.j",
    gen=lambda r: (lambda n: r.sample(range(n), n))(r.randint(2, 8)),
    build=lambda a: (f"procedure main()\n  int d[{len(a)}]\n  int n\n"
                     f"  n += {len(a)}\n" + inits("d", a)
                     + "  call next_perm_clean(d,n)\n"),
    extract=lambda s,a: s["d"],
    ref=_ref_next_perm,
    skip=lambda a: a == sorted(a, reverse=True))

def _gen_connected(r):
    V = r.randint(3, 6)
    w = [0]*(V*V)
    perm = r.sample(range(V), V)
    for i in range(1, V):                    # random spanning tree first
        a, b = perm[i], perm[r.randrange(i)]
        wt = r.randint(1, 9); w[a*V+b] = wt; w[b*V+a] = wt
    for a in range(V):                        # extra edges
        for b in range(a+1, V):
            if w[a*V+b] == 0 and r.random() < 0.3:
                wt = r.randint(1, 9); w[a*V+b] = wt; w[b*V+a] = wt
    return {"V": V, "w": w}
def ref_mst_weight(w, V, INF):
    key = [INF]*V; key[0] = 0; intree = [False]*V; total = 0
    for _ in range(V):
        u = min((key[i], i) for i in range(V) if not intree[i])[1]
        intree[u] = True; total += key[u]
        for v in range(V):
            if w[u*V+v] > 0 and not intree[v] and w[u*V+v] < key[v]:
                key[v] = w[u*V+v]
    return total
register("prim_mst",
    procs="mst/prim.j",
    gen=_gen_connected,
    build=lambda g: (lambda V, w:
        f"procedure main()\n  int w[{V*V}]\n  int v_n\n  int key[{V}]\n  int parent[{V}]\n"
        f"  int intree[{V}]\n  int total\n  int inf\n  stack dlog\n  stack blog\n"
        f"  v_n += {V}\n  inf += {INF}\n" + inits("w", w)
        + "".join(f"  key[{i}] += {INF}\n" for i in range(1, V))
        + "".join(f"  parent[{i}] -= 1\n" for i in range(V))
        + "  call prim(w,v_n,key,parent,intree,total,inf,dlog,blog)\n")(g["V"], g["w"]),
    extract=lambda s,g: s["total"],
    ref=lambda g: ref_mst_weight(g["w"], g["V"], INF))   # MST weight is unique

def ref_scc_canon(adj, V):
    # Kosaraju in Python; canonical form: each vertex -> min vertex of its SCC
    g = [[v for v in range(V) if adj[u*V+v]] for u in range(V)]
    gt = [[v for v in range(V) if adj[v*V+u]] for u in range(V)]
    seen = [False]*V; order = []
    def d1(u):
        seen[u] = True
        for v in g[u]:
            if not seen[v]: d1(v)
        order.append(u)
    for u in range(V):
        if not seen[u]: d1(u)
    comp = [0]*V; cid = 0
    def d2(u, c):
        comp[u] = c
        for v in gt[u]:
            if comp[v] == 0: d2(v, c)
    for u in reversed(order):
        if comp[u] == 0:
            cid += 1; d2(u, cid)
    members = {}
    for v in range(V): members.setdefault(comp[v], []).append(v)
    return [min(members[comp[v]]) for v in range(V)]
register("kosaraju_scc",
    procs="scc/kosaraju.j",
    gen=lambda r: (lambda V: {"V": V,
        "adj": [1 if (u != v and r.random() < 0.35) else 0
                for u in range(V) for v in range(V)]})(r.randint(3, 6)),
    build=lambda g: (lambda V, adj:
        f"procedure main()\n  int adj[{V*V}]\n  int adjt[{V*V}]\n  int v_n\n"
        f"  int visited[{V}]\n  int order[{V}]\n  int comp[{V}]\n  int ncomp\n  stack blog\n"
        f"  v_n += {V}\n" + inits("adj", adj)
        + "".join(f"  adjt[{v*V+u}] += 1\n" for u in range(V) for v in range(V) if adj[u*V+v])
        + "  call kosaraju(adj,adjt,v_n,visited,order,comp,ncomp,blog)\n")(g["V"], g["adj"]),
    extract=lambda s,g: (lambda comp, V:
        (lambda members: [min(members[comp[v]]) for v in range(V)])(
            {c: [v for v in range(V) if comp[v] == c] for c in set(comp)}))(s["comp"], g["V"]),
    ref=lambda g: ref_scc_canon(g["adj"], g["V"]))

def _collinear_free(pts):
    n = len(pts)
    for i in range(n):
        for j in range(i+1, n):
            for k in range(j+1, n):
                (x1,y1),(x2,y2),(x3,y3) = pts[i], pts[j], pts[k]
                if (x2-x1)*(y3-y1) - (y2-y1)*(x3-x1) == 0: return False
    return True
def ref_hull_flags(pts):
    # Andrew monotone chain, strict turns (general position assumed)
    P = sorted(range(len(pts)), key=lambda i: pts[i])
    def half(idx):
        h = []
        for i in idx:
            while len(h) >= 2:
                (x1,y1),(x2,y2),(x3,y3) = pts[h[-2]], pts[h[-1]], pts[i]
                if (x2-x1)*(y3-y1) - (y2-y1)*(x3-x1) <= 0: h.pop()
                else: break
            h.append(i)
        return h
    hull = set(half(P)[:-1] + half(P[::-1])[:-1])
    return [1 if i in hull else 0 for i in range(len(pts))]
def _gen_hull(r):
    while True:
        n = r.randint(3, 8)
        pts = []
        while len(pts) < n:
            p = (r.randint(0, 30), r.randint(0, 30))
            if p not in pts: pts.append(p)
        if _collinear_free(pts): return pts
register("convex_hull",
    procs="geometry/convex_hull.j",
    gen=_gen_hull,
    build=lambda pts: (lambda n:
        f"procedure main()\n  int x[{n}]\n  int y[{n}]\n  int n\n  int hull[{n}]\n"
        f"  int start\n  stack hseq\n  n += {n}\n"
        + inits("x", [p[0] for p in pts]) + inits("y", [p[1] for p in pts])
        + "  call jarvis(x,y,n,hull,start,hseq)\n")(len(pts)),
    extract=lambda s,pts: s["hull"],
    ref=ref_hull_flags)

# --- rank/rank.j: Er (1985) lexicographic ranking of ordered trees -----------
# Spec (written from the problem statement, not from the .j source): an ordered
# tree with n nodes is encoded as its 2n-bit ballot sequence b (1 = down/open,
# 0 = up/close); the valid encodings are exactly the sequences with n ones in
# which every prefix has #1 >= #0.  rank(b) is b's 1-based position when those
# sequences are listed in ascending lexicographic order, and unrank is its
# inverse.  The reference below enumerates the sequences directly from that
# definition and sorts them, which shares no code path with the .j file.
import functools
@functools.lru_cache(maxsize=None)
def _ballot_seqs(n):
    out = []
    def go(s, o, c):
        if len(s) == 2*n: out.append(tuple(s)); return
        if o < n: go(s+[1], o+1, c)
        if c < o: go(s+[0], o, c+1)
    go([], 0, 0)
    return sorted(out)
def _gen_tree(r):
    n = r.randint(2, 6)
    return (n, r.randrange(len(_ballot_seqs(n))))     # 0-based position
def _tree_b(inp):    return list(_ballot_seqs(inp[0])[inp[1]])
def _tree_rank(inp): return inp[1] + 1                # the .j files are 1-based
def _main_from_b(proc, inp):
    n = inp[0]
    return (f"procedure main()\n  int n\n  int index\n  int b[{2*n}]\n  n += {n}\n"
            + inits("b", _tree_b(inp)) + f"  call {proc}(b,n,index)\n")
def _main_from_index(proc, inp):
    n = inp[0]
    return (f"procedure main()\n  int n\n  int index\n  int b[{2*n}]\n  n += {n}\n"
            f"  index += {_tree_rank(inp)}\n  call {proc}(b,n,index)\n")

# `rank' keeps b and adds the rank to index (it is the non-clean direction).
register("tree_rank",
    procs="rank/rank.j", gen=_gen_tree,
    build=lambda inp: _main_from_b("rank", inp),
    extract=lambda s,inp: (s["index"], s["b"]),
    ref=lambda inp: (_tree_rank(inp), _tree_b(inp)))
# `rankCC' and `rankC' are two independent clean implementations of the same
# function: b is consumed (zeroed) and index receives the rank.  Checking both
# against the same reference is what pins down that rankC's `uncall unrankCC'
# (which used to name a nonexistent `unrank') targets the right procedure.
for _p in ("rankCC", "rankC"):
    register("tree_" + _p,
        procs="rank/rank.j", gen=_gen_tree,
        build=(lambda p: lambda inp: _main_from_b(p, inp))(_p),
        extract=lambda s,inp: (s["index"], s["b"]),
        ref=lambda inp: (_tree_rank(inp), [0]*(2*inp[0])))
# `unrankCC' / `unrankC': index is consumed, b receives the sequence.
for _p in ("unrankCC", "unrankC"):
    register("tree_" + _p,
        procs="rank/rank.j", gen=_gen_tree,
        build=(lambda p: lambda inp: _main_from_index(p, inp))(_p),
        extract=lambda s,inp: (s["index"], s["b"]),
        ref=lambda inp: (0, _tree_b(inp)))

# --- qsort/queue5e.j: doubly linked deque ------------------------------------
# pop_front / pop_back are defined as the inverses of push_front / push_back,
# so the reference is simply collections.deque.  Popping from an empty queue is
# an error in the .j file, so the generator never emits one.
def _gen_deque(r):
    ops, q = [], 0
    for _ in range(r.randint(2, 10)):
        if q == 0 or (q < 5 and r.random() < 0.5):
            ops.append((r.choice(["push_front", "push_back"]), r.randint(1, 99))); q += 1
        else:
            ops.append((r.choice(["pop_front", "pop_back"]), 0)); q -= 1
    return ops
def _build_deque(ops):
    maxq = q = npop = 0
    for o, _ in ops:
        if o.startswith("push"): q += 1; maxq = max(maxq, q)
        else: q -= 1; npop += 1
    # 3 cells per node, the free list starts at 3, so 3*(maxq+2) always fits
    out = [f"procedure main()\n  int elem[{3*(maxq+2)}]\n  int flp\n  int head\n"
           f"  int tail\n  int val\n  int out[{max(npop,1)}]\n  flp += 3\n"]
    k = 0
    for o, v in ops:
        if o.startswith("push"):
            out.append(f"  val += {v}\n  call {o}(elem, head, tail, flp, val)\n")
        else:
            # after a pop the popped value sits in val; move it into out[k]
            out.append(f"  call {o}(elem, head, tail, flp, val)\n"
                       f"  out[{k}] ^= val\n  val ^= out[{k}]\n"); k += 1
    return "".join(out)
def _ref_deque(ops):
    import collections
    d, out = collections.deque(), []
    for o, v in ops:
        if o == "push_front": d.appendleft(v)
        elif o == "push_back": d.append(v)
        elif o == "pop_front": out.append(d.popleft())
        else: out.append(d.pop())
    return out if out else [0]      # out[] is declared with length >= 1
register("deque_queue5e",
    procs="qsort/queue5e.j", gen=_gen_deque, build=_build_deque,
    extract=lambda s,inp: s["out"],
    ref=_ref_deque)

# --- string_search/Force_str_search*.j: naive (brute force) string matching --
# Spec (from the algorithm, not from the .j sources): find the smallest s with
# t[s:s+m] == p, or report "not found".  The five files agree on the algorithm
# and disagree only on how they report the answer, so each registration below
# normalises the file's own output convention to that one spec.
def _gen_strmatch(r):
    n = r.randint(3, 9); m = r.randint(1, min(3, n))
    alpha = r.randint(2, 3)
    t = [r.randint(1, alpha) for _ in range(n)]
    p = [r.randint(1, alpha) for _ in range(m)]
    if r.random() < 0.5:                       # plant an occurrence half the time
        s = r.randrange(n - m + 1); t[s:s+m] = p
    return p, t
def _ref_find(pt):
    p, t = pt
    for s in range(len(t) - len(p) + 1):
        if t[s:s+len(p)] == p: return s
    return -1
def _strmatch_main(call):
    def build(pt):
        p, t = pt
        return (f"procedure main()\n  int p[{len(p)}]\n  int t[{len(t)}]\n  int m\n"
                f"  int n\n  int i\n  int j\n  stack g\n"
                f"  m += {len(p)}\n  n += {len(t)}\n" + inits("p", p) + inits("t", t)
                + f"  {call}\n")
    return build
# 1-a keeps i local and reports success through the stack (top(g) = m), as its
# own main() does.  Two shapes of legitimate input abort it, so it is XFAIL:
#   * the occurrence ends exactly at the end of t  -> `fi j < n' (line 23) fails
#   * no occurrence, but a nonempty proper prefix of p is a suffix of t
#     -> i is still > 0 at `delocal int i = 0' (line 24)
# Exhaustively over the binary alphabet (m<=3, n<=m+3): 592 of 1260 inputs abort;
# on the 668 that run, top(g)=m holds exactly when an occurrence exists.
register("str_search1a",
    procs="string_search/Force_str_search1-a.j", gen=_gen_strmatch,
    build=_strmatch_main("call f_strmatch(p,t,m,n,j,g)"),
    extract=lambda s,pt: (s["g"][0] == len(pt[0]) if s["g"] else False),
    ref=lambda pt: _ref_find(pt) >= 0,
    expect_fail="aborts on two legitimate input shapes: an occurrence ending at "
                "the end of t (`fi j < n'), and a nonempty proper prefix of p "
                "occurring as a suffix of t (`delocal int i = 0')")
# 1-b exposes i and j; i = m signals success and j is then one past the match.
register("str_search1b",
    procs="string_search/Force_str_search1-b.j", gen=_gen_strmatch,
    build=_strmatch_main("call f_strmatch(p,t,m,n,i,j,g)"),
    extract=lambda s,pt: (s["j"] - len(pt[0])) if s["i"] == len(pt[0]) else -1,
    ref=_ref_find)
# 2-a keeps i local and leaves the answer in j: the match position, or the
# one-past-the-last start n-m+1 when there is no occurrence.
register("str_search2a",
    procs="string_search/Force_str_search2-a.j", gen=_gen_strmatch,
    build=_strmatch_main("call f_strmatch(p,t,m,n,j)"),
    extract=lambda s,pt: s["j"],
    ref=lambda pt: (lambda k: k if k >= 0 else len(pt[1]) - len(pt[0]) + 1)(_ref_find(pt)))
# 2-b is 2-a with i exposed: (i, j) = (m, position) on success, (0, n-m+1) else.
register("str_search2b",
    procs="string_search/Force_str_search2-b.j", gen=_gen_strmatch,
    build=_strmatch_main("call f_strmatch(p,t,m,n,i,j)"),
    extract=lambda s,pt: (s["i"], s["j"]),
    ref=lambda pt: (lambda k, m, n: (m, k) if k >= 0 else (0, n - m + 1))(
        _ref_find(pt), len(pt[0]), len(pt[1])))
# 2-c documents its own output convention in the source header: "j = the
# position of the first occurrence, j = -1 on failure".  The failure branch is
# `j -= n - 1', which yields 2-m rather than -1: it is only correct for the
# file's own example length m = 3.  Exhaustively over the binary alphabet:
#   m=1,2 no occurrence -> `fi j >= 0' (line 27) aborts
#   m=3   no occurrence -> j = -1  (correct, by coincidence)
#   m>=4  no occurrence -> j = 2-m (-2, -3, ... instead of -1)
# The correct decrement is n - m + 2.  Generator spans m = 1..5 so every one of
# those regimes is exercised.
register("str_search2c",
    procs="string_search/Force_str_search2-c.j",
    gen=lambda r: (lambda n: (lambda m: (
        [r.randint(1, 2) for _ in range(m)], [r.randint(1, 2) for _ in range(n)]))(
        r.randint(1, min(5, n))))(r.randint(3, 9)),
    build=_strmatch_main("call f_strmatch(p,t,m,n,j)"),
    extract=lambda s,pt: s["j"],
    ref=_ref_find,
    expect_fail="the not-found branch `j -= n - 1' encodes failure as 2-m, not "
                "the -1 the file's own header promises; correct only for m=3, "
                "and `fi j >= 0' aborts outright for m<=2 (should be n - m + 2)")

# --- ssort/code/ssort1.j: selection sort as the inverse of insertion sort ----
# ssort1(a, n, p) is defined as `uncall isort1(p, n, a)'.  Run on the identity
# permutation p and a permutation a of 0..n-1 it consumes a (back to the
# identity) and leaves p = a's inverse permutation.  The reference is the
# definition of "inverse permutation", which shares nothing with the .j code.
register("ssort1_invperm",
    procs="ssort/code/ssort1.j",
    gen=lambda r: (lambda n: r.sample(range(n), n))(r.randint(2, 7)),
    build=lambda a: (f"procedure main()\n  int a[{len(a)}]\n  int p[{len(a)}]\n"
                     f"  int n = {len(a)}\n" + inits("a", a)
                     + "  call id_perm(p,n)\n  call ssort1(a,n,p)\n"),
    extract=lambda s,a: (s["a"], s["p"]),
    ref=lambda a: (list(range(len(a))), [a.index(k) for k in range(len(a))]))

# --- others/code/lisort.j: linked-list insertion sort ------------------------
# The sorted order is not in a[]; it is the order in which the "next" pointer
# array L[] is traversed from the head L[0] until the 0 terminator.  a[0] is a
# sentinel slot; the n real keys live in a[1..n].
def _lisort_order(store, a):
    """Keys in the order the L[] "next" pointers visit them, from the head
    L[0] to the 0 terminator.  Bounded by n+1 steps so a broken (cyclic) list
    reports a mismatch instead of hanging the harness."""
    L, keys, out, k = store["L"], store["a"], [], store["L"][0]
    while k != 0 and len(out) <= len(a):
        out.append(keys[k]); k = L[k]
    return out
register("lisort",
    procs="others/code/lisort.j",
    gen=lambda r: [r.randint(0, 20) for _ in range(r.randint(2, 8))],
    build=lambda a: (f"procedure main()\n  int a[{len(a)+1}]\n  int L[{len(a)+1}]\n"
                     f"  int n = {len(a)}\n" + inits("a", [0] + a)
                     + "  call lisort(a,L,n)\n"),
    extract=_lisort_order,
    ref=lambda a: sorted(a))

# --- isort/isort10.j ---------------------------------------------------------
# Same right-to-left insertion sort as isort9 (alpha-renamed in -> a), with the
# right inversion table in inv[]; registered so the file itself has L2 cover.
register("isort10", procs="isort/isort10.j", gen=_gen_sortarr,
    build=lambda a: (lambda n: f"procedure main()\n  int a[{n}]\n  int inv[{n}]\n"
                     f"  int sz\n  sz += {n}\n" + inits("a", a)
                     + "  call isort(a,inv,sz)\n")(len(a)),
    extract=lambda s,a: s["a"], ref=_ref_sorted)

# ---- driver ----------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cases", type=int, default=40)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--only", default=None)
    args = ap.parse_args()

    total_ok = total = 0
    xfail_confirmed, xpass_alarm = [], []   # names, for the summary line
    for name, a in ALGOS.items():
        if args.only and args.only != name: continue
        procs = a["_procs"]() if "_procs" in a else procs_of(a["procs"])
        r = random.Random(args.seed)
        ok = fails = skipped = 0
        first_fail = None
        for _ in range(args.cases):
            inp = a["gen"](r)
            if a.get("skip") and a["skip"](inp): skipped += 1; continue
            try:
                store = run_store(procs + a["build"](inp))
                got = a["extract"](store, inp)
                want = a["ref"](inp)
                if got == want: ok += 1
                else:
                    fails += 1
                    if first_fail is None: first_fail = (inp, got, want)
            except Exception as e:
                fails += 1
                if first_fail is None: first_fail = (inp, f"ERR {e}", None)
        total += 1
        reason = a.get("expect_fail")
        if reason:
            # expect_fail entry: fails>0 means the known bug still reproduces
            # (healthy / green); fails==0 means it unexpectedly vanished
            # (alarm / red -- do NOT silently accept a bug going away).
            healthy = fails > 0
            tag = "XFAIL" if healthy else "XPASS"
            (xfail_confirmed if healthy else xpass_alarm).append(name)
        else:
            healthy = fails == 0
            tag = "OK   " if healthy else "FAIL "
        total_ok += healthy
        extra = f"  (skipped {skipped})" if skipped else ""
        print(f"  {tag} {name:16s} {ok}/{ok+fails} match{extra}")
        if reason:
            print(f"        expect_fail: {reason}")
        if first_fail and (not reason or not healthy):
            print(f"        first mismatch: input={first_fail[0]} got={first_fail[1]} want={first_fail[2]}")
    print(f"\n{total_ok}/{total} algorithms healthy over {args.cases} random cases"
          f" ({len(xfail_confirmed)} confirmed known-fail, {len(xpass_alarm)} unexpectedly clean)")
    if xpass_alarm:
        print("  XPASS (investigate -- has the bug been fixed? if so, drop expect_fail=...):")
        for n in xpass_alarm: print(f"    - {n}")
    return 0 if total_ok == total else 1

if __name__ == "__main__":
    sys.exit(main())
