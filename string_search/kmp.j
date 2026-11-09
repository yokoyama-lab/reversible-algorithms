// STATUS: known-broken (WIP). Diagnosed 2026-07: the outer loops
//   `from i = 1 loop ... until i = m` (compf) and `... until i = m || j = n`
//   (kmp) guard on the KMP prefix pointer `i`, which BACKTRACKS (i = f[i]) and
//   can return to 1.  A reversible `from`-assertion must be false on every
//   re-entry, so `from i = 1` fails ("should be false: i = 1").  A correct
//   reversible KMP must loop on the MONOTONE index (pattern/text position) and
//   log each backtrack step; the failure array f[] must also be initialised.
//   FIXED implementation: see kmp2.j (monotone loop + logged backtracking).
//compfのif文のf[j] += i部分でエラーが出る

procedure kmp(int p[], int t[],int f[], int m, int n, stack g)
  local int i = 1
    local int j = 1
      call compf(p, m, f, g)
      from i = 1 loop
          if i = 0 || p[i] = t[j] then
              i += 1
              j += 1
              push(0, g)
          else
              push(i, g)
              i += f[top(g)]
          fi top(g) = 0
      until i = m || j = n
      push(j, g)
      push(i, g)
    delocal int j = 0
  delocal int i =  0

procedure compf(int p[], int m, int f[], stack g)
  local int i = 1
    local int j = 0

      from i = 1 loop
          if i = 0 || p[i] = p[j] then
              i += 1
              j += 1
              push(f[j], g)
              f[j] += i
              push(0, g)
          else
              push(i, g)
              i += f[top(g)]
          fi top(g) = 0
      until i = m
      push(j, g)
      push(i, g)
    delocal int j = 0
  delocal int i =  0



procedure main()
  int p[4] = {0, 2, 4, 3}
  int t[11] = {0, 1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
  int f[3]
  int m = 4
  int n = 11
  int i
  int j
  stack g

  call kmp(p, t, f, m, n, g)

  if i = m then
    printf("Success")
  else
    printf("Failure")
  fi i = m
