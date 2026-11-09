//Cのプログラム（force_str_search.c）を元に可逆化をしたJanusプログラム
//基本的に元のプログラムと同じ動作を想定
//Janusでは拡張しない限り文字列を扱えないので数列で考える
//最悪のとき文字列長に比例したゴミがgに格納される
//入力：パターンp[], 文字列t[], パターン長m, 文字列長n
//出力：フラグr
//ゴミ出力（元入力）：パターンp[], 文字列t[], パターン長m, 文字列長n
//ゴミ出力（元入力以外）：ゴミスタックg

//文字列tの探索場所がjで，サイズをnで表す
//パターンpの探索場所がiで，サイズをmで表す
procedure f_strmatch(int p[], int t[], int m, int n, int r, stack g)
  local int i = 0, int j = 0
    from j = 0 loop
      if p[i] = t[j] then
        i += 1
        j += 1
      else
        j -= i - 1
        push(i, g) //iをゼロクリア
      fi i > 0
    until i = m || j = n

    if i = m then //delocalのために探索成功時に0クリア
      r += 1
      i -= m //iをゼロクリア
      push(j, g)
    else
      j -= n //jをゼロクリア
      push(i, g)
    fi r = 1
  delocal int i = 0, int j = 0

procedure main()
  int p[3] = {2, 4, 3}
  int t[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int m = size(p)
  int n = size(t)
  int r
  stack g

  call f_strmatch(p, t, m, n, r, g)

  if r = 1 then
    printf("Success")
  else
    printf("Failure")
  fi r = 1
