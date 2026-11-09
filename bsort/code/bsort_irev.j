procedure bsort_irev(int a[], int n)
  local int i = 0
    local int t1 = 1
      from  t1 = 1
      do    emit(t1)
      loop  local int j = n - 1
              local int t2 = 1
                from  t2 = 1
                do    emit(t2)
                loop  local int t3 = 0
                        if a[j-1] > a[j] then
                          a[j-1] <=> a[j]
                          t3 ^= 1
                        fi t3 = 1
                        emit(t3)
                      delocal int t3 = 0
                      j -= 1
                until j = i
              delocal int t2 = 0
              emit(j)
            delocal int j = 0
            i += 1
      until i = n
    delocal int t1 = 0
    emit(i)
  delocal int i = 0

procedure main()
  int a[6]    // input array
  int n       // size of stk[]

  n += 6

  a[0] += 2
  a[1] += 5
  a[2] += 4
  a[3] += 0
  a[4] += 3
  a[5] += 1

  call bsort_irev(a,n)