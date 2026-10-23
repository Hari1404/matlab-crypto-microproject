function c = encrypt_symbols(sym, k, S)
% ENCRYPT_SYMBOLS Encrypt a row of plaintext symbols with the key k.
%   The encryption function is E_k(m) = k*m mod p, from P to C.
%   sym is a row of numbers from P (1 to 95). The result c is a row of numbers from C (1 to 96).
%   encrypt_symbols(sym, k)     uses the sets from define_sets.
%   encrypt_symbols(sym, k, S)  uses the sets in the struct S.
if nargin < 3
    S = define_sets();
end
if ~isnumeric(sym) || ~all(ismember(sym(:), S.plain))
    error('encrypt_symbols:range', 'Every symbol must be a whole number from the set P.');
end
if ~isnumeric(k) || ~isscalar(k) || ~ismember(k, S.keys)
    error('encrypt_symbols:key', 'The key must be one whole number from the set K.');
end
c = mod(double(k) * double(reshape(sym, 1, [])), S.prime);
end
