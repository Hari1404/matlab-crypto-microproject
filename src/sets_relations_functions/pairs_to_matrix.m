function M = pairs_to_matrix(pairs, nrows, ncols)
% PAIRS_TO_MATRIX Turn a list of ordered pairs into a relation matrix.
%   pairs is a matrix with two columns. Each row [a b] is one pair of the relation.
%   M has nrows rows and ncols columns. M(a, b) is true when the pair [a b] is in the list.
M = false(nrows, ncols);
if isempty(pairs)
    return;
end
if size(pairs, 2) ~= 2 || any(pairs(:) ~= round(pairs(:))) || any(pairs(:, 1) < 1) || any(pairs(:, 1) > nrows) || any(pairs(:, 2) < 1) || any(pairs(:, 2) > ncols)
    error('pairs_to_matrix:range', 'Every pair must be two whole numbers that fit inside the matrix.');
end
for r = 1:size(pairs, 1)
    M(pairs(r, 1), pairs(r, 2)) = true;
end
end
