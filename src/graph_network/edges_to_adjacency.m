function A = edges_to_adjacency(edges, n)
% EDGES_TO_ADJACENCY Turn a list of undirected edges into an adjacency matrix.
%   edges is a matrix with two columns. Each row [i j] is one edge between vertex i and vertex j.
%   A is an n by n matrix of true and false. A(i, j) and A(j, i) are both true when [i j] is an edge.
A = false(n, n);
if isempty(edges)
    return;
end
if size(edges, 2) ~= 2 || any(edges(:) ~= round(edges(:))) || any(edges(:) < 1) || any(edges(:) > n)
    error('edges_to_adjacency:range', 'Every edge must be two whole numbers from 1 to n.');
end
if any(edges(:, 1) == edges(:, 2))
    error('edges_to_adjacency:loop', 'An edge cannot join a vertex to itself.');
end
for r = 1:size(edges, 1)
    A(edges(r, 1), edges(r, 2)) = true;
    A(edges(r, 2), edges(r, 1)) = true;
end
end
