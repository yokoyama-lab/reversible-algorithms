/*
 * 以下の卒論にあるプログラムをマクロを使って簡略化し、ゴミを大幅に減らしたバージョン
 *
 * Nøhr, S. V.: Reversible Graph Algorithms, Bachelor's thesis, Copenhagen University (2015).
 * The original program is available from https://github.com/Ekima/Reversible-Graph-Algorithms-Janus-
 * Original code (S. V. Nøhr, no license stated): https://github.com/Ekima/Reversible-Graph-Algorithms-Janus-/blob/89b96be6ee78a0be872c3f8505d20f38eb619477/heaps.janus
 * The parts taken from it are not covered by this repository's MIT license (see RIGHTS.md).
 * Tested on jana
 */

/* Minimum-priority queue heap implementation */

/*
 * insert inserts a new item into the minimum priority queue
 *
 * Parameters:
 * int A[]              A minimum heap array with an inconsistency at index i
 * int heapsize         The heaps current size
 * int key              The key value of the new item
 * int lastIndex        Initially, set to zero
 *
 * Postcondition:
 * The item has been inserted in the right place in the queue
 * keyは入力のA[i]にあった値に
 */
procedure insert(int A[], int heapsize, int key, int lastIndex)
    heapsize += 1
    // Call decreasekey on the last (and newly inserted) item in the queue
    call decreasekey(A, heapsize, key, lastIndex)

/*
 * decreasekey decreases the key of a node in the queue
 *
 * Parameters:
 * int A[]              A minimum heap array with an inconsistency at index i
 * int i                Index to the node which key should be decreased
 * int key              The new key value of the item
 * int j                Initially, set to zero
 *
 * Postcondition:
 * The minimum item of the minimum priority queue has been transferred to min
 * keyは入力のA[i]にあった値に
 * jは最後に処理をしたノードのindexに
 */
procedure decreasekey(int A[], int i, int key, int j)
    if key > A[i] then
        error("New key is bigger than current key")
    fi key > A[i]
    key <=> A[i]
    j ^= i
    local int parent = PARENT(j)
    from i = j loop
        A[j] <=> A[PARENT(j)]
        j ^= A[LEFT(parent)] < A[RIGHT(parent)] ? LEFT(parent) : RIGHT(parent)
        j <=> parent
        parent ^= PARENT(j)
    until j = 1 || A[parent] <= A[j] // 根に達するか、heap条件を満たすなら停止
    delocal int parent = PARENT(j)

/*
 * minimum the minimum value of a minimum list and copies its value to a
 * container
 *
 * Parameters:
 * int A[]          A minimum queue
 * int min          Container for the content of the minimum node. Must be 0.
 *
 * Postcondition:
 * min contains the content of the minimum node of the minimum queue A[]
 */
procedure minimum(int A[], int min)
    min += A[1]

/*
 * extractmin extracts the minimum item in a minimum priority queue, then
 * rearranges the underlying heap to ensure the minimum heap property.
 *
 * Parameters:
 * int A[]              A minimum heap array with an inconsistency at index i
 * int heapsize         The heaps current size
 * int min              A placeholder for the minimum item in the heap, initially zero
 * int j                Initially, set to zero
 *
 * Postcondition:
 * The minimum item of the minimum priority queue has been transferred to min
 * j is a path to the final position processed
 */
procedure extractmin(int A[], int heapsize, int min, int j)
    if heapsize < 1 then
        error("Heap underflow")
    fi heapsize < 1
    
    // Extract minimum element
    min <=> A[1]  // zero clear A[1]
    A[1] += MAX
    
    // Swap minimum element with the final element of the heap
    A[1] <=> A[heapsize]
    // Decrease size of heap
    heapsize -= 1
    // Call minheapify to preserve minimum heap property
    call minheapify(A, heapsize, 1, j)
    call path2index(j)

// path2index converts a path (a sequence of 0 or 1) to an index
procedure path2index(int x)
    local int path = x * 2 + 1 // xに最上位に1を追加するため、また停止性の判定のため
        x ^= path / 2 // zero clear x
        from x = 0 loop
            x ^= path % 2
            path ^= x % 2
            uncall double(path)
            call double(x)
        until path = 1 // pathの最上位の1を除去するため
    delocal int path = 1
    uncall double(x)

/*
 * minheapify ensure the minimum heap property of a tree, where both subtrees of
 * the node at index i has the minimum heap property, yet the node at index i
 * might be larger
 *
 * Parameters:
 * int A[]              A minimum heap array with an inconsistency at index i
 * int heapsize         The heaps current size
 * int i                An index for a node in the heap
 * int j                Initially, set to zero
 *
 * Postcondition:
 * A minimum heap which has no inconsistency at index i and its two subtrees
 * j は元のindex iにあった要素がどこにいったか(ゴミ)
 */
procedure minheapify(int A[], int heapsize, int i, int j)
    // Find the smallest note between i and the children of i
    if (RIGHT(i) <= heapsize && A[RIGHT(i)] < A[i] && A[RIGHT(i)] < A[LEFT(i)]) ||
       (LEFT(i) <= heapsize && A[LEFT(i)] < A[i]) then
        local int min = LEFT(i) <= heapsize && A[LEFT(i)] < A[i] ? LEFT(i) : RIGHT(i)
        A[i] <=> A[min]
        call minheapify(A, heapsize, min, j)
        call double(j)
        j ^= LEFT(i) = min ? 0 : 1 // set the lowest bit
        delocal int min = j % 2 = 0 ? LEFT(i) : RIGHT(i)
    else
        j ^= 1
    fi j != 1

procedure double(int x)
    local int tmp = x * 2
        tmp <=> x
    delocal int tmp = x / 2

procedure main()
    // Initial minimum heap.
    int A[] = {0, 1, 2, 3, 7, 4, 8, 9}
    
    int heapsize = size(A)-1
    // Heap garbage for each time we perform minheapify (used in extractmin).
    // The size can differ in accordance to the heap's size.
    int heapgarbage
    int heapgarbage1
    int heapgarbage2
    int heapgarbage3
    int heapgarbage4
    int heapgarbage5
    
    // Containers for the elements we extract, and insert.
    int min1 = 0
    int min2 = 0
    int min3 = 0
    int min4 = 0
    int min5 = 0
    int min6 = 0
    
    // Garbage for each time we perform decreasekey (used in insert).
    int lastIndex = 0
    int lastIndex1 = 0
    int lastIndex2 = 0
    int lastIndex3 = 0
    int lastIndex4 = 0
    
    call extractmin(A, heapsize, min1, heapgarbage)
    call extractmin(A, heapsize, min2, heapgarbage1)
    call extractmin(A, heapsize, min3, heapgarbage2)
    call extractmin(A, heapsize, min4, heapgarbage3)
    call extractmin(A, heapsize, min5, heapgarbage4)
    call extractmin(A, heapsize, min6, heapgarbage5)
    
    call insert(A, heapsize, min3, lastIndex)
    call insert(A, heapsize, min2, lastIndex1)
    call insert(A, heapsize, min5, lastIndex2)
    call insert(A, heapsize, min4, lastIndex3)
    call insert(A, heapsize, min1, lastIndex4)
