function L = adjacency_to_list(A)
% ADJACENCY_TO_LIST Turn an adjacency matrix into an adjacency list.
%   L is a cell array with one cell for each vertex.
%   L{i} is a row vector with the numbers of the neighbors of vertex i, in increasing order (empty if there are none).
n = size(A, 1);
if size(A, 2) ~= n
    error('adjacency_to_list:size', 'The adjacency matrix must be square.');
end
L = cell(1, n);
for i = 1:n
    L{i} = find(A(i, :));
end
end
