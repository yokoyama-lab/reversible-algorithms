procedure make_p'(int p[], int p'[], int n)   // pi[] |-> (pi[], pi_inv[])
  local int i = 0
    from  i = 0
    do    p'[p[i]] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure pp'2decfac(int p[], int p'[], int n)
  local int i = 0
    from i = 0 do
      local int s = p[i]
        if i = p'[i] then
          skip                    // self-swap would alias
        else
          p[i] <=> p[p'[i]]
        fi i = p'[i]
        if s = i then
          skip
        else
          p'[s] <=> p'[i]
        fi s = i
        p[i] += s - i   // update p[i] from i to s
        p'[i] ^= i      // zero clear
      delocal int s = p[i]
      p[i] -= i
      i += 1
    until i = n
  delocal int i = n

procedure perm2decfac_nolex(int p[], int n)
  local int p'[n] = {0}  // inversion table
    call make_p'(p,p',n)
    call pp'2decfac(p,p',n)
  delocal int p'[n] = {0}

procedure main()
  int p[8]			// permutation
  int n				// length of permutation (and inversion table)

  n ^= 8

  // p[0] ^= 2
  // p[1] ^= 5
  // p[2] ^= 7
  // p[3] ^= 1
  // p[4] ^= 4
  // p[5] ^= 6
  // p[6] ^= 0
  // p[7] ^= 3

  // Minimum
  // p[0] ^= 0
  // p[1] ^= 1
  // p[2] ^= 2
  // p[3] ^= 3
  // p[4] ^= 4
  // p[5] ^= 5
  // p[6] ^= 6
  // p[7] ^= 7

  p[0] ^= 7
  p[1] ^= 0
  p[2] ^= 1
  p[3] ^= 2
  p[4] ^= 3
  p[5] ^= 4
  p[6] ^= 5
  p[7] ^= 6

  // The following is the maximum
  // p[0] ^= 7
  // p[1] ^= 0
  // p[2] ^= 1
  // p[3] ^= 2
  // p[4] ^= 3
  // p[5] ^= 4
  // p[6] ^= 5
  // p[7] ^= 6

  call perm2decfac_nolex(p, n)