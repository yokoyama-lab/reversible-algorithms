// Tested on an online interpreter: http://topps.diku.dk/pirc/janus-playground/

procedure bsort1(int a[], int n, stack gb)
  local int i = 0
    from  i = 0
    loop  local int j = n - 1
            from  j = n - 1
            loop  if a[j] < a[j-1] then
                    local int t = a[j-1] ^ a[j]
                      a[j-1] ^= t
                      a[j] ^= t
                    delocal int t = a[j-1] ^ a[j]
                    local int t = 1
                      push(t,gb)  // push control garbage to garbage stack gb
                    delocal int t = 0
                  else
                    local int t = 0
                      push(t,gb)  // push control garbage to garbage stack gb
                    delocal int t = 0
                  fi top(gb) = 1
                  j -= 1
            until j = i
          delocal int j = i
          i += 1
    until i = n
  delocal int i = n

procedure main()
  int a[6]    // input array
  int n       // size of array a[]
  stack gb    // garbage

  n += 6

  a[0] += 2
  a[1] += 5
  a[2] += 4
  a[3] += 0
  a[4] += 3
  a[5] += 1

  call bsort1(a,n,gb)
