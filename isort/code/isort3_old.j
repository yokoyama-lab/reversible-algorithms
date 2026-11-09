// Xor-copying from s[] to t[] of length n
procedure xcopyArray(int s[], int t[], int n)
  local int i = 0
    from  i = 0
    do    t[i] ^= s[i]
          i += 1
    until i = n
  delocal int i = n

procedure isort1(int a[], int n, stack gb)
  local int j = 0
    from  j = 0
    loop  local int i = j
    
            // insert a[j] into a[0..j]
            from  i = j
            loop  a[i-1] <=> a[i]
                  i -= 1
            until i = 0 || a[i-1] <= a[i]
            push(i,gb)

          delocal int i = 0
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

procedure isort3(int a[], int p[], int n)
  local stack gb = nil
    call isort1(a,n,gb)
    call id_perm(p,n)       // set identity permutation of length n to p
    uncall isort1(p,n,gb)
  delocal stack gb = nil

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int p[6]                   // permutation (output)
  int n = 6                  // size of array a[]

  call isort3(a,p,n)
