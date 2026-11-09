////////////////////////////////////////////////////////
// Lutz, C. (1986). "Janus: a time-reversible language."
// Factorization program
// (the original program has an error)
////////////////////////////////////////////////////////

procedure div(int x, int y)
  local int tmp = x / y
    tmp <=> x
  delocal int tmp = x * y

// assert(num >= 2)
procedure factorC(int num, stack fact)      // factor num into table in fact
  local int try = 1   // Attempted factor.  Starts and ends zero
    from  try=1
    loop  try += 1
          from  empty(fact) || top(fact) != try  // Divide out all occurrences of this factor
          loop  push(try, fact)
                try ^= top(fact)
                call div(num,try)
          until (num % try) != 0
    until try > num                  // Exit early if possible
    try ^= top(fact)
    num -= 1
  delocal int try = 0

procedure main()
  int num        // Number to factor
  stack fact     // Factor table.  Starts zero. Ends with factors in ascending order

  // num ^= 72
  // call factorC(num, fact)
  // uncall factorC(num, fact)
  // num ^= 72

  num ^= 8888
  call factorC(num, fact)
