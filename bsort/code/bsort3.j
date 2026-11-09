procedure bsort1(int a[], int n, stack gb)
  local int i = 0
    from  i = 0
    loop  local int j = n - 1
            from  j = n - 1
            loop  if a[j] < a[j-1] then
                    a[j-1] <=> a[j]
                    local int pushtmp = 1
                      push(pushtmp, gb) // push control garbage to garbage stack gb
                    delocal int pushtmp = 0
                  else
                    local int pushtmp = 0
                      push(pushtmp, gb) // push control garbage to garbage stack gb
                    delocal int pushtmp = 0
                  fi top(gb) = 1
                  j -= 1
            until j = i
          delocal int j = i
          i += 1
    until i = n
  delocal int i = n

// Setting to p[] identity permutation of length n
procedure id_perm(int p[], int n)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure bsort3(int a[], int n, int p[]) // p[i] = i for 0 ≤ i ≤ n − 1
  local stack gb = nil
    call bsort1(a,n,gb)
    uncall bsort1(p,n,gb)
  delocal stack gb = nil

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array and output array
  int p[6]                   // permutation (output)
  int n = 6                  // size of input array a[]

  call id_perm(p,n)          // set identity permutation of length n to p
  call bsort3(a,n,p)
