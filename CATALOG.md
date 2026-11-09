# Reversible Algorithms — Catalog

A live index of the reversible Janus programs in this repository, with a
per-file **reversibility verification status** (PyJanus jana2014: parse →
validate → `call`+`uncall` = identity).  Regenerate with:

```sh
PYJANUS=<path-to-PyJanus> python3 tools/build_catalog.py
```

Machine-readable form: [`catalog.json`](catalog.json).

## Collection health

Total programs: **134**

| status | count | meaning |
|---|---:|---|
| `reversible` | 123 | parses & round-trips under PyJanus (call+uncall = identity) |
| `by_design` | 8 | intentionally not executable jana2014 (template / demo / historical) |
| `library` | 3 | no `main` — reusable procedures only |

## Coverage matrix (category × status)

| category | total | `reversible` | `by_design` | `library` | in corpus |
|---|---|---|---|---|---|
| Sorting | 48 | 45 | 3 | 0 | 8 |
| Searching | 27 | 24 | 3 | 0 | 1 |
| Graph | 14 | 11 | 0 | 3 | 9 |
| Data structure | 12 | 11 | 1 | 0 | 5 |
| Dynamic programming | 4 | 4 | 0 | 0 | 2 |
| Geometry | 2 | 2 | 0 | 0 | 2 |
| Permutation/ranking | 15 | 15 | 0 | 0 | 2 |
| Combinatorics/Numeric | 6 | 6 | 0 | 0 | 2 |
| Numeric | 6 | 5 | 1 | 0 | 2 |

## Flagship entries

Fully-documented, corpus-verified algorithms.  *EEA* = *Energy-Efficient
Algorithms* (arXiv:1605.08448); all are 0-energy (reversible) in its model.

| algorithm | file | source | technique | time | space | energy | verified |
|---|---|---|---|---|---|:--:|:--:|
| Counting sort | `csort/csort1.j` | EEA Thm 6.13 | decision-bit log | Θ(n+k) | Θ(n+k) | 0 | ✅ |
| Duplicated insertion sort | `isort/disort.j` | EEA Thm 6.6 | log-then-unroll | Θ(n²) | Θ(n) | 0 | ✅ |
| Merge sort (word model) | `msort/msort2.j` | EEA Thm 6.4 | index augmentation | Θ(n lg n) | Θ(n) | 0 | ✅ |
| Tree sort (general d-bit) | `treesort/treesort.j` | EEA Thm 6.5 | AVL + multiplicity | Θ(n lg n) | Θ(nd) | 0 | ✅ |
| Dynamic array | `dynarray/dynarray.j` | EEA Thm 5.5 | resize-bit log | O(1) amort. | Θ(n) | 0 | ✅ |
| AVL search | `avl/avl_search.j` | EEA Thm 6.9 | Bennett (compute-copy-uncompute) | Θ(lg n) | O(1) | 0 | ✅ |
| AVL insert | `avl/avl_insert.j` | EEA Thm 6.11 | rotation-code log | Θ(lg n) | Θ(n) | 0 | ✅ |
| AVL delete | `avl/avl_delete.j` | EEA Thm 6.12 | successor splice + overwrite log | O(lg n) | Θ(n)+O(k) | 0 | ✅ |
| Binary min-heap | `minheap/minheap_subset.j` | EEA Thm 6.7/6.8 | protected-if + uncompute | Θ(lg n) | Θ(lg n) | 0 | ✅ |
| Breadth-first search | `bfs/bfs.j` | EEA Thm 6.16 | discovery-bit log | Θ(V+E) | Θ(V+E) | 0 | ✅ |
| Depth-first search | `depth_search/dsearch_matrix.j` | EEA §6.2 | recursion + decision-bit log | Θ(V+E) | Θ(V+E) | 0 | ✅ |
| Bellman-Ford | `bellman_ford/bellman_ford.j` | EEA Thm 6.18 | overwrite log + uncompute | Θ(VE) | Θ(VE) | 0 | ✅ |
| Floyd-Warshall | `floyd_warshall/floyd_warshall.j` | EEA Thm 6.20 | overwrite log | Θ(V³) | O(V³) | 0 | ✅ |
| Matrix APSP (min,+) | `apsp/apsp.j` | EEA Thm 6.22 | repeated squaring + Bennett min | O(V³ lg V) | O(V² lg V) | 0 | ✅ |

