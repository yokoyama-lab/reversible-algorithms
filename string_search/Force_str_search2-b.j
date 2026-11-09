//if文のelse部分を変更することによりスタックを排除した形
//janusでは拡張しない限り文字列を扱えないので数列で考える
//aとの違いはjを局所変数とするか否か

//文字列tのサイズをnで表し，パターンpのサイズをmで表す
//文字列の探索開始場所をj，パターンの探索場所をiと表す
procedure f_strmatch(int p[], int t[], int m, int n, int i, int j)
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

procedure main()
  int p[3] = {2, 4, 3}
  int t[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int m = 3
  int n = 10
  int j
  int i

  call f_strmatch(p, t, m, n, i, j)

  if i = m then
    printf("Success")
  else
    printf("Failure")
  fi i = m
