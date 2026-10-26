function arcs = adjacency_to_arcs(A)
% ADJACENCY_TO_ARCS Turn the adjacency matrix of a directed graph into the list of arcs.
%   arcs has one row [i j] for each arc i -> j, sorted by i and then by j (row by row through the matrix).
%   Error adjacency_to_arcs:size when A is not square.
n = size(A, 1);
if size(A, 2) ~= n
    error('adjacency_to_arcs:size', 'The adjacency matrix must be square.');
end
arcs = zeros(0, 2);
for i = 1:n
    js = find(A(i, :));
    for t = 1:numel(js)
        arcs(end + 1, :) = [i js(t)];
    end
end
end
