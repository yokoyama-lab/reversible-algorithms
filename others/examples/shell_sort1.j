//////////////////////////////////////////////////////////////////////
// Sedgewick, R. (1997). Algorithms in C: Parts 1-4, Fundamentals, Data Structures, Sorting, and Searching, Addison-Wesley Longman Publishing Co., Inc.
// p.275
//
// Shellsort with garbage
//
// PRECONDITIONS:
//  * sz >= 9 (array length >= 10): the gap-descent loop's re-entry
//    assertion `h > sz/9` requires the final gap h=1 to satisfy 1 <= sz/9.
//  * all elements > 0: the inner insertion loop uses the zero-cleared
//    cell a[i] as its own guard (`from a[i] = 0`), so a genuine 0 value
//    shifting into a[i] breaks the re-entry assertion.
//////////////////////////////////////////////////////////////////////

procedure shell_sort(int a[], int sz, stack gb)
  local int h = 1
  from  h = 1
  do    local int t = h * 3 + 1
          t <=> h
        delocal int t = h / 3
  until h > sz / 9

  from  h > sz / 9
  loop  local int t = h / 3
          t <=> h
        delocal int t = h * 3 + 1
        local int i = h
          from  i = h
          loop  local int j = i
                  local int v = 0
                    v ^= a[i]
                    a[i] ^= v  // zero clear
                    from  a[i] = 0
                    loop  a[j] ^= a[j-h]
                          a[j-h] ^= a[j] // zero clear
                          j -= h
                    until j < h || v > a[j-h]
                    a[j] ^= v
                  delocal int v = a[j]
                  push(j,gb)
                delocal int j = 0
                i += 1
          until i > sz
          push(i,gb)
        delocal int i = 0
  until h = 1

  delocal int h = 1

procedure main()
  int a[10]
  int ord[10]
  int sz
  stack gb

  sz ^= 9

  a[0] += 2
  a[1] += 8
  a[2] += 7
  a[3] += 1
  a[4] += 3
  a[5] += 5
  a[6] += 6
  a[7] += 4
  a[8] += 0
  a[9] += 9

  call shell_sort(a,sz,gb)

  ord[0] += 0
  ord[1] += 1
  ord[2] += 2
  ord[3] += 3
  ord[4] += 4
  ord[5] += 5
  ord[6] += 6
  ord[7] += 7
  ord[8] += 8
  ord[9] += 9

  uncall shell_sort(ord,sz,gb)