function T = try_all_keys(c, S)
% TRY_ALL_KEYS Decrypt a ciphertext with every key of K, like an eavesdropper who does not know the key.
%   T = try_all_keys(c) uses define_sets. T = try_all_keys(c, S) uses the sets in the struct S (p up to 1000).
%   c is a row of numbers from C. T has
%   T.keys            the keys that were tried (the set K)
%   T.stopped         true for a key where the decryption stops with an error (a value outside P)
%   T.texts           the text for each key (empty when the decryption stops)
%   T.readable        true when the text has only letters, digits, spaces and the characters . , ! ? ' -
%   T.count_stopped   the number of keys that stop
%   T.count_readable  the number of keys with a readable text
if nargin < 2
    S = define_sets();
end
if S.prime > 1000
    error('try_all_keys:size', 'The prime p must be at most 1000, because trying every key takes too long.');
end
if ~isnumeric(c) || isempty(c) || ~all(ismember(c(:), S.cipher))
    error('try_all_keys:range', 'The ciphertext must be a row of whole numbers from the set C, at least one.');
end
allowed = ['A':'Z' 'a':'z' '0':'9' ' .,!?''-'];
n = numel(S.keys);
T.keys = S.keys;
T.stopped = false(1, n);
T.readable = false(1, n);
T.texts = cell(1, n);
for q = 1:n
    try
        t = decrypt_text(c, S.keys(q), S);
        T.texts{q} = t;
        T.readable(q) = all(ismember(t, allowed));
    catch
        T.stopped(q) = true;
        T.texts{q} = '';
    end
end
T.count_stopped = sum(T.stopped);
T.count_readable = sum(T.readable);
end
