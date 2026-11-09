// find the previous element to one at position x in L[] and set its position to p
procedure search(int j, int p, int L[], stack gb)
  from  p = 0
  loop  local int t1 = L[p]
          p <=> t1
          push(t1,gb)
        delocal int t1 = 0
  until L[p] = j

procedure lisort(int a[], int L[], int n)
  L[0] ^= n                        // L1
  local int j = n - 1
    from  j = n - 1
    do    local int p = L[0], int q = 0, stack gb = nil      // L2
            from  empty(gb) // t = 0
            loop  push(q,gb)
                  q <=> p      // L4, zero clear p
                  p ^= L[q]
            until (a[j] <= a[p]) || (p = 0)  // L3
            L[q] ^= p          // zero clear L[q]
            L[q] ^= j          // L5
            L[j] <=> p         // zero clear p
            uncall search(j,q,L,gb) // zero clear gb and q, the previous element of j
          delocal int p = 0, int q = 0, stack gb = nil
          j -= 1
    until j = 0
  delocal int j = 0

procedure main()
  int a[7] = {0,2,5,4,0,3,1}   // input array
  int L[7]                     // pointers
  int n = 6                    // size of array a[]

  call lisort(a,L,n)
