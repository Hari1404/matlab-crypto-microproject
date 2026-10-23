function show_cipher(S, k)
% SHOW_CIPHER Print encryption and decryption as functions, with their properties.
%   show_cipher()      uses define_sets and the example key 85.
%   show_cipher(S, k)  uses the sets in the struct S and the key k.
if nargin < 1
    S = define_sets();
end
if nargin < 2
    k = 85;
end
j = key_inverse(k, S);
p = S.prime;
np = numel(S.plain);
nc = numel(S.cipher);

fprintf('\n=== ENCRYPTION AND DECRYPTION AS FUNCTIONS ===\n');
fprintf('Encryption E_k : P -> C,  E_k(m) = k*m mod %d\n', p);
fprintf('Decryption D_k : C -> P,  D_k(c) = j*c mod %d, where j is the inverse of k\n', p);
fprintf('Example key k = %d. Its inverse is j = %d, because %d * %d = %d = 1 (mod %d).\n', k, j, k, j, k * j, p);

fprintf('\nSome values of E_%d and D_%d:\n', k, k);
fprintf('  %-8s %-12s %-12s\n', 'm', ['E_' num2str(k) '(m)'], 'D_k(E_k(m))');
sample = [1 2 3 34 np];
for m = sample
    c = encrypt_symbols(m, k, S);
    d = decrypt_symbols(c, k, S);
    fprintf('  %-8d %-12d %-12d\n', m, c, d);
end

[pairs, M] = cipher_relation(k, S);
F = function_properties(M);
used = sum(any(M, 1));
missing = find(~any(M, 1));
fprintf('\nProperties of E_%d, a relation with %d pairs from P (%d symbols) to C (%d values):\n', k, size(pairs, 1), np, nc);
prop_line('Function (every symbol has exactly one ciphertext value)', F.is_function);
prop_line('One-to-one (different symbols give different values)', F.one_to_one);
fprintf('  %-62s: %s (%d of %d values are used, %d is left out)\n', 'Onto (every value of C is used)', yes_no(F.onto), used, nc, missing(1));

back = decrypt_symbols(encrypt_symbols(S.plain, k, S), k, S);
fprintf('\nD_k(E_k(m)) = m for all %d symbols of P : %s\n', np, yes_no(isequal(back, S.plain)));
fprintf('So E_k is one-to-one, and D_k undoes it. The value %d is not used, so E_k is not onto.\n', missing(1));
end

function prop_line(label, flag)
fprintf('  %-62s: %s\n', label, yes_no(flag));
end

function s = yes_no(flag)
if flag
    s = 'yes';
else
    s = 'no';
end
end
