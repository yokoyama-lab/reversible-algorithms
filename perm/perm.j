// recursive implementation of permutation: exponential time
procedure permR(int n, int r, int res)
  if r=0 then
    res ^= 1
  else
    local int tmp = 0
      n -= 1
      r -= 1
      call permR(n, r, tmp)
      res ^= (n + 1) * tmp
      uncall permR(n, r, tmp)
      r += 1
      n += 1
    delocal int tmp = 0
  fi r=0

// iterative implementation of permutation
procedure permI(int n, int r, int res)
  res ^= 1
  local int i = 0
    from  i = 0
    loop  local int tmp = 0
            tmp <=> res
            res ^= tmp * (n - i)
          delocal int tmp = res / (n - i)
          i += 1
    until i = r
  delocal int i = r

procedure main()
  int n
  int r
  int res

  n += 10
  r += 3
  call permI(n,r,res)