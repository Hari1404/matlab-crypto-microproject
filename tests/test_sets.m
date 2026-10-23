function test_sets()
% TEST_SETS Checks for the sets and the conversion between text and symbols.
S = define_sets();
c = cell(0, 2);

c(end+1, :) = {'there are 6 users', numel(S.users) == 6};
c(end+1, :) = {'the user names are all different', numel(unique(S.users)) == 6};
c(end+1, :) = {'the alphabet has 95 characters', numel(S.alphabet) == 95};
c(end+1, :) = {'the alphabet characters are all different', numel(unique(S.alphabet)) == 95};
c(end+1, :) = {'the alphabet starts with a space and ends with ~', S.alphabet(1) == ' ' && S.alphabet(end) == '~'};
c(end+1, :) = {'P has 95 symbols', isequal(S.plain, 1:95)};
c(end+1, :) = {'C has 96 values', isequal(S.cipher, 1:96)};
c(end+1, :) = {'K has 96 keys', isequal(S.keys, 1:96)};
c(end+1, :) = {'p is 97 and p is prime', S.prime == 97 && isprime(S.prime)};
c(end+1, :) = {'g is 5', S.generator == 5};
c(end+1, :) = {'every plaintext symbol is also a key (P is inside K)', all(ismember(S.plain, S.keys))};

pw = zeros(1, S.prime - 1);
x = 1;
for i = 1:(S.prime - 1)
    x = mod(x * S.generator, S.prime);
    pw(i) = x;
end
c(end+1, :) = {'the powers of g give every key once (g generates the group)', isequal(sort(pw), S.keys)};

c(end+1, :) = {'the space is symbol 1', isequal(text_to_symbols(' '), 1)};
c(end+1, :) = {'A is symbol 34', isequal(text_to_symbols('A'), 34)};
c(end+1, :) = {'~ is symbol 95', isequal(text_to_symbols('~'), 95)};
c(end+1, :) = {'Hello Bob gives the right symbols', isequal(text_to_symbols('Hello Bob'), [41 70 77 77 80 1 35 80 67])};
c(end+1, :) = {'the symbols come as a row', size(text_to_symbols('Hi'), 1) == 1};
c(end+1, :) = {'an empty text gives no symbols', isempty(text_to_symbols(''))};
c(end+1, :) = {'text -> symbols -> text works for all 95 characters', isequal(symbols_to_text(text_to_symbols(S.alphabet)), S.alphabet)};
c(end+1, :) = {'text -> symbols -> text works for Hello Bob', isequal(symbols_to_text(text_to_symbols('Hello Bob')), 'Hello Bob')};
c(end+1, :) = {'a tab character is rejected', raises_error(@() text_to_symbols(char(9)))};
c(end+1, :) = {'a number instead of text is rejected', raises_error(@() text_to_symbols(65))};
c(end+1, :) = {'symbol 0 is rejected', raises_error(@() symbols_to_text(0))};
c(end+1, :) = {'symbol 96 is rejected', raises_error(@() symbols_to_text(96))};
c(end+1, :) = {'symbol 2.5 is rejected', raises_error(@() symbols_to_text(2.5))};

summarize_checks('test_sets', c);
end

function flag = raises_error(f)
flag = false;
try
    f();
catch
    flag = true;
end
end
