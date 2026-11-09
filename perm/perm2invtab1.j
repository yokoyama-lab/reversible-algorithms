//////////////////////////////////////////////////////////////////////
// Permutation to inversion table
// an example inversion table p.12
// 5.1.1 Exercise 6, p.19, p.579
//////////////////////////////////////////////////////////////////////

// set floor(log_2 n) to count.  NB: 0 = floor(log_2 0)
procedure log_floor(int n, int count)
  local int r = 1
    from  r = 1
    loop  local int t = 2 * r	// r *= 2
            t <=> r
          delocal int t = r / 2
          count += 1
    until r > n
    from  r > n
    loop  local int t = r / 2	// r /= 2
            t <=> r
          delocal int t = 2 * r
    until r = 1
  delocal int r = 1
  count -= 1

// set x to the power of 2 to res
procedure pow_two(int x, int res)
  if x>=0 && res = 0 then skip else error("pow_two") fi 1=1
  res ^= 1
  local int u = x
    from  u = x
    loop  local int t = 2 * res	// res *= 2
            t <=> res
          delocal int t = res / 2
          u -= 1
    until u = 0
  delocal int u = 0

procedure double(int x)
  local int t = (x * 2) ^ x
    x ^= t
  delocal int t = (x / 2) ^ x

procedure perm2invtab(int a[], int b[], int x[], int n)
  local int k = 0 local int log2_n = 0
    call log_floor(n, k)
    log2_n ^= k
    from  k = log2_n
    loop  local int two_k = 0  // 2^k
            call pow_two(k, two_k) // two_k = 2^k
            local int j = 0
              from  j = 0
              loop  local int r = (a[j] / two_k) % 2
                      local int s = a[j] / (two_k * 2)
                        if r = 0 then
                          b[a[j]] += x[s]
                        else // r = 1
                          x[s] += 1
                        fi r = 0
                      delocal int s = a[j] / (two_k * 2)
                    delocal int r = (a[j] / two_k) % 2
                    j += 1
              until j = n
              from  j = n
              loop  j -= 1
                    if (a[j] / two_k) % 2 = 1 then
                      x[a[j] / (two_k * 2)] -= 1
                    fi (a[j] / two_k) % 2 = 1
              until j = 0
            delocal int j = 0
            // show(k,two_k)
            uncall pow_two(k, two_k)
          delocal int two_k = 0
          k -= 1
    until k = -1
    uncall log_floor(n, log2_n)
  delocal int log2_n = 0 delocal int k = -1

procedure main()
  int a[9]  // permutation
  int b[9]  // inversion table
  int x[9]  // intermediate data
  int sz
  stack gb

  sz ^= 9

  a[0] ^= 4
  a[1] ^= 8
  a[2] ^= 0
  a[3] ^= 7
  a[4] ^= 1
  a[5] ^= 5
  a[6] ^= 3
  a[7] ^= 6
  a[8] ^= 2

  // b[0] ^= 2
  // b[1] ^= 3
  // b[2] ^= 6
  // b[3] ^= 4
  // b[4] ^= 0
  // b[5] ^= 2
  // b[6] ^= 2
  // b[7] ^= 1
  // b[8] ^= 0

  // a[0] ^= 2
  // a[1] ^= 5
  // a[2] ^= 7
  // a[3] ^= 1
  // a[4] ^= 4
  // a[5] ^= 6
  // a[6] ^= 0
  // a[7] ^= 3

  // call perm2invtab(a,b,x,sz)