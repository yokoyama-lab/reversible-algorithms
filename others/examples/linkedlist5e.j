/////////////////////////////////////////////////////////////
// Insertion and search on sorted lists
//
// p.242 A single-array representation of objects,
// Cormen, T. H., et al. (2009).
// Introduction to Algorithms third edition, The MIT Press.
/////////////////////////////////////////////////////////////

// Assign an element greater than val to p.
// If such an element is not found, the rearest location is assigned to p.
procedure list_search_sub(int elem[], int val, int p)
  from  elem[p+1] = 0
  loop  call move_next(elem, p)
  until elem[p+2] = 0 || val <= elem[p]

// val: an element to find
// p: a pointer to the searched node (0 if not found)
procedure list_search(int elem[], int head, int val, int p)
  p ^= head
  call list_search_sub(elem, val, p)

  if val != elem[p] then 	//if val is not found in the list
    uncall list_search_sub(elem, val, p)
    p ^= head
  fi p = 0

// allocate a new node and point newp to the node
procedure allocate_object(int elem[], int flp, int newp)
  newp ^= elem[flp] + flp
  elem[flp] ^= newp - flp
  newp <=> flp
  flp += 3

// move pointer p to the next element of the list
procedure move_next(int elem[], int p)
  local int tmp = elem[p+2]
    p ^= elem[tmp+1] 	// 0 clear
    p <=> tmp
  delocal int tmp = 0

// sp points to the next free cell
// The list on elem[] is assumed to be an increasing list
// "val" does not change before and after the invocation of the procedure
procedure list_insert(int elem[], int head, int flp, int val)
  local int p = head
    call list_search_sub(elem, val, p)

    // Insertion
    local int new = 0
      call allocate_object(elem, flp, new)
      elem[new] ^= val
      if head = 0 then                                // (a) empty list
        p ^= new                                      //1
        new ^= p                                      //2
        head ^= p                                     //3
      else
        if (elem[p+1] = 0 && val <= elem[p]) then     // (b) head of non-empty list
          elem[p+1] ^= new                            //1
          elem[new+2] ^= p                            //2
          head ^= p                                   //3, clear
          head ^= new                                 //4
          p ^= elem[new+2]                            //5, clear
          new ^= head                                 //6, clear
          p ^= head                                   //7
        else
          if (elem[p+2] = 0 && val > elem[p]) then    // (c) rear of non-empty list
            elem[p+2] ^= new                          //1
            elem[new+1] ^= p                          //2
            p ^= elem[new+1]                          //3, clear
            p ^= new                                  //4
            new ^= p                                  //5, clear
          else                                        // (d) middle of non-empty list
            uncall move_next(elem, p)
            elem[new+1] ^= p                          //1
            elem[new+2] ^= elem[p+2]                  //2
            elem[p+2] ^= elem[new+2]                  //3, clear
            elem[p+2] ^= new                          //4
            local int tmp = elem[new+2]
              elem[tmp+1] ^= p                        //5, clear
              elem[tmp+1] ^= elem[p+2]                //6
            delocal int tmp = elem[new+2]
            new ^= elem[p+2]                          //7, clear
            call move_next(elem, p)
          fi elem[p+2] = 0                            // rear of list
        fi elem[p+1] = 0       	                      // head of list
      fi (elem[p+2] = 0 && elem[p+1] = 0)             // list has one element
    delocal int new = 0
    uncall list_search_sub(elem, val, p)              // move p to head
  delocal int p = head

procedure main()
  int elem[24]
  int flp
  int key
  int head
  int val

  flp += 3

  val ^= 22
  call list_insert(elem, head, flp, val)
  val ^= 22
  val ^= 33
  call list_insert(elem, head, flp, val)
  val ^= 33
  val ^= 11
  call list_insert(elem, head, flp, val)
  val ^= 11
  val ^= 55
  call list_insert(elem, head, flp, val)
  val ^= 55
  val ^= 44
  call list_insert(elem, head, flp, val)
  val ^= 44

  val ^= 33
  uncall list_insert(elem, head, flp, val) //list_delete
  val ^= 33
  val ^= 88
  call list_insert(elem, head, flp, val)
  val ^= 88
  val ^= 11
  uncall list_insert(elem, head, flp, val)
  val ^= 11

  val ^= 44
  call list_search(elem, head, val, key)

  //// Search for elements not included in the list
  // val ^= 99
  // call list_search(elem, head, val, key)
