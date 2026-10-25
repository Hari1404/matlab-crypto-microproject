function show_encryption(S)
% SHOW_ENCRYPTION Print the encryption of a message with the Diffie-Hellman shared key.
%   show_encryption()   uses define_sets.
%   show_encryption(S)  uses the prime p and the users in the struct S.
if nargin < 1
    S = define_sets();
end
p = S.prime;
n = numel(S.users);
answer = {'NO', 'yes'};
D = define_secrets(S);
txt = 'Meet me at the library at 5 pm, Bob.';
M = send_message(txt, 1, 2, D, S);
name1 = M.from;
name2 = M.to;
sym = text_to_symbols(txt);
K = dh_key_table(D, p);
j = key_inverse(M.key_receiver, S);

fprintf('\n=== ENCRYPTION WITH THE SHARED KEY ===\n');
fprintf('The shared key of two users is the key k of the cipher E_k(m) = k*m mod %d. The secret numbers stay with their users.\n', p);

% 1. one message
fprintf('\n1. %s sends a message to %s\n', name1, name2);
fprintf('  The message: %s\n', txt);
fprintf('  %s computes the key B^a mod p = %d^%d mod %d = %d.\n', name1, M.public_to, D.private(1), p, M.key_sender);
fprintf('  %s computes the key A^b mod p = %d^%d mod %d = %d.\n', name2, M.public_from, D.private(2), p, M.key_receiver);
fprintf('  Both keys are the same: %s. This is the key k of the cipher.\n', answer{double(M.agree) + 1});
fprintf('  The text has %d characters. Every character becomes a symbol (a space is 1, the character ~ is %d) and is encrypted with k.\n', numel(sym), numel(S.plain));
fprintf('  Example: the first character %s is the symbol %d, and k*m mod p = %d * %d mod %d = %d.\n', txt(1), sym(1), M.key_sender, sym(1), p, M.cipher(1));
fprintf('  The %d numbers that cross the channel:\n', numel(M.cipher));
fprintf('%s\n', format_numbers(M.cipher, 12));
fprintf('  %s finds the inverse key j = %d (because %d * %d mod %d = 1) and computes j*c mod %d for every number c.\n', name2, j, M.key_receiver, j, p, p);
fprintf('  The text that %s gets: %s\n', name2, M.received);
fprintf('  It is the same as the message: %s\n', answer{double(M.ok) + 1});

% 2. a wrong key
wrongk = K(1, 3);
try
    wtxt = decrypt_text(M.cipher, wrongk, S);
    stopped = false;
catch
    wtxt = '';
    stopped = true;
end
fprintf('\n2. What a wrong key gives\n');
fprintf('  Suppose %s decrypts the same numbers with the key of %s and %s, which is %d.\n', name2, S.users{1}, S.users{3}, wrongk);
if stopped
    fprintf('  The decryption stops, because a number turns into a value that is not a symbol (not from 1 to %d). This is not the right key.\n', numel(S.plain));
else
    fprintf('  The result is only nonsense: %s\n', wtxt);
end

% 3. every pair
allok = true;
for a = 1:n
    for b = 1:n
        if a ~= b
            Mq = send_message(txt, a, b, D, S);
            allok = allok && Mq.ok;
        end
    end
end
fprintf('\n3. Every pair of users\n');
fprintf('  The same message goes from every user to every other user, %d messages in all. The receiver gets the same text every time: %s.\n', n * (n - 1), answer{double(allok) + 1});

% 4. self-checks
checks = {
    sprintf('%s and %s compute the same key', name1, name2), M.agree;
    sprintf('%s gets the same text that %s sent', name2, name1), M.ok;
    'the key is the key in the table of keys (dh_key_table)', M.key_sender == K(1, 2);
    'the ciphertext has one value for each character of the text', numel(M.cipher) == numel(sym);
    'every ciphertext value is a number from 1 to p-1 (the set C)', all(ismember(M.cipher, S.cipher));
    'every user sends to every other user and the receiver gets the text', allok;
    'a wrong key does not give the message back', stopped || ~strcmp(wtxt, txt)};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
