//Cのプログラム（force_str_search.c）を元に可逆化をしたJanusプログラム
//基本的に元のプログラムと同じ動作を想定
//Janusでは拡張しない限り文字列を扱えないので数列で考える
//aとの違いはiを局所変数とするか否か

//文字列tの探索場所がjで，サイズをnで表す
//パターンpの探索場所がiで，サイズをmで表す
procedure f_strmatch(int p[], int t[], int m, int n, int i, int j, stack g)
  from j = 0 loop
    if p[i] = t[j] then
      i += 1
      j += 1
    else
      j += 1
      j -= i
      push(i, g)
    fi i > 0
  until i = m || j = n

procedure main()
  int p[3] = {2, 4, 3}
  int t[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int m = 3
  int n = 10
  int i
  int j
  stack g

  call f_strmatch(p, t, m, n, i, j, g)

  if i = m then
    printf("Success")
  else
    printf("Failure")
  fi i = m
