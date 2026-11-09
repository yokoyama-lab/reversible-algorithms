//////////////////////////////////////////////////////////////////////
// counting sort with optimal garbage
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.195
//////////////////////////////////////////////////////////////////////

procedure xcopyArray(int s[], int t[], int n)
  local int i = 0
    from  i = 0
    do    t[i] ^= s[i]
          i += 1
    until i = n
  delocal int i = n

procedure csort(int a[], int sz, int b[], int c[], int k)
  local int j = 0
    from  j = 0
    loop  c[a[j]] += 1
          j += 1
    until j = sz
  delocal int j = sz
  // show(c)

  local int i = 1
    from  i = 1
    loop  c[i] += c[i-1]
          i += 1
    until i = k
  delocal int i = k

  // decrement j first: with `j -= 1' at the end of the body the loop exits
  // as soon as j reaches 0, so a[0] was never placed (see docs/).
  local int j = sz
    from  j = sz
    loop  j -= 1
          b[c[a[j]]-1] ^= a[j]
          c[a[j]] -= 1
    until j = 0
  delocal int j = 0

procedure main()
  int a[8]     // input array
  int sz       // size of a[]
  int b[8]     // sorted array
  int c[6]     // distribution
  int k        // the range of elements
  int d[8]     // sorted array (result)

  k += 6

  sz += 8
  a[0] += 2
  a[1] += 5
  a[2] += 3
  a[3] += 0
  a[4] += 2
  a[5] += 3
  a[6] += 0
  a[7] += 3

  // Bennett method
  call csort(a,sz,b,c,k)
  // call xcopyArray(b,d,sz)
  // uncall csort(a,sz,b,c,k)
