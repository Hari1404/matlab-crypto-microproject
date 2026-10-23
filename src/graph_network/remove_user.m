function [B, keep] = remove_user(A, v)
% REMOVE_USER The adjacency matrix after the vertex v and all its edges are removed.
%   B is smaller than A by one row and one column. A is not changed.
%   keep lists the numbers (in A) of the vertices that remain, so row r of B is vertex keep(r) of A.
n = size(A, 1);
if size(A, 2) ~= n
    error('remove_user:size', 'The adjacency matrix must be square.');
end
if ~isscalar(v) || v ~= round(v) || v < 1 || v > n
    error('remove_user:range', 'The vertex must be a whole number from 1 to n.');
end
keep = [1:(v - 1), (v + 1):n];
B = A(keep, keep);
end
