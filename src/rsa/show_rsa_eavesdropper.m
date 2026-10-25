function show_rsa_eavesdropper(S)
% SHOW_RSA_EAVESDROPPER Print what Eve can do against RSA: factor n, a list of all small numbers, and the key transport.
%   show_rsa_eavesdropper()   uses define_sets.
%   show_rsa_eavesdropper(S)  uses the sets S (6 users).
%   Eve listens to the channel between Alice and Bob. She knows no private key.
if nargin < 1
    S = define_sets();
end
R = define_rsa_users(S);
answer = {'NO', 'yes'};
txt = 'Meet me at the library at 5 pm, Bob.';
k = 85;
M = rsa_send_message(txt, 1, 2, R, S);
name1 = M.from;
name2 = M.to;
sym = text_to_symbols(txt);
E = eavesdrop_rsa(M.n, M.e);
got = rsa_decrypt_text(M.cipher, M.n, E.d);
A = eavesdrop_codebook(M.cipher, M.n, M.e);
T = rsa_key_transport(txt, k, 1, 2, R, S);

fprintf('\n=== THE EAVESDROPPER AND RSA ===\n');
fprintf('Eve listens to the channel between %s and %s. She knows no private key. She sees:\n', name1, name2);
fprintf('  the public key of %s: (n, e) = (%d, %d)\n', name2, M.n, M.e);
fprintf('  the encrypted message, %d numbers:\n', numel(M.cipher));
fprintf('%s\n', rsa_format_numbers(M.cipher, 12));

% 1. factoring
fprintf('\n1. Eve factors n\n');
fprintf('  She tries t = 2, 3, 4, ... until t divides n = %d.\n', M.n);
fprintf('  She finds %d after %d tries. So p = %d and q = n/p = %d / %d = %d.\n', E.p, E.tries, E.p, M.n, E.p, E.q);
fprintf('  She computes phi = (p-1)*(q-1) = %d * %d = %d, and the private exponent d, the inverse of e mod phi: d = %d.\n', E.p - 1, E.q - 1, E.phi, E.d);
fprintf('  This is the private key of %s: %s.\n', name2, answer{double(E.d == R.d(2)) + 1});
fprintf('  She decrypts the message with d: %s\n', got);
fprintf('  Eve reads the message: %s\n', answer{double(strcmp(got, txt)) + 1});
fprintf('  This works because n is small: there are only %d numbers to try (from 2 to the square root of n).\n', E.worst);

% 2. a bigger n
tab_p = [11 101 1009 8009];
tab_q = [13 103 1013 8011];
tab_e = [7 7 17 17];
tab = zeros(numel(tab_p), 4);
tab_ok = true;
for r = 1:numel(tab_p)
    Kr = rsa_make_keys(tab_p(r), tab_q(r), tab_e(r));
    Er = eavesdrop_rsa(Kr.n, Kr.e);
    tab(r, :) = [Kr.n, floor(log2(Kr.n)) + 1, Er.tries, Er.worst];
    tab_ok = tab_ok && (Er.d == Kr.d);
end
fprintf('\n2. Why a big n is needed\n');
fprintf('  Eve tries the numbers from 2 up to the smaller prime p, so she needs at most the square root of n tries. The table gives key pairs with bigger and bigger n.\n');
fprintf('  %-12s%-10s%-12s%-12s%s\n', 'n', 'bits', 'tries', 'most tries', 'Eve gets the right d');
for r = 1:size(tab, 1)
    fprintf('  %-12d%-10d%-12d%-12d%s\n', tab(r, 1), tab(r, 2), tab(r, 3), tab(r, 4), answer{double(tab_ok) + 1});
end
fprintf('  The number of tries grows with the square root of n. A modulus with 2048 bits (a number with 617 digits) would need up to 2^1024 tries, which is impossible. Faster factoring methods exist, but they are also far too slow for such an n. Real systems use moduli like that. This project uses small n on purpose, so that every step can be checked by hand.\n');

% 3. the list
fprintf('\n3. Eve uses a list of all small numbers\n');
fprintf('  Every character is encrypted alone, so every number of the message is the encryption of one number from 1 to %d. Eve can skip the factoring.\n', numel(S.cipher));
fprintf('  She encrypts every number t from 1 to %d with the public key of %s and writes the results in a list. For example t = %d (the symbol of the character %s) gives %d^%d mod %d = %d.\n', A.tries, name2, sym(1), txt(1), sym(1), M.e, M.n, A.book(sym(1)));
fprintf('  She looks up every number of the message in the list. The numbers found: %d of %d.\n', A.found, numel(M.cipher));
fprintf('  The text that she reads: %s\n', A.text);
fprintf('  Eve reads the message: %s\n', answer{double(strcmp(A.text, txt)) + 1});
fprintf('  She needed only %d encryptions and no private key. The same character always gives the same number, so the list works for every message to %s. Real RSA adds random padding to every block, so that such a list cannot exist.\n', A.tries, name2);

% 4. the key transport
k_eve = mod_pow(T.key_cipher, E.d, T.n);
try
    t_eve = decrypt_text(T.cipher, k_eve, S);
catch
    t_eve = '';
end
A2 = eavesdrop_codebook(T.key_cipher, T.n, T.e);
k_list = A2.values(1);
try
    t_list = decrypt_text(T.cipher, k_list, S);
catch
    t_list = '';
end
fprintf('\n4. Eve and the key transport\n');
fprintf('  Now %s sends the key k = %d to %s with RSA, and then the same message with the cipher of Point 1 and this key. Eve sees the number c = %d and the %d numbers of the text.\n', name1, k, name2, T.key_cipher, numel(T.cipher));
fprintf('  With the private exponent d = %d that she found by factoring n, she computes k = c^d mod n = %d^%d mod %d = %d.\n', E.d, T.key_cipher, E.d, T.n, k_eve);
fprintf('  She decrypts the text with the key %d: %s\n', k_eve, t_eve);
fprintf('  The list also gives the key: the key is a number from 1 to %d, so the list entry for t = %d is %d, the number c. She finds the key %d without factoring.\n', S.prime - 1, k_list, A2.book(k_list), k_list);
fprintf('  She decrypts the text with the key %d: %s\n', k_list, t_list);
fprintf('  Eve reads the message: %s\n', answer{double(strcmp(t_eve, txt) && strcmp(t_list, txt)) + 1});
fprintf('  A key with only %d possible values is too small to transport with textbook RSA. Real systems send a long random key with padding.\n', S.prime - 1);

% 5. self-checks
checks = {
    sprintf('Eve finds the primes of %s: p = %d and q = %d', name2, min(R.p(2), R.q(2)), max(R.p(2), R.q(2))), E.p == min(R.p(2), R.q(2)) && E.q == max(R.p(2), R.q(2));
    'the number of tries is p-1', E.tries == E.p - 1;
    sprintf('Eve gets the private exponent d of %s', name2), E.d == R.d(2);
    'Eve reads the message with her d', strcmp(got, txt);
    'in the table, Eve gets the right private exponent for every n', tab_ok;
    'in the table, the number of tries is never more than the most tries', all(tab(:, 3) <= tab(:, 4));
    'the list has the encryption of every number from 1 to 96 and finds all numbers of the message', A.all_found && A.found == numel(M.cipher);
    'Eve reads the message with the list and no private key', strcmp(A.text, txt);
    sprintf('Eve gets the key k = %d with her d and with the list', k), k_eve == k && k_list == k;
    'Eve reads the text that was sent with the key, both ways', strcmp(t_eve, txt) && strcmp(t_list, txt)};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
