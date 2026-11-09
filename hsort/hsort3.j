//////////////////////////////////////////////////////////////////////
// percolating heapsort with optimal garbage
// Schellekens, M. P. (2010). "MOQA; unlocking the potential of compositional static average-case analysis." The Journal of Logic and Algebraic Programming 79(1): 61-83.
// Schellekens, M. (2008). A Modular Calculus for the Average Cost of Data Structuring. p.184
//////////////////////////////////////////////////////////////////////

// p.154
procedure maxHeapify(int a[], int i, int n, stack gb)
  // l = i*2, r = i*2+1
  local int largest = 0
  local int l = i*2
  local int r = i*2 + 1
    if l > n || (l <= n && a[l] <= a[i] && (r > n || (r <= n && a[r] <= a[i]))) then
      local int t = 0
        push(t,gb)
      delocal int t = 0
    else if a[l] > a[i] && (r > n || (r <= n && a[r] <= a[l])) then
        local int t = a[l] ^ a[i]
          a[i] ^= t
          a[l] ^= t
        delocal int t = a[l] ^ a[i]
        call maxHeapify(a,l,n,gb)
        local int t = 1
          push(t,gb)
        delocal int t = 0
      else
        local int t = a[r] ^ a[i]
          a[i] ^= t
          a[r] ^= t
        delocal int t = a[r] ^ a[i]
        call maxHeapify(a,r,n,gb)
        local int t = 2
          push(t,gb)
        delocal int t = 0
      fi top(gb) = 1
    fi top(gb) = 0
  delocal int r = i*2 + 1
  delocal int l = i*2
  delocal int largest = 0

// p.157
procedure buildMaxHeap(int a[], int n, stack gb)
  local int i = n / 2
    from  i = n / 2
    loop  call maxHeapify(a,i,n,gb)
          i -= 1
    until i = 0
  delocal int i = 0

// p.160
procedure heapsort(int a[], int n, stack gb)
  call buildMaxHeap(a,n,gb)
  local int i = n
    from  i = n
    loop  local int t = a[1] ^ a[i]  // a[1] <=> a[i]
            a[1] ^= t
            a[i] ^= t
          delocal int t = a[1] ^ a[i]
          i -= 1
          local int j = 1
            call maxHeapify(a,j,i,gb)
          delocal int j = 1
    until i = 1
  delocal int i = 1

procedure double(int x)
  local int t = (x * 2) ^ x
    x ^= t
  delocal int t = (x / 2) ^ x

procedure otimes(int a[], int n, stack gb)
  local int i = 1
    from  i = 1
    loop
          if a[2*i] >= a[2*i+1] then
            local int t = a[2*i] ^ a[i] // a[2*i] <=> a[i]
              a[2*i] ^= t
              a[i]   ^= t
            delocal int t = a[2*i] ^ a[i]
            call double(i)
            local int t = 0
              pop(t,gb)
              call double(t)
              push(t,gb)
            delocal int t = 0
          else
            local int t = a[2*i+1] ^ a[i] // a[2*i+1] <=> a[i]
              a[2*i+1] ^= t
              a[i]     ^= t
            delocal int t = a[2*i+1] ^ a[i]
            call double(i)
            i += 1
            local int t = 0
              pop(t,gb)
              call double(t)
              t += 1
              push(t,gb)
            delocal int t = 0
          fi top(gb) % 2 = 0
    until i >= n / 2 
    local int t = a[i] ^ a[n]
      a[i]  ^= t
      a[n] ^= t
    delocal int t = a[i] ^ a[n]
  delocal int i = top(gb)
  
procedure hsort_sub(int a[], int n, stack gb)
  call buildMaxHeap(a,n,gb)
  local int j = n
    from  j = n
    loop  local int t = 1
            push(t,gb)
          delocal int t = 0
          call otimes(a,j,gb)
          j -= 1
    until j = 2
  delocal int j = 2

// percolating heapsort
procedure hsort(int a[], int p[], int n, stack gb)
  call hsort_sub(a,n,gb)
  n += 1
  call id_perm(p,n)
  n -= 1
  uncall hsort_sub(p,n,gb)

procedure id_perm(int p[], int sz)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = sz
  delocal int i = sz

procedure main()
  int a[11]    // input array
  int n       // size of stk[]
  stack gb     // garbage stack
  // int ord[17]  // permutation
  int i
  int p[11] // permutation

  n += 10

  //////////////////////////////////
  // Testing maxHeapify

  // a[1] += 16
  // a[2] += 4
  // a[3] += 10
  // a[4] += 14
  // a[5] += 7
  // a[6] += 9
  // a[7] += 3
  // a[8] += 2
  // a[9] += 8
  // a[10] += 1

  // i += 2
  // call maxHeapify(a, i, n, gb)

  //////////////////////////////////
  // Testing buildMaxHeap

  // a[1] += 4
  // a[2] += 1
  // a[3] += 3
  // a[4] += 2
  // a[5] += 16
  // a[6] += 9
  // a[7] += 10
  // a[8] += 14
  // a[9] += 8
  // a[10] += 7

  // call buildMaxHeap(a,n,gb)

  //////////////////////////////////
  // Heapsort

  a[1] += 4
  a[2] += 1
  a[3] += 3
  a[4] += 2
  a[5] += 16
  a[6] += 9
  a[7] += 10
  a[8] += 14
  a[9] += 8
  a[10] += 7

  call hsort(a,p,n,gb)

  // a[1] += 2
  // a[2] += 4
  // a[3] += 3
  // a[4] += 1
  // a[5] += 7
  // a[6] += 8
  // a[7] += 9
  // a[8] += 10
  // a[9] += 14
  // a[10] += 16

  // i += 4

  // local int j = 1
  //   call maxHeapify(a,j,i,gb)
  // delocal int j = 1
