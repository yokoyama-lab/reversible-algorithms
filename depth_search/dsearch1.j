// 卒業研究「可逆な深さ優先探索」

procedure traverse(int k, int key, int f, stack g, int adj[], int visited[], int next[], int val [])
  local int t = adj[k]
    local int s = 0
      push(visited[k], g)
      visited[k] ^= 1
      if k = key then
        push(f, g)
        f ^= 1
        local int pushtmp = 1
          push(pushtmp, g)
        delocal int pushtmp = 0
      else
        local int pushtmp = 0
          push(pushtmp, g)
        delocal int pushtmp = 0
      fi top(g) = 1
      local int pushtmp = 1
        push(pushtmp, g)
      delocal int pushtmp = 0
      from top(g) = 1 loop
        if visited[val[t]]=0 then
          call traverse(val[t], key, f, g, adj, visited, next ,val )
          local int pushtmp = 1
            push(pushtmp, g)
          delocal int pushtmp = 0
        else
          local int pushtmp = 0
            push(pushtmp, g)
          delocal int pushtmp = 0
        fi top(g) = 1
        push(s, g)
        s ^= next[t]
        push(t, g)
        t ^= s
        local int pushtmp = 0
          push(pushtmp, g)
        delocal int pushtmp = 0
      until next[t] = 0 || f != 0
      push(t, g)
      push(s, g)
    delocal int s = 0
  delocal int t = 0

procedure traverse_b(int k, int key, int f, int adj[], int visited[], int next[], int val[])
  local stack g = nil
    local int x = 0
      call traverse (k, key, x, g, adj, visited, next, val)
      f ^= x
      uncall traverse (k, key, x, g, adj, visited, next, val)
    delocal int x = 0
  delocal stack g = nil
