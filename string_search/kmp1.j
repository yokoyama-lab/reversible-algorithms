// STATUS: known-broken (WIP), same root cause as kmp.j: the outer loop
//   guards on the backtracking prefix pointer `i` (non-monotone), so the
//   reversible `from i = 1` re-entry assertion fails. Needs a monotone loop
//   index + logged backtracking. FIXED implementation: see kmp2.j.
procedure compf(int p[], int m, int f[], stack g)
    local int i = 0
        local int j = 1
            from i = 0 loop
                if i = 0 || p[i] = p[j] then
                    j += 1
                    i += 1
                    push(f[j], g)
                    f[j] += i
                    push(0, g)
                else
                    push(i, g)
                    i += f[top(g)]
                fi top(g) = 0
            until j = m-1
            push(i, g)
            push(j, g)
        delocal int j = 0
    delocal int i = 0

procedure kmp(int p[], int t[], int f[], int m, int n, int i, int j, stack g)
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
    until i = m && j = n

procedure main()
    int pat[3] = {2, 4, 3}
    int text[10] = {1, 2, 3, 4, 5, 1, 2, 4, 3, 5}
    int m = 3
    int n = 10
    int i = 1
    int j = 1
    stack g
    int f[3]

    call kmp(pat, text, f, m, n, i, j, g)

    if i = m+1 then
        printf("Success")
    else
        printf("Failure")
    fi i = m
