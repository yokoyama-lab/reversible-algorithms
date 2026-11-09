procedure isort4(int a[], int p[], int n)
  local int j = 1
    from  j = 1
    loop  local int i = j

            // insert a[j] into a[0..j]
            from  i = j
            loop  a[i-1] <=> a[i]
                  p[i-1] <=> p[i]
                  i -= 1
            until i = 0 || a[i-1] <= a[i]

            // clear i
            from  p[i] = j
            loop  i += 1
            until i = j

          delocal int i = j
          j += 1
    until j = n
  delocal int j = n

// Setting to p[] identity permutation of length n
procedure id_perm(int p[], int n)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int p[6]                   // permutation
  int n = 6                  // size of input array a[]

  call id_perm(p,n)

  call isort4(a,p,n)
