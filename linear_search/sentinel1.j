// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法

procedure banpei1(int k[], int key, int n, int f, stack g)
  local int i = 0
    push(k[n], g)
    k[n] ^= key
    local int pushtmp = 1
      push(pushtmp, g)
    delocal int pushtmp = 0
    from top(g) = 1 loop
      i += 1
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    until k[i] = key
    if i < n then
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
    push(i, g)
  delocal int i = 0

procedure banpei2(int k[], int key, int n, int f)
  local stack g = nil
    local int x = 0
      call banpei1(k, key, n, x, g)
      f ^= x
      uncall banpei1(k, key, n, x, g)
    delocal int x = 0
  delocal stack g = nil

procedure main()
  int key
  int n
  int k[11] = {10, 4, 3, 2, 9, 6, 7, 8, 5, 1}
  int f
  key ^= 9
  n ^= 10
  call banpei2(k,key,n,f)
