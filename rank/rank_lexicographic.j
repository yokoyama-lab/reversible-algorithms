//////////////////////////////////////////////////////////////////////
// Bonet, B. (2008). Efficient algorithms to rank and unrank permutations in lexicographic order. AAAI-Workshop on Search in AI and Robotics.
//
// The lexicographic order is preserverd in the transformations.
//////////////////////////////////////////////////////////////////////

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

// set ceil(log_2 n) to count.  NB: 0 = ceil(log_2 0)
procedure log_ceil(int n, int count)
  local int r = 1
    from  r = 1
    loop  local int t = 2 * r	// r *= 2
            t <=> r
          delocal int t = r / 2
          count += 1
    until r >= n
    from  r >= n
    loop  local int t = r / 2	// r /= 2
            t <=> r
          delocal int t = 2 * r
    until r = 1
  delocal int r = 1

// O(n log n) uniform lexicographic ranking
// NB: This is not (yet) clean
procedure rank(int pi[], int t[], int n, int rank)
  local int i = 1
    from  i = 1
    loop  local int k = 0
            call log_ceil(n,k)
            local int ctr = pi[i]
              local int node = 0
                call pow_two(k,node)
                node += pi[i]

                local stack gb = nil
                  local int j = 1
                    from  j = 1
                    loop  if node % 2 = 1 then   // whether node is odd
                            ctr -= t[node - 1]
                          fi node % 2 = 1
                          t[node] += 1

                          // node >>= 1
                          local int u = node % 2
                            push(u,gb)
                          delocal int u = 0
                          local int u = node / 2
                            u <=> node
                          delocal int u = node * 2 + top(gb)

                          j += 1
                    until j = k + 1
                  delocal int j = k + 1

                  t[node] += 1
                  local int u = rank * (n+1-i) + ctr
                    rank <=> u
                  delocal int u = rank / (n+1-i)

                  from  node = 1   // restore node
                  loop  local int u2 = 0
                          pop(u2,gb)
                          local int u3 = node * 2 + u2
                            u3 <=> node
                          delocal int u3 = node / 2
                        delocal int u2 = node % 2
                  until empty(gb)

                delocal stack gb = nil

                node -= pi[i]
                uncall pow_two(k,node)
              delocal int node = 0
            delocal int ctr = rank % (n+1-i)
            uncall log_ceil(n,k)
          delocal int k = 0
          i += 1
    until i = n+1
  delocal int i = n+1

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

// Bonet, B. (2008). Efficient algorithms to rank and unrank permutations in lexicographic order. AAAI-Workshop on Search in AI and Robotics.
// ranks to inversion vectors, time complexity is O(n log n)
// clean encoding: rank |-> d[]
// rank2factorial_digits
procedure rank2d(int rank, int d[], int n)
  local int fac = 0
    n -= 1
    call factI(n,fac)
    n += 1
    local int i = n - 1
      from  i = n - 1
      loop  d[n-i-1] ^= rank / fac
            rank -= fac * d[n-i-1]
            local int t1 = fac / i
              fac ^= t1 * i
              fac ^= t1
            delocal int t1 = fac
            i -= 1
      until i = 0
    delocal int i = 0
  delocal int fac = 1

// Bonet, B. (2008). Efficient algorithms to rank and unrank permutations in lexicographic order. AAAI-Workshop on Search in AI and Robotics.
// Figure 4
// d[] factorial digits
procedure unrank(int pi[], int t[], int n, int d[])
  local int k = 0
    call log_ceil(n,k)
    local int two_k = 0
    call pow_two(k, two_k)
    call make_tree(t,n)
    local int i = 1
      from  i = 1
      loop  local int node = 1
              local int j = 1
                from  j = 1
                loop  t[node-1] -= 1
                      local int t1 = node * 2 // node <<= 1
                        node <=> t1
                      delocal int t1 = node / 2
                      if d[i-1] >= t[node-1] then
                        d[i-1] -= t[node-1]
                        node += 1
                      fi node % 2 = 1
                      j += 1
                until j = k + 1
              delocal int j = k + 1
              t[node-1] -= 1
              pi[i-1] ^= node - two_k
            delocal int node = pi[i-1] + two_k
            i += 1
      until i = n + 1
    delocal int i = n + 1
    uncall pow_two(k, two_k)
    delocal int two_k = 0
    uncall log_ceil(n,k)
  delocal int k = 0

// Figure 4, line 5-6
procedure make_tree(int t[], int n)
  local int k = 0
    call log_ceil(n,k)
    local int i = 0
      from  i = 0
      loop  local int i_max = 0
              call pow_two(i,i_max)
              local int j = 1
                from  j = 1
                loop  local int k_i = 0       // t[2^i + j - 1] ^= 1 << (k - i)
                        local int t1 = k - i
                          call pow_two(t1, k_i)
                          t[i_max + j - 2] ^= k_i
                          uncall pow_two(t1, k_i)
                        delocal int t1 = k - i
                      delocal int k_i = 0
                      j += 1
                until j = i_max + 1
              delocal int j = i_max + 1
              uncall pow_two(i,i_max)
            delocal int i_max = 0
            i += 1
      until i = k + 1
    delocal int i = k + 1
    uncall log_ceil(n,k)
  delocal int k = 0

// d[n+1] factorial digits
// temporary array t[n*2] is necessary
procedure rank2perm(int rank, int pi[], int n, int d[], int t[])
  call rank2d(rank,d,n)
  call unrank(pi, t, n, d)

procedure main()
  int pi[8]			// permutation
  int d[8]			// inversion table
  int t[15]			// tree
  int n				// length of permutation (and inversion table)
  int rank			// rank of permutation

  n ^= 8

  pi[0] ^= 2
  pi[1] ^= 5
  pi[2] ^= 7
  pi[3] ^= 1
  pi[4] ^= 4
  pi[5] ^= 6
  pi[6] ^= 0
  pi[7] ^= 3

  uncall unrank(pi, t, n, d)

  // pi[1] ^= 0
  // pi[2] ^= 1
  // pi[3] ^= 2
  // pi[4] ^= 3
  // pi[5] ^= 4
  // pi[6] ^= 5
  // pi[7] ^= 6
  // pi[8] ^= 7

  // pi[1] ^= 7
  // pi[2] ^= 6
  // pi[3] ^= 5
  // pi[4] ^= 4
  // pi[5] ^= 3
  // pi[6] ^= 2
  // pi[7] ^= 1
  // pi[8] ^= 0

  // call rank(pi, t, n, rank)

  // rank ^= 13600
  // call rank2perm(rank,pi,n,d,t)

  // uncall unrank(pi, t, n, d)
  // uncall rank2d(rank,d,n)
