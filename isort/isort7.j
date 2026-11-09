// isort using optimal intermediate garbage with optimal garbage
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.18 (37)

procedure isort(int in[], int sz, int ord[])
  local int j=0
    from  j=0
    loop  local int i = j
            from  i=j
            loop  local int t1 = in[i-1]  // in[i-1] <=> in[i]
                    local int t2 = in[i]
                      in[i-1] ^= t1 ^ t2
                      in[i]   ^= t1 ^ t2
                    delocal int t2 = in[i-1]
                  delocal int t1 = in[i]
		  local int t1 = ord[i-1]  // ord[i-1] <=> ord[i]
                    local int t2 = ord[i]
                      ord[i-1] ^= t1 ^ t2
                      ord[i]   ^= t1 ^ t2
                    delocal int t2 = ord[i-1]
                  delocal int t1 = ord[i]
                  i -= 1
            until i=0 || in[i-1] <= in[i]
            from  ord[i] = j      // the loop does not appear in the original isort
            loop  i -= 1
	    until i=0
          delocal int i = 0
          j += 1
    until j=sz
  delocal int j=sz

procedure main()
  int a[6]     // input array
  int sz       // size of stk[]
  int ord[6]   // order

  sz += 6
  a[0] += 50
  a[1] += 20
  a[2] += 40
  a[3] += 60
  a[4] += 10
  a[5] += 30

  ord[0] += 0
  ord[1] += 1
  ord[2] += 2
  ord[3] += 3
  ord[4] += 4
  ord[5] += 5

  call isort(a,sz,ord)