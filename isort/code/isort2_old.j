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

procedure isort2(int a[], int b[], int n)
  local stack gb = nil
    call isort1(a,n,gb)
    call xcopyArray(a,b,n)  // Bennett trick: Copy a[] to zero cleared b[]
    uncall isort1(b,n,gb)   // Lecerf reversal: clear gb
  delocal stack gb = nil

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int b[6]                   // input array at the end (garbage)
  int n = 6                  // size of array a[]

  call isort2(a,b,n)
