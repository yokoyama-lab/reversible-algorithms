//ゴミをなくす方法として文字が違ったとしてもパターンの最後まで比較させる方法を考えたがアサーションの記述が不可能になった
//janusでは拡張しない限り文字列を扱えないので数列で考える

//文字列tの探索場所がjで，サイズをnで表す
//パターンpの探索場所がiで，サイズをmで表す
//fが0でその地点まで一致，１で不一致，２で探索成功を表す
procedure f_strmatch(int p[], int t[], int n, int m, int i, int j, int f)
  from j = 0 loop
    if p[i] != t[j] && f = 0 then
      f += 1
    fi   //ここを書くことができない
    if i = m && f = 0 then
      f += 2
    fi f = 2
    if i = m && f = 1 then
      f -= 1
      i -= m+1
      j -= m
    fi 　//ここを書くことができない
    i += 1
    j += 1
  until j < n && f < 2

procedure main()
  char p[]
  char t[]
  int m
  int n
  int i
  int j
  int f

  call f_strmatch(p, t, m, n, i, j, f)
