//////////////////////////////////////////////////////////////////////
// A clean translation from an inversion table to a rank
//////////////////////////////////////////////////////////////////////

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

// clean translation from an inversion table to a rank
procedure invtab2rank(int inv[], int n, int rank)
  local int fac = 1
    local int i = n
      from  i = n
      loop  i -= 1
            rank += inv[i] * fac
            inv[i] -= rank / fac        // zero clear
            local int t = fac * (n-i)   // fac *= n-i
              t <=> fac
            delocal int t = fac / (n-i)
      until i = 0
    delocal int i = 0
    uncall factI(n,fac)
  delocal int fac = 0

procedure main()
  int inv[9]
  int sz
  int r

  sz ^= 9

  // Exerpted from TAOCP *5.1.1 Inversions
  inv[0] ^= 2
  inv[1] ^= 3
  inv[2] ^= 6
  inv[3] ^= 4
  inv[4] ^= 0
  inv[5] ^= 2
  inv[6] ^= 2
  inv[7] ^= 1
  inv[8] ^= 0

  call invtab2rank(inv, sz, r)