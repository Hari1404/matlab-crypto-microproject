function sym = decrypt_symbols(c, k, S)
% DECRYPT_SYMBOLS Decrypt a row of ciphertext values with the key k.
%   The decryption function is D_k(c) = j*c mod p, where j is the inverse of k.
%   c is a row of numbers from C (1 to 96). The result is a row of numbers from P (1 to 95).
%   With a wrong key a result can be 96, which is not a plaintext symbol. Then this stops with an error.
%   decrypt_symbols(c, k)     uses the sets from define_sets.
%   decrypt_symbols(c, k, S)  uses the sets in the struct S.
if nargin < 3
    S = define_sets();
end
if ~isnumeric(c) || ~all(ismember(c(:), S.cipher))
    error('decrypt_symbols:range', 'Every ciphertext value must be a whole number from the set C.');
end
if ~isnumeric(k) || ~isscalar(k) || ~ismember(k, S.keys)
    error('decrypt_symbols:key', 'The key must be one whole number from the set K.');
end
j = key_inverse(k, S);
sym = mod(j * double(reshape(c, 1, [])), S.prime);
if ~all(ismember(sym, S.plain))
    error('decrypt_symbols:wrongkey', 'With this key a value decrypts to a number outside P. This is not the right key.');
end
end
