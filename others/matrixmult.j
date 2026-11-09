n       // Width and height of matrices .
A[9]   // Matrix A.
B[9]   // Matrix B.
LU[9]  // Lower and upper triangle .
pi[3]  // Permutation .
t m1 m2 // Temporary variables .
i j k   // Induction variables .
bigk    // LUP scaling coefficient .
i1
i2[3]
p[3]
p2[9]
km[3] km2[9]
t2[3]

// Debug variables
i3[3]
i4[3] i5[9]
i6[3]
i7[3] i8[9]

// Initialize A and B and call matrixMult .
// Expected output :
// A = {16 , 10 , 14 , 26 , 9, 22 , 30 , 10 , 23}
// B = {3 , 1, 4, 2, 2, 3, 4, 1, 1}
// All other variables = 0
procedure main
	n ^= 3
	A[ 0] ^= 0 A[ 1] ^= 4 A[ 2] ^= 2
	A[ 3] ^= 4 A[ 4] ^= 1 A[ 5] ^= 3
	A[ 6] ^= 4 A[ 7] ^= 1 A[ 8] ^= 4
	B[ 0] ^= 3 B[ 1] ^= 1 B[ 2] ^= 4
	B[ 3] ^= 2 B[ 4] ^= 2 B[ 5] ^= 3
	B[ 6] ^= 4 B[ 7] ^= 1 B[ 8] ^= 1
	call multMatrix

// Computes A*=B where A and B are matrices .
// Input : A and B.
// Output : AB ( stored in A) and B.
procedure multMatrix
	call LUP
	call permute
	call multLower
	call multUpper
	call unscale
	uncall LUP

// Computes m1 *= m2 where m1 and m2 are scalars .
// Input m1 and m2 .
// Output m1 *m2 ( stored in m1) and m2 .
procedure multScalar
	t += m1
	m1 += t*m2 -t
	t -= m1/m2

