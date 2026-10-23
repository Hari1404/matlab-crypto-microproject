function B = remove_channel(A, i, j)
% REMOVE_CHANNEL The adjacency matrix after the edge between vertex i and vertex j is removed.
%   A is not changed. The edge must exist.
n = size(A, 1);
if size(A, 2) ~= n
    error('remove_channel:size', 'The adjacency matrix must be square.');
end
if ~isscalar(i) || ~isscalar(j) || i ~= round(i) || j ~= round(j) || i < 1 || j < 1 || i > n || j > n
    error('remove_channel:range', 'Both vertices must be whole numbers from 1 to n.');
end
if i == j
    error('remove_channel:loop', 'A channel cannot join a vertex to itself.');
end
if ~A(i, j)
    error('remove_channel:missing', 'There is no channel between these two vertices.');
end
B = A;
B(i, j) = false;
B(j, i) = false;
end
