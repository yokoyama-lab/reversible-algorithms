// checked on Oct. 17, 2014

procedure bsort4(int a[], int n, int d[])
  local int i = 0
    from i = 0
    loop local int j = n-1  
           from j = n-1
           loop  if a[j] < a[j-1] then
                    a[j-1] <=> a[j]
                    d[j-i-1] += 1
                 fi d[j-i-1] = i + 1
                 j -= 1
           until j = i  // \{ \textcolor{blue}{a[0..i]} is ordered \}
         delocal int j = i
         i += 1
    until i = n
  delocal int i = n  

procedure main()
  int a[6] ={2,5,4,0,3,1}   // input array
  int d[6]                  // factorial representation
  int n = 6                 // size of array a[]

  call bsort4(a,n,d)

  // input:  a[6] = {2, 5, 4, 0, 3, 1}, d[6] = {0, 0, 0, 0, 0, 0}
  // output: a[6] = {0, 1, 2, 3, 4, 5}, d[6] = {2, 4, 3, 0, 1, 0}