procedure LUP
	bigk ^= 1
	from k = 0
	do

		i2[k] += k
		from i2[k] = k
		do
			p2[n*k+i2[k]] -= 1
			if B[i2[k]*n+k] > p[k] || -B[i2[k]*n+k] > p[k]
			then
				if B[i2[k]*n+k] > 0
				then
					p2[n*k+i2[k]] += B[i2[k]*n+k ]+1
				else
					p2[n*k+i2[k]] += 1-B[i2[k]*n+k]
				fi B[i2[k]*n+k] > 0
				p[k] <=> p2[n*k+i2[k]]
				km2 [i2[k]*n+k] += i2[k]
				km[k] <=> km2 [i2[k]*n+k]
			fi (B[i2[k]*n+k] >= p[k] || -B[i2[k]*n+k] >= p[k]) && p2[n*k+i2[k]] >= 0
			i2[k] += 1
		loop
		until i2[k] = n

		pi[k] += km[k]

		from i3[k] = 0
		do
			B[k*n+i3[k]] <=> B[km[k]*n+i3[k]]
			i3[k] += 1
		loop
		until i3[k] = n

		t += bigk
		bigk += t*B[k*n+k]-t
		if bigk < 0
		then
			if B[k*n+k] < 0
			then t -= (- bigk )/( -B[k*n+k])
			else t -= -((- bigk )/B[k*n+k])
			fi B[k*n+k] < 0
		else
			if B[k*n+k] < 0
			then t -= -( bigk /(-B[k*n+k ]))
			else t -= bigk /(B[k*n+k])
			fi B[k*n+k] < 0
		fi bigk < 0
		
		t2[k] += B[k*n+k]
		
		from i4[k] = 0
		do
			from i5[n*k+i4[k]] = 0
			do
				t += B[i4[k]*n+i5[n*k+i4[k ]]]
				B[i4[k]*n+i5[n*k+i4[k ]]] += t*t2[k]-t
				if B[i4[k]*n+i5[n*k+i4[k ]]] < 0
				then
					if t2[k] < 0
					then t -= (-B[i4[k]*n+i5[n*k+i4[k ]]])/( - t2[k])
					else t -= -((-B[i4[k]*n+i5[n*k+i4[k ]]])/ t2[k])
					fi t2[k] < 0
				else
					if t2[k] < 0
					then t -= -(B[i4[k]*n+i5[n*k+i4[k]]]/( - t2[k ]))
					else t -= B[i4[k]*n+i5[n*k+i4[k ]]]/( t2[k])
					fi t2[k] < 0
				fi B[i4[k]*n+i5[n*k+i4[k ]]] < 0
				i5[n*k+i4[k]] += 1
			loop
			until i5[n*k+i4[k]] = n
			i4[k] += 1
		loop
		until i4[k] = n

		i6[k] += k+1
		from i6[k] = k+1
		do
		loop
			t += B[i6[k]*n+k]
			if t < 0
			then
				if t2[k] < 0
				then B[i6[k]*n+k] += (-t)/( - t2[k])-t
				else B[i6[k]*n+k] += -((-t)/ t2[k])-t
				fi t2[k] < 0
			else
				if t2[k] < 0
				then B[i6[k]*n+k] += -(t/(- t2[k])) -t
				else B[i6[k]*n+k] += t/( t2[k])-t
				fi t2[k] < 0
			fi t < 0
			t -= B[i6[k]*n+k]* t2[k]
			t += B[i6[k]*n+k]
			B[i6[k]*n+k] += t* bigk /t2[k]-t
			t -= B[i6[k]*n+k]* t2[k]/ bigk
			i6[k] += 1
		until i6[k] = n

		i7[k] += k+1

		from i7[k] = k+1
		do
		loop
			i8[k*n+i7[k]] += k+1
			from i8[k*n+i7[k]] = k+1
			do
			loop
				t <=> B[i7[k]*n+i8[k*n+i7[k ]]]
				t -= B[k*n+i8[k*n+i7[k ]]]* B[i7[k]*n+k]/ bigk
				t <=> B[i7[k]*n+i8[k*n+i7[k ]]]
				i8[k*n+i7[k]] += 1
			until i8[k*n+i7[k]] = n
			i7[k] += 1
		until i7[k] = n
		k += 1
	loop
	until k = n -1
	k -= n -1

	// Updates matrix A by multiplying with the lower triangle stored in
// matrix LU.
// Input : A and LU .
// Output : AL ( stored in A) and LU.
procedure multLower
	from i=0 do
		from j=0 do
			if j<n -1 then
				k += j+1
				from k=j+1 do
				// a_ij += a_ik * l_kj
					t += A[i*n+k]
					A[i*n+j] += t * LU[k*n+j]
					t -= A[i*n+k]
					k +=1
				until k=n 
				k -=n
			fi j<n -1
			j +=1
			until j=n 
			j -=n
		i +=1
	until i=n i -=n

// Updates matrix A by multiplying with the upper triangle stored in
// matrix LU.
// Input : A and LU .
// Output : AU ( stored in A) and LU.
procedure multUpper
	from i=0 do
		j += n
		from j=n do
			j -= 1
			// a_ij *= u_jj
			m1 <=> A[i*n+j] 
			m2 <=> LU[j*n+j]
			call multScalar
			m1 <=> A[i*n+j] 
			m2 <=> LU[j*n+j]
			if j >0 then
				from k=0 do
					// a_ij += a_ik u_kj
					t += A[i*n+k]
					A[i*n+j] += t * LU[k*n+j]
					t -= A[i*n+k]
					k += 1
				until k=j k -=j
			fi j >0
		until j=0
		i +=1
	until i=n i -=n

// Permutates A given a series of swaps defined in pi.
// Input : A and pi .
// Output : AP ( stored in A) and pi.
procedure permute
	from i=0 do
		j += n -1
		from j=n -1 do
			j -= 1
			A[i*n+j] <=> A[i*n+pi[j]]
		until j=0
		i += 1
	until i=n i -=n

