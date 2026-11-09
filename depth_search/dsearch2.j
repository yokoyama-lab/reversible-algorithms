// 卒業研究「可逆な深さ優先探索」

procedure traverse(int k, int key, int f, stack g, int adj[], int visited[], int next, int val[])
  local int t = adj[k]
    visited[k] ^= 1
    if k = key then
      f ^= 1
    fi k = key
    from t = adj[k] loop
      if visited[val[t]] = 0 then
        call traverse(val[t], key, f, g, adj, visited, next, val)
        push(1, g)
      else
        push(0, g)
      fi top(g) = 1
      push(t, g)
      t ^= next[adj[k]]
    until next[t] = 0 || f != 0
    push(t, g)
  delocal int t = 0

procedure traverse_b(int k, int key, int f, int adj[], int visited[], int next[], int val[])
  local stack g = nil
    local int x = 0
      call traverse(k, key, x, g, adj, visited, next, val)
      f ^= x
      uncall traverse(k, key, x, g, adj, visited, next, val)
    delocal int x = 0
  delocal stack g = nil
