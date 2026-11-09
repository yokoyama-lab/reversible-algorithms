//////////////////////////////////////////////////////////////////////
// selection sort with optimal garbage (linear size)
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.29 Exercise 2.2-2
//////////////////////////////////////////////////////////////////////

// set the maximum of a[j..n-1] to p
procedure max(int p, int j, int a[], int n)
  local stack gb = nil
    call max_sub(p,j,a,n,gb)
    local int pp = p
      uncall max_sub(pp,j,a,n,gb)
    delocal int pp = 0
  delocal stack gb = nil

procedure max_sub(int p, int j, int a[], int n, stack gb)
  p ^= j
  j += 1
  from  empty(gb)
  loop  if a[p] > a[j] then
          push(p,gb)
          p ^= j
          local int pushtmp = 1
            push(pushtmp, gb)
          delocal int pushtmp = 0
        else
          local int pushtmp = 0
            push(pushtmp, gb)
          delocal int pushtmp = 0
        fi top(gb) = 1
        j += 1
  until j=n

procedure ssort_sub(int a[], int n, int d[])
  local int i = 0
    from  i = 0
    loop  local int j = i
            local int p = 0
              call max(p,j,a,n)
              if j != p then
                a[j] <=> a[p]
              fi j != p
              d[j] ^= p - i
            delocal int p = d[j] + i
          delocal int j = i
          i += 1
    until i = n
  delocal int i = n

procedure id_perm(int p[], int n)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = n
  delocal int i = n

procedure ssort(int a[], int n, int d[], int p[])
  call ssort_sub(a,n,d)
  // call id_perm(p,n)
  // uncall ssort_sub(p,n,d)

procedure main()
  int a[6] = {50,20,40,60,10,30}    // input array
  int n = 6                         // size of stk[]
  int d[6]                          // factorial representation
  int p[6]                          // permutation

  call ssort(a,n,d,p)
