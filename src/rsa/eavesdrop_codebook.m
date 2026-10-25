function A = eavesdrop_codebook(c, n, e)
% EAVESDROP_CODEBOOK Eve reads RSA numbers with a list of all small numbers, without a private key.
%   A = eavesdrop_codebook(c, n, e) encrypts every number t from 1 to 96 (every symbol and every key of the cipher)
%   with the public key (n, e) and writes the results in a list. Then every number of c is looked up in the list.
%   c is one row of at least one whole number from 0 to n-1. n is a whole number from 97 to 2^26. e is a whole number, 3 or bigger.
%   A has
%   A.n, A.e      the public key
%   A.tries       the number of encryptions that Eve needs: 96
%   A.book        the list: A.book(t) = t^e mod n for t = 1 to 96
%   A.values      for every number of c the number t that gives it in the list (0 when the number is not in the list)
%   A.found       how many numbers of c are in the list
%   A.all_found   true when every number of c is in the list
%   A.text        the text that the numbers give when all are found and every t is a symbol (1 to 95), otherwise empty
%   The errors are eavesdrop_codebook:modulus, :exponent and :cipher.
if ~is_whole_number(n) || n < 97 || n > 2^26
    error('eavesdrop_codebook:modulus', 'n must be one whole number from 97 to 67108864.');
end
if ~is_whole_number(e) || e < 3
    error('eavesdrop_codebook:exponent', 'e must be one whole number, 3 or bigger.');
end
if ~isnumeric(c) || ~isreal(c) || size(c, 1) ~= 1 || size(c, 2) < 1 || any(c ~= round(c)) || any(c < 0) || any(c > n - 1)
    error('eavesdrop_codebook:cipher', 'c must be one row of at least one whole number from 0 to n-1 = %d.', n - 1);
end
A.n = n;
A.e = e;
A.tries = 96;
A.book = zeros(1, 96);
for t = 1:96
    A.book(t) = mod_pow(t, e, n);
end
A.values = zeros(1, numel(c));
for q = 1:numel(c)
    hit = find(A.book == c(q), 1);
    if ~isempty(hit)
        A.values(q) = hit;
    end
end
A.found = sum(A.values > 0);
A.all_found = (A.found == numel(c));
A.text = '';
if A.all_found && all(A.values <= 95)
    A.text = symbols_to_text(A.values);
end
end
