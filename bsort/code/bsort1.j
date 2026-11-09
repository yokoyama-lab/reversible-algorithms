procedure bsort1(int a[], int n, stack gb)
  local int i = 0
    from  i = 0
    loop  local int j = n - 1
            from  j = n - 1
            loop  if a[j] < a[j-1]
                  then a[j-1] <=> a[j]
                       local int pushtmp = 1
                         push(pushtmp, gb) // push control garbage
                       delocal int pushtmp = 0
                  else
                    local int pushtmp = 0
                      push(pushtmp, gb) // push control garbage
                    delocal int pushtmp = 0
                  fi top(gb) = 1
                  j -= 1
            until j = i
          delocal int j = i
          i += 1
    until i = n
  delocal int i = n

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int n = 6                  // size of array a[]
  stack gb                   // garbage

  call bsort1(a,n,gb)
