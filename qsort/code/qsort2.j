// in-place quick sort

procedure partition2(int a[], int l, int r, int p, int ord[])
  local int j = l
    from  j = l
    loop  if a[j] <= a[r] then
            p += 1
            local int k = p  // slide a[p..j-1] to the right by one, and move a[j] to position p
              from  k = p
              loop  a[k] <=> a[j]
                    ord[k] <=> ord[j]
                    k += 1
              until k = j
            delocal int k = j  
          fi (p >= l) && (ord[p] >= ord[j])
          j += 1
    until j = r + 1
  delocal int j = r + 1

// xor-copy to p the index of the maximum of ord[l..r]
procedure max(int p, int ord[], int l, int r)
  local stack gb = nil
    local int m = 0
      call max_sub(m,ord,l,r,gb)
      p ^= m
      uncall max_sub(m,ord,l,r,gb)
    delocal int m = 0
  delocal stack gb = nil

procedure max_sub(int m, int ord[], int l, int r, stack gb)
  m ^= l
  local int i = l + 1
    from  i = l + 1
    loop  if ord[i] >= ord[m] then
            push(m,gb)
            m ^= i
            local int pushtmp = 1
              push(pushtmp, gb)
            delocal int pushtmp = 0
          else
            local int pushtmp = 0
              push(pushtmp, gb)
            delocal int pushtmp = 0
          fi top(gb) = 1
          i += 1
    until i = r + 1
  delocal int i = r + 1

procedure qsort2(int a[], int l, int r, int p[])
  if l < r then
    local int q = l - 1     // q remembers where to divide
      call partition2(a,l,r,q,p)
      call qsort2(a,l,q-1,p)
      call qsort2(a,q+1,r,p)
      call max(q,p,l,r)     // zero clear q
    delocal int q = 0
  fi l < r

// Setting to p[] identity permutation of length n
procedure id_perm(int p[], int n)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure main()
  int a[8] = {2,8,7,1,3,5,6,4}   // input array
  int p[8]    // permutation

  call id_perm(p,8)

  call qsort2(a,0,7,p)
