//////////////////////////////////////////////////////////////////////
// Er, M. C. (1985).
// "Enumerating ordered trees lexicographically."
// The Computer Journal 28(5).
//
// procedure GenSuc, p. 540
// . Amortized cost of genSuc: O(1)
// . Cyclic
//////////////////////////////////////////////////////////////////////

procedure genSuc(int b[], int n)
  local int j = 0
    local int k = 0

      local int i = 2*n - 2
        from  i = 2*n - 2
        loop  i -= 1
        until b[i] = 1

        j += i-1
        from  j = i-1
        loop  j -= 1
        until j = -1 || b[j] = 0

        k += i-j
      delocal int i = k+j

      local int m = j+1
        from  m = j+1
        do    b[m] -= 1     // 1 -> 0
        loop  m += 1
        until m = j+k
        m -= j+k

        if j = -1 then
          j += 1
        fi j = 0
        b[j] += 1

        // clear j
        from  b[j] = 1
        do    j += 1
        until j = 2*n
        j -= 2*n

        k -= 1
        m += (2*n - 1) - 2*k
        from  m = (2*n - 1) - 2*k
        loop  b[m+1] += 1
              m += 2
        until m = 2*n - 1
      delocal int m = 2 * n - 1

      // clear k
      from  b[2*n - 2*k - 2] = 0 || k = n-1
      loop  k -= 1
      until k = 0
    delocal int k = 0
  delocal int j = 0


procedure main()
  int n int b[8]

  b[0] += 1
  b[1] += 0
  b[2] += 1
  b[3] += 0
  b[4] += 1
  b[5] += 0
  b[6] += 1
  b[7] += 0
  n += 4

  call genSuc(b,n)
  call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
  // call genSuc(b,n)
