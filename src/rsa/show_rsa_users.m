function show_rsa_users(S)
% SHOW_RSA_USERS Print the RSA keys of all users, a message from Alice to Bob, what the other users get and the number of keys.
%   show_rsa_users()   uses define_sets.
%   show_rsa_users(S)  uses the sets S (6 users).
if nargin < 1
    S = define_sets();
end
R = define_rsa_users(S);
nu = numel(S.users);
answer = {'NO', 'yes'};
txt = 'Meet me at the library at 5 pm, Bob.';
M = rsa_send_message(txt, 1, 2, R, S);
name1 = M.from;
name2 = M.to;
sym = text_to_symbols(txt);

fprintf('\n=== RSA USERS AND MESSAGES ===\n');
fprintf('Every user has an RSA key pair. The public keys are in a directory that everybody can read. Each user keeps the own private key. To send a message, the sender needs only the public key of the receiver: no key exchange is needed first.\n');

% 1. the keys
ed_ok = all(mod(R.e .* R.d, R.phi) == 1);
same_ok = (numel(unique(R.n)) == nu);
fprintf('\n1. The keys of the users\n');
fprintf('  The public directory (everybody can read it):\n');
fprintf('  %-8s%-8s%s\n', 'User', 'n', 'e');
for i = 1:nu
    fprintf('  %-8s%-8d%d\n', S.users{i}, R.n(i), R.e(i));
end
fprintf('  The private part (each user knows only the own numbers; p, q and phi must stay secret too):\n');
fprintf('  %-8s%-6s%-6s%-8s%s\n', 'User', 'p', 'q', 'phi', 'd');
for i = 1:nu
    fprintf('  %-8s%-6d%-6d%-8d%d\n', S.users{i}, R.p(i), R.q(i), R.phi(i), R.d(i));
end
fprintf('  Every user has a different n: %s. For every user e*d mod phi = 1: %s.\n', answer{double(same_ok) + 1}, answer{double(ed_ok) + 1});

% 2. one message
[c1, st1] = mod_pow(sym(1), M.e, M.n);
fprintf('\n2. %s sends a message to %s\n', name1, name2);
fprintf('  The message: %s\n', txt);
fprintf('  %s looks up the public key of %s in the directory: (n, e) = (%d, %d).\n', name1, name2, M.n, M.e);
fprintf('  The text has %d characters. Every character becomes a symbol (a space is 1, the character ~ is %d) and is encrypted alone: c = m^e mod n.\n', numel(sym), numel(S.plain));
fprintf('  Example: the first character %s is the symbol %d, and %d^%d mod %d = %d (%d squaring steps and %d multiplication steps).\n', txt(1), sym(1), sym(1), M.e, M.n, c1, size(st1, 1), sum(st1(:, 1)));
fprintf('  The %d numbers that cross the channel (numbers from 0 to n-1 = %d):\n', numel(M.cipher), M.n - 1);
fprintf('%s\n', rsa_format_numbers(M.cipher, 12));
fprintf('  %s decrypts every number c with the private key d = %d: m = c^d mod n. The text that %s gets: %s\n', name2, R.d(2), name2, M.received);
fprintf('  It is the same as the message: %s\n', answer{double(M.ok) + 1});

% 3. the other users
others = setdiff(1:nu, 2);
none_reads = true;
fprintf('\n3. What the other users get\n');
fprintf('  Only %s has the private key d = %d that fits the public key of %s. The other users decrypt the same %d numbers with their own private keys:\n', name2, R.d(2), name2, numel(M.cipher));
for i = others
    try
        wtxt = rsa_decrypt_text(M.cipher, R.n(2), R.d(i));
        stopped = false;
    catch
        wtxt = '';
        stopped = true;
    end
    if stopped
        fprintf('  %s with d = %d: the decryption stops, because a number turns into a value that is not a symbol.\n', S.users{i}, R.d(i));
    else
        fprintf('  %s with d = %d: only nonsense: %s\n', S.users{i}, R.d(i), wtxt);
    end
    none_reads = none_reads && (stopped || ~strcmp(wtxt, txt));
end

% 4. every pair
allok = true;
for a = 1:nu
    for b = 1:nu
        if a ~= b
            Mq = rsa_send_message(txt, a, b, R, S);
            allok = allok && Mq.ok;
        end
    end
end
fprintf('\n4. Every pair of users\n');
fprintf('  The same message goes from every user to every other user, %d messages in all. The receiver gets the same text every time: %s.\n', nu * (nu - 1), answer{double(allok) + 1});

% 5. how many keys
fprintf('\n5. How many keys are needed\n');
fprintf('  With Diffie-Hellman every pair of users has its own shared key: %d users have %d pairs, so %d keys, and two users must exchange public values first.\n', nu, nu * (nu - 1) / 2, nu * (nu - 1) / 2);
fprintf('  With RSA every user has only one key pair: %d users need %d key pairs, and a sender needs only the public key of the receiver.\n', nu, nu);

% 6. self-checks
checks = {
    'every user has a different modulus n', same_ok;
    'e*d = 1 (mod phi) for every user', ed_ok;
    sprintf('%s gets the same text that %s sent', name2, name1), M.ok;
    'the ciphertext has one number for each character of the text', numel(M.cipher) == numel(sym);
    sprintf('every ciphertext number is from 0 to n-1 = %d', M.n - 1), all(M.cipher >= 0 & M.cipher <= M.n - 1);
    'every user sends to every other user and the receiver gets the text', allok;
    sprintf('no other user gets the text with the own private key (%d users tried)', numel(others)), none_reads};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for k = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{k, 1}, answer{double(checks{k, 2}) + 1});
end
end
