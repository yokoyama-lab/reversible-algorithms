////////////////////////////////////////////////////////////////////////////
// Er, N. C. (1983).
// "A Note on Generating Well-formed Parenthesis Strings Lexicographically."
// The Computer Journal 26(3): 205-207.
// . p.205 procedure GenParentheses
//
// Er, M. C. (1985).
// "Enumerating ordered trees lexicographically."
// The Computer Journal 28(5).
// . p.539 procedure GenOrdTrees
////////////////////////////////////////////////////////////////////////////

procedure genParentheses(int l, int r, int p[], int n)
  if l=0 && r=0 then
    show(p)
  else
    local int i = 2 * (n - l) - r
      if r != 0 then
        p[i] += 1
        r -= 1
        call genParentheses(l,r,p,n)
        r += 1
        p[i] -= 1
      fi r != 0
      if l != 0 then
        p[i] += 2
        l -= 1
        r += 1
        call genParentheses(l,r,p,n)
        r -= 1
        l += 1
        p[i] -= 2
      fi l != 0
    delocal int i = 2 * (n - l) - r
  fi l=0 && r=0

procedure genOrdTree(int x, int y, int b[], int n)
  if x=0 && y=0 then
    show(b)
  else
    if y != 0 then
      b[2 * (n - x) - y] += 1
      y -= 1
      call genParentheses(x,y,b,n)
      y += 1
      b[2 * (n - x) - y] -= 1
    fi y != 0
    if x != 0 then
      b[2 * (n - x) - y] += 2
      x -= 1
      y += 1
      call genParentheses(x,y,b,n)
      y -= 1
      x += 1
      b[2 * (n - x) - y] -= 2
    fi x != 0
  fi x=0 && y=0

procedure main()
  int i
  int j
  int b[6]  // = n * 2
  int n

  n += 3
  i += n
  // call genParentheses(i,j,b,n)
  call genOrdTree(i,j,b,n)
  i -= n