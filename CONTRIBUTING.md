# 貢献ガイド — 「1人1可逆アルゴリズム」演習

横山研の学部生向け演習：不可逆な（普通の）アルゴリズムを1つ選び、
Janus（jana2014 方言）で**可逆化**し、このコレクションに1本追加する。
目的は次の2つ。

1. **可逆プログラミングの実践** — なぜ可逆化が難しいのか（情報を失う
   代入・分岐・ループをどう扱うか）を手を動かして体得する。
2. **コレクションへの貢献** — 自分の実装が `tools/reftest.py` の参照
   実装と一致し、CI の reversibility スイープを通ることを確認した上で
   コレクションに残す。研究室の資産として後輩・他大学に使われる。

## 手順

### ① アルゴリズムを選ぶ（Issue で宣言）
`.github/ISSUE_TEMPLATE/new-algorithm.md` で新規 Issue を立て、担当を
宣言する（重複防止・進捗共有のため）。候補は下の「おすすめの題材」を
参照。

### ② レシピを選ぶ
`RECIPES.md` の早見表（9パターン）から、自分のアルゴリズムがどの型の
「情報破壊」を起こすかを見極めて選ぶ。まずレシピ5（保護付き分岐/ループ、
追加空間0）で書けないか検討し、無理ならログ系（レシピ1,2,7,8,9）や
Bennett（レシピ3）へ。複数レシピの合成もよくある（例: `dijkstra.j` は
レシピ1+3）。

### ③ テストファーストで `.j` を実装
まず「何を入力に何を返すか」を決め、`tools/reftest.py` に登録する
テストケース（次のステップ）を先に書いてから実装する。ヘッダには
このリポジトリの慣例（`numeric/ext_gcd.j`, `dp/knapsack.j` 参照）に
倣い、コメントブロックで次を明記する:

- **出典**: 原アルゴリズムの参考文献 / 使ったレシピ番号
- **前提条件**: 入力の制約（例: `a >= 1, b >= 1`）
- **forward/uncall 契約**: forward で何が起こり、`uncall` すると何が
  復元されるか（何をログして何を捨てるか）

### ④ PyJanus でローカル検証
```bash
cd ../PyJanus   # PyJanus をこのリポジトリと同じ階層にクローンしておく
python3 -m jana_py.cli --std jana2014 <path>/your_algo.j          # 実行
python3 -m jana_py.cli --std jana2014 -i <path>/your_algo.j       # 逆変換の確認
```
`call P; uncall P` が恒等になること（= 可逆性）を、`main()` の末尾に
`uncall` を書いた版を手元で試すか、`tools/build_catalog.py` のスイープ
（ステップ⑥）で自動確認する。

### ⑤ `tools/reftest.py` に参照実装を登録
Python の標準的な実装との差分テストを1エントリ追加する。例
（`dp/knapsack.j` の登録を参照）:
```python
register("your_algo",
    procs="your_dir/your_algo.j",
    gen=lambda r: ...,                 # ランダム入力生成
    build=lambda inp: (f"procedure main()\n ... call your_algo(...)\n"),
    extract=lambda s, inp: s["answer_var"],
    ref=lambda inp: <Python参照実装>)
```
`python3 tools/reftest.py --only your_algo`（PyJanus の場所は `PYJANUS`、未設定なら `../PyJanus`）
でローカル実行して一致を確認。

### ⑥ カタログを再生成
```bash
python3 tools/build_catalog.py
```
`catalog.json` / `CATALOG.md` が更新される。コミットに含めること
（CI がツリーとの一致をチェックする）。

### ⑦ PR 作成
Issue を参照し、テスト結果（reftest の出力）を貼る。

## 合格基準

**必須（CI green）**:
- `tools/reftest.py` が 200 ケース × seed 1/42/99 の3通りで全て一致
  （`.github/workflows/reftest.yml`）。
- `catalog.json` / `CATALOG.md` が `tools/build_catalog.py` の出力と
  一致（stale なら CI が `catalog job` で落ちる）。

**加点（必須ではないが歓迎）**:
- RECIPES.md の9パターンに当てはまらない新しい可逆化パターンを見つけ、
  ドキュメント化した。
- 複数レシピを組み合わせて空間/時間のトレードオフを改善した。
- 前提条件（precondition）を「by-design で仕方ない」で済まさず、
  最小化・除去できた（例: 定義域を広げた、ログを削った）。

## よくある失敗

詳細は `RECIPES.md` の「落とし穴チェックリスト」を参照。特に多いのは
次の3つ:

- **push/pop は l-value のみ**。リテラルを直接 push しようとして構文
  エラーになる（`local int t = 定数; push(t,s)` にする）。
- **`from C … until D` の再入で ¬C が破れる**。後退・非単調な変数を
  ループ条件に使わない（後退はレシピ8で別途ログする）。
- **同一配列の self-swap で alias エラー**。`a[i] <=> a[j]` は `i = j`
  になり得るなら分岐で保護する。

## おすすめの題材

`CATALOG.md` のカバレッジ・マトリクスで手薄なカテゴリから。
Graph・Geometry・Combinatorics/Numeric・Dynamic programming は特に
空きが多い。

1. 最小全域木の **Kruskal 版**（Union-Find の可逆化が主題。Prim 版は
   `mst/prim.j` にあるので比較対象に）— Graph
2. 強連結成分の **Tarjan 版**（Kosaraju 版は `scc/kosaraju.j`）— Graph
3. 凸包の **Graham scan 版**（Jarvis 版は `geometry/convex_hull.j`。
   ソートとの合成が主題）— Geometry
4. 行列の積（`others/matrixmult.j` は by-design の疑似コードのみ。
   実行可能な jana2014 実装がまだない）— Numeric
5. Stirling数（第一種/第二種）の動的計画 — Combinatorics/Numeric
6. 二分探索木（AVL 以外。単純 BST の insert/search/delete）—
   Data structure
7. オープンアドレス法のハッシュテーブル — Data structure
8. エラトステネスの篩 — Numeric
9. 最長回文部分列（LPS, DP）— Dynamic programming
10. 区間スケジューリング問題（貪欲法 or DP）— Dynamic programming

迷ったら Issue で相談すること（重複や難易度は秘書経由で調整可能）。
