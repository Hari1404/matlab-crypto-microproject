function F = function_properties(M)
% FUNCTION_PROPERTIES Check whether a relation from A to B is a function.
%   M is a matrix of 0 and 1 (or false and true). It has one row for each element of A
%   and one column for each element of B. M(a, b) = 1 means a is related to b.
%   F.is_function   every a is related to exactly one b
%   F.one_to_one    it is a function and no two a's have the same b
%   F.onto          it is a function and every b is used
%   F.bijective     one-to-one and onto
if ~(isnumeric(M) || islogical(M)) || ndims(M) ~= 2 || any(M(:) ~= 0 & M(:) ~= 1)
    error('function_properties:input', 'The relation must be a matrix of 0 and 1.');
end
M = logical(M);
per_input = sum(M, 2);
per_output = sum(M, 1);
F.is_function = all(per_input == 1);
F.one_to_one = F.is_function && all(per_output <= 1);
F.onto = F.is_function && all(per_output >= 1);
F.bijective = F.one_to_one && F.onto;
end
