//if文のelse部分を変更することによりスタックを排除した形
//Janusでは拡張しない限り文字列を扱えないので数列で考える
//実行時間に比例したゴミを格納する必要が無い

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
      from i = m loop
        i -= 1
      until i = 0
    fi j < n-m+1
  delocal int i = 0

procedure main()
  int p[3] = {2, 4, 3}
  int t[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int m = 3
  int n = 10
  int j

  call f_strmatch(p, t, m, n, j)
