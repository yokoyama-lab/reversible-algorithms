// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，リスト＋番兵法スタックver

procedure aolinear(stack s, int key, int f, stack g)
  local int x = 0
    local int pushtmp = 1
      push(pushtmp, g)
    delocal int pushtmp = 0
    from top(g) = 1 loop
      pop(x, s)
      push(x, g)
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    until top(s) >= key
    if top(s) = key then
      pop(x, s)
      push(x, g)
      if !empty(s) then
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
      local int pushtmp = 1
        push(pushtmp, g)
      delocal int pushtmp = 0
    else
      local int pushtmp = 0
        push(pushtmp, g)
      delocal int pushtmp = 0
    fi top(g) = 1
    push(x, g)
  delocal int x = 0

procedure main()
  int key
  int f
  stack s
  key ^= 100
  local int x = 0
    x += 100
    push(x, s)
    x += 19
    push(x, s)
    x += 17
    push(x, s)
    x += 15
    push(x, s)
    x += 13
    push(x, s)
    x += 11
    push(x, s)
    x += 9
    push(x, s)
    x+=7
    push(x, s)
    x += 5
    push(x, s)
    x += 3
    push(x, s)
    x += 1
    push(x, s)
  delocal int x = 0
  local stack g = nil
    local int y = -1
      call aolinear(s, key, y, g)
      f ^= y
      uncall aolinear(s, key,y, g)
    delocal int y = -1
  delocal stack g = nil
