// Dijkstra, E. W. (1979). Program Inversion. Program Construction, International Summer School, Springer-Verlag: 54--57.

procedure perm2fac_a1(int p[], int y[], int m)
  local int i = 1
    from  i = 1
    loop  local int j = i
            from  j = i
            loop  p[j-1] <=> p[j]
                  j -= 1
            until j = 0 || p[j-1] < p[j]
            y[i] <=> j
          delocal int j = 0
	  i += 1
    until i = m
  delocal int i = m

procedure main()
  int p[6]   // permutation
  int y[6]   // increasing factorial representation

  p[0] ^= 2
  p[1] ^= 5
  p[2] ^= 4
  p[3] ^= 0
  p[4] ^= 3
  p[5] ^= 1

  call perm2fac_a1(p,y,6)

  // input:  p[6] = {2, 5, 4, 0, 3, 1}, y[6] = {0, 0, 0, 0, 0, 0}
  // output: p[6] = {0, 1, 2, 3, 4, 5}, y[6] = {0, 1, 1, 0, 2, 1}