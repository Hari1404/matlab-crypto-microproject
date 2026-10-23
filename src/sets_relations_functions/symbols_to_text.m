function txt = symbols_to_text(sym)
% SYMBOLS_TO_TEXT Turn a row of plaintext symbols (numbers 1 to 95) back into text.
%   Symbol s becomes the character with code s + 31.
if ~isnumeric(sym) || any(sym ~= round(sym)) || any(sym < 1) || any(sym > 95)
    error('symbols_to_text:range', 'Symbols must be whole numbers from 1 to 95.');
end
txt = char(reshape(sym, 1, []) + 31);
end
