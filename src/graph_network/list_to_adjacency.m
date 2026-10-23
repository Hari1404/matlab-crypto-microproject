function A = list_to_adjacency(L)
% LIST_TO_ADJACENCY Turn an adjacency list into an adjacency matrix.
%   L is a cell array with one cell for each vertex. L{i} holds the numbers of the neighbors of vertex i.
%   A is an n by n matrix of true and false, where n is the number of cells in L.
n = numel(L);
A = false(n, n);
for i = 1:n
    nb = L{i};
    if isempty(nb)
        continue;
    end
    if any(nb ~= round(nb)) || any(nb < 1) || any(nb > n)
        error('list_to_adjacency:range', 'Every neighbor must be a whole number from 1 to n.');
    end
    A(i, nb) = true;
end
end
