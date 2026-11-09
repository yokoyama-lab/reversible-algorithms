procedure partition1(int a[], int l, int r, int q, int p[])
  local int t[r-l] = {0}, int ord_t[r-l] = {0}
    q ^= l - 1
    local int j = l
      from  j = l
      loop  if a[j] <= a[r] then
              q += 1
              if q != j then
                a[q] <=> a[j]       // move a[j] to a[q]
                p[q] <=> p[j]       // move p[j] to p[q]
              fi q != j
            else
              t[j-q-1] <=> a[j]     // move a[j] to t[j-q-1]
              ord_t[j-q-1] <=> p[j] // move p[j] to ord_t[j-q-1]
            fi (q >= l) && (j-q-1 = -1 || p[q] > ord_t[j-q-1])
            j += 1
      until j = r + 1
    delocal int j = r + 1

    local int k = 0                 // move t[0..r-q] to a[q+1..r]
      from  k = 0
      loop  a[q+1+k] <=> t[k]       // move t[k] to a[q+1+k]
            p[q+1+k] <=> ord_t[k]   // move ord_t[k] to p[q+1+k]
          k += 1
      until k = r - q
    delocal int k = r - q
  delocal int t[r-l] = {0}, int ord_t[r-l] = {0}

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

procedure qsort1(int a[], int l, int r, int ord[])
  if l < r then
    local int q = 0           // q remembers where to divide
      call partition1(a,l,r,q,ord)
      call qsort1(a,l,q-1,ord)
      call qsort1(a,q+1,r,ord)
      uncall max(q,ord,l,r)   // zero clear q
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
  int a[8] = {2,8,7,1,3,5,6,4}     // input array
  int p[8]                         // permutation

  call id_perm(p,8)

  call qsort1(a,0,7,p)
//  uncall qsort1(p,0,7,a)

