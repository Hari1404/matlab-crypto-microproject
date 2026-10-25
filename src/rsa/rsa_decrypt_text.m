function txt = rsa_decrypt_text(c, n, d)
% RSA_DECRYPT_TEXT Decrypt a row of numbers with the private key d and give back the text.
%   c is one row of at least one whole number from 0 to n-1. Every number is decrypted with rsa_decrypt_number.
%   Every result must be a symbol (a number from 1 to 95). With a wrong key a result is usually not a symbol,
%   and then this stops with an error (rsa_decrypt_text:symbols), like decrypt_symbols does for the other cipher.
if ~isnumeric(c) || size(c, 1) ~= 1 || size(c, 2) < 1
    error('rsa_decrypt_text:cipher', 'The ciphertext must be one row of at least one number.');
end
m = zeros(1, numel(c));
for q = 1:numel(c)
    m(q) = rsa_decrypt_number(c(q), n, d);
end
if any(m < 1) || any(m > 95)
    error('rsa_decrypt_text:symbols', 'A decrypted number is not a symbol (not from 1 to 95). This is not the right key.');
end
txt = symbols_to_text(m);
end
