// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，単純法スタックver

procedure search(stack s, int key, stack t, int f, stack g)
  local int x = 0
    local int pushtmp = 1
      push(pushtmp, g)
    delocal int pushtmp = 0
    from top(g) = 1 loop
      if top(s) = key then
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
      pop(x, s)
      push(x, t)
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    until f != -1  || empty(s)
  push(x, g)
  delocal int x = 0

procedure search1(stack s,int key,int f)
  local stack t = nil
    local stack g = nil
      local int y = -1
        call search(s, key, t, y, g)
        f ^= y
        uncall search(s, key, t, y, g)
      delocal int y = -1
    delocal stack g = nil
  delocal stack t = nil

procedure main()
  stack s
  int k
  int f
  k ^= 51
  local int x = 0
    x += 1
    push(x, s)
    x += 2
    push(x, s)
    x += 3
    push(x, s)
    x += 4
    push(x, s)
    x += 5
    push(x, s)
    x += 6
    push(x, s)
    x+=7
    push(x, s)
    x += 8
    push(x, s)
    x += 9
    push(x, s)
    x += 10
    push(x, s)
  delocal int x = 0
  call search1(s,k,f)
