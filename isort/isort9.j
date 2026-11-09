// insertion sort (right to left) with optimal intermediate garbage: right decreasing relative inversion table for original input order permutation.
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.40
// Knuth, D. E., (1973). TAoCP, Chap. 5.
// Bonet, B., Efficient Algorithms to Rank and Unrank.
// Garbage inv[] matches the rank2perm input format from [Bonet].

procedure isort(int in[], int inv[], int sz)
  local int j=sz-1
    from  j=sz-1
    do  local int i=j
        from  i=j
        loop  local int t = in[i-1] ^ in[i] // in[i-1] <=> in[i]
                    in[i-1] ^= t
                    in[i]   ^= t
              delocal int t = in[i-1] ^ in[i]
              i += 1
        until i = sz || in[i-1] <= in[i]
        // move right inversion number (i-j) to inv[j-1], and clear i
        inv[j-1] += i - j
        delocal int i=inv[j-1] + j 
        j -= 1
    until j=0
  delocal int j=0

// pi = 25714603
// I(pi) = 24512200

procedure main()
  int a[8]     // input array
  int sz       // size of array
  int inv[8]   // inversion vector
 
  sz += 8
  
  a[0] += 2
  a[1] += 5
  a[2] += 7
  a[3] += 1
  a[4] += 4
  a[5] += 6
  a[6] += 0
  a[7] += 3

  call isort(a,inv,sz)
  
  inv[6] += 1
  uncall isort(a,inv,sz)