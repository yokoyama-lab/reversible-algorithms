//////////////////////////////////////////////////////////////////////
// Reversible Extended Euclidean Algorithm WITHOUT a quotient log
//
// Same iteration as ext_gcd.j, but the quotient q of each step is
// NOT pushed on a stack: it is recomputed from the Bezout cofactors
// after the step, so `delocal` can clear it.  With
//   s_k = |x_k| + |y_k|   (cofactors of the k-th remainder)
// the recurrence s_{k+1} = s_{k-1} + q_k * s_k holds (signs of the
// cofactors alternate), s_k >= 1, and s is non-decreasing, hence
//   q_k = (s_{k+1} - 1) / s_k .
// After the step, (x0,y0) hold (x_k,y_k) and (x1,y1) hold
// (x_{k+1},y_{k+1}), which is exactly what the delocal reads.
// The entry assertion x1 = 0 holds only on entry (x_1 = 0, and
// |x_k| >= 1 for every k >= 2).
// Precondition: a >= 1, b >= 1.
//   forward: (a,b, x0=1,x1=0,y0=0,y1=1) -> (g, 0, x0,x1,y0,y1)
//            with x0*A + y0*B = g,  |x1|*g = B,  |y1|*g = A
//   uncall : restores the original state.  No stack is used.
//////////////////////////////////////////////////////////////////////

procedure ext_gcd_clean(int a, int b, int x0, int x1, int y0, int y1)
  from  x1 = 0                   // true only on entry
  loop  local int q = a / b
          a -= q * b             // a := a mod b
          a <=> b                // (a,b) := (b, a mod b)
          x0 -= q * x1
          x0 <=> x1
          y0 -= q * y1
          y0 <=> y1
        delocal int q = (x1 * (1 - 2*(x1 < 0)) + y1 * (1 - 2*(y1 < 0)) - 1)
                        / (x0 * (1 - 2*(x0 < 0)) + y0 * (1 - 2*(y0 < 0)))
  until b = 0

procedure main()
  int a
  int b
  int x0
  int x1
  int y0
  int y1

  a += 240
  b += 46
  x0 += 1        // (x0,x1,y0,y1) = (1,0,0,1)
  y1 += 1

  call ext_gcd_clean(a,b,x0,x1,y0,y1)
  // gcd(240,46) = 2;  x0*240 + y0*46 = 2  (x0=-9, y0=47);  x1=23, y1=-120
