function show_sets(S)
% SHOW_SETS Print the sets of the system in the Command Window.
%   show_sets()   uses the sets from define_sets.
%   show_sets(S)  prints the sets in the struct S.
if nargin < 1
    S = define_sets();
end
fprintf('\n=== SETS OF THE SYSTEM ===\n');
fprintf('Prime p = %d, generator g = %d\n\n', S.prime, S.generator);
fprintf('U (users)            : {%s}\n', strjoin(S.users, ', '));
fprintf('                       |U| = %d\n', numel(S.users));
fprintf('P (plaintext symbols): {%d, %d, ..., %d}\n', S.plain(1), S.plain(2), S.plain(end));
fprintf('                       |P| = %d, symbol 1 is the space, symbol %d is the character ~\n', numel(S.plain), S.plain(end));
fprintf('C (ciphertext values): {%d, %d, ..., %d}\n', S.cipher(1), S.cipher(2), S.cipher(end));
fprintf('                       |C| = %d\n', numel(S.cipher));
fprintf('K (keys)             : {%d, %d, ..., %d}, the group Z_%d* under multiplication mod %d\n', S.keys(1), S.keys(2), S.keys(end), S.prime, S.prime);
fprintf('                       |K| = %d\n', numel(S.keys));
end
