# 可逆化レシピ集 — Reversibilization Recipes

不可逆アルゴリズムを Janus（jana2014 方言）へ移植するときに繰り返し使う
パターン集。各レシピは「いつ使うか → 骨格コード → このリポジトリの実例」
の順。新しいアルゴリズムを追加するときは、まず該当レシピを選び、
`tools/reftest.py` に参照実装との差分テストを1エントリ登録すること
（テストファースト）。

対象言語はいわゆる **jana2014**（PyJanus `--std jana2014`）。
`push`/`pop` の引数は **l-value のみ**（リテラル不可）、`from C … until D`
のループは **C が初回のみ真・D 成立で脱出・再入時は ¬C を検証**、という
可逆制御構造の規律が全レシピの前提になる。

---

## 0. 早見表

| # | レシピ | 使いどころ | 追加空間 | 実例 |
|---|---|---|---|---|
| 1 | 決定ビット・ログ | 分岐が自分の条件を書き換える | 1 bit/分岐 | `bfs/bfs.j` |
| 2 | 上書きログ | 代入が旧値を破壊する | 1 語/上書き | `bellman_ford/bellman_ford.j` |
| 3 | Bennett（計算-複写-逆計算） | 途中結果だけ欲しい | 一時的のみ | `avl/avl_search.j` |
| 4 | 中間値の逆計算 | 一時変数を式で戻せる | 0 | `floyd_warshall/floyd_warshall.j` の `sum` |
| 5 | 保護付き分岐/ループ | 条件が不変に保てる | 0 | `dp/lcs.j` |
| 6 | 表の全保持 DP | DP セルが近傍の純関数 | 表そのもの | `dp/knapsack.j` |
| 7 | ログして巻き戻す | 反復ごとに作業領域を空に戻す | 一時的のみ | `isort/disort.j` |
| 8 | 単調ループ＋バックトラックのログ | ポインタが後退するループ | 後退分のみ | `string_search/kmp2.j` |
| 9 | 破壊された情報だけを記録 | 何を失うかが特定できる | 失った情報ぶん | `numeric/ext_gcd.j` の商 |

---

## 1. 決定ビット・ログ（decision-bit log）

**いつ**: `if` の本体が自分の条件を書き換えてしまい、`fi` の出口検証に
元の条件が使えないとき。

**骨格**: 分岐の**末尾**で 0/1 を専用スタックに push し、`fi top(bl) = 1`
を出口検証にする。push が末尾にあるので、逆実行では最初に top() が読まれ、
どちらの枝を戻るかが決まる。

```janus
if <条件（本体が壊す）> then
  <本体>
  local int b = 1
    push(b,bl)
  delocal int b = 0
else
  local int b = 0
    push(b,bl)
  delocal int b = 0
fi top(bl) = 1
```

3分岐以上はコード値（0,1,2,…）を push（実例: `avl/avl_insert.j` の回転
コード 0/LL/RR/LR/RL、`avl/avl_delete.j` の構造分岐）。

**実例**: `bfs/bfs.j`（訪問判定）、`dijkstra/dijkstra.j`（緩和判定）、
`toposort/toposort.j`、`csort/csort1.j`。

**注意（実バグ事例）**: `avl_delete.j` は当初、外側分岐の出口検証に
`left[node] = 0` を使っていたが、二子ケースの rebalance が回転で
`left[node]` を書き換えるため約7%の入力で assertion 破綻した。**本体が
（間接的にでも）条件に触れるなら決定ビットにする**こと。参照実装との
ランダム差分テスト（reftest）がこれを検出した。

## 2. 上書きログ（overwrite log）

**いつ**: `dist[v] = 新値` のように旧値を破壊する代入が避けられないとき。

**骨格**: `push(旧値が入ったセル, log)` はセルを**ゼロ化**して旧値を積む。
その直後に新値を `+=` すればよい。

```janus
local int nd = <新値の式>
  push(dist[v],dlog)   // 旧値をログ、セルは 0 に
  dist[v] += nd
delocal int nd = dist[v]
```

**実例**: `bellman_ford/bellman_ford.j`、`floyd_warshall/floyd_warshall.j`、
`apsp/apsp.j`、`numeric/modexp.j`（アキュムレータ）、`dp/lis.j` の fold。
たいていレシピ1（決定ビット）と対で使う。

## 3. Bennett：計算-複写-逆計算（compute-copy-uncompute）

**いつ**: 探索や min/max fold の**結果だけ**が欲しく、途中のログを残したく
ないとき。

**骨格**: ログを取りながら計算する下請け手続きを `call` → 結果を `^=` で
複写 → 同じ下請けを `uncall` してログを消す。下請けが読む状態を、複写の
間に**変更しないこと**（変更すると uncall が合わなくなる）。

```janus
procedure wrapper(…, int res)
  local int acc = <初期値>
    local stack lg = nil
      local stack bl = nil
        call sub(…, acc, lg, bl)     // ログを取りつつ計算
        res ^= acc                    // 結果だけ複写
        uncall sub(…, acc, lg, bl)   // ログ消去・acc 復元
      delocal stack bl = nil
    delocal stack lg = nil
  delocal int acc = <初期値>
```

**実例**: `avl/avl_search.j`（探索パス）、`apsp/apsp.j` の `cell_min`、
`dijkstra/dijkstra.j` の `select_min`、`geometry/closest_pair.j`、
`ssort/ssort1.j` の `max`。`dijkstra` では選択（clean）を**先に**済ませて
から状態を変更する順序が本質的。

## 4. 中間値の逆計算（uncompute intermediates）

**いつ**: 一時変数が、変更されない他の変数から式で再計算できるとき。

