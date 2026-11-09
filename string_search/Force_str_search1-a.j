//Cのプログラム（force_str_search.c）を元に可逆化をしたJanusプログラム
//基本的に元のプログラムと同じ動作を想定
//Janusでは拡張しない限り文字列を扱えないので数列で考える
//実行時間に比例したゴミがgに格納される

//文字列tの探索場所がjで，サイズをnで表す
//パターンpの探索場所がiで，サイズをmで表す
procedure f_strmatch(int p[], int t[], int m, int n, int j, stack g)
  local int i = 0
    from j = 0 loop
      if p[i] = t[j] then
        i += 1
        j += 1
      else
        j -= i
        j += 1
        push(i, g) //ゼロクリアのため
      fi i > 0
    until i = m || j = n

    if i = m then //delocalのために探索成功時に0クリア
      push(i, g)
    fi j < n
  delocal int i = 0

procedure main()
  int p[3] = {2, 4, 3}
  int t[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int m = 3
  int n = 10
  int j
  stack g

  call f_strmatch(p, t, m, n, j, g)

  if top(g) = m then
    printf("Success")
  else
    printf("Failure")
  fi top(g) = m
