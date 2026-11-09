////////////////////////////////////////////////////////////////////////////
// Er, N. C. (1983).
// "A Note on Generating Well-formed Parenthesis Strings Lexicographically."
// The Computer Journal 26(3): 205-207.
// . p.206 function BuildTree
////////////////////////////////////////////////////////////////////////////

procedure buildTree(int p[],int b[],int l[],int r[],int n)
  local int i = 2 * n
    local stack stk = nil
      from  i = 2 * n
      do    if p[i] = 2 || i = 2 * n then
               b[i] += 2 // Leaf
               local int tmp = i
                 push(tmp,stk)
               delocal int tmp = 0
            else
               b[i] += 1 // Node
               local int tmp = 0
                 pop(tmp,stk)
                 l[i] ^= tmp  tmp ^= l[i]
                 pop(tmp,stk)
                 r[i] ^= tmp  tmp ^= r[i]
                 tmp ^= i
                 push(tmp,stk)
               delocal int tmp = 0
            fi b[i] = 2 || i = 2 * n 
      loop  i -= 1
      until i = 0
      local int tmp = 0
        pop(tmp,stk)
      delocal int tmp = 0
    delocal stack stk = nil
  delocal int i = 0

procedure main()
  int n
  int b[9]
  int l[9]
  int r[9]
  int p[9] // = 2*n+1

  n += 4
  // p[0] += 1
  // p[1] += 1
  // p[2] += 1
  // p[3] += 1
  // p[4] += 2
  // p[5] += 2
  // p[6] += 2
  // p[7] += 2

  p[0] += 1
  p[1] += 2
  p[2] += 1
  p[3] += 1
  p[4] += 1
  p[5] += 2
  p[6] += 2
  p[7] += 2

  call buildTree(p,b,l,r,n)