function [pairs, M] = cipher_relation(k, S)
% CIPHER_RELATION The encryption function E_k written as a relation from P to C.
%   pairs has one row [m c] for each plaintext symbol m, where c = E_k(m).
%   M is the same relation as a matrix of true and false, with one row for each
%   symbol of P and one column for each value of C. M(m, c) is true when E_k(m) = c.
%   cipher_relation(k)     uses the sets from define_sets.
%   cipher_relation(k, S)  uses the sets in the struct S.
if nargin < 2
    S = define_sets();
end
c = encrypt_symbols(S.plain, k, S);
pairs = [S.plain(:), c(:)];
M = pairs_to_matrix(pairs, numel(S.plain), numel(S.cipher));
end
