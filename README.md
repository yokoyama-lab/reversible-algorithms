# Reversible Algorithms in Janus

A curated, **verified** collection of reversible algorithms written in
[Janus](https://github.com/yokoyama-lab/PyJanus) (the `jana2014` dialect,
runnable with [PyJanus](https://github.com/yokoyama-lab/PyJanus); most files
also run unmodified on the online
[Janus playground](http://tetsuo.jp/janus-playground/)). The collection spans
sorting, searching, graph algorithms, data structures, dynamic programming,
combinatorics, and number theory — including a full implementation of the
algorithms from *Energy-Efficient Algorithms* (arXiv:1605.08448). Every
program is checked for reversibility (`call`+`uncall` = identity) and a
40-algorithm subset is checked for **correctness** against Python reference
implementations in CI, on every push.

## これは何か

日本語では「Janus（可逆プログラミング言語）で書かれた、検証済みの可逆アルゴリズム集」です。

- **134** 本の Janus プログラム
  - **123** 本 — PyJanus (`jana2014`, main e0cd78f) で `call`+`uncall` が恒等になることを確認済み（`reversible`）
  - **8** 本 — 意図的に実行不可（テンプレート／デモ／歴史的経緯の記録。`by_design`）
  - **3** 本 — `main` を持たない再利用可能な手続きライブラリ（`library`）
  - **未説明の失敗は 0 件**
- 対象言語は **jana2014**（`push`/`pop` は l-value のみ、`from C … until D` の入退場規律あり）
- 生きたカタログは [`CATALOG.md`](CATALOG.md) / [`catalog.json`](catalog.json)（`tools/build_catalog.py` で再生成）

## クイックスタート

[PyJanus](https://github.com/yokoyama-lab/PyJanus) をクローンしてインタプリタとして使う。

```sh
git clone https://github.com/yokoyama-lab/PyJanus.git
cd PyJanus
python3 -m jana_py.cli --std jana2014 -s ../reversible-algorithms/bfs/bfs.j
```

可逆性（call/uncall で入力が復元されること）を自分で確かめるには、`call` した後
続けて同じ手続きを `uncall` する `main()` を書く（各ファイルの `procedure main()`
がその実例）。多くのファイルはブラウザ版の
[janus-playground](http://tetsuo.jp/janus-playground/) にそのまま貼り付けても動く。

## 検証の3層

| # | 層 | 何を確認するか | ツール |
|---|---|---|---|
| 1 | 可逆性スイープ | 全134本を parse → validate → `call`+`uncall` = identity | `tools/build_catalog.py` |
| 2 | 参照差分テスト | 105 エントリ（99 ファイル）× 200ランダムケース × 3 seed を Python 参照実装と突合（CI必須） | `tools/reftest.py`, `.github/workflows/reftest.yml` |
| 3 | PyJanus corpus | interpreter / inverse / C codegen / Coq 検証済みオラクルの差分テスト（33例をミラー） | [PyJanus](https://github.com/yokoyama-lab/PyJanus) |

CI にはカタログの鮮度ゲートもある — `catalog.json`/`CATALOG.md` が
`build_catalog.py` の出力と一致しないとジョブが失敗する。

**差分テストは実際にバグを見つけている**: AVL 削除のリバランス回転で
出口検証ビットが誤っていた実バグ、および shell sort の潜在的な定義域制約
（長さ ≥ 10、要素はすべて正）を発見・文書化済み（詳細は
[`RECIPES.md`](RECIPES.md) 落とし穴チェックリストを参照）。

## 主要アルゴリズム（抜粋）

*EEA* = *Energy-Efficient Algorithms*（arXiv:1605.08448）。全項目とも同論文の
モデルで 0-energy（可逆）。全リストは [`CATALOG.md`](CATALOG.md) を参照。

| algorithm | file | source | technique |
|---|---|---|---|
| Counting sort | `csort/csort1.j` | EEA Thm 6.13 | decision-bit log |
| Merge sort (word model) | `msort/msort2.j` | EEA Thm 6.4 | index augmentation |
| Tree sort (general d-bit) | `treesort/treesort.j` | EEA Thm 6.5 | AVL + multiplicity |
| AVL search / insert / delete | `avl/avl_*.j` | EEA Thm 6.9/6.11/6.12 | Bennett / rotation-code log |
| Dynamic array | `dynarray/dynarray.j` | EEA Thm 5.5 | resize-bit log |
| Binary min-heap | `minheap/minheap_subset.j` | EEA Thm 6.7/6.8 | protected-if + uncompute |
| Breadth/Depth-First Search | `bfs/bfs.j`, `depth_search/dsearch_matrix.j` | EEA Thm 6.16 / §6.2 | discovery-bit log |
| Bellman-Ford / Floyd-Warshall | `bellman_ford/`, `floyd_warshall/` | EEA Thm 6.18/6.20 | overwrite log |
| Matrix APSP (min,+) | `apsp/apsp.j` | EEA Thm 6.22 | repeated squaring + Bennett min |

論文の全対応表は [`ENERGY_EFFICIENT_ALGORITHMS.md`](ENERGY_EFFICIENT_ALGORITHMS.md)。

## ディレクトリ構成（主要カテゴリ）

| ディレクトリ | 内容 |
|---|---|
| `bsort/`, `isort/`, `msort/`, `qsort/`, `ssort/`, `hsort/`, `csort/`, `treesort/` | ソート（bubble/insertion/merge/quick/selection/heap/counting/tree） |
| `linear_search/`, `string_search/` | 探索（線形探索・文字列探索/KMP） |
| `bfs/`, `dijkstra/`, `bellman_ford/`, `floyd_warshall/`, `apsp/`, `depth_search/`, `toposort/` | グラフアルゴリズム |
| `avl/`, `minheap/`, `dynarray/` | データ構造（AVL木・二分ヒープ・動的配列） |
| `dp/` | 動的計画法（LCS, 編集距離, ナップサック, LIS） |
| `perm/`, `rank/`, `inc_code/` | 順列・ランキング |
| `numeric/` | 数論（GCD, 拡張ユークリッド, modexp） |
| `geometry/` | 幾何（最近点対） |
| `others/` | 上記に分類しきれない例・歴史的実装 |
| `tools/` | `build_catalog.py`（カタログ生成）, `reftest.py`（参照差分テスト）, `convert_literal_push.py` |

## 新しいアルゴリズムの追加方法

1. [`RECIPES.md`](RECIPES.md) の早見表から該当する可逆化パターンを選ぶ
2. `tools/reftest.py` に Python 参照実装との差分テストを1エントリ登録する（テストファースト）
3. `PYJANUS=<path> python3 tools/build_catalog.py` でカタログを再生成しコミットする

詳細な手順・レビュー基準は CONTRIBUTING.md にまとめる予定（準備中）。

## 出典・引用

- Demaine, E. D., Lynch, J., Mirano, G. J., Tyagi, N., et al. *Energy-Efficient
  Algorithms*. arXiv:1605.08448.
- Dijkstra, E. W. (1979). *Program Inversion*. Program Construction,
  International Summer School.
- Nøhr, S. V. (2015). *Reversible Graph Algorithms*. Bachelor's thesis,
  Copenhagen University.
- Myrvold, W. and Ruskey, F. (2001). "Ranking and unranking permutations in
  linear time." *Information Processing Letters*.
- Bonet, B. (2008). "Efficient algorithms to rank and unrank permutations in
  lexicographic order."
- Er, M. C. (1983, 1985) — permutation/combination generation.
- 個別ファイルの出典・卒業論文・出典URLはヘッダコメントおよび
  [`CATALOG.md`](CATALOG.md) の inventory 表を参照。

## License

MIT License — [`LICENSE`](LICENSE) を参照。
