// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.18 (37)

procedure isort(int in[], int sz, int gb[])
  local int j=1
    from  j=1
    loop  local int i = j
            from  i=j
            loop  local int t1 = in[i-1]  // in[i-1] <=> in[i]
                    local int t2 = in[i]
                      in[i-1] ^= t1 ^ t2
                      in[i]   ^= t1 ^ t2
                    delocal int t2 = in[i-1]
                  delocal int t1 = in[i]
                  i -= 1
            until i=0 || in[i-1] <= in[i]
            gb[j-1] ^= i
          delocal int i = gb[j-1]
          j += 1
    until j=sz
  delocal int j=sz

procedure main()
  int a[6]     // input array
  int sz       // size of stk[]
  int gb[6]    // garbage

  sz += 6
  a[0] += 50
  a[1] += 20
  a[2] += 40
  a[3] += 60
  a[4] += 10
  a[5] += 30

  call isort(a,sz,gb)