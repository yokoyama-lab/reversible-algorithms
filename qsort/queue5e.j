//////////////////////////////////////////////////////////////////////
// Queue
//////////////////////////////////////////////////////////////////////

// Allocate a new node to cell
procedure allocate_object(int elem[], int flp, int newp)
  newp ^= elem[flp] + flp
  elem[flp] ^= newp - flp
  newp <=> flp
  flp += 3

// push_sub is shared by push_front and push_back
procedure push_sub(int elem[], int head, int tail, int next, int prev, int flp, int val)
  if true then
    local int newp = 0
      call allocate_object(elem, flp, newp)
      if head != 0 then		//if stack is not empty
        elem[head+next] ^= newp
        local int tmp = head
          head ^= tmp		// 0 clear
          head ^= elem[newp+prev]
          elem[newp+prev] ^= head    // 0 clear
          elem[newp+prev] ^= tmp
        delocal int tmp = elem[newp+prev]
      else
        tail ^= newp
      fi elem[newp+prev] != 0
      local int tmp = val
        val ^= tmp		// 0 clear
        val ^= elem[newp]
        elem[newp] ^= val	// 0 clear
        elem[newp] ^= tmp
      delocal int tmp = elem[newp]
      head <=> newp
    delocal int newp = 0
  fi head != 0

procedure push_front(int elem[], int head, int tail, int flp, int val)
  local int next = 2
    local int prev = 1
      call push_sub(elem, head, tail, next, prev, flp, val)
    delocal int prev = 1
  delocal int next = 2

procedure push_back(int elem[], int head, int tail, int flp, int val)
  local int next = 1
    local int prev = 2
      call push_sub(elem, tail, head, next, prev, flp, val)
    delocal int prev = 2
  delocal int next = 1

procedure pop_front(int elem[], int head, int tail, int flp, int val)
  uncall push_front(elem, head, tail, flp, val)

procedure pop_back(int elem[], int head, int tail, int flp, int val)
  uncall push_back(elem, head, tail, flp, val)

procedure main()
  int elem[21]
  int flp
  int head
  int tail
  int val

  flp += 3

  val += 11
  call push_back(elem, head, tail, flp, val)

  val += 22
  call push_back(elem, head, tail, flp, val)

  val += 33
  call push_back(elem, head, tail, flp, val)

  uncall push_front(elem, head, tail, flp, val)
  val -= 11

  uncall push_back(elem, head, tail, flp, val)
  val -= 33

  uncall push_front(elem, head, tail, flp, val)
  val -= 22

  // popping from an empty queue (error)
  // uncall push_back(elem, head, tail, flp, val)

  val += 44
  call push_front(elem, head, tail, flp, val)

  val += 55
  call push_front(elem, head, tail, flp, val)

  val += 66
  call push_front(elem, head, tail, flp, val)

  val += 77
  call push_back(elem, head, tail, flp, val)

  val += 88
  call push_back(elem, head, tail, flp, val)

  uncall push_front(elem, head, tail, flp, val)
  val -= 66

  uncall push_front(elem, head, tail, flp, val)
  val -= 55

  uncall push_front(elem, head, tail, flp, val)
  val -= 44

  uncall push_back(elem, head, tail, flp, val)
  val -= 88

  uncall push_front(elem, head, tail, flp, val)
  val -= 77
