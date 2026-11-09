線形探索アルゴリズム

・Lsearch：線形探索の一般法
・sentinel：番兵法を用いた解法
・list_sentinel：整列したリストと番兵法を用いた解法

Lsearch1
  input:配列k,要素数n,鍵key
  output:f(見つかったら1そうでなければ0)
  liner1:通常の線形探索
    最良時間計算量:15
    最悪時間計算量:7n+6
  liner2:liner1を用いた一般解法
    時間計算量:7
  全体の計算量
    最良時間計算量：44
    最悪時間計算量：14n+26

Lsearch2
  Lsearch1のlinear2関数をmainに置いたもの
  input:配列k,要素数n,鍵key
  output:f(見つかったら1そうでなければ0)
  liner1:通常の線形探索
    最良時間計算量:15
    最悪時間計算量:7n+6
  全体の計算量
    最良時間計算量:43
    最悪時間計算量:14n+25

Lsearch3
  Lsearch1のlinear1,linear2関数を改善し，a_linear2に置き換えたもの
  input:配列k,要素数n,鍵key
  output:f(見つかったら1そうでなければ0)
  a_linear2:通常の線形探索
    最良時間計算量:5n+4
    最悪時間計算量:5n+5
　全体の計算量
    最良時間計算量:5n+11
    最悪時間計算量:5n+12

Lsearch4
  スタックを用いて線形探索を実装したもの
  input:スタックs,鍵k
  output:f(見つかったら1そうでなければ-1)
  search
    最良時間計算量:16
    最悪時間計算量:8n+6
  search1
    時間計算量:9
  全体の計算量
    最良時間計算量:2n+48
    最悪時間計算量:18n+28

Lsearch5
  スタックを用いて線形探索を実装したもの
  input:スタックs,鍵k
  output:f(見つかったら1そうでなければ0)
  search
    最良時間計算量:24
    最悪時間計算量:13n+9
  search1
    時間計算量:9
  全体の計算量
    最良時間計算量:2n+64
    最悪時間計算量:28n+34

Lsearch6
  スタックを用いて線形探索を実装したもので，search1関数を省略したもの
  input:スタックs,鍵k
  output:f(見つかったら1そうでなければ0)
  search
    最良時間計算量:24
    最悪時間計算量:13n+9
  全体の計算量
    最良時間計算量:2n+63
    最悪時間計算量:28n+33

Lsearch7
  スタックを用いて線形探索を実装したもので，search1関数を省略したもの
  input:スタックs,鍵k
  output:f(見つかったら1そうでなければ0)
  search
    最良時間計算量:16
    最悪時間計算量:8n+6
  全体の計算量
    最良時間計算量:2n+45
    最悪時間計算量:18n+25

sentinel1
  番兵法を用いた実装
  input:配列k,鍵key 要素数n
  output:f
  banpei1
    最良時間計算量:13
    最悪時間計算量:4n+11
  banpei2
    時間計算量:7
  全体の計算量
    最良時間計算量:40
    最悪時間計算量:8n+36

sentinel2
  番兵法を用いた実装で関数banpei2を省略した形
  input:配列k,鍵key 要素数n
  output:f
  banpei
    最良時間計算量:13
    最悪時間計算量:4n+13
  全体の計算量
    最良時間計算量:39
    最悪時間計算量:8n+39

sentinel3
  番兵法をスタックで実装したもの
  input:スタックs,鍵key 要素数n
  output:f
  banpei
    最良時間計算量:5n+22
    最悪時間計算量:10n+22
  banpei1
    時間計算量:9
  全体の計算量
    最良時間計算量:12n+60
    最悪時間計算量:22n+60

sentinel4
  番兵法をスタックで実装して関数banpei1を省略した形
  input:スタックs,鍵key 要素数n
  output:f
  banpei
    最良時間計算量:5n+22
    最悪時間計算量:10n+22
  全体の計算量
    最良時間計算量:12n+59
    最悪時間計算量:22n+59

sentinel5
  番兵法をスタックで実装して関数banpei1を省略した形
  input:スタックs,鍵key 要素数n
  output:f
  banpei
    最良時間計算量:5n+22
    最悪時間計算量:10n+22
  全体の計算量
    最良時間計算量:12n+59
    最悪時間計算量:22n+59

list_sentinel1
  番兵法とリストを用いた実装
  input:配列k,鍵key 要素数n
  output:f
  aolinear1
    最良時間計算量:11
    最悪時間計算量:4n+11
  aolinear2
    時間計算量:7
  全体の計算量
    最良時間計算量:36
    最悪時間計算量:8n+36

list_sentinel2
  番兵法とリストを用いてaolinear2を省略した実装
  input:配列k,鍵key 要素数n
  output:f
  aosearch
    最良時間計算量:11
    最悪時間計算量:4n+11
  全体の計算量
    最良時間計算量:35
    最悪時間計算量:8n+35

list_sentinel3
  番兵法とリストをスタックを用いて実装
  input:配列k,鍵key 要素数n
  output:f
  aolinear
    最良時間計算量:16
    最悪時間計算量:5n+9
  aolinear2
    時間計算量:9
  全体の計算量
    最良時間計算量:2n+48
    最悪時間計算量:12n+34

list_sentinel4
  番兵法とリストをスタックを用いて実装
  input:配列k,鍵key 要素数n
  output:f
  aolinear
    最良時間計算量:16
    最悪時間計算量:5n+9
  全体の計算量
    最良時間計算量:2n+47
    最悪時間計算量:12n+33

list_sentinel5
  番兵法とリストをスタックを用いて実装
  input:配列k,鍵key 要素数n
  output:f
  aolinear
    最良時間計算量:16
    最悪時間計算量:5n+9
  全体の計算量
    最良時間計算量:2n+45
    最悪時間計算量:12n+31

最良→１つ目に探索したいものがある
最悪→配列またはスタックの中に存在しない
