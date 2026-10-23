function [comp, k] = connected_components(A)
% CONNECTED_COMPONENTS Split an undirected graph into its connected groups of vertices.
%   comp(v) is the number of the group of vertex v. The groups are numbered 1, 2, ... by their smallest vertex.
%   k is the number of groups.
n = size(A, 1);
comp = zeros(1, n);
k = 0;
for v = 1:n
    if comp(v) == 0
        k = k + 1;
        dist = bfs_search(A, v);
        comp(isfinite(dist)) = k;
    end
end
end
