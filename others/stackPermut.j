////////////////////////////////////////////////////////////////////////////
// Er, N. C. (1983).
// "A Note on Generating Well-formed Parenthesis Strings Lexicographically."
// The Computer Journal 26(3): 205-207.
// . p.206 procedure StackPermut
////////////////////////////////////////////////////////////////////////////

procedure stackPermut(int l, int r, int p[], int n, int e, stack stk)
  if l=0 && r=0 then
    show(p)
  else
    if r != 0 then
      local int i = 0
        pop(i,stk)
        p[n-l-r] += i
        r -= 1
        call stackPermut(l,r,p,n,e,stk)
        r += 1
        p[n-l-r] -= i
        push(i,stk)
      delocal int i = 0
    fi r != 0
    if l != 0 then
      local int tmp = e
        push(tmp, stk)
      delocal int tmp = 0
      l -= 1
      r += 1
      e += 1
      call stackPermut(l,r,p,n,e,stk)
      e -= 1
      r -= 1
      l += 1
      local int tmp = 0
        pop(tmp, stk)
      delocal int tmp = e
    fi l != 0
  fi l=0 && r=0

procedure main()
  int i
  int j
  int p[4]  // = n
  int n
  int e
  stack stk

  n += 4
  i += n
  e += 0
  call stackPermut(i,j,p,n,e,stk)
