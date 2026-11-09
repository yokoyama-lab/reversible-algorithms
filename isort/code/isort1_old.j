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

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int n = 6                  // size of array a[]
  stack gb                   // garbage

  call isort1(a,n,gb)
