// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法

procedure linear1(int k[], int key, int n, int f, stack g)
  local int i = 0
    local int pushtmp = 1
      push(pushtmp, g)
    delocal int pushtmp = 0
    from top(g) = 1 loop
      if k[i] = key then
        push(f, g)
        f ^= 1
        local int pushtmp = 1
          push(pushtmp, g)
        delocal int pushtmp = 0
      else
        local int pushtmp = 0
          push(pushtmp, g)
        delocal int pushtmp = 0
      fi top(g) = 1
      i += 1
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    until i >= n || f != 0
    push(i, g)
  delocal int i = 0

procedure main()
  int k[10] = {4, 2, 3, 5, 10, 7, 8, 6, 1, 9}
  int key
  int f
  int n
  key ^= 0
  n ^= 10
  local stack g = nil
    local int x = 0
      call linear1(k, key, n, x, g)
      f ^= x
      uncall linear1(k, key, n, x, g)
    delocal int x = 0
  delocal stack g = nil