## Full inventory

### Sorting

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `bsort/bsort2.j` | ✅ reversible | ★ | bubble sort with optimal garbage |
| `bsort/code/bsort1.j` | ✅ reversible |  |  |
| `bsort/code/bsort1_online.j` | ✅ reversible |  | Tested on an online interpreter: http://topps.diku.dk/pirc/janus-playground/ |
| `bsort/code/bsort2.j` | ✅ reversible |  | Xor-copying from s[] to t[] of length n |
| `bsort/code/bsort3.j` | ✅ reversible |  | Setting to p[] identity permutation of length n |
| `bsort/code/bsort4.j` | ✅ reversible |  | checked on Oct. 17, 2014 |
| `bsort/code/bsort5.j` | ✅ reversible |  | We compute the values d[] in the order of decreasing i, the opposite order to bsort4 |
| `bsort/code/bsort_dijkstra79_A2.j` | ✅ reversible |  | Dijkstra, E. W. (1979). Program Inversion. Program Construction, International Summer Scho |
| `bsort/examples/bsort_inversiontable.j` | ✅ reversible |  | bubble sort with optimal intermediate garbage and optimal garbage (inversion table) |
| `bsort/examples/bsort_inversiontable_r2l.j` | ✅ reversible |  | bubble sort (right to left) with optimal intermediate garbage and optimal garbage: |
| `csort/csort1.j` | ✅ reversible | ★ | Reversible Counting Sort |
| `hsort/code/hsort1.j` | ✅ reversible |  | heapsort with optimal garbage |
| `hsort/code/hsort2.j` | ✅ reversible |  | Wrong! |
| `hsort/hsort2.j` | ✅ reversible | ★ | heapsort with optimal garbage |
| `hsort/hsort3.j` | ✅ reversible |  | percolating heapsort with optimal garbage |
| `isort/code/isort1.j` | ✅ reversible |  | checked on Oct. 17, 2014 |
| `isort/code/isort1_old.j` | ✅ reversible |  | insert a[j] into a[0..j] |
| `isort/code/isort2.j` | ✅ reversible |  | checked on Oct. 17, 2014 |
| `isort/code/isort2_old.j` | ✅ reversible |  | Xor-copying from s[] to t[] of length n |
| `isort/code/isort3.j` | ✅ reversible |  | checked on Oct. 17, 2014 |
| `isort/code/isort3_old.j` | ✅ reversible |  | Xor-copying from s[] to t[] of length n |
| `isort/code/isort4_old.j` | ✅ reversible |  | insert a[j] into a[0..j] |
| `isort/code/isort_dijkstra79_A1.j` | ✅ reversible |  | Dijkstra, E. W. (1979). Program Inversion. Program Construction, International Summer Scho |
| `isort/disort.j` | ✅ reversible | ★ | Reversible Duplicated Insertion Sort |
| `isort/isort10.j` | ✅ reversible |  | insertion sort (right to left) with optimal intermediate garbage: right decreasing relativ |
| `isort/isort5.j` | ✅ reversible |  | Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.1 |
| `isort/isort6.j` | ✅ reversible |  | isort with optimal garbage |
| `isort/isort7.j` | ✅ reversible |  | isort using optimal intermediate garbage with optimal garbage |
| `isort/isort8.j` | ✅ reversible |  | insertion sort (left to right) with optimal intermediate garbage: (left) inversion table f |
| `isort/isort9.j` | ✅ reversible |  | insertion sort (right to left) with optimal intermediate garbage: right decreasing relativ |
| `isort/isort_hall.j` | ✅ reversible |  | Hall, J. S. (1994). A reversible instruction set architecture and algorithms. Physics and  |
| `msort/code/msort.j` | ✅ reversible |  | mergesort using internally optimal garbage with optimal garbage |
| `msort/msort1.j` | ✅ reversible |  | mergesort with optimal garbage |
| `msort/msort2.j` | ✅ reversible | ★ | mergesort using internally optimal garbage with optimal garbage |
| `others/code/lisort.j` | ✅ reversible |  | find the previous element to one at position x in L[] and set its position to p |
| `others/examples/counting_sort.j` | ✅ reversible |  | counting sort with optimal garbage |
| `others/examples/shell_sort1.j` | ✅ reversible |  | Sedgewick, R. (1997). Algorithms in C: Parts 1-4, Fundamentals, Data Structures, Sorting,  |
| `qsort/code/qsort.j` | ✅ reversible |  | xor-copy to p the index of the maximum of ord[l..r] |
| `qsort/code/qsort1.j` | ✅ reversible |  | xor-copy to p the index of the maximum of ord[l..r] |
| `qsort/code/qsort2.j` | ✅ reversible |  | in-place quick sort |
| `qsort/qsort2.j` | ✅ reversible | ★ | qsort using minimum garbage with optimal garbage |
| `ssort/code/ssort.j` | ✅ reversible |  | selection sort with optimal garbage (linear size) |
| `ssort/code/ssort1.j` | ✅ reversible |  | checked on Oct. 17, 2014 |
| `ssort/ssort1.j` | ✅ reversible | ★ | selection sort with optimal garbage (linear size) |
| `treesort/treesort.j` | ✅ reversible | ★ | Reversible Comparison Sort, general case (via reversible AVL tree) |
| `bsort/code/bsort_irev.j` | ⚠️ by_design — irreversible demo variant (uses emit; non-jana2014) |  |  |
| `isort/code/isort_irev.j` | ⚠️ by_design — irreversible demo variant (uses emit; non-jana2014) |  | insert a[j] into a[j+1..n-1] |
| `isort/code/isort_irev1.j` | ⚠️ by_design — irreversible demo variant (uses emit; non-jana2014) |  | find the previous element to one at position x in L[] and set its position to p |

