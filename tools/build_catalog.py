#!/usr/bin/env python3
"""Build the reversible-algorithms catalog: a live index + coverage matrix.

Scans every *.j program, records category / provenance, and runs a
reversibility sweep with PyJanus (parse -> validate -> body+invert==identity)
to record a verification status per file.  Emits:

  catalog.json   machine-readable index (one record per .j file)
  CATALOG.md     human-readable: health summary, coverage matrix, flagship
                 table, full inventory, and a "collection backlog" of files
                 that need attention.

Usage:
  python3 tools/build_catalog.py      # PyJanus: $PYJANUS, else ../PyJanus

Re-run whenever programs are added so the catalog stays current.
"""
from __future__ import annotations
import os, sys, glob, json, io, contextlib, copy, re

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PYJANUS = os.environ.get(
    "PYJANUS", os.path.join(os.path.dirname(REPO), "PyJanus"))  # sibling checkout

# ---- PyJanus reversibility sweep (optional; degrades to status="unknown") ----
def make_checker():
    try:
        sys.path.insert(0, PYJANUS)
        from jana_py.ast import Program, ProcMain
        from jana_py.invert import invert_stmts
        from jana_py.parser_jana2014 import parse_program
        from jana_py.runtime import Runtime
        from jana_py.validate import validate_program
    except Exception as e:                      # PyJanus not importable
        return None

    def store(program):
        rt = Runtime(program); rt.run()
        return {k: copy.deepcopy(c.value) for k, c in rt._root_frame.vars.items()}

    def check(path, rel):
        try:
            prog = parse_program(rel, open(path).read())
        except Exception as e:
            return "parse_err", str(e).splitlines()[0][:80]
        try:
            validate_program(prog)
        except Exception as e:
            msg = str(e)
            if "No main" in msg or "no main" in msg:
                return "library", "no main procedure (reusable procedures only)"
            return "validate_err", msg.splitlines()[0][:80]
        if prog.main is None:
            return "library", "no main procedure"
        try:
            with contextlib.redirect_stdout(io.StringIO()):
                init = ProcMain(prog.main.vdecls, [], prog.main.pos)
                s0 = store(Program(init, prog.procs, prog.struct_defs))
                body = list(prog.main.stmts) + invert_stmts(prog.main.stmts, global_mode=False)
                s1 = store(Program(ProcMain(prog.main.vdecls, body, prog.main.pos),
                                   prog.procs, prog.struct_defs))
            return ("reversible", "") if s0 == s1 else ("not_identity", "")
        except Exception as e:
            full = str(e)
            if "l-values are supported" in full:
                reason = "dialect: literal push/pop"
            elif "aliases" in full:
                reason = "alias restriction (var on both sides)"
            elif "Assertion failed" in full:
                reason = "assertion failed (logic/reversibility)"
            elif "out of" in full and "index" in full:
                reason = "array index out of bounds"
            else:
                reason = full.splitlines()[0][:60]
            return "run_err", reason
    return check

# ---- categorisation --------------------------------------------------------
DIR_CATEGORY = {
    "bsort": "Sorting", "ssort": "Sorting", "isort": "Sorting", "msort": "Sorting",
    "qsort": "Sorting", "hsort": "Sorting", "csort": "Sorting", "treesort": "Sorting",
    "linear_search": "Searching", "string_search": "Searching",
    "bfs": "Graph", "depth_search": "Graph", "bellman_ford": "Graph",
    "floyd_warshall": "Graph", "apsp": "Graph",
    "avl": "Data structure", "minheap": "Data structure", "dynarray": "Data structure",
    "perm": "Permutation/ranking", "rank": "Permutation/ranking", "inc_code": "Permutation/ranking",
    "dp": "Dynamic programming", "numeric": "Numeric",
    "dijkstra": "Graph", "toposort": "Graph", "geometry": "Geometry",
    "mst": "Graph", "scc": "Graph",
}
# per-file overrides for the mixed others/ bucket
def categorize(rel):
    top = rel.split("/")[0]
    if top in DIR_CATEGORY:
        # a couple of intra-dir exceptions
        base = os.path.basename(rel)
        if top == "qsort" and "queue" in base: return "Data structure"
        return DIR_CATEGORY[top]
    base = os.path.basename(rel).lower()
    if "sort" in base: return "Sorting"
    if "search" in base or "binarytree" in base: return "Graph"
    if any(k in base for k in ("queue", "linkedlist", "stack", "buildtree", "tree")): return "Data structure"
    if any(k in base for k in ("rank", "invtab", "decfac", "perm")): return "Permutation/ranking"
    if any(k in base for k in ("fact", "combination", "gensuc", "genparen", "factoriz")): return "Combinatorics/Numeric"
    if "matrixmult" in base: return "Numeric"
    return "Misc"

def provenance(path):
    for line in open(path, encoding="utf-8", errors="replace"):
        s = line.strip()
        if s.startswith("//"):
            s = s.lstrip("/").strip()
        elif s.startswith("/*"):
            s = s.lstrip("/*").strip()
        elif s == "" or not s.startswith(("//", "/*", "*")):
            continue
        else:
            s = s.lstrip("*").strip()
        if s:
            return s[:90]
    return ""

