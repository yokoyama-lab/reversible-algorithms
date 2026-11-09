// checked on Oct. 17, 2014

procedure isort2(int a[], int n, int p[]) //\,\textcolor{blue}{\{ $p_k = k$ for all $k$ \}}\label{lst:isort1:invariant1}
  local int j = n-1
    from j = n-1
    loop  // insert $a_j$ into the ordered subarray \textcolor{blue}{a[j+1..n-1]}, \{ $p_k = k$ for any $k=0,\ldots,j$ \} \label{lst:isort1:invariant2}
      local int i = j
        from  i = j // @\label{lst:isort1:loop1}@
        loop  a[i] <=> a[i+1]
              p[i] <=> p[i+1]
              i += 1                  // \{ $p_i = j$ \}
        until i = n-1 || a[i] <= a[i+1] // \textcolor{blue}{\{ a[j..n-1] is ordered \}}\label{lst:isort1:short}
        // zero clear i        \hspace{1.58cm} // isort2 diff:
        from p[i]=j loop i-=1 until i=j
      delocal int i=j // \label{lst:isort1:delocal}
      j -= 1 // @\label{lst:isort1:jincremented}@
    until j = -1
  delocal int j = -1

// xor-copy to p the index of the minimum of ord[l..r]
procedure min(int p, int ord[], int l, int r)
  local stack gb = nil
    local int m = 0
      call min_sub(m,ord,l,r,gb)
      p ^= m
      uncall min_sub(m,ord,l,r,gb)
    delocal int m = 0
  delocal stack gb = nil

procedure min_sub(int m, int ord[], int l, int r, stack gb)
  m ^= l
  local int i = l + 1
    from  i = l + 1
    loop  if ord[i] <= ord[m] then
            push(m,gb)
            m ^= i
            push(1,gb)
          else
            push(0,gb)
          fi top(gb) = 1
          i += 1
    until i = r + 1
  delocal int i = r + 1

// Setting to p[] identity permutation of length n
procedure id_perm(int p[], int n)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure main()
  int a[6] = {2,5,4,0,3,1}   // input array
  int p[6]                   // permutation
  int n = 6                  // size of input array a[]
  // int i

  call id_perm(p,n)
  call isort2(a,n,p)

  // call max(i,3,a)