### Searching

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `linear_search/Lsearch1.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法 |
| `linear_search/Lsearch2.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法 |
| `linear_search/Lsearch3.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」 |
| `linear_search/Lsearch4.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法スタックver |
| `linear_search/Lsearch5.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法スタックver |
| `linear_search/Lsearch6.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法スタックver |
| `linear_search/Lsearch7.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法スタックver |
| `linear_search/list_sentinel1.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法 |
| `linear_search/list_sentinel2.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法 |
| `linear_search/list_sentinel3.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法スタックver |
| `linear_search/list_sentinel4.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法スタックver |
| `linear_search/list_sentinel5.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法スタックver |
| `linear_search/sentinel1.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法 |
| `linear_search/sentinel2.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法 |
| `linear_search/sentinel3.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法スタックver |
| `linear_search/sentinel4.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法スタックver |
| `linear_search/sentinel5.j` | ✅ reversible |  | 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法スタックver |
| `string_search/Force_str_search1-a.j` | ✅ reversible |  | Cのプログラム（force_str_search.c）を元に可逆化をしたJanusプログラム |
| `string_search/Force_str_search1-b.j` | ✅ reversible |  | Cのプログラム（force_str_search.c）を元に可逆化をしたJanusプログラム |
| `string_search/Force_str_search1-c.j` | ✅ reversible |  | Cのプログラム（force_str_search.c）を元に可逆化をしたJanusプログラム |
| `string_search/Force_str_search2-a.j` | ✅ reversible |  | if文のelse部分を変更することによりスタックを排除した形 |
| `string_search/Force_str_search2-b.j` | ✅ reversible |  | if文のelse部分を変更することによりスタックを排除した形 |
| `string_search/Force_str_search2-c.j` | ✅ reversible |  | if文のelse部分を変更することによりスタックを排除した形 |
| `string_search/kmp2.j` | ✅ reversible | ★ | Reversible Knuth-Morris-Pratt (occurrence counting) |
| `string_search/Force_str_search_rejected.j` | ⚠️ by_design — documented rejected approach (kept for analysis notes) |  | ゴミをなくす方法として文字が違ったとしてもパターンの最後まで比較させる方法を考えたがアサーションの記述が不可能になった |
| `string_search/kmp.j` | ⚠️ by_design — historical known-broken; fixed implementation in kmp2.j |  | STATUS: known-broken (WIP). Diagnosed 2026-07: the outer loops |
| `string_search/kmp1.j` | ⚠️ by_design — historical known-broken; fixed implementation in kmp2.j |  | STATUS: known-broken (WIP), same root cause as kmp.j: the outer loop |