**骨格**: `local int t = <式>` … `delocal int t = <同じ式>`。式が参照する
変数を本体が変更しないことが条件。

```janus
local int sum = path[i*n+k] + path[k*n+j]
  … （sum を読むだけ。path[i*n+k], path[k*n+j] は不変） …
delocal int sum = path[i*n+k] + path[k*n+j]
```

**実例**: `floyd_warshall/floyd_warshall.j` の候補和（緩和で書き換わる
セルは i≠k, j≠k のため式の参照先と重ならない、という不変条件に注意）、
`geometry/closest_pair.j` の距離、`bellman_ford` の `tempDist`。

## 5. 保護付き分岐・単純ループ（protected if / simple for）

**いつ**: 条件・ループ変数が本体で不変に保てるとき。**ログ不要・追加空間0**
の最良ケース。まずこれで書けないか考える。

```janus
if a[i] = b[j] then <どちらの枝も条件を壊さない> fi a[i] = b[j]

local int i = 0
  from  i = 0
  loop  <本体（i を触らない）>
        i += 1
  until i = n
delocal int i = n
```

**実例**: `dp/lcs.j`・`dp/edit_distance.j`・`dp/knapsack.j` の全分岐、
各所の添字ループ。

## 6. 表の全保持 DP（table-retention DP）

**いつ**: DP の各セルが**既に確定した近傍セルの純関数**として一度だけ
書けるとき。

**要点**: 表を消さず全部持てば、上書きが発生せず、分岐条件は確定済み
セルしか読まないので安定 — **構成的に可逆**（レシピ5の大規模適用）。
空間は表サイズだが、これは論文でいう 0-energy の代価。

**実例**: `dp/lcs.j`、`dp/edit_distance.j`、`dp/knapsack.j`。
答えの取り出し（max など）が要るなら仕上げにレシピ3を1回。

## 7. ログして巻き戻す（log-then-unroll）

**いつ**: 外側ループの1反復ごとに使う作業カウンタ・作業領域を、次の反復の
ために**空に戻したい**とき。

**骨格**: 反復内で下請けを `call` して仕事をし、残したい書き込みだけ実行後、
同じ下請けを `uncall`。

**実例**: `isort/disort.j`（rank を数えて B に書き、rank カウンタを巻き
戻す）。レシピ3の「ループ内適用」版。

## 8. 単調ループ＋バックトラックのログ

**いつ**: KMP の接頭辞ポインタのように、**後退しうる変数**が本来のループ
制御であるとき。後退変数は `from` の検証に使えない（再入時に初期値へ
戻り得るため）。

**骨格**: ループは**単調なインデックス**（テキスト位置など）で回し、
後退の連鎖は「壊した値を push ＋ 後退回数を push」で完全に記録する。

```janus
local int c = 0                 // この step の後退回数
  from  c = 0
  loop  local int t = f[j-1]
          push(j,gq)            // 壊す j を記録
          j += t
        delocal int t = j
        c += 1
  until j = 0 || t[i] = p[j]
  push(c,gq)                    // 後退回数も記録
delocal int c = 0
```

**実例**: `string_search/kmp2.j`（歴史的経緯は `kmp.j` ヘッダの診断を
参照 — 後退変数でループを組んで破綻した実例）。

## 9. 破壊された情報だけを記録する

**いつ**: アルゴリズムが**何の情報を失うのか**を正確に特定できるとき。
それだけをログすれば、漫然と全履歴を取るより空間効率がよい。

**実例**:
- `numeric/ext_gcd.j` — 除算 `(a,b) → (b, a mod b)` が失うのは**商**だけ。
  商列のみを push。
- `inc_code/inc_perm.j` — next-permutation の後で復元不能なのは枢軸
  インデックス i, j の2語だけ。探索自体は clean に行い（`delocal k = 結果`
  の自己参照 delocal で探索変数を消す）、i, j のみ push。
- `dynarray/dynarray.j` — テーブル倍化が失うのは「リサイズしたか」の
  1 bit だけ。

---

## 落とし穴チェックリスト

- **`from C … until D` の再入で ¬C**。後退・非単調な変数を C にしない
  （レシピ8）。ループ体が C を偶然真に戻さないか（`shell_sort1.j` は
  `sz >= 9` という定義域前提が生じた実例 — 前提はヘッダに明記）。
- **同一配列の self-swap は alias エラー**。`a[i] <=> a[j]` は i = j に
  なり得るなら `if i = j then skip else … fi i = j` で保護
  （`qsort/code/qsort.j`, `perm/code/perm2decfac_nolex.j` の修正事例）。
- **`push`/`pop` は l-value のみ**。リテラルは
  `local int t = 定数; push(t,s); delocal int t = 0` に
  （`tools/convert_literal_push.py` が一括変換）。
- **32bit 符号付きの折り返し**。C コード生成との差分検証を通すなら定数は
  int 範囲に（`minheap_subset.j` のセンチネル 4294967295→1000000 の事例）。
- **Bennett の複写と逆計算の間に、下請けが読む状態を変えない**
  （`dijkstra` は選択→変更の順序で回避）。
- **予約語**: `size` などは変数名にできない（`dynarray` の `cap` 改名事例）。

## 検証の作法（必須）

1. **可逆性**: `call P; uncall P` が恒等（`tools/build_catalog.py` の
   スイープが全 `.j` に対して自動確認）。
2. **正答性**: `tools/reftest.py` に Python 参照実装とのランダム差分
   テストを登録（CI が 200 ケース × 3 シードで実行）。
3. **処理系整合**: PyJanus corpus（`tests/jana2014/fixtures/examples/`）
   に `.ja` を追加すれば、逆変換・C codegen・Coq 検証済みオラクルとの
   差分テストに自動で載る。
