// bubble sort with optimal intermediate garbage and optimal garbage (inversion table) 
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.40
// Knuth, D. E., (1973). TAoCP, Chapter 5

procedure bsort(int in[], int inv[], int sz)
  local int i=sz-1
    from  i=sz-1
    loop  local int j = 0
            from  j = 0
            loop  if in[j+1] < in[j] then
                     local int t = in[j+1] ^ in[j] // in[j] <=> in[j+1]
                        in[j+1] ^= t
                        in[j]   ^= t
                     delocal int t = in[j+1] ^ in[j]
                     inv[sz-i+j] += 1 // increment inversion table
                  fi inv[sz-i+j] = sz-i
                  j += 1
            until j = i
          delocal int j = i
          i -= 1
    until i=0
  delocal int i=0
  

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

  call bsort(a,inv,sz)