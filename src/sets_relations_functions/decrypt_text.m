function txt = decrypt_text(c, k, S)
% DECRYPT_TEXT Decrypt a row of ciphertext values with the key k and give back the text.
%   The values are decrypted with decrypt_symbols and then turned back into text.
%   decrypt_text(c, k)     uses the sets from define_sets.
%   decrypt_text(c, k, S)  uses the sets in the struct S.
if nargin < 3
    S = define_sets();
end
txt = symbols_to_text(decrypt_symbols(c, k, S));
end
