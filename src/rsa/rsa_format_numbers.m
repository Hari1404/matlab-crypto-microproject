function s = rsa_format_numbers(v, per_row)
% RSA_FORMAT_NUMBERS Turn numbers into text: per_row numbers in each line, every line starts with 2 spaces.
%   v is one row of whole numbers, 0 or bigger, at least one. Every number is right-aligned in a field that is one place
%   wider than the biggest number, so the numbers never run together (format_numbers uses a fixed width of 4 places).
%   The lines are separated by a new line character (there is none at the end).
if ~isnumeric(v) || isempty(v) || any(v(:) ~= round(v(:))) || any(v(:) < 0)
    error('rsa_format_numbers:range', 'The numbers must be whole numbers, 0 or bigger, at least one.');
end
if ~is_whole_number(per_row) || per_row < 1
    error('rsa_format_numbers:width', 'per_row must be one whole number of at least 1.');
end
v = reshape(double(v), 1, []);
w = numel(sprintf('%d', max(v))) + 1;
fmt = ['%' num2str(w) 'd'];
s = '';
for q = 1:per_row:numel(v)
    part = v(q:min(q + per_row - 1, numel(v)));
    row = ['  ' sprintf(fmt, part)];
    if isempty(s)
        s = row;
    else
        s = [s char(10) row];
    end
end
end
