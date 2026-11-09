/*
 * Guo, L., Peng, C. and He, C.: New Reversible Computing Algorithms for Shortest Paths Problem, Proc. the 6th International Conference on Information Technology: IoT and Smart City, pp.82–87, ACM Press (2018). https://doi.org/10.1145/3301551.3301605
 * pp.83-84
 * Built on the heap code (S. V. Nøhr, no license stated): https://github.com/Ekima/Reversible-Graph-Algorithms-Janus-/blob/89b96be6ee78a0be872c3f8505d20f38eb619477/heaps.janus
 * The parts taken from it are not covered by this repository's MIT license (see RIGHTS.md).
*/

/*
 * minheapify ensure the minimum heap property of a tree, where both subtrees of
 * the node at index i has the minimum heap property, yet the node at index i
 * might be larger
 *
 * Parameters:
 * int A[]              A minimum heap array with an inconsistency at index i
 * int heapsize         The heaps current size
 * int i                An index for a node in the heap
 * int lastindex        Initially, set to zero
 * int pow              Initially, set to one
 *
 * Postcondition:
 * A minimum heap which has no inconsistency at index i and its two subtrees
 */
procedure minheapify(int A[], int heapsize, int i, int lastindex, int pow)
    local int left = 0, int right = 0, int min = 0
    call left(i, left)
    call right(i, right)

    //Find the smallest note between i and the children of i
    if left <= heapsize && A[left] < A[i] then
        min += left
        if right <= heapsize && A[right] < A[min] then
            min -= left
            min += right
        fi right <= heapsize && A[right] < A[left]
    else
        min += i
        if right <= heapsize && A[right] < A[min] then
            min -= i
            min += right
        fi right <= heapsize && A[right] < A[i]
    fi left <= heapsize && A[left] < A[i]
    //if i isn't the smallest element, switch and call minheapify
    if min != i then
        A[i] <=> A[min]
        call minheapify(A, heapsize, min, lastindex,pow)
    else
        lastindex += min
    fi min != i
    //set the current min to 0
    if min != i then
        if lastindex / 2 = i && lastindex % 2 = 1 then
            min -= 1
        fi lastindex / 2 = i && lastindex % 2 = 1
        if lastindex % 2 = 0 then
            min -= lastindex / pow
        else
            min -= (lastindex-1) / pow
        fi lastindex % 2 = 0
        local int tmp = pow * 2
            tmp <=> pow
        delocal int tmp = pow / 2
    fi min = 0
    if i = lastindex then
        min -= lastindex
    fi i = lastindex
    uncall right(i, right)
    uncall left(i, left)
    delocal int left = 0, int right = 0, int min = 0

/*
 * parent finds the index of the parent of the node at index i
 *
 * Parameters:
 * int i            Node index
 * int parent       Container for the index of the parent node. Must be 0.
 *
 * Postcondition:
 * parent contains an index to the parent node of node #i
 */
procedure parent(int i, int parent)
    parent += i / 2

/*
 * left finds the index of the left child of the node at index i
 *
 * Parameters:
 * int i            Node index
 * int left        Container for the index of the child node. Must be 0.
 *
 * Postcondition:
 * left contains an index to the left child node of node #i
 */
procedure left(int i, int left)
    left += 2 * i

/*
 * right finds the index of the right child of the node at index i
 *
 * Parameters:
 * int i            Node index
 * int right        Container for the index of the child node. Must be 0.
 *
 * Postcondition:
 * right contains an index to the right child node of node #i
 */
procedure right(int i, int right)
    right += 2 * i + 1

/*
 * decreasekey decreases the key of a node in the queue
 *
 * Parameters:
 * int A[]              A minimum heap array with an inconsistency at index i
 * int i                Index to the node which key should be decreased
 * int key              The new key value of the item
 * int last_index       Initially, set to zero
 * int pow              Initially, set to one
 * int min              Initially, set to zero
 *
 * Postcondition:
 * The minimum item of the minimum priority queue has been transferred to min
 */
procedure decreasekey(int A[], int i, int key, int last_index, int pow, int differ)
    local int tmp = i
    differ += A[i] - key
    A[i] -= differ //subtract the difference from current key
    local int loopcond = 1
    from loopcond = 1 && pow = 1 do
show(last_index, pow, differ)
        local int parent = 0
        call parent(tmp, parent)
        //check whether the node is larger than its parent node
        if tmp <= 1 || A[parent] <= A[tmp] then
            loopcond -= 1 //exit the loop using the loop condition
        else //if not, swap the two nodes and continue
            A[tmp] <=> A[parent]
            tmp -= last_index / pow
            tmp += parent
        fi loopcond = 0
        uncall parent(last_index/pow, parent)
        local int temp = pow
        pow += temp
        delocal int temp = pow / 2
        delocal int parent = 0
    until loopcond = 0
    delocal int loopcond = 0
    delocal int tmp = last_index/(pow/2)

procedure main()
    // Initial minimum heap.
    // int A[] = {0, 1, 2, 3, 7, 4, 8, 9}
    // int A[] = {0, 2, 5, 6, 7, 8, 9}  // Figure 3
    // int A[] = {0, 7, 2, 6, 5, 8, 9}  // Figure 4(a)
    // int heapsize = size(A)-2
    // int i = 1
    // int lastindex
    // int pow = 1

    // call minheapify(A, heapsize, i, lastindex, pow)

    // Initial minimum heap.
    int A[] = {0, 2, 5, 6, 7, 8, 9}  // Figure 3, Figure 6(a)
    int last_index = 4
    int pow = 1
    int differ = 0
    int i = 4
    int key = 1

    call decreasekey(A, i, key, last_index, pow, differ)
