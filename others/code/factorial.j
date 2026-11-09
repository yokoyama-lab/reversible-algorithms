// Tested on an online interpreter: http://topps.diku.dk/pirc/janus-playground/

procedure factorial(int n, int res)
  res += 1
  local int i = 0
    from  i = 0
    loop  i += 1
          local int tmp = res * i
            res <=> tmp
          delocal int tmp = res / i  // {res = i!}
    until i = n
  delocal int i = n

procedure main()
  int n
  int res

  n += 5
  call factorial(n,res)