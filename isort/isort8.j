// insertion sort (left to right) with optimal intermediate garbage: (left) inversion table for original order permutation
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.40
// Knuth, D. E., (1973). TAoCP, Chap. 5.

procedure isort_l2r(int in[], int inv[], int sz)
  local int j=0
    from  j=0
    do  local int i=j
        from  i=j
        loop  local int t = in[i-1] ^ in[i] // in[i-1] <=> in[i]
                    in[i-1] ^= t
                    in[i]   ^= t
              delocal int t = in[i-1] ^ in[i]
              i -= 1
        until i = 0 || in[i-1] <= in[i]
        // move inversion number (j-i) to inv[j], and clear i
        inv[j] += j - i
        delocal int i=j-inv[j] 
        j += 1
    until j=sz
  delocal int j=sz


procedure main()
  int a[5]     // input array
  int sz       // size of array
  int inv[5]   // inversion vector
//  int iperm[5]
//  int b[5]
  sz += 5
  
  a[0] += 20
  a[1] += 50
  a[2] += 40
  a[3] += 10
  a[4] += 30

  call isort_l2r(a,inv,sz)