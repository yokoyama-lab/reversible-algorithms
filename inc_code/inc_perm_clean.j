//////////////////////////////////////////////////////////////////////
// Reversible Next Permutation WITHOUT garbage
//
// inc_perm.j logs the two pivot indices (i, j) on `glog`, claiming they
// are not recoverable from the successor permutation.  They are: the
// lexicographic successor is a bijection (on non-last permutations),
// and both indices can be re-found by a scan of the array they leave
// behind, so each is cleared by `uncall`ing a clean search.
//   * After the swap p[i] <=> p[j] (before the suffix reversal) the
//     suffix p[i+1..n-1] is still descending, p[j] holds the old p[i],
//     every p[k] with i < k < j is > the new p[i], and p[j] < p[i].
//     So j = smallest index > i with p[j] < p[i]   (find_less).
//   * After the suffix reversal the suffix is ascending and
//     p[i] > p[i+1] (p[i+1] is the minimum of a suffix containing the
//     old p[i] < new p[i]).  So i = largest index with p[i] > p[i+1]
//     (find_desc) -- the pivot of the PREVIOUS-permutation algorithm.
// Garbage: 0 words.  Time: two extra O(n) scans.
// Precondition: p is not the lexicographically last (descending)
// permutation.
//   forward: p -> next permutation of p
//   uncall : restores the previous permutation.
//////////////////////////////////////////////////////////////////////

// ii := largest index with p[ii] < p[ii+1]  (clean: no garbage)
procedure find_pivot(int p[], int n, int ii)
  local int k = n - 2
    from  k = n - 2
    loop  k -= 1
    until p[k] < p[k+1]
    ii ^= k
  delocal int k = ii

// jj := largest index > pivot i with p[jj] > p[i]  (clean)
procedure find_succ(int p[], int n, int i, int jj)
  local int k = n - 1
    from  k = n - 1
    loop  k -= 1
    until p[k] > p[i]
    jj ^= k
  delocal int k = jj

// jj := smallest index > i with p[jj] < p[i]  (clean)
procedure find_less(int p[], int n, int i, int jj)
  local int k = i + 1
    from  k = i + 1
    loop  k += 1
    until p[k] < p[i]
    jj ^= k
  delocal int k = jj

// ii := largest index with p[ii] > p[ii+1]  (clean)
procedure find_desc(int p[], int n, int ii)
  local int k = n - 2
    from  k = n - 2
    loop  k -= 1
    until p[k] > p[k+1]
    ii ^= k
  delocal int k = ii

procedure next_perm_clean(int p[], int n)
  local int i = 0
    call find_pivot(p,n,i)
    local int j = 0
      call find_succ(p,n,i,j)
      local int t = p[i] ^ p[j]     // p[i] <=> p[j] (indices differ)
        p[i] ^= t
        p[j] ^= t
      delocal int t = p[i] ^ p[j]
      uncall find_less(p,n,i,j)     // j re-found on the swapped array
    delocal int j = 0
    // reverse the suffix p[i+1 .. n-1]
    local int k = 0
      from  k = 0
      loop  local int t = p[i+1+k] ^ p[n-1-k]
              p[i+1+k] ^= t
              p[n-1-k] ^= t
            delocal int t = p[i+1+k] ^ p[n-1-k]
            k += 1
      until k = (n-1-i)/2
    delocal int k = (n-1-i)/2
    uncall find_desc(p,n,i)         // i re-found on the successor
  delocal int i = 0

procedure main()
  int d[8]
  int n

  n += 8
  d[0] += 6
  d[1] += 7
  d[2] += 3
  d[3] += 5
  d[4] += 4
  d[5] += 2
  d[6] += 1
  d[7] += 0

  call next_perm_clean(d,n)
  // successor of 6 7 3 5 4 2 1 0  is  6 7 4 0 1 2 3 5
