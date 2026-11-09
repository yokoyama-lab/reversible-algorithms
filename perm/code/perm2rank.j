//////////////////////////////////////////////////////////////////////
// Myrvold, W. and F. Ruskey (2001). "Ranking and unranking permutations in linear time." Information Processing Letters 79(6): 281-284.
//////////////////////////////////////////////////////////////////////

// unclean unranking: (r,pi[]=identitiy permutation) |-> (r,pi[])
procedure unrank1(int n, int r, int pi[])
  if n > 0 then
    local int t = pi[n-1] ^ pi[r % n] // pi[n-1] <=> pi[r % n]
      pi[n - 1] ^= t
      pi[r % n] ^= t
    delocal int t = pi[n-1] ^ pi[r % n]
    call unrank1(n-1,r/n,pi)
  fi n > 0

// Clean ranking: pi[] |-> r
procedure perm2rank_sub(int n, int pi[], int pi_inv[], int res)
  if n > 1 then
    local int s = pi[n-1]
      local int t = pi[n-1] ^ pi[pi_inv[n-1]]	// pi[n-1] <=> pi[pi_inv[n-1]]
        pi[n-1]         ^= t
        pi[pi_inv[n-1]] ^= t
      delocal int t = pi[pi_inv[n-1]] ^ pi[n-1]
      local int t = pi_inv[s] ^ pi_inv[n-1]	// pi_inv[s] <=> pi_inv[n-1]
        pi_inv[s]   ^= t
        pi_inv[n-1] ^= t
      delocal int t = pi_inv[n-1] ^ pi_inv[s]
      call perm2rank_sub(n-1,pi,pi_inv,res)
      local int t = s + n * res
        t <=> res
      delocal int t = (res - s) / n
    delocal int s = res % n
    pi[n-1] ^= n-1
    pi_inv[n-1] ^= n-1
  fi n > 1

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

// Unclean: r |-> (r,pi[])
procedure unrank2(int n, int r, int pi[])
  if n > 0 then
    local int fac = 0
      n -= 1
      call factI(n,fac)
      n += 1
      local int s = r / fac
        local int t = pi[n-1] ^ pi[s]	// pi[n-1] <=> pi[s]
          pi[n-1] ^= t
          pi[s]   ^= t
        delocal int t = pi[s] ^ pi[n-1]
        n -= 1
        local int p = r % fac
          call unrank2(n,p,pi)
        delocal int p = r % fac
        n += 1
      delocal int s = r / fac
      n -= 1
      uncall factI(n,fac)
      n += 1
    delocal int fac = 0
  fi n > 0

// Clean ranking: pi[] |-> r
procedure rank2(int n, int pi[], int pi_inv[], int res)
  if n > 1 then
    local int s = pi[n-1]
      local int t = pi[n-1] ^ pi[pi_inv[n-1]]	// pi[n-1] <=> pi[pi_inv[n-1]]
        pi[n-1]         ^= t
        pi[pi_inv[n-1]] ^= t
      delocal int t = pi[pi_inv[n-1]] ^ pi[n-1]
      local int t = pi_inv[s] ^ pi_inv[n-1]	// pi_inv[s] <=> pi_inv[n-1]
        pi_inv[s]   ^= t
        pi_inv[n-1] ^= t
      delocal int t = pi_inv[n-1] ^ pi_inv[s]
      local int t = n - 1
        call rank2(t,pi,pi_inv,res)
        local int fac = 0
          call factI(t,fac)
          res += s * fac
          s -= res / fac
          uncall factI(t,fac)
        delocal int fac = 0
      delocal int t = n - 1
    delocal int s = 0
    pi[n-1] ^= n-1
    pi_inv[n-1] ^= n-1
  fi n > 1

// pi[] |-> (pi[], pi_inv[])
procedure make_pi_inv(int p[], int p_inv[], int n)
  local int i = 0
    from  i = 0
    loop  p_inv[p[i]] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure perm2rank(int p[], int p_inv[], int n, int rank)
  call make_pi_inv(p,p_inv,n)
  call perm2rank_sub(n,p,p_inv,rank)

procedure main()
  int n
  int r
  int pi[4]
  int pi_inv[4]
  int res

  n ^= 4
  // r ^= 4 * 3 * 2 * 1 - 1
  r ^= 0

  // identity permutaiton
  pi[0] ^= 0
  pi[1] ^= 1
  pi[2] ^= 2
  pi[3] ^= 3

  //////////////////
  // unrank1 & rank1
  //////////////////

  call unrank1(n,r,pi)
  // call perm2rank(pi,pi_inv,n,res)

  //////////////////
  // unrank2 & rank2
  //////////////////

  // call unrank2(n,r,pi)  // r |-> (r,pi[])
  // call make_pi_inv(pi,pi_inv,n) // pi[] |-> pi_inv[]
  // r ^= 18
  // call rank2(n,pi,pi_inv,res) // pi[] |-> r
