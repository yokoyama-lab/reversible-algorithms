//////////////////////////////////////////////////////////////////////
// reversible queue
//////////////////////////////////////////////////////////////////////

// Allocate a new node to cell
procedure allocate_object_queue(int qelem[], int qflp, int newp)
  newp ^= qelem[qflp] + qflp
  qelem[qflp] ^= newp - qflp
  newp <=> qflp
  qflp += 3

// push_sub is shared by push_front and push_back
procedure push_sub(int qelem[], int head, int tail, int next, int prev, int qflp, int val)
  if true then
    local int newp = 0
      call allocate_object_queue(qelem, qflp, newp)
      if head != 0 then		//if stack is not empty
        qelem[head+next] ^= newp
        local int tmp = head
          head ^= tmp		// 0 clear
          head ^= qelem[newp+prev]
          qelem[newp+prev] ^= head    // 0 clear
          qelem[newp+prev] ^= tmp
        delocal int tmp = qelem[newp+prev]
      else
        tail ^= newp
      fi qelem[newp+prev] != 0
      local int tmp = val
        val ^= tmp		// 0 clear
        val ^= qelem[newp]
        qelem[newp] ^= val	// 0 clear
        qelem[newp] ^= tmp
      delocal int tmp = qelem[newp]
      head <=> newp
    delocal int newp = 0
  fi head != 0

procedure push_front(int qelem[], int head, int tail, int qflp, int val)
  local int next = 2
    local int prev = 1
      call push_sub(qelem, head, tail, next, prev, qflp, val)
    delocal int prev = 1
  delocal int next = 2

procedure push_back(int qelem[], int head, int tail, int qflp, int val)
  local int next = 1
    local int prev = 2
      call push_sub(qelem, tail, head, next, prev, qflp, val)
    delocal int prev = 2
  delocal int next = 1

procedure pop_front(int qelem[], int head, int tail, int qflp, int val)
  uncall push_front(qelem, head, tail, qflp, val)

procedure pop_back(int qelem[], int head, int tail, int qflp, int val)
  uncall push_back(qelem, head, tail, qflp, val)

//////////////////////////////////////////////////////////////////////
// Tree manipulation
//////////////////////////////////////////////////////////////////////

// Assign a new node to "cell"
procedure allocate_object(int elem[], int next[], int flp, int hp, int cell)
  if flp = 0 then
    cell ^= hp
    hp += 1
  else
    local int tmp = next[flp]
      next[flp] ^= tmp
      cell <=> tmp
      next[flp] ^= tmp
    delocal int tmp = next[flp]
    cell <=> flp
  fi flp = 0 && cell = hp - 1


procedure move_next(int elem[], int prev[], int next[], int p)
  // print("BBB")
  // show(elem,prev,next,p)
  local int tmp = next[p]
    p ^= prev[tmp] 	// 0 clear
    p <=> tmp
  delocal int tmp = 0
  // show(elem,prev,next,p)
  // print("AAA")

// Search "cell".  If the node is found, its address is stored in "p".
procedure tree_search(int elem[], int parent[], int left[], int right[], int root, int cell, int p)
  p ^= root
  from  p = root
  loop  if cell <= elem[p] then
          call move_next(elem, parent, left, p)
        else
          call move_next(elem, parent, right, p)
        fi cell <= elem[parent[p]]
  until (cell <= elem[p] && left[p] = 0) || (elem[p] < cell && right[p] = 0)

// Inserting "cell"
// flp: free list pointer
// hp: heap pointer
procedure tree_insert(int elem[], int parent[], int left[], int right[], int root, int flp, int hp, int cell)
  if root = 0 then	// if it is a null tree.
    local int tmp = 0
      call allocate_object(elem, right, flp, hp, tmp)
      root <=> tmp
      elem[root] ^= cell
    delocal int tmp = 0
  else
    local int p = 0
    call tree_search(elem, parent, left, right, root, cell, p)

    // insertion
    local int tmp = 0
      call allocate_object(elem, right, flp, hp, tmp)
      elem[tmp] ^= cell
      parent[tmp] ^= p
      if cell < elem[p] then
        left[p] ^= tmp  tmp ^= left[p]
        call move_next(elem, parent, left, p)
      else
        right[p] ^= tmp
        tmp ^= right[p]
        call move_next(elem, parent, right, p)
      fi cell < elem[parent[p]]
    delocal int tmp = 0

    uncall tree_search(elem, parent, left, right, root, cell, p)
    delocal int p = 0
  fi left[root] = 0 && right[root] = 0 //if it is a tip.

//////////////////////////////////////////////////////////////////////
// Breadth First Search
// Cormen, T. H., et al. (2009).
// Introduction to Algorithms third edition, The MIT Press. p.594.
//////////////////////////////////////////////////////////////////////

procedure bfs(int elem[], int parent[], int left[], int right[], int root, stack garbage, stack res, int qelem[], int head, int tail, int qflp) 
  from head = 0 && tail = 0  // if queue is empty
  do   if left[root] != 0 then // there is a left child
         local int val = left[root]
           call push_back(qelem, head, tail, qflp, val)
         delocal int val = 0
       fi left[root] != 0
       if right[root] != 0 then // there is a left child
         local int val = right[root]
           call push_back(qelem, head, tail, qflp, val)
         delocal int val = 0
       fi right[root] != 0
       local int val = elem[root]
         push(val,res)
       delocal int val = 0
       push(root,garbage)
       call pop_front(qelem, head, tail, qflp, root)
  until head = 0 && tail = 0
  local int val = elem[root]
    push(val,res)
  delocal int val = 0
  push(root,garbage)

//////////////////////////////////////////////////////////////////////
// Copying stacks
//////////////////////////////////////////////////////////////////////

procedure xcopy(stack s, stack t)
  local stack tmp = nil
    // first reverse the elements in source stack s and store them in stack tmp
    from  empty(tmp)
    do    local int v = 0
            pop(v,s)
            push(v,tmp)
          delocal int v = 0
    until empty(s)

    // next duplicate the elements in stack tmp
    //  and push them into both source stack s and target stack t
    from  empty(s)
    do    local int v = 0
            pop(v,tmp)
            push(v,s)
          delocal int v = 0
          local int v = top(s)
            push(v,t)
          delocal int v = 0
    until empty(tmp)
  delocal stack tmp = nil

//////////////////////////////////////////////////////////////////////
// Main procedure
//////////////////////////////////////////////////////////////////////

procedure main()
  int elem[12]
  int parent[12]
  int left[12]
  int right[12]
  int root // a pointer to the root
  int flp  // a free list pointer
  int hp   // a heap pointer
  int cell
  stack res // the result of bfs
  stack res_
  stack garbage
  // int val

  // heap for queue
  int qelem[36]
  int head
  int tail
  int qflp

  //initialization
  hp += 1
  qflp += 3

  //The same values may be inserted more than once.
  cell += 12
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 12
  cell += 5
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 5
  cell += 2
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 2
  cell += 9
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 9
  cell += 18
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 18
  cell += 15
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 15
  cell += 19
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 19
  cell += 17
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 17
  cell += 13
  call tree_insert(elem, parent, left, right, root, flp, hp, cell)
  cell -= 13

  // val += 3
  // call push_back(qelem, head, tail, qflp, val)

  // val += 5
  // call push_back(qelem, head, tail, qflp, val)

  // 2pass Bennett trick
  call bfs(elem, parent, left, right, root, garbage, res, qelem, head, tail, qflp)
  call xcopy(res,res_)
  uncall bfs(elem, parent, left, right, root, garbage, res, qelem, head, tail, qflp)