# files that intentionally do not run under PyJanus jana2014
BY_DESIGN = {
    "bsort/code/bsort_irev.j": "irreversible demo variant (uses emit; non-jana2014)",
    "isort/code/isort_irev.j": "irreversible demo variant (uses emit; non-jana2014)",
    "isort/code/isort_irev1.j": "irreversible demo variant (uses emit; non-jana2014)",
    "others/matrixmult.j": "pseudo-code sketch, not executable jana2014",
    "string_search/Force_str_search_rejected.j": "documented rejected approach (kept for analysis notes)",
    "minheap/minheap_Nohr2015_w_macro.j": "macro template; expand with preprocess.sh",
    "string_search/kmp.j": "historical known-broken; fixed implementation in kmp2.j",
    "string_search/kmp1.j": "historical known-broken; fixed implementation in kmp2.j",
}

# files mirrored into the PyJanus corpus (tests/jana2014/fixtures/examples/*.ja)
IN_CORPUS = {
    "csort/csort1.j","isort/disort.j","dynarray/dynarray.j","bfs/bfs.j",
    "bellman_ford/bellman_ford.j","floyd_warshall/floyd_warshall.j","apsp/apsp.j",
    "avl/avl_search.j","avl/avl_insert.j","avl/avl_delete.j","treesort/treesort.j",
    "msort/msort2.j","bsort/bsort2.j","ssort/ssort1.j","hsort/hsort2.j",
    "qsort/qsort2.j","rank/rank.j","depth_search/dsearch_matrix.j",
    "minheap/minheap_subset.j",
    "numeric/ext_gcd.j","numeric/modexp.j","dp/knapsack.j","dp/lis.j",
    "dijkstra/dijkstra.j","toposort/toposort.j","geometry/closest_pair.j",
    "string_search/kmp2.j","inc_code/inc_perm.j",
    "mst/prim.j","scc/kosaraju.j","geometry/convex_hull.j",
    "others/examples/fact.j","others/examples/combination.j",
}

# ---- run --------------------------------------------------------------------
check = make_checker()
records = []
for path in sorted(glob.glob(f"{REPO}/**/*.j", recursive=True)):
    rel = os.path.relpath(path, REPO)
    if rel in BY_DESIGN:
        status, detail = "by_design", BY_DESIGN[rel]
    else:
        status, detail = (check(path, rel) if check else ("unknown", ""))
    records.append({
        "file": rel,
        "category": categorize(rel),
        "status": status,
        "detail": detail,
        "in_pyjanus_corpus": rel in IN_CORPUS,
        "provenance": provenance(path),
    })

with open(f"{REPO}/catalog.json", "w") as f:
    json.dump({"records": records}, f, ensure_ascii=False, indent=1)

# ---- markdown ---------------------------------------------------------------
from collections import Counter, defaultdict
status_counts = Counter(r["status"] for r in records)
cat_files = defaultdict(list)
for r in records: cat_files[r["category"]].append(r)
CATS = ["Sorting","Searching","Graph","Data structure","Dynamic programming","Geometry","Permutation/ranking",
        "Combinatorics/Numeric","Numeric","Misc"]

def md_escape(s): return s.replace("|","\\|")

lines = []
w = lines.append
w("# Reversible Algorithms — Catalog\n")
w("A live index of the reversible Janus programs in this repository, with a\n"
  "per-file **reversibility verification status** (PyJanus jana2014: parse →\n"
  "validate → `call`+`uncall` = identity).  Regenerate with:\n")
w("```sh\nPYJANUS=<path-to-PyJanus> python3 tools/build_catalog.py\n```\n")
w("Machine-readable form: [`catalog.json`](catalog.json).\n")

w("## Collection health\n")
w(f"Total programs: **{len(records)}**\n")
w("| status | count | meaning |")
w("|---|---:|---|")
MEAN = {
 "reversible":"parses & round-trips under PyJanus (call+uncall = identity)",
 "library":"no `main` — reusable procedures only",
 "run_err":"runtime error (often `dialect:literal-push/pop`, convertible)",
 "parse_err":"different Janus dialect / needs preprocessing",
 "validate_err":"validation error (e.g. no main)",
 "not_identity":"runs but not reversible — needs fixing",
 "by_design":"intentionally not executable jana2014 (template / demo / historical)",
 "unknown":"PyJanus unavailable at build time",
}
for s,c in status_counts.most_common():
    w(f"| `{s}` | {c} | {MEAN.get(s,'')} |")
w("")

w("## Coverage matrix (category × status)\n")
seen_stats = [s for s,_ in status_counts.most_common()]
hdr = "| category | total | " + " | ".join(f"`{s}`" for s in seen_stats) + " | in corpus |"
w(hdr); w("|" + "---|"*(len(seen_stats)+3))
for cat in CATS:
    rs = cat_files.get(cat)
    if not rs: continue
    row = Counter(r["status"] for r in rs)
    ncorp = sum(1 for r in rs if r["in_pyjanus_corpus"])
    w(f"| {cat} | {len(rs)} | " + " | ".join(str(row.get(s,0)) for s in seen_stats) + f" | {ncorp} |")
