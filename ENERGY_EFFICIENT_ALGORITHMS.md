# Energy-Efficient Algorithms — Janus implementations

Reversible Janus (`jana2014` dialect) implementations of the algorithms in

> *Energy-Efficient Algorithms* — arXiv:1605.08448
> (Demaine, Lynch, Mirano, Tyagi, et al.)

Each program is a pure Janus procedure, hence reversible by construction; in
the paper's energy model that means **0-energy** (Landauer). Correctness and
reversibility were checked with **PyJanus**
(`github.com/yokoyama-lab/PyJanus`):

```sh
python3 -m jana_py.cli --std jana2014 -s <file>.j        # run (forward)
# reversibility: `call` then `uncall` (or --direction backward) restores the input
```

## Map: paper → file

| Paper (section / theorem) | This repo |
|---|---|
| §6.1 Reversible Comparison Sort (merge sort + index, word model) — Thm 6.4 | `msort/msort2.j` *(pre-existing)* |
| §6.1 Reversible Comparison Sort (general case, AVL + counting) — Thm 6.5 | `treesort/treesort.j` |
| §6.1.1 Reversible Duplicated Insertion Sort — Thm 6.6 | `isort/disort.j` |
| §6.1.2 Reversible Counting Sort — Thm 6.13 | `csort/csort1.j` |
| §5.2 Reversible Dynamic Array — Thm 5.5 | `dynarray/dynarray.j` |
| §5.3 Reversible AVL Tree — Search, Thm 6.9 | `avl/avl_search.j` |
| §5.3 Reversible AVL Tree — Insert (+rotations), Thm 6.11 | `avl/avl_insert.j` |
| §5.3 Reversible AVL Tree — Delete (+rotations), Thm 6.12 | `avl/avl_delete.j` |
| §5.4 Reversible Binary Heap (insert / delete-min) — Thm 6.7/6.8 | `minheap/` *(pre-existing, min-heap)* |
| §6.2 Reversible BFS — Thm 6.16 | `bfs/bfs.j` |
| §6.2 Reversible DFS | `depth_search/` *(pre-existing)* |
| §6.3 Reversible Bellman-Ford — Thm 6.18 | `bellman_ford/bellman_ford.j` |
| §6.4 Reversible Floyd-Warshall — Thm 6.20 | `floyd_warshall/floyd_warshall.j` |
| §6.5 Reversible APSP via (min,+) repeated squaring — Thm 6.22 | `apsp/apsp.j` |

## Reversibility techniques used (as in the paper)

- **Uncompute intermediates** — a temporary (e.g. `tempDist`, a candidate sum)
  is subtracted back to 0 after use (Bellman-Ford, Floyd-Warshall).
- **Log every overwrite** — when an irreversible assignment is unavoidable, the
  old value is pushed on a log stack so it can be restored (Bellman-Ford dist/pred,
  Floyd-Warshall / APSP cells, AVL pointers & heights).
- **Decision-bit logging** — a branch that mutates its own condition pushes one
  bit (or a small code) used as the reversible exit assertion (counting-sort
  placement, BFS discovery, relaxations, AVL rotation codes 0/LL/RR/LR/RL).
- **Compute–copy–uncompute (Bennett)** — a reversible subroutine computes a value
  into a temporary log, the result is copied out, then the subroutine is `uncall`ed
  to erase the log, leaving no garbage (AVL search path; the (min,+) inner
  minimum in `apsp`, which is what keeps its permanent space at O(V²·lg V)).

## Notes on the irreversible / semi-reversible variants

The paper also states **standard** (energy-costing) and **semi-reversible**
versions (e.g. APSP Thm 6.21 / 6.23). Janus cannot express a genuinely
irreversible step, so those are represented here only by their reversible
counterparts; the difference is purely the paper's energy/space accounting,
not the Janus code. Stacks/queues/deques and doubly-linked lists (§5.1) are
provided natively by Janus (`stack`, `push`/`pop`/`top`/`empty`).
