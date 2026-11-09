// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」
//配列版単純法の手書きによる解法

procedure a_linear2(int k[], int key, int n, int f)
  local int i = 0
    from i = 0 loop
      if k[i] = key then
        f ^= 1
      fi k[i] = key
      i += 1
    until i >= n
  delocal int i = n

procedure main()
  int k[10] = {4, 2, 3, 5, 10, 7, 8, 6, 1, 9}
  int key
  int f
  int n
  key ^= 11
  n ^= 10
  call a_linear2(k, key, n, f)
