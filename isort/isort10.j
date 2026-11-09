// insertion sort (right to left) with optimal intermediate garbage: right decreasing relative inversion table for original input order permutation.
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.40
// Knuth, D. E., (1973). TAoCP, Chap. 5.
// Bonet, B., Efficient Algorithms to Rank and Unrank.
// Garbage inv[] matches the rank2perm input format from [Bonet].

procedure isort(int a[], int inv[], int sz)
  local int j=sz-1
    from  j=sz-1
    do  local int i=j
        from  i=j
        loop  local int t = a[i-1] ^ a[i] // a[i-1] <=> a[i]
                    a[i-1] ^= t
                    a[i]   ^= t
              delocal int t = a[i-1] ^ a[i]
              i += 1
        until i = sz || a[i-1] <= a[i]
        // move right inversion number (i-j) to inv[j-1], and clear i
        inv[j-1] += i - j
        delocal int i=inv[j-1] + j 
        j -= 1
    until j=0
  delocal int j=0

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
procedure rank2d(int rank, int d[], int n)
  local int fac = 0
    n -= 1
    call factI(n,fac)
    n += 1
    local int i = 0
      from  i = 0
      loop  d[i] ^= rank / fac
            rank -= fac * d[i]
            local int t1 = fac / (n-i-1)
              fac ^= t1 * (n-i-1)
              fac ^= t1
            delocal int t1 = fac
            i += 1
            // show(rank,fac,d)
      until i = n - 2
      d[i] ^= rank
      rank ^= d[i]
    delocal int i = n - 2
  delocal int fac = 1

procedure inc_(int rank, int n)
  local int fac = 0
    call factI(n, fac)
    local int t = (rank + 1) % fac
      rank <=> t
    delocal int t = (rank - 1 + fac) % fac
    uncall factI(n, fac)
  delocal int fac = 0

procedure inc(int rank, int n)
  local int fac = 0
    call factI(n, fac)
    rank += 1
    if rank = fac then
      rank -= fac
    fi rank = 0
    uncall factI(n, fac)
  delocal int fac = 0

// pi = 25714603
// I(pi) = 24512200

procedure main()
  int a[8]     // input array
  int sz       // size of array
  int inv[8]   // inversion vector
  int rank
 
  sz += 8
  
  a[0] += 2
  a[1] += 5
  a[2] += 7
  a[3] += 1
  a[4] += 4
  a[5] += 6
  a[6] += 0
  a[7] += 3

  // increment permutation by one
  call isort(a,inv,sz)
  uncall rank2d(rank, inv, sz)
  call inc(rank,sz)
  call rank2d(rank, inv, sz)
  uncall isort(a,inv,sz)

  // a[0] += 7
  // a[1] += 6
  // a[2] += 5
  // a[3] += 4
  // a[4] += 3
  // a[5] += 2
  // a[6] += 1
  // a[7] += 0

  // // increment permutation by one
  // call isort(a,inv,sz)
  // uncall rank2d(rank, inv, sz)
  // call inc(rank,sz)
  // call rank2d(rank, inv, sz)
  // uncall isort(a,inv,sz)

