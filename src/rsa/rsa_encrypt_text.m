function c = rsa_encrypt_text(txt, n, e)
% RSA_ENCRYPT_TEXT Encrypt a text with the public key (n, e). The result is a row of numbers from 0 to n-1.
%   The text is one row of at least one of the 95 printable characters. Every character becomes a symbol (1 to 95)
%   and every symbol is encrypted alone with rsa_encrypt_number. A symbol is smaller than n because n is at least 97.
if ~ischar(txt) || size(txt, 1) ~= 1 || size(txt, 2) < 1
    error('rsa_encrypt_text:text', 'The message must be a text with at least one character (text in single quotes).');
end
sym = text_to_symbols(txt);
c = zeros(1, numel(sym));
for q = 1:numel(sym)
    c(q) = rsa_encrypt_number(sym(q), n, e);
end
end
