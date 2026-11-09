//if文のelse部分を変更することによりスタックを排除した形
//Janusでは拡張しない限り文字列を扱えないので数列で考える
//最悪のときでも文字列長に比例したゴミを格納する必要が無い
//入力：パターンp[], 文字列t[], パターン長m, 文字列長n
//出力：tを先頭から見ていってパターンが最初に出現する位置j..j+size(p)-1, ただし探索失敗時はj=-1
//ゴミ出力（元入力）：パターンp[], 文字列t[], パターン長m, 文字列長n

//文字列tのサイズをnで表し，パターンpのサイズをmで表す
//文字列の探索開始場所をj，パターンの探索場所をiと表す
procedure f_strmatch(int p[], int t[], int m, int n, int j)
  local int i = 0
    from i = 0 && j = 0 loop
      if p[i] = t[i+j] then
        i += 1
      else
      　from p[i] != t[i+j] loop
          i -= 1
        until i = 0
        j += 1
      fi i > 0
    until i = m || j = n-m+1

    if i = m then
      i -= m //iをゼロクリア
    else
      j -= n - 1
    fi j >= 0
  delocal int i = 0

procedure main()
  int p[3] = {2, 4, 9}
  int t[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int m = size(p)
  int n = size(t)
  int j

  call f_strmatch(p, t, m, n, j)
