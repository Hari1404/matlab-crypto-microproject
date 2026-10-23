function sym = text_to_symbols(txt)
% TEXT_TO_SYMBOLS Turn a text into a row of plaintext symbols (numbers 1 to 95).
%   A character with code c becomes the symbol c - 31.
%   So the space is symbol 1 and the character ~ is symbol 95.
if ~ischar(txt)
    error('text_to_symbols:type', 'The text must be a character vector (text in single quotes).');
end
codes = double(reshape(txt, 1, []));
if any(codes < 32) || any(codes > 126)
    error('text_to_symbols:range', 'The text has a character outside the 95 printable characters (space to ~).');
end
sym = codes - 31;
end
