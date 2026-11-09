// Dijkstra, E. W. (1979). Program Inversion. Program Construction, International Summer Schoo, Springer-Verlag: 54--57.

procedure perm2fac_a2(int v[], int m)
  local int k = m
    from  k = m
    loop  k -= 1
          local int i = 0
            from  i = 0
            loop  if v[i] > v[k] then
                    v[i] -= 1
                  fi v[i] >= v[k]
                  i += 1
            until i = k
          delocal int i = k
    until k = 0
  delocal int k = 0

procedure main()
  int p[6] = {2,5,4,0,3,1}  // permutation

  show(p)
  call perm2fac_a2(p,6)