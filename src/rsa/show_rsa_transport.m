function show_rsa_transport(S)
% SHOW_RSA_TRANSPORT Print the key transport: a key of the cipher of Point 1 is sent with RSA, then a text is sent with that key.
%   show_rsa_transport()   uses define_sets.
%   show_rsa_transport(S)  uses the sets S (6 users).
if nargin < 1
    S = define_sets();
end
R = define_rsa_users(S);
nu = numel(S.users);
p = S.prime;
answer = {'NO', 'yes'};
txt = 'Meet me at the library at 5 pm, Bob.';
k = 85;
T = rsa_key_transport(txt, k, 1, 2, R, S);
name1 = T.from;
name2 = T.to;
sym = text_to_symbols(txt);
j = key_inverse(T.key_received, S);
[kc, st1] = mod_pow(k, T.e, T.n);
[kb, st2] = mod_pow(T.key_cipher, R.d(2), R.n(2));

fprintf('\n=== RSA KEY TRANSPORT ===\n');
fprintf('RSA with big numbers is slow, so real systems use RSA only to send a key. The text is encrypted with a fast cipher and that key. Here the fast cipher is the cipher of Point 1, E_k(m) = k*m mod %d, and the key k is a number from 1 to %d.\n', p, p - 1);
fprintf('With Diffie-Hellman both users compute the key together. With key transport the sender chooses the key and sends it, encrypted with the public key of the receiver.\n');

% 1. the key
fprintf('\n1. %s sends a key to %s\n', name1, name2);
fprintf('  %s chooses the key k = %d (the example key of Point 1). She looks up the public key of %s: (n, e) = (%d, %d).\n', name1, k, name2, T.n, T.e);
fprintf('  She encrypts the key: c = k^e mod n = %d^%d mod %d = %d (%d squaring steps and %d multiplication steps). The number c crosses the channel.\n', k, T.e, T.n, kc, size(st1, 1), sum(st1(:, 1)));
fprintf('  %s decrypts it with the private key d = %d: k = c^d mod n = %d^%d mod %d = %d.\n', name2, R.d(2), T.key_cipher, R.d(2), R.n(2), kb);
fprintf('  The key that %s gets is the key that %s chose: %s.\n', name2, name1, answer{double(T.agree) + 1});

% 2. the text
fprintf('\n2. %s sends a message with the key\n', name1);
fprintf('  The message: %s\n', txt);
fprintf('  The text has %d characters. Every character becomes a symbol (a space is 1, the character ~ is %d) and is encrypted with the key: E_k(m) = k*m mod %d.\n', numel(sym), numel(S.plain), p);
fprintf('  Example: the first character %s is the symbol %d, and %d * %d mod %d = %d.\n', txt(1), sym(1), k, sym(1), p, T.cipher(1));
fprintf('  The %d numbers that cross the channel (numbers from 1 to %d):\n', numel(T.cipher), p - 1);
fprintf('%s\n', format_numbers(T.cipher, 12));
fprintf('  %s finds the inverse key j = %d (because %d * %d mod %d = 1) and computes j*c mod %d for every number c.\n', name2, j, T.key_received, j, p, p);
fprintf('  The text that %s gets: %s\n', name2, T.received);
fprintf('  It is the same as the message: %s\n', answer{double(T.ok) + 1});

% 3. the other users
others = setdiff(1:nu, 2);
none_gets = true;
fprintf('\n3. What the other users get\n');
fprintf('  Only %s has the private key d that fits the public key of %s. The other users decrypt the number c = %d with their own keys:\n', name2, name2, T.key_cipher);
for i = others
    v = mod_pow(T.key_cipher, R.d(i), R.n(i));
    if v < 1 || v > p - 1
        fprintf('  %s: %d^%d mod %d = %d. This is not a key (a key is from 1 to %d), so the text cannot be decrypted.\n', S.users{i}, T.key_cipher, R.d(i), R.n(i), v, p - 1);
        none_gets = none_gets && (v ~= k);
    else
        try
            wtxt = decrypt_text(T.cipher, v, S);
            stopped = false;
        catch
            wtxt = '';
            stopped = true;
        end
        if stopped
            fprintf('  %s: %d^%d mod %d = %d. With this key the decryption stops, because a number turns into a value that is not a symbol.\n', S.users{i}, T.key_cipher, R.d(i), R.n(i), v);
        else
            fprintf('  %s: %d^%d mod %d = %d. With this key the result is only nonsense: %s\n', S.users{i}, T.key_cipher, R.d(i), R.n(i), v, wtxt);
        end
        none_gets = none_gets && (v ~= k) && (stopped || ~strcmp(wtxt, txt));
    end
end

% 4. why not RSA for the whole text
per_number = size(st2, 1) + sum(st2(:, 1));
rsa_all = numel(T.cipher) * per_number;
transport_all = per_number + numel(T.cipher);
fprintf('\n4. Why the key is sent and not the whole text\n');
fprintf('  One RSA decryption with d = %d takes %d squaring steps and %d multiplication steps, %d modular multiplications in all.\n', R.d(2), size(st2, 1), sum(st2(:, 1)), per_number);
fprintf('  If %s decrypted all %d numbers of the text with RSA, that would be %d * %d = %d modular multiplications.\n', name2, numel(T.cipher), numel(T.cipher), per_number, rsa_all);
fprintf('  With key transport it is one RSA decryption for the key and one multiplication j*c mod %d for each number of the text: %d + %d = %d (without the few steps of Euclid''s algorithm that find j).\n', p, per_number, numel(T.cipher), transport_all);
fprintf('  With a big n the difference is huge, because every RSA step works with very big numbers and the cipher of Point 1 needs only one small multiplication.\n');

% 5. every pair
allok = true;
for a = 1:nu
    for b = 1:nu
        if a ~= b
            Tq = rsa_key_transport(txt, k, a, b, R, S);
            allok = allok && Tq.agree && Tq.ok;
        end
    end
end
fprintf('\n5. Every pair of users\n');
fprintf('  The same key and the same message go from every user to every other user, %d times in all. The receiver gets the key and the text every time: %s.\n', nu * (nu - 1), answer{double(allok) + 1});

% 6. self-checks
checks = {
    sprintf('%s gets the key that %s chose', name2, name1), T.agree;
    sprintf('the encrypted key is a number from 0 to n-1 = %d', T.n - 1), T.key_cipher >= 0 && T.key_cipher <= T.n - 1;
    sprintf('the encrypted key is not the key itself (%d and %d)', T.key_cipher, k), T.key_cipher ~= k;
    sprintf('%s gets the same text that %s sent', name2, name1), T.ok;
    'the ciphertext has one number for each character of the text', numel(T.cipher) == numel(sym);
    'every ciphertext number is from 1 to p-1 (the set C)', all(ismember(T.cipher, S.cipher));
    sprintf('no other user gets the key or the text with the own private key (%d users tried)', numel(others)), none_gets;
    'every user sends the key and the text to every other user and the receiver gets both', allok;
    'one RSA decryption of the key and the text with the cipher is fewer multiplications than RSA for every number', transport_all < rsa_all};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
