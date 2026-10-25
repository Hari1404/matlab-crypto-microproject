function [reach, k] = reach_by_matrix(A)
% REACH_BY_MATRIX Which vertices can reach which, found with matrix products (no breadth-first search).
%   [reach, k] = reach_by_matrix(A) takes an adjacency matrix A of an undirected graph.
%   reach(i, j) is true when there is a path from i to j (reach(i, i) is always true).
%   k is the number of groups of vertices (connected components).
%   It starts with R = A or the identity and squares R again and again, keeping only true and false.
%   After t squarings R holds all paths of up to 2^t edges, so n squarings are always enough.
n = size(A, 1);
R = double(logical(A) | eye(n));
for t = 1:max(n, 1)
    R = double(R * R > 0);
end
reach = R > 0;
k = 0;
seen = false(1, n);
for v = 1:n
    if ~seen(v)
        k = k + 1;
        seen = seen | reach(v, :);
    end
end
end
