function E = adjacency_to_edges(A)
% ADJACENCY_TO_EDGES Turn an adjacency matrix into a list of undirected edges.
%   E has two columns. Each row [i j] is one edge with i < j, in increasing order (row by row).
%   E has 0 rows (and 2 columns) when the graph has no edges. Only the part above the diagonal is read.
n = size(A, 1);
if size(A, 2) ~= n
    error('adjacency_to_edges:size', 'The adjacency matrix must be square.');
end
E = zeros(0, 2);
for i = 1:(n - 1)
    nb = find(A(i, (i + 1):n)) + i;
    for t = 1:numel(nb)
        E(end + 1, :) = [i, nb(t)];
    end
end
end
