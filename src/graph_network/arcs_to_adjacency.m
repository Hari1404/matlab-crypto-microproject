function A = arcs_to_adjacency(arcs, n)
% ARCS_TO_ADJACENCY Turn a list of arcs into the adjacency matrix of a directed graph.
%   arcs is a matrix with two columns. Each row [i j] is one arc from vertex i to vertex j (user i can send to user j).
%   A is an n by n matrix of true and false. A(i, j) is true when [i j] is an arc. A(j, i) is not set by it.
%   Errors: arcs_to_adjacency:range (not whole numbers from 1 to n, or not two columns),
%   arcs_to_adjacency:loop (an arc from a vertex to itself), arcs_to_adjacency:repeat (the same arc twice).
A = false(n, n);
if isempty(arcs)
    return;
end
if size(arcs, 2) ~= 2 || any(arcs(:) ~= round(arcs(:))) || any(arcs(:) < 1) || any(arcs(:) > n)
    error('arcs_to_adjacency:range', 'Every arc must be two whole numbers from 1 to n.');
end
if any(arcs(:, 1) == arcs(:, 2))
    error('arcs_to_adjacency:loop', 'An arc cannot join a vertex to itself.');
end
for r = 1:size(arcs, 1)
    if A(arcs(r, 1), arcs(r, 2))
        error('arcs_to_adjacency:repeat', 'The arc from %d to %d is given twice.', arcs(r, 1), arcs(r, 2));
    end
    A(arcs(r, 1), arcs(r, 2)) = true;
end
end
