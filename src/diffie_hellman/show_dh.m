function show_dh(S)
% SHOW_DH Print the Diffie-Hellman key exchange: Alice and Bob step by step, the secret numbers and public values of all users, and the table of shared keys.
%   show_dh()   uses define_sets.
%   show_dh(S)  uses the prime p, the generator g and the users in the struct S.
if nargin < 1
    S = define_sets();
end
p = S.prime;
g = S.generator;
answer = {'NO', 'yes'};
D = define_secrets(S);
n = numel(D.users);
name1 = S.users{1};
name2 = S.users{2};
E = dh_exchange(D.private(1), D.private(2), p, g);

fprintf('\n=== DIFFIE-HELLMAN KEY EXCHANGE ===\n');
fprintf('Everybody knows the public numbers p = %d and g = %d, also an eavesdropper. Every user keeps one secret number.\n', p, g);

% 1. two users
fprintf('\n1. %s and %s agree on a key\n', name1, name2);
fprintf('  %s picks the secret number a = %d and sends A = g^a mod p = %d^%d mod %d = %d.\n', name1, E.a, g, E.a, p, E.A);
fprintf('  %s picks the secret number b = %d and sends B = g^b mod p = %d^%d mod %d = %d.\n', name2, E.b, g, E.b, p, E.B);
fprintf('  %s computes B^a mod p = %d^%d mod %d = %d.\n', name1, E.B, E.a, p, E.key_alice);
fprintf('  %s computes A^b mod p = %d^%d mod %d = %d.\n', name2, E.A, E.b, p, E.key_bob);
fprintf('  Both keys are the same: %s. The key is %d, a number from 1 to %d, so it can be used as a key of the cipher.\n', answer{double(E.agree) + 1}, E.key, p - 1);
fprintf('  Why: (g^b)^a = (g^a)^b = g^(a*b) (mod p). Here a*b = %d, a*b mod %d = %d, and %d^%d mod %d = %d.\n', E.a * E.b, p - 1, E.exponent, g, E.exponent, p, E.key_formula);
fprintf('  The secret numbers a and b never crossed the channel. Only A = %d and B = %d did.\n', E.A, E.B);

% 2. all users
fprintf('\n2. The secret number and the public value of every user\n');
fprintf('  %-10s%-10s%s\n', 'user', 'secret', 'public');
for i = 1:n
    fprintf('  %-10s%-10d%d\n', D.users{i}, D.private(i), D.public(i));
end

% 3. the table of keys
K = dh_key_table(D, p);
fprintf('\n3. The shared key of every pair of users\n');
fprintf('Row i, column j: the key that user i computes from the public value of user j. A user needs no key with himself (-).\n');
fprintf('  %-10s', '');
for j = 1:n
    fprintf('%-8s', D.users{j});
end
fprintf('\n');
for i = 1:n
    fprintf('  %-10s', D.users{i});
    for j = 1:n
        if i == j
            fprintf('%-8s', '-');
        else
            fprintf('%-8d', K(i, j));
        end
    end
    fprintf('\n');
end
fprintf('The table is symmetric, so two users always get the same key: %s\n', answer{double(isequal(K, K')) + 1});

% 4. self-checks
off = ~eye(n);
ok_plain = true;
for i = 1:n
    v = 1;
    for k = 1:D.private(i)
        v = mod(v * g, p);
    end
    ok_plain = ok_plain && (v == D.public(i));
end
wrong = dh_shared_key(E.a + 1, E.B, p);
checks = {
    sprintf('%s and %s get the same key', name1, name2), E.agree;
    'the key is the same as g^(a*b mod (p-1)) mod p', E.key == E.key_formula;
    'the table of keys is symmetric (two users get the same key)', isequal(K, K');
    'every key in the table is a number from 1 to p-1, so it is a key of the cipher', all(ismember(K(off)', S.keys));
    'the public values of the users are all different', numel(unique(D.public)) == n;
    'dh_public_value agrees with multiplying by g again and again (every user)', ok_plain;
    'a different secret number gives a different key', wrong ~= E.key};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
