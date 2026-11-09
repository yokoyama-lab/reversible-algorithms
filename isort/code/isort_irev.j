procedure isort_irev(int a[], int n)
  local int j = n - 1
    local int t1 = 1
      from  t1 = 1
      do    emit(t1)
      loop  local int i = j
      
              local int t2 = 1
                // insert a[j] into a[j+1..n-1]
                from  t2 = 1
                do    emit(t2)
                loop  a[i-1] <=> a[i]
                      i += 1
                until i = n || a[i-1] <= a[i]
              delocal int t2 = 0
              emit(i)

            delocal int i = 0
            j -= 1
      until j = 0
    delocal int t1 = 0
    emit(j)
  delocal int j = 0

procedure main()
  int a[6]    // input array
  int n       // size of array a[]

  n += 6

  a[0] += 2
  a[1] += 5
  a[2] += 4
  a[3] += 0
  a[4] += 3
  a[5] += 1

  call isort_irev(a,n)