### Graph

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `apsp/apsp.j` | ✅ reversible | ★ | Reversible All-Pairs Shortest Paths via (min,+) matrix multiplication |
| `bellman_ford/bellman_ford.j` | ✅ reversible | ★ | Reversible Bellman-Ford (single-source shortest paths) |
| `bfs/bfs.j` | ✅ reversible | ★ | Reversible Breadth-First Search |
| `depth_search/dsearch_matrix.j` | ✅ reversible | ★ | Reversible Depth-First Search (adjacency matrix, recursive) |
| `dijkstra/dijkstra.j` | ✅ reversible | ★ | Reversible Dijkstra (single-source shortest paths, O(V^2)) |
| `floyd_warshall/floyd_warshall.j` | ✅ reversible | ★ | Reversible Floyd-Warshall (all-pairs shortest paths) |
| `mst/prim.j` | ✅ reversible | ★ | Reversible Prim MST (minimum spanning tree, O(V^2)) |
| `others/examples/binarytree2e.j` | ✅ reversible |  | Depth first search: dfs_rec |
| `others/examples/breadth_first_search.j` | ✅ reversible |  | reversible queue |
| `scc/kosaraju.j` | ✅ reversible | ★ | Reversible Kosaraju SCC (strongly connected components) |
| `toposort/toposort.j` | ✅ reversible | ★ | Reversible Topological Sort (DFS post-order) |
| `depth_search/dsearch1.j` | 📚 library — no main procedure (reusable procedures only) |  | 卒業研究「可逆な深さ優先探索」 |
| `depth_search/dsearch2.j` | 📚 library — no main procedure (reusable procedures only) |  | 卒業研究「可逆な深さ優先探索」 |
| `depth_search/dsearch3.j` | 📚 library — no main procedure (reusable procedures only) |  | 卒業研究「可逆な深さ優先探索」 |

### Data structure

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `avl/avl_delete.j` | ✅ reversible | ★ | Reversible AVL Tree -- Delete (with rotations) |
| `avl/avl_insert.j` | ✅ reversible | ★ | Reversible AVL Tree -- Insert (with rotations) |
| `avl/avl_search.j` | ✅ reversible | ★ | Reversible AVL Tree -- Search |
| `dynarray/dynarray.j` | ✅ reversible | ★ | Reversible Dynamic Array |
| `minheap/minheap_GPC2018.j` | ✅ reversible |  | Guo, L., Peng, C. and He, C.: New Reversible Computing Algorithms for Shortest Paths Probl |
| `minheap/minheap_Nohr2015.j` | ✅ reversible |  | Nøhr, S. V.: Reversible Graph Algorithms, Bachelor's thesis, Copenhagen University (2015). |
| `minheap/minheap_subset.j` | ✅ reversible | ★ | Reversible binary (min-)heap -- verified-subset-compliant version. |
| `others/examples/buildTree.j` | ✅ reversible |  | Er, N. C. (1983). |
| `others/examples/linkedlist5e.j` | ✅ reversible |  | Insertion and search on sorted lists |
| `others/stackPermut.j` | ✅ reversible |  | Er, N. C. (1983). |
| `qsort/queue5e.j` | ✅ reversible |  | Queue |
| `minheap/minheap_Nohr2015_w_macro.j` | ⚠️ by_design — macro template; expand with preprocess.sh |  | 以下の卒論にあるプログラムをマクロを使って簡略化し、ゴミを大幅に減らしたバージョン |

### Dynamic programming

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `dp/edit_distance.j` | ✅ reversible |  | Reversible Edit Distance (Levenshtein, dynamic programming) |
| `dp/knapsack.j` | ✅ reversible | ★ | Reversible 0/1 Knapsack (dynamic programming) |
| `dp/lcs.j` | ✅ reversible |  | Reversible Longest Common Subsequence (dynamic programming) |
| `dp/lis.j` | ✅ reversible | ★ | Reversible Longest Increasing Subsequence (O(n^2) DP) |

