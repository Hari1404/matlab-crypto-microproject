function r = cycle_rank(A)
% CYCLE_RANK The number of independent cycles of an undirected graph: edges - vertices + groups.
%   It is 0 exactly when the graph has no cycle (a tree, or a forest).
n = size(A, 1);
m = size(adjacency_to_edges(A), 1);
[comp, k] = connected_components(A);
r = m - n + k;
end
