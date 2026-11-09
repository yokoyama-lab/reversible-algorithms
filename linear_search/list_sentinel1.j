// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法

procedure aolinear1(int k[], int key, int n, int f, stack g)
  local int i = 0
    local int pushtmp = 1
      push(pushtmp, g)
    delocal int pushtmp = 0
    from top(g) = 1 loop
      i += 1
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    until key <= k[i]
    if k[i] = key && i != n then
      push(f, g)
      f ^= 1
      local int pushtmp = 1
        push(pushtmp, g)
      delocal int pushtmp = 0
    else
      push(f, g)
      f ^= -1
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    fi top(g) = 1
    push(i, g)
  delocal int i = 0

procedure aolinear2(int k[], int key, int n, int f)
  local stack g = nil
    local int x = 0
      call aolinear1(k, key, n, x, g)
      f ^= x
      uncall aolinear1(k, key, n, x, g)
    delocal int x = 0
  delocal stack g = nil

procedure main()
  int k[11] = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 100}
  int key
  int f
  int n
  key ^= 100
  n ^= 10
  call aolinear2(k, key, n, f)
