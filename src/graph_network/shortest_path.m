function [path, len] = shortest_path(A, s, t)
% SHORTEST_PATH A shortest path from vertex s to vertex t, found with breadth-first search.
%   path is the row of vertices from s to t. len is the number of edges on it.
%   If t cannot be reached, path is empty and len is Inf.
%   If several shortest paths exist, the one found first by the search is returned.
n = size(A, 1);
if size(A, 2) ~= n
    error('shortest_path:size', 'The adjacency matrix must be square.');
end
if ~isscalar(t) || t ~= round(t) || t < 1 || t > n
    error('shortest_path:target', 'The target vertex must be a whole number from 1 to n.');
end
[dist, parent] = bfs_search(A, s);
if isinf(dist(t))
    path = zeros(1, 0);
    len = Inf;
    return;
end
path = t;
while path(1) ~= s
    path = [parent(path(1)), path];
end
len = dist(t);
end
