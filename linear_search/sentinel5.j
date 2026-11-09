// 2017 年度 南山大学 理工学部 卒業研究「可逆線形探索」，番兵法スタックver

procedure banpei(stack s, int key, stack t, int f, stack gb)
  local int x = 0
    local int temp = key
      push(temp, t)
    delocal int temp = 0
    local int pushtmp = 1
      push(pushtmp, gb)
    delocal int pushtmp = 0
    from top(gb) = 1 loop
      pop(x, s)
      push(x, t)
      local int pushtmp = 0
        push(pushtmp, gb)
      delocal int pushtmp = 0
    until empty(s)
    local int pushtmp = 1
      push(pushtmp, gb)
    delocal int pushtmp = 0
    from top(gb) = 1 loop
      pop(x, t)
      push(x, gb)
      local int pushtmp = 0
        push(pushtmp, gb)
      delocal int pushtmp = 0
    until top(t) = key
    pop(x, t)
    push(x, gb)
    if !empty(t) then
      push(f, gb)
      f ^= 1
      local int pushtmp = 1
        push(pushtmp, gb)
      delocal int pushtmp = 0
    else
      push(f, gb)
      f ^= -1
      local int pushtmp = 0
        push(pushtmp, gb)
      delocal int pushtmp = 0
    fi top(gb) = 1
    push(x, gb)
  delocal int x = 0

procedure main()
  int key
  int f
  stack s
  key ^= 11
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
  local stack g = nil
    local stack t = nil
      local int y = 0
        call banpei(s, key, t, y, g)
        f ^= y
        uncall banpei(s, key, t, y, g)
      delocal int y = 0
    delocal stack t = nil
  delocal stack g = nil
