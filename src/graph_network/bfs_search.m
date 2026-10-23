function [dist, parent, order] = bfs_search(A, s)
% BFS_SEARCH Breadth-first search from the vertex s in the graph with adjacency matrix A.
%   dist(v)    the number of edges on a shortest path from s to v (Inf if v cannot be reached)
%   parent(v)  the vertex from which the search reached v (0 for s and for the vertices not reached)
%   order      the vertices in the order the search visited them (s first)
%   The neighbors of a vertex are visited in increasing order, so the result is always the same.
n = size(A, 1);
if size(A, 2) ~= n
    error('bfs_search:size', 'The adjacency matrix must be square.');
end
if ~isscalar(s) || s ~= round(s) || s < 1 || s > n
    error('bfs_search:start', 'The start vertex must be a whole number from 1 to n.');
end
dist = Inf(1, n);
parent = zeros(1, n);
dist(s) = 0;
queue = zeros(1, n);
head = 1;
tail = 1;
queue(1) = s;
while head <= tail
    v = queue(head);
    head = head + 1;
    nb = find(A(v, :));
    for t = 1:numel(nb)
        w = nb(t);
        if isinf(dist(w))
            dist(w) = dist(v) + 1;
            parent(w) = v;
            tail = tail + 1;
            queue(tail) = w;
        end
    end
end
order = queue(1:tail);
end
