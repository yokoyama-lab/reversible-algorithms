procedure bsort4(int a[], int d[], int n)
  local int i = 0
    from  i = 0
    loop  local int j = n - 1
            from  j = n - 1
            loop  if a[j] < a[j-1] then
                    a[j-1] <=> a[j]
                    d[j-i-1] += 1
                  fi d[j-i-1] = i + 1
                  j -= 1
            until j = i
          delocal int j = i
          i += 1
    until i = n
  delocal int i = n

// We compute the values d[] in the order of decreasing i, the opposite order to bsort4
procedure bsort5(int a[], int d[], int n)
  local int i = n - 1
    from  i = n - 1
    loop  local int j = 0
            from  j = 0
            loop  if a[j+1] < a[j] then
                    a[j] <=> a[j+1]
                    d[n - (i-j)] += 1
                  fi d[n - (i-j)] = n - i
                  j += 1
            until j = i
          delocal int j = i
          i -= 1
    until i = 0
  delocal int i = 0

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int d[6]                   // factorial representation
  int n = 6                  // size of array a[]

  call bsort5(a,d,n)

  // input:  a[6] = {2, 5, 4, 0, 3, 1}, d[6] = {0, 0, 0, 0, 0, 0}
  // output: a[6] = {0, 1, 2, 3, 4, 5}, d[6] = {0, 0, 1, 3, 2, 4}
