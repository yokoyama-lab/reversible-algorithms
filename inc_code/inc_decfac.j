procedure inc_decfac(int d[], int n)
  local int i = n
    from  i = n
    do    i -= 1
          d[i] += 1
    loop  d[i] -= n - i
    until i = 0 || d[i] <= n - i - 1

    if i = 0 && d[0] = n then d[0] -= n fi i = 0 && d[0] = 0

    from  i = 0 || d[i] != 0
    do    i += 1
    until i = n
  delocal int i = n

procedure main()
  int n
  int d[5]

  n ^= 5
  d[0] ^= 4
  d[1] ^= 3
  d[2] ^= 2
  d[3] ^= 1
  d[4] ^= 0

  call inc_decfac(d,n)