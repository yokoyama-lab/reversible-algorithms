//////////////////////////////////////////////////////////////////////
// Hall, J. S. (1994). A reversible instruction set architecture and algorithms. Physics and Computation, 1994. PhysComp '94, Proceedings., Workshop on. Figure 5
//////////////////////////////////////////////////////////////////////

procedure isort_hall(int a[], int b[], int n)
  b[n] ^= 999
  local int i = n - 1
    from  i = n - 1                       // label: bol
    loop  local int j = i
            local int x = a[j]
              from  j = i
              loop  if x <= b[j+1] then
                      b[j] ^= x               // label: ex
                    else
                      local int t = b[j] ^ b[j+1] // b[j] <=> b[j+1]
                        b[j]   ^= t
                        b[j+1] ^= t
                      delocal int t = b[j] ^ b[j+1]
                    fi b[j] = x
                    j += 1
              until j > 0 && (b[j-1] = x || j = n)
              j -= 1

              from  x = b[j]	// label: brl
              loop  j -= 1
              until j = i
            delocal int x = a[j]
          delocal int j = i
          i -= 1
    until i = -1
  delocal int i = -1
  b[n] ^= 999


procedure main()
  int a[5]
  int b[6]
  int n

  n += 5

  a[0] ^= 3
  a[1] ^= 5
  a[2] ^= 1
  a[3] ^= 2
  a[4] ^= 4

  call isort_hall(a,b,n)