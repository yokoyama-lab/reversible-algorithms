// mergesort using internally optimal garbage with optimal garbage
// Sedgewick, R. and P. Flajolet (2013).
// An introduction to the analysis of algorithms, 2nd ed.,
// Addison-Wesley Longman Publishing Co., Inc. p.8

procedure merge(int a[], int l, int m, int r, int p[])
  local int b[r+1]={0}, int c[r+1]={0}, int p_b[r+1]={0}, int p_c[r+1]={0} // @\label{lst:merge:local}@
    local int k = l
      from  k = l // @\label{lst:merge:fstloopbegin}@
      loop  b[k-l] <=> a[k]
            p_b[k-l] <=> p[k]
            k += 1
      until k = m + 1 // @\label{lst:merge:fstloopend}@
      from  k = m + 1 // @\label{lst:merge:sndloopbegin}@
      loop  c[k-m-1] <=> a[k]
            p_c[k-m-1] <=> p[k]
            k += 1
      until k = r + 1 // @\label{lst:merge:sndloopend}@
    delocal int k = r + 1

    b[m-l+1] ^= 999
    c[r-m] ^= 999 // set sentinel \label{lst:merge:setsentinel}

    local int i = 0, int j = 0, int k = l
      from  k = l // @\label{lst:merge:mainloopbegin}@
      loop  if c[j] < b[i] then
              a[k] <=> c[j]
              p[k] <=> p_c[j]
              j += 1
            else
              a[k] <=> b[i]
              p[k] <=> p_b[i]
              i += 1
            fi p[k] > m // @\label{lst:merge:middle}@
            k += 1
      until k = r + 1 // @\label{lst:merge:mainloopend}@
    delocal int i = m-l+1, int j = r-m, int k = r+1
    
    b[m-l+1] ^= 999
    c[r-m] ^= 999  // zero clear sentinel \label{lst:merge:clearsentinel}
  delocal int b[r+1]={0}, int c[r+1]={0}, int p_b[r+1]={0}, int p_c[r+1]={0} // @\label{lst:merge:delocal}@


// procedure merge(int a[], int l, int m, int r, int p[])
//   local int b[r+1] = {0}, int c[r+1] = {0}, int p_b[r+1] = {0}, int p_c[r+1] = {0}
//     local int k = l
//       from  k = l
//       loop  b[k-l] <=> a[k]
//             p_b[k-l] <=> p[k]
//             k += 1
//       until k = m + 1
    
//       from  k = m + 1
//       do    c[k-m-1] <=> a[k]
//             p_c[k-m-1] <=> p[k]
//       loop  k += 1
//       until k = r
//     delocal int k = r
  
//     b[m-l+1] ^= 999  // set sentinel
//     c[r-m]   ^= 999  // set sentinel
  
//     local int k = l
//       local int i = 0
//         local int j = 0
//           from  k = l
//           do    if c[j] < b[i] then
//                   a[k] <=> c[j]
//                   p[k] <=> p_c[j]
//                   j += 1
//                 else
//                   a[k] <=> b[i]
//                   p[k] <=> p_b[i]
//                   i += 1
//                 fi p[k] > m
//           loop  k += 1
//           until k = r
//         delocal int j = r - m
//       delocal int i = m - l + 1
//     delocal int k = r

//     b[m-l+1] ^= 999  // zero clear sentinel
//     c[r-m]   ^= 999  // zero clear sentinel
//   delocal int b[r+1] = {0}, int c[r+1] = {0}, int p_b[r+1] = {0}, int p_c[r+1] = {0}

procedure msort_sub(int a[], int l, int r, int p[])
  if l < r then
    call msort_sub(a,l,(l+r)/2,p)
    call msort_sub(a,(l+r)/2+1,r,p)
    call merge(a,l,(l+r)/2,r,p)
  fi l < r

procedure msort(int a[], int n, int p[])
  call msort_sub(a,0,n-1,p)

procedure main()
  int a[8] = {50,20,40,70,10,30,20,60}    // input array, p.35
  int p[8] = {0,1,2,3,4,5,6,7}          // order
  int n = 8

  call msort(a,n,p)
