//////////////////////////////////////////////////////////////////////
// heapsort with optimal garbage
// Cormen, T. H., et al. (2009). Introduction to Algorithms third edition, The MIT Press. p.154-
//////////////////////////////////////////////////////////////////////

// p.154
procedure maxHeapify(int a[], int i, int n, stack gb)
  local int largest = 0
    local int l = i*2
      local int r = i*2 + 1
        if l > n || a[l] <= a[i] && (r > n || a[r] <= a[i]) then
          local int pushtmp = 0
            push(pushtmp, gb)
          delocal int pushtmp = 0
        else if a[l] > a[i] && (r > n || a[r] <= a[l]) then
            a[l] <=> a[i]
            call maxHeapify(a,l,n,gb)
            local int pushtmp = 1
              push(pushtmp, gb)
            delocal int pushtmp = 0
          else
            a[r] <=> a[i]
            call maxHeapify(a,r,n,gb)
            local int pushtmp = 2
              push(pushtmp, gb)
            delocal int pushtmp = 0
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
procedure hsort_sub(int a[], int n, stack gb)
  call buildMaxHeap(a,n,gb)
  local int i = n
    from  i = n
    loop  a[1] <=> a[i]
          i -= 1
          call maxHeapify(a,1,i,gb)
    until i = 1
  delocal int i = 1

procedure hsort1(int a[], int p[], int n)
  local stack gb = nil  // garbage stack
    call hsort_sub(a,n,gb)
    call id_perm(p,n+1)
    uncall hsort_sub(p,n,gb)
  delocal stack gb = nil

procedure id_perm(int p[], int sz)
  local int i = 0
    from  i = 0
    loop  p[i] ^= i
          i += 1
    until i = sz
  delocal int i = sz

procedure main()
  int a[11]  // input array
  int n      // size of stk[]
  int p[11]  // permutation

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

  call hsort1(a,p,n)

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
