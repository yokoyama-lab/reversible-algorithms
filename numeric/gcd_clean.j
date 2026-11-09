//////////////////////////////////////////////////////////////////////
// Reversible GCD (subtractive Euclid) WITHOUT a step log
//
// gcd.j pushes one bit per subtraction step (which of a,b was larger),
// so its log grows with the NUMBER of steps (up to ~max(a,b) bits).
// Here the step direction is instead folded into a 2x2 matrix
//   M = [[m11,m12],[m21,m22]]   with invariant  (A,B)^T = M (a,b)^T
// (A,B the original inputs, M = I on entry):
//   a -= b   is   M := M [[1,1],[0,1]]   (m12 += m11; m22 += m21)
//   b -= a   is   M := M [[1,0],[1,1]]   (m11 += m12; m21 += m22)
// After the first kind the second column sum exceeds the first, after
// the second kind the first exceeds the second (M has non-negative
// entries and no zero column), so the column sums serve as the branch
// exit assertion -- the direction is recoverable without a log.
// The entry assertion m12 + m21 = 0 holds only on entry.
// Garbage is M plus the copy b = a: O(log max(A,B)) bits instead of
// one bit per step.  m11+m12 = A/g and m21+m22 = B/g on exit.
// Precondition: a,b > 0.
//   forward: (a,b, M=I) -> (a=b=gcd(a,b), M)
//   uncall : restores the original (a,b) and M = I.
//////////////////////////////////////////////////////////////////////

procedure gcd_clean(int a, int b, int m11, int m12, int m21, int m22)
  from  m12 + m21 = 0           // M = I only on entry
  loop  if a > b then
          a -= b
          m12 += m11
          m22 += m21
        else
          b -= a
          m11 += m12
          m21 += m22
        fi m12 + m22 > m11 + m21
  until a = b

procedure main()
  int a
  int b
  int m11
  int m12
  int m21
  int m22

  a += 48
  b += 36
  m11 += 1
  m22 += 1
  call gcd_clean(a,b,m11,m12,m21,m22)
  // gcd(48,36) = 12  ->  a = b = 12;  m11+m12 = 4, m21+m22 = 3
