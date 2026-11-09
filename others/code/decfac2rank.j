procedure incfac2rank(int n, int d[], int rank)
  local int i = 0
    from  i = 0 do
      i += 1
      local int t = d[i-1] + i * rank // rank := d[i-1] + n * rank
        t <=> rank
      delocal int t = (rank - d[i-1]) / i
      d[i-1] ^= rank % i  // zero clear
    until i = n
  delocal int i = n

// iterative factorial: linear time
procedure factI(int n, int res)
  res ^= 1
  local int i = 0
    from  i = 0
    loop  local int tmp = res
            res ^= tmp ^ tmp * (n - i)
          delocal int tmp = res / (n - i)
          i += 1
    until i = n
  delocal int i = n

procedure decfac2rank(int d[], int n, int rank)
  local int fac = 1
    local int i = n
      from  i = n
      do    i -= 1
            rank += d[i] * fac
            d[i] -= rank / fac          // zero clear d[i]
      loop  local int t = fac * (n-i)   // fac *= n-i
              t <=> fac
            delocal int t = fac / (n-i)
      until i = 0
    delocal int i = 0
    uncall factI(n-1,fac)               // zero clear fac
  delocal int fac = 0

procedure main()
  int n = 4
  int d[4] = {0}
  int rank

  rank ^= 23
  uncall decfac2rank(d,n,rank)

  // d[0] ^= 0
  // d[1] ^= 1
  // d[2] ^= 0
  // d[3] ^= 2
  // call incfac2rank(n,d,rank)