### Geometry

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `geometry/closest_pair.j` | ✅ reversible | ★ | Reversible Closest Pair of Points (brute force, squared distances) |
| `geometry/convex_hull.j` | ✅ reversible | ★ | Reversible Convex Hull (Jarvis march / gift wrapping) |

### Permutation/ranking

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `inc_code/inc_decfac.j` | ✅ reversible |  |  |
| `inc_code/inc_perm.j` | ✅ reversible | ★ | Reversible Next Permutation (lexicographic successor) |
| `inc_code/inc_perm_clean.j` | ✅ reversible |  | Reversible Next Permutation WITHOUT garbage |
| `others/code/decfac2rank.j` | ✅ reversible |  | iterative factorial: linear time |
| `others/examples/invtab2rank.j` | ✅ reversible |  | A clean translation from an inversion table to a rank |
| `perm/code/perm2decfac.j` | ✅ reversible |  | Bonet, B. (2008). Efficient algorithms to rank and unrank permutations in lexicographic or |
| `perm/code/perm2decfac_nolex.j` | ✅ reversible |  | p[0] ^= 2 |
| `perm/code/perm2rank.j` | ✅ reversible |  | Myrvold, W. and F. Ruskey (2001). "Ranking and unranking permutations in linear time." Inf |
| `perm/code/perm2rank2.j` | ✅ reversible |  | Myrvold, W. and F. Ruskey (2001). "Ranking and unranking permutations in linear time." Inf |
| `perm/perm.j` | ✅ reversible |  | recursive implementation of permutation: exponential time |
| `perm/perm2.j` | ✅ reversible |  | recursive implementation of permutation: linear time |
| `perm/perm2invtab1.j` | ✅ reversible |  | Permutation to inversion table |
| `rank/rank.j` | ✅ reversible | ★ | Er, M. C. (1985). |
| `rank/rank_lexicographic.j` | ✅ reversible |  | Bonet, B. (2008). Efficient algorithms to rank and unrank permutations in lexicographic or |
| `rank/rank_perm.j` | ✅ reversible |  | Myrvold, W. and F. Ruskey (2001). "Ranking and unranking permutations in linear time." Inf |

### Combinatorics/Numeric

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `others/code/factorial.j` | ✅ reversible |  | Tested on an online interpreter: http://topps.diku.dk/pirc/janus-playground/ |
| `others/examples/combination.j` | ✅ reversible | ★ | iterative factorial: linear time |
| `others/examples/fact.j` | ✅ reversible | ★ | recursive factorial: factR is called exponential times |
| `others/examples/factorization.j` | ✅ reversible |  | Lutz, C. (1986). "Janus: a time-reversible language." |
| `others/examples/genParentheses.j` | ✅ reversible |  | Er, N. C. (1983). |
| `others/examples/genSuc.j` | ✅ reversible |  | Er, M. C. (1985). |

### Numeric

| file | status | in corpus | provenance |
|---|---|:--:|---|
| `numeric/ext_gcd.j` | ✅ reversible | ★ | Reversible Extended Euclidean Algorithm |
| `numeric/ext_gcd_clean.j` | ✅ reversible |  | Reversible Extended Euclidean Algorithm WITHOUT a quotient log |
| `numeric/gcd.j` | ✅ reversible |  | Reversible GCD (subtractive Euclid) |
| `numeric/gcd_clean.j` | ✅ reversible |  | Reversible GCD (subtractive Euclid) WITHOUT a step log |
| `numeric/modexp.j` | ✅ reversible | ★ | Reversible Modular Exponentiation (square-and-multiply) |
| `others/matrixmult.j` | ⚠️ by_design — pseudo-code sketch, not executable jana2014 |  | Debug variables |

## Collection backlog (files needing attention)

0 programs do not yet round-trip under PyJanus jana2014. Most are valid in the tetsuo.jp playground dialect but use literal `push`/`pop`; converting these to l-value temporaries (as in the corpus examples) would bring them into the verified corpus.

