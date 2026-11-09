// bubble sort (right to left) with optimal intermediate garbage and optimal garbage: 
// inv[] = (right decreasing relative inversion table for original input order permutation) 
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.40
// Knuth, D. E., (1973). TAoCP, Chapter 5
// Bonet, B., Efficient Algorithms to Rank and Unrank.
// Garbage inv[] matches the rank2perm input format from [Bonet].

procedure bsort(int in[], int inv[], int sz)
  local int i=0
    from  i=0
    loop  local int j = sz - 1
            from  j = sz-1
            loop  if in[j] < in[j-1] then
                     local int t = in[j-1] ^ in[j] // in[j-1] <=> in[j]
                        in[j-1] ^= t
                        in[j]   ^= t
                     delocal int t = in[j-1] ^ in[j]
                     inv[j-i-1] += 1 // increment right inversion table
                  fi inv[j-i-1] = i+1
                  j -= 1
            until j = i
          delocal int j = i
          i += 1
    until i=sz
  delocal int i=sz
  

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

  call bsort(a,inv,sz)
  
  //inv[6] += 1
  //uncall isort(a,inv,sz)