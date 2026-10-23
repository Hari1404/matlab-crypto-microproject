function R = reachable_from(A, s)
% REACHABLE_FROM The vertices that can be reached from the vertex s (s itself included), in increasing order.
dist = bfs_search(A, s);
R = find(isfinite(dist));
end
