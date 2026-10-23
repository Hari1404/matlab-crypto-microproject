function c = encrypt_text(txt, k, S)
% ENCRYPT_TEXT Encrypt a text with the key k. The result is a row of numbers from C.
%   The text is turned into symbols and then encrypted with encrypt_symbols.
%   encrypt_text(txt, k)     uses the sets from define_sets.
%   encrypt_text(txt, k, S)  uses the sets in the struct S.
if nargin < 3
    S = define_sets();
end
c = encrypt_symbols(text_to_symbols(txt), k, S);
end
