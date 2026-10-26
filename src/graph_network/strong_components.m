function [comp, k] = strong_components(A)
% STRONG_COMPONENTS Split a directed graph into its strongly connected groups of vertices.
%   Two vertices are in the same group when each can be reached from the other along arcs.
%   comp(v) is the number of the group of vertex v. The groups are numbered 1, 2, ... by their smallest vertex.
%   k is the number of groups. Error strong_components:size when A is not square.
n = size(A, 1);
if size(A, 2) ~= n
    error('strong_components:size', 'The adjacency matrix must be square.');
end
reach = isfinite(distance_matrix(A));
comp = zeros(1, n);
k = 0;
for v = 1:n
    if comp(v) == 0
        k = k + 1;
        comp(reach(v, :) & reach(:, v)') = k;
    end
end
end
