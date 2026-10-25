function show_eavesdropper(S)
% SHOW_EAVESDROPPER Print what an eavesdropper (Eve) can do with the public numbers and the encrypted message.
%   show_eavesdropper()   uses define_sets.
%   show_eavesdropper(S)  uses the prime p, the generator g and the users in the struct S.
if nargin < 1
    S = define_sets();
end
p = S.prime;
g = S.generator;
answer = {'NO', 'yes'};
D = define_secrets(S);
txt = 'Meet me at the library at 5 pm, Bob.';
M = send_message(txt, 1, 2, D, S);
name1 = M.from;
name2 = M.to;
V = eavesdrop_dh(M.public_from, M.public_to, p, g);
eve_text = decrypt_text(M.cipher, V.key, S);
T = try_all_keys(M.cipher, S);

fprintf('\n=== THE EAVESDROPPER ===\n');
fprintf('Eve listens to the channel between %s and %s. She knows no secret number. She sees:\n', name1, name2);
fprintf('  the public numbers p = %d and g = %d\n', p, g);
fprintf('  the public values A = %d (from %s) and B = %d (from %s)\n', M.public_from, name1, M.public_to, name2);
fprintf('  the encrypted message, %d numbers:\n', numel(M.cipher));
fprintf('%s\n', format_numbers(M.cipher, 12));

% 1. try every secret number
fprintf('\n1. Eve tries every secret number\n');
fprintf('  She computes g^1, g^2, g^3, ... mod p until she gets A = %d.\n', V.A);
fprintf('  She gets %d^%d mod %d = %d after %d tries. So the secret number of %s is %d.\n', g, V.secret, p, V.A, V.tries, name1, V.secret);
fprintf('  She computes B^a mod p = %d^%d mod %d = %d. This is the key of %s and %s.\n', V.B, V.secret, p, V.key, name1, name2);
fprintf('  She decrypts the message with the key %d: %s\n', V.key, eve_text);
fprintf('  Eve reads the message: %s\n', answer{double(strcmp(eve_text, txt)) + 1});
fprintf('  This works because p is small: there are only %d secret numbers to try.\n', V.worst);

% 2. why a big prime is needed
tp = [97 1009 10007 100003];
fprintf('\n2. Why a big prime is needed\n');
fprintf('  Worst case: the secret number of %s is the last one that Eve tries, which is p-2.\n', name1);
fprintf('  %-10s%-14s%-12s%s\n', 'p', 'g (smallest)', 'tries', 'Eve gets the right key');
rows_ok = true;
worst_ok = true;
for q = 1:numel(tp)
    p2 = tp(q);
    g2 = 2;
    while ~is_generator(g2, p2)
        g2 = g2 + 1;
    end
    E2 = dh_exchange(p2 - 2, 2, p2, g2);
    V2 = eavesdrop_dh(E2.A, E2.B, p2, g2);
    rows_ok = rows_ok && (V2.key == E2.key);
    worst_ok = worst_ok && (V2.tries == p2 - 2);
    fprintf('  %-10d%-14d%-12d%s\n', p2, g2, V2.tries, answer{double(V2.key == E2.key) + 1});
end
fprintf('  The number of tries grows with p. A prime with 2048 bits (a number with 617 digits) would need up to 2^2048 tries, which is impossible. Faster attacks than trying every number exist, but they are also far too slow for such a prime. Real systems use primes like that. This project uses p = %d on purpose, so that every step can be checked by hand.\n', p);

% 3. try every key of the cipher
shown = find(T.readable);
shown = shown(1:min(5, numel(shown)));
fprintf('\n3. Eve tries every key of the cipher\n');
fprintf('  The cipher has only %d keys. Eve can skip the key exchange and decrypt the numbers with every key.\n', numel(S.keys));
fprintf('  Keys where the decryption stops (a value that is not a symbol): %d of %d\n', T.count_stopped, numel(S.keys));
fprintf('  Keys that give a readable text (only letters, digits, spaces and . , ! ? '' -): %d\n', T.count_readable);
for q = shown
    fprintf('  key %-3d gives: %s\n', T.keys(q), T.texts{q});
end
fprintf('  So Eve can read the message without any secret number. This cipher is too simple to be secure. A real cipher has a key with at least 128 bits.\n');

% 4. self-checks
checks = {
    sprintf('Eve finds the secret number %d of %s', D.private(1), name1), V.secret == D.private(1);
    'the number of tries is the secret number', V.tries == V.secret;
    sprintf('Eve gets the same key as %s and %s', name1, name2), V.key == M.key_sender;
    'Eve reads the message with her key', strcmp(eve_text, txt);
    'in the table, Eve gets the right key for every prime', rows_ok;
    'in the table, the tries are p-2 for every prime', worst_ok;
    'the real key is one of the keys that give a readable text', T.readable(M.key_sender)};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
