// find the previous element to one at position x in L[] and set its position to p
// t keeps the number of iteration
procedure search(int x, int p, int L[], int n, stack gb, int t)
  from  p = 0
  loop  local int t1 = L[p]
          p <=> t1
          push(t1,gb)
        delocal int t1 = 0
        t += 1
  until L[p] = x

procedure isort_irev1(int a[], int L[], int n)
  L[0] ^= n                                // L1
  L[n] ^= 0
  local int j = n - 1
    local int t1 = 1
      from  t1 = 1
      do    emit(t1)
            local int k = a[j]
              local int p = L[0]           // L2
                local int q = 0
                  local int t2 = 1
                    from  t2 = 1
                    do    emit(t2)
                    loop  emit(q)
                          q ^= p           // L4
                          emit(p)
                          p ^= L[q]
                    until (k <= a[p]) || (p = 0)
                  delocal int t2 = 0
                  emit(L[q])
                  L[q] ^= j                // L5
                  emit(L[j])
                  L[j] ^= p
                  emit(q)
                delocal int q = 0
                emit(p)
              delocal int p = 0
            delocal int k = a[j]
            j -= 1
      until j = 0
    delocal int t1 = 0
  delocal int j = 0

procedure main()
  int a[7]    // input array
  int L[7]    // pointers
  int n       // size of array a[]

  n += 6

  a[0] += 0
  a[1] += 2
  a[2] += 5
  a[3] += 4
  a[4] += 0
  a[5] += 3
  a[6] += 1

  call isort_irev1(a,L,n)