w("")

# curated flagship entries (technique / complexity / source) — kept in sync by hand
FLAGSHIP = [
 # name, file, source/thm, technique, time, space, energy
 ("Counting sort","csort/csort1.j","EEA Thm 6.13","decision-bit log","Θ(n+k)","Θ(n+k)","0"),
 ("Duplicated insertion sort","isort/disort.j","EEA Thm 6.6","log-then-unroll","Θ(n²)","Θ(n)","0"),
 ("Merge sort (word model)","msort/msort2.j","EEA Thm 6.4","index augmentation","Θ(n lg n)","Θ(n)","0"),
 ("Tree sort (general d-bit)","treesort/treesort.j","EEA Thm 6.5","AVL + multiplicity","Θ(n lg n)","Θ(nd)","0"),
 ("Dynamic array","dynarray/dynarray.j","EEA Thm 5.5","resize-bit log","O(1) amort.","Θ(n)","0"),
 ("AVL search","avl/avl_search.j","EEA Thm 6.9","Bennett (compute-copy-uncompute)","Θ(lg n)","O(1)","0"),
 ("AVL insert","avl/avl_insert.j","EEA Thm 6.11","rotation-code log","Θ(lg n)","Θ(n)","0"),
 ("AVL delete","avl/avl_delete.j","EEA Thm 6.12","successor splice + overwrite log","O(lg n)","Θ(n)+O(k)","0"),
 ("Binary min-heap","minheap/minheap_subset.j","EEA Thm 6.7/6.8","protected-if + uncompute","Θ(lg n)","Θ(lg n)","0"),
 ("Breadth-first search","bfs/bfs.j","EEA Thm 6.16","discovery-bit log","Θ(V+E)","Θ(V+E)","0"),
 ("Depth-first search","depth_search/dsearch_matrix.j","EEA §6.2","recursion + decision-bit log","Θ(V+E)","Θ(V+E)","0"),
 ("Bellman-Ford","bellman_ford/bellman_ford.j","EEA Thm 6.18","overwrite log + uncompute","Θ(VE)","Θ(VE)","0"),
 ("Floyd-Warshall","floyd_warshall/floyd_warshall.j","EEA Thm 6.20","overwrite log","Θ(V³)","O(V³)","0"),
 ("Matrix APSP (min,+)","apsp/apsp.j","EEA Thm 6.22","repeated squaring + Bennett min","O(V³ lg V)","O(V² lg V)","0"),
]
st = {r["file"]: r["status"] for r in records}
w("## Flagship entries\n")
w("Fully-documented, corpus-verified algorithms.  *EEA* = *Energy-Efficient\n"
  "Algorithms* (arXiv:1605.08448); all are 0-energy (reversible) in its model.\n")
w("| algorithm | file | source | technique | time | space | energy | verified |")
w("|---|---|---|---|---|---|:--:|:--:|")
for name,file,src,tech,t,sp,en in FLAGSHIP:
    ok = "✅" if st.get(file)=="reversible" else "⚠️"
    w(f"| {name} | `{file}` | {src} | {tech} | {t} | {sp} | {en} | {ok} |")
w("")

w("## Full inventory\n")
for cat in CATS:
    rs = cat_files.get(cat)
    if not rs: continue
    w(f"### {cat}\n")
    w("| file | status | in corpus | provenance |")
    w("|---|---|:--:|---|")
    for r in sorted(rs, key=lambda r:(r['status']!='reversible', r['file'])):
        badge = "✅" if r["status"]=="reversible" else ("📚" if r["status"]=="library" else "⚠️")
        corp = "★" if r["in_pyjanus_corpus"] else ""
        det = f" — {r['detail']}" if r['detail'] and r['status']!='reversible' else ""
        w(f"| `{md_escape(r['file'])}` | {badge} {r['status']}{md_escape(det)} | {corp} | {md_escape(r['provenance'])} |")
    w("")

w("## Collection backlog (files needing attention)\n")
backlog = [r for r in records if r["status"] in ("run_err","parse_err","not_identity")]
w(f"{len(backlog)} programs do not yet round-trip under PyJanus jana2014. "
  "Most are valid in the tetsuo.jp playground dialect but use literal "
  "`push`/`pop`; converting these to l-value temporaries (as in the corpus "
  "examples) would bring them into the verified corpus.\n")
by_reason = defaultdict(list)
for r in backlog:
    key = r["detail"] or r["status"]
    by_reason[key].append(r["file"])
for reason, fs in sorted(by_reason.items(), key=lambda kv:-len(kv[1])):
    w(f"- **{md_escape(reason)}** ({len(fs)}): " + ", ".join(f"`{f}`" for f in fs[:8]) + (" …" if len(fs)>8 else ""))
w("")

open(f"{REPO}/CATALOG.md","w").write("\n".join(lines))
print(f"wrote catalog.json ({len(records)} records) and CATALOG.md")
print("status:", dict(status_counts))
