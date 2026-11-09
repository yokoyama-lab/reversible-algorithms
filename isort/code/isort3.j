// checked on Oct. 17, 2014

procedure isort3(int a[], int n, int d[])
  local int j = n - 1
    from  j = n - 1 do
      local int i = j
        from  i = j
        loop  a[i-1] <=> a[i] // @\label{lst:isort3:swap}@
              i += 1
        until i = n || a[i-1] <= a[i] // \{ a[j..n-1] is ordered\label{lst:isort3:short} \}
        d[j-1] += i - j
      delocal int i = d[j-1] + j // @\label{lst:isort3:deallocate}@
      j -= 1
    until j = 0
  delocal int j = 0  

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int d[6]                   // factorial representation (garbage)
  int n = 6                  // size of input array a[]

  call isort3(a,n,d)
