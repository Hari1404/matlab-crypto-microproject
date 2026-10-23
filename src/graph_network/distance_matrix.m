function D = distance_matrix(A)
% DISTANCE_MATRIX The distance between every two vertices (the number of edges on a shortest path).
%   D(i, j) is Inf when there is no path from i to j. D(i, i) is 0.
n = size(A, 1);
D = Inf(n, n);
for s = 1:n
    D(s, :) = bfs_search(A, s);
end
end
