function test_rsa_users()
% TEST_RSA_USERS Checks for RSA with the users: define_rsa_users, check_rsa_users, rsa_send_message, rsa_key_transport,
%   eavesdrop_rsa, eavesdrop_codebook, show_rsa_users, show_rsa_transport, show_rsa_eavesdropper and demo_point7.
%   The expected numbers come from an independent Python program (plain pow), or from repeated multiplication here.
S = define_sets();
R = define_rsa_users(S);
txt = 'Meet me at the library at 5 pm, Bob.';
sym = double(txt) - 31;
c = cell(0, 2);

n_ref = [3233 2773 2881 2627 2449 2993];
phi_ref = [3120 2668 2772 2520 2340 2880];
e_ref = [17 17 5 11 7 7];
d_ref = [2753 157 1109 2291 1003 823];
p_ref = [61 47 43 71 79 73];
q_ref = [53 59 67 37 31 41];
ab_ref = [1315 1017 1017 560 1 728 1017 1 872 560 1 560 928 1017 1 762 1982 2248 1471 872 1471 2652 1 872 560 1 2645 1 580 728 219 1 181 1523 2248 1392];
ag_ref = [1414 1536 1536 342 1 672 1536 1 1138 342 1 342 2920 1536 1 1784 1023 1114 1190 1138 1190 125 1 1138 342 1 667 1 81 672 272 1 12 979 1114 977];
ac_ref = [286 2387 2387 1977 1 385 2387 1];
key85_ref = [2310 560 1977 582 1145 342];
key96_ref = [494 600 1444 1942 823 2955];
key2_ref = [1752 741 32 2048 128 128];

% --- define_rsa_users ---
fn = fieldnames(R)';
c(end+1, :) = {'define_rsa_users has the fields users, p, q, n, phi, e, d in this order', isequal(fn, {'users', 'p', 'q', 'n', 'phi', 'e', 'd'})};
c(end+1, :) = {'R.users is the list of users of define_sets', isequal(R.users, S.users)};
c(end+1, :) = {'R.p is 61 47 43 71 79 73', isequal(R.p, p_ref)};
c(end+1, :) = {'R.q is 53 59 67 37 31 41', isequal(R.q, q_ref)};
c(end+1, :) = {'R.n is 3233 2773 2881 2627 2449 2993', isequal(R.n, n_ref)};
c(end+1, :) = {'R.phi is 3120 2668 2772 2520 2340 2880', isequal(R.phi, phi_ref)};
c(end+1, :) = {'R.e is 17 17 5 11 7 7', isequal(R.e, e_ref)};
c(end+1, :) = {'R.d is 2753 157 1109 2291 1003 823', isequal(R.d, d_ref)};
c(end+1, :) = {'every field has one number for each of the 6 users (1 by 6)', isequal(size(R.p), [1 6]) && isequal(size(R.q), [1 6]) && isequal(size(R.n), [1 6]) && isequal(size(R.phi), [1 6]) && isequal(size(R.e), [1 6]) && isequal(size(R.d), [1 6])};
c(end+1, :) = {'n = p*q and phi = (p-1)*(q-1) for every user (computed again here)', isequal(R.n, R.p .* R.q) && isequal(R.phi, (R.p - 1) .* (R.q - 1))};
c(end+1, :) = {'e*d mod phi = 1 for every user (computed again here)', all(mod(R.e .* R.d, R.phi) == 1)};
c(end+1, :) = {'the 6 moduli n are different', numel(unique(R.n)) == 6};
c(end+1, :) = {'define_rsa_users() gives the same as define_rsa_users(S)', isequal(define_rsa_users(), R)};
S2 = S;
S2.users = {'A', 'B', 'C', 'D', 'E', 'F'};
R2 = define_rsa_users(S2);
c(end+1, :) = {'other names of users give the same numbers with the new names', isequal(R2.users, S2.users) && isequal(R2.n, R.n) && isequal(R2.d, R.d)};
S5 = S;
S5.users = S.users(1:5);
S7 = S;
S7.users = [S.users, {'Heidi'}];
c(end+1, :) = {'5 users are rejected with define_rsa_users:count', strcmp(error_id(@() define_rsa_users(S5)), 'define_rsa_users:count')};
c(end+1, :) = {'7 users are rejected with define_rsa_users:count', strcmp(error_id(@() define_rsa_users(S7)), 'define_rsa_users:count')};
Sbad = struct('prime', 97);
Sbad2 = S;
Sbad2.users = 'Alice';
c(end+1, :) = {'a struct without users, a number and users that are not a list are rejected with define_rsa_users:sets', strcmp(error_id(@() define_rsa_users(Sbad)), 'define_rsa_users:sets') && strcmp(error_id(@() define_rsa_users(5)), 'define_rsa_users:sets') && strcmp(error_id(@() define_rsa_users(Sbad2)), 'define_rsa_users:sets')};

% --- check_rsa_users ---
c(end+1, :) = {'check_rsa_users accepts the keys of define_rsa_users (with and without S)', ~raises_error(@() check_rsa_users(R, S)) && ~raises_error(@() check_rsa_users(R))};
names = {'p', 'q', 'n', 'phi', 'e', 'd'};
for k = 1:numel(names)
    Rm = rmfield(R, names{k});
    c(end+1, :) = {sprintf('check_rsa_users: the missing field %s is rejected with :fields', names{k}), strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
    Rm = R;
    Rm.(names{k}) = R.(names{k})(1:5);
    c(end+1, :) = {sprintf('check_rsa_users: only 5 numbers in %s are rejected with :fields', names{k}), strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
    Rm = R;
    Rm.(names{k}) = R.(names{k})';
    c(end+1, :) = {sprintf('check_rsa_users: a column in %s is rejected with :fields', names{k}), strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
    Rm = R;
    Rm.(names{k}) = 'abcdef';
    c(end+1, :) = {sprintf('check_rsa_users: a text in %s is rejected with :fields', names{k}), strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
end
Rm = rmfield(R, 'users');
c(end+1, :) = {'check_rsa_users: the missing field users is rejected with :fields', strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
Rm = R;
Rm.users = S.users(1:5);
c(end+1, :) = {'check_rsa_users: 5 names in users are rejected with :fields', strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
Rm = R;
Rm.users = 'Alice';
c(end+1, :) = {'check_rsa_users: users that is a text are rejected with :fields', strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
Rm = R;
Rm.n = R.n + 1i;
c(end+1, :) = {'check_rsa_users: complex numbers are rejected with :fields', strcmp(error_id(@() check_rsa_users(Rm, S)), 'check_rsa_users:fields')};
c(end+1, :) = {'check_rsa_users: a number, a text, a cell and a list of structs are rejected with :fields', strcmp(error_id(@() check_rsa_users(5, S)), 'check_rsa_users:fields') && strcmp(error_id(@() check_rsa_users('abc', S)), 'check_rsa_users:fields') && strcmp(error_id(@() check_rsa_users({}, S)), 'check_rsa_users:fields') && strcmp(error_id(@() check_rsa_users([R R], S)), 'check_rsa_users:fields')};
c(end+1, :) = {'check_rsa_users: R for 6 users with S for 5 users is rejected with :fields', strcmp(error_id(@() check_rsa_users(R, S5)), 'check_rsa_users:fields')};
Rk = R;
Rk.d(1) = 2752;
c(end+1, :) = {'check_rsa_users: a wrong d (2752 for Alice) is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key')};
msg = error_msg(@() check_rsa_users(Rk, S));
c(end+1, :) = {'check_rsa_users: the message names Alice and e*d', ~isempty(strfind(msg, 'The key of Alice is not proper')) && ~isempty(strfind(msg, 'e*d is not 1 mod phi'))};
Rk = R;
Rk.d(3) = 0;
c(end+1, :) = {'check_rsa_users: d = 0 is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key')};
Rk = R;
Rk.d(3) = R.phi(3);
c(end+1, :) = {'check_rsa_users: d = phi is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key')};
Rk = R;
Rk.d(3) = 1109.5;
c(end+1, :) = {'check_rsa_users: d = 1109.5 is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key')};
Rk = R;
Rk.d(1) = R.d(1) + R.phi(1);
c(end+1, :) = {'check_rsa_users: d + phi (5873 for Alice, still e*d = 1 mod phi but bigger than phi - 1) is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key') && mod(Rk.e(1) * Rk.d(1), Rk.phi(1)) == 1};
Rk = R;
Rk.p(3) = 44;
c(end+1, :) = {'check_rsa_users: p = 44 (not a prime) for Carol is rejected with :key and the message names Carol', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key') && ~isempty(strfind(error_msg(@() check_rsa_users(Rk, S)), 'The key of Carol is not proper'))};
Rk = R;
Rk.e(4) = 3;
c(end+1, :) = {'check_rsa_users: e = 3 for Dave (gcd 3 with phi = 2520) is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key') && ~isempty(strfind(error_msg(@() check_rsa_users(Rk, S)), 'The key of Dave is not proper'))};
Rk = R;
Rk.e(2) = 2;
c(end+1, :) = {'check_rsa_users: e = 2 for Bob is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key')};
Rk = R;
Rk.q(1) = Rk.p(1);
c(end+1, :) = {'check_rsa_users: p = q for Alice is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key')};
Rk = R;
Rk.n(5) = 2450;
c(end+1, :) = {'check_rsa_users: n that is not p*q for Frank is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key') && ~isempty(strfind(error_msg(@() check_rsa_users(Rk, S)), 'The key of Frank is not proper')) && ~isempty(strfind(error_msg(@() check_rsa_users(Rk, S)), 'n or phi does not fit p and q'))};
Rk = R;
Rk.phi(6) = 2881;
c(end+1, :) = {'check_rsa_users: phi that is not (p-1)*(q-1) for Grace is rejected with :key', strcmp(error_id(@() check_rsa_users(Rk, S)), 'check_rsa_users:key') && ~isempty(strfind(error_msg(@() check_rsa_users(Rk, S)), 'The key of Grace is not proper')) && ~isempty(strfind(error_msg(@() check_rsa_users(Rk, S)), 'n or phi does not fit p and q'))};
Rs = R;
for k = 1:numel(names)
    Rs.(names{k})(2) = R.(names{k})(1);
end
c(end+1, :) = {'check_rsa_users: Bob with the whole key of Alice is rejected with :same', strcmp(error_id(@() check_rsa_users(Rs, S)), 'check_rsa_users:same')};
Rs = R;
Rs.p(2) = 53;
Rs.q(2) = 61;
Rs.n(2) = 3233;
Rs.phi(2) = 3120;
Rs.e(2) = 17;
Rs.d(2) = 2753;
c(end+1, :) = {'check_rsa_users: Bob with p and q of Alice in the other order is rejected with :same', strcmp(error_id(@() check_rsa_users(Rs, S)), 'check_rsa_users:same')};

% --- rsa_send_message ---
M = rsa_send_message(txt, 1, 2, R, S);
ref = zeros(1, numel(sym));
back = zeros(1, numel(sym));
for q = 1:numel(sym)
    ref(q) = slow_pow(sym(q), 17, 2773);
    back(q) = slow_pow(M.cipher(q), 157, 2773);
end
c(end+1, :) = {'rsa_send_message has the fields from, to, i, j, text, n, e, cipher, received, ok in this order', isequal(fieldnames(M)', {'from', 'to', 'i', 'j', 'text', 'n', 'e', 'cipher', 'received', 'ok'})};
c(end+1, :) = {'Alice to Bob: from, to, i, j and text', strcmp(M.from, 'Alice') && strcmp(M.to, 'Bob') && M.i == 1 && M.j == 2 && strcmp(M.text, txt)};
c(end+1, :) = {'Alice to Bob: the public key of Bob (2773, 17) is used', M.n == 2773 && M.e == 17};
c(end+1, :) = {'Alice to Bob: the ciphertext is the list from the Python program', isequal(M.cipher, ab_ref)};
c(end+1, :) = {'Alice to Bob: the ciphertext is the same with repeated multiplication', isequal(M.cipher, ref)};
c(end+1, :) = {'Alice to Bob: repeated multiplication with d = 157 gives the symbols back', isequal(back, sym)};
c(end+1, :) = {'Alice to Bob: Bob gets the text and ok is true', strcmp(M.received, txt) && M.ok == true};
c(end+1, :) = {'Alice to Bob: the ciphertext has 36 numbers from 0 to 2772', numel(M.cipher) == 36 && all(M.cipher >= 0 & M.cipher <= 2772)};
c(end+1, :) = {'the same character gives the same number (the 8 spaces are all 1)', sum(M.cipher == 1) == 8 && all(M.cipher(sym == 1) == 1)};
c(end+1, :) = {'rsa_send_message(txt, 1, 2) gives the same as with R and S', isequal(rsa_send_message(txt, 1, 2), M)};
M3 = rsa_send_message(txt, 1, 3, R, S);
c(end+1, :) = {'Alice to Carol: the public key of Carol (2881, 5) and the first 8 numbers 286 2387 2387 1977 1 385 2387 1', M3.n == 2881 && M3.e == 5 && isequal(M3.cipher(1:8), ac_ref) && M3.ok == true};
M6 = rsa_send_message(txt, 1, 6, R, S);
c(end+1, :) = {'Alice to Grace: the public key (2993, 7) and the 36 numbers from the Python program', M6.n == 2993 && M6.e == 7 && isequal(M6.cipher, ag_ref) && M6.ok == true};
Mh = rsa_send_message('Hello, RSA!', 5, 6, R, S);
c(end+1, :) = {'Frank to Grace: ''Hello, RSA!'' gives the 11 numbers 328 1536 1784 1784 979 272 1 428 2864 1254 128', isequal(Mh.cipher, [328 1536 1784 1784 979 272 1 428 2864 1254 128]) && Mh.ok == true && strcmp(Mh.from, 'Frank') && strcmp(Mh.to, 'Grace')};
Mi = rsa_send_message('Hi', 2, 1, R, S);
c(end+1, :) = {'Bob to Alice: ''Hi'' gives 3199 1877 with the key (3233, 17)', isequal(Mi.cipher, [3199 1877]) && Mi.ok == true};
Ma = rsa_send_message('a', 1, 4, R, S);
c(end+1, :) = {'Alice to Dave: one character ''a'' gives the one number 208', isequal(Ma.cipher, 208) && Ma.ok == true && strcmp(Ma.received, 'a')};
alltxt = char(32:126);
Mall = rsa_send_message(alltxt, 1, 2, R, S);
c(end+1, :) = {'all 95 printable characters go from Alice to Bob and come back', Mall.ok == true && strcmp(Mall.received, alltxt) && numel(Mall.cipher) == 95};
c(end+1, :) = {'all 95 printable characters: the first 5 and the last 3 numbers and the sum are from the Python program', isequal(Mall.cipher(1:5), [1 741 1553 27 508]) && isequal(Mall.cipher(end-2:end), [2067 1833 189]) && sum(Mall.cipher) == 128123};
Mlong = rsa_send_message(repmat(txt, 1, 10), 3, 5, R, S);
c(end+1, :) = {'a text of 360 characters goes from Carol to Frank and comes back', Mlong.ok == true && numel(Mlong.cipher) == 360};
Ralt = R;
Kalt = rsa_make_keys(67, 71, 17);
Ralt.p(1) = Kalt.p;
Ralt.q(1) = Kalt.q;
Ralt.n(1) = Kalt.n;
Ralt.phi(1) = Kalt.phi;
Ralt.e(1) = Kalt.e;
Ralt.d(1) = Kalt.d;
Malt = rsa_send_message(txt, 1, 2, Ralt, S);
c(end+1, :) = {'another key for the sender Alice gives the same ciphertext (the sender needs only the public key of Bob)', isequal(Malt.cipher, M.cipher) && Malt.ok == true};
Rbob = R;
Kbob = rsa_make_keys(83, 89, 5);
Rbob.p(2) = Kbob.p;
Rbob.q(2) = Kbob.q;
Rbob.n(2) = Kbob.n;
Rbob.phi(2) = Kbob.phi;
Rbob.e(2) = Kbob.e;
Rbob.d(2) = Kbob.d;
Mbob = rsa_send_message(txt, 1, 2, Rbob, S);
c(end+1, :) = {'another key for the receiver Bob gives another ciphertext, and Bob still gets the text', ~isequal(Mbob.cipher, M.cipher) && Mbob.n == Kbob.n && Mbob.e == 5 && Mbob.ok == true};
pairs_ok = true;
for a = 1:6
    for b = 1:6
        if a ~= b
            Mq = rsa_send_message(txt, a, b, R, S);
            pairs_ok = pairs_ok && Mq.ok && Mq.n == n_ref(b) && Mq.e == e_ref(b) && strcmp(Mq.from, S.users{a}) && strcmp(Mq.to, S.users{b});
        end
    end
end
c(end+1, :) = {'all 30 pairs of different users: the receiver gets the text and the key of the receiver is used', pairs_ok};
c(end+1, :) = {'rsa_send_message: a bad sender is rejected with :sender (0, 7, 1.5, text, list, empty)', all(strcmp({error_id(@() rsa_send_message(txt, 0, 2, R, S)), error_id(@() rsa_send_message(txt, 7, 2, R, S)), error_id(@() rsa_send_message(txt, 1.5, 2, R, S)), error_id(@() rsa_send_message(txt, 'a', 2, R, S)), error_id(@() rsa_send_message(txt, [1 2], 2, R, S)), error_id(@() rsa_send_message(txt, [], 2, R, S))}, 'rsa_send_message:sender'))};
c(end+1, :) = {'rsa_send_message: a bad receiver is rejected with :receiver (0, 7, 2.5, text, list, empty)', all(strcmp({error_id(@() rsa_send_message(txt, 1, 0, R, S)), error_id(@() rsa_send_message(txt, 1, 7, R, S)), error_id(@() rsa_send_message(txt, 1, 2.5, R, S)), error_id(@() rsa_send_message(txt, 1, 'a', R, S)), error_id(@() rsa_send_message(txt, 1, [1 2], R, S)), error_id(@() rsa_send_message(txt, 1, [], R, S))}, 'rsa_send_message:receiver'))};
c(end+1, :) = {'rsa_send_message: sender = receiver is rejected with :same', strcmp(error_id(@() rsa_send_message(txt, 3, 3, R, S)), 'rsa_send_message:same')};
c(end+1, :) = {'rsa_send_message: a bad text is rejected with :text (empty, number, two rows, cell)', all(strcmp({error_id(@() rsa_send_message('', 1, 2, R, S)), error_id(@() rsa_send_message(5, 1, 2, R, S)), error_id(@() rsa_send_message(['ab'; 'cd'], 1, 2, R, S)), error_id(@() rsa_send_message({'a'}, 1, 2, R, S))}, 'rsa_send_message:text'))};
c(end+1, :) = {'rsa_send_message: a text with a tab character is rejected', raises_error(@() rsa_send_message(['a' char(9) 'b'], 1, 2, R, S))};
c(end+1, :) = {'rsa_send_message: the sender is checked before the receiver and the text', strcmp(error_id(@() rsa_send_message('', 0, 0, R, S)), 'rsa_send_message:sender') && strcmp(error_id(@() rsa_send_message('', 1, 0, R, S)), 'rsa_send_message:receiver') && strcmp(error_id(@() rsa_send_message('', 1, 1, R, S)), 'rsa_send_message:same')};
Rbad = R;
Rbad.d(1) = 2752;
Rbad2 = R;
Rbad2.d(2) = 156;
c(end+1, :) = {'rsa_send_message: bad keys (a wrong d of the sender or of the receiver) are rejected with check_rsa_users:key', strcmp(error_id(@() rsa_send_message(txt, 1, 2, Rbad, S)), 'check_rsa_users:key') && strcmp(error_id(@() rsa_send_message(txt, 1, 2, Rbad2, S)), 'check_rsa_users:key')};
c(end+1, :) = {'rsa_send_message: R that is not a struct is rejected with check_rsa_users:fields', strcmp(error_id(@() rsa_send_message(txt, 1, 2, 5, S)), 'check_rsa_users:fields')};

% --- rsa_key_transport ---
T = rsa_key_transport(txt, 85, 1, 2, R, S);
c(end+1, :) = {'rsa_key_transport has the fields from, to, i, j, text, key, n, e, key_cipher, key_received, agree, cipher, received, ok in this order', isequal(fieldnames(T)', {'from', 'to', 'i', 'j', 'text', 'key', 'n', 'e', 'key_cipher', 'key_received', 'agree', 'cipher', 'received', 'ok'})};
c(end+1, :) = {'Alice sends the key 85 to Bob: from, to, i, j, text and key', strcmp(T.from, 'Alice') && strcmp(T.to, 'Bob') && T.i == 1 && T.j == 2 && strcmp(T.text, txt) && T.key == 85};
c(end+1, :) = {'Alice sends the key 85 to Bob: the public key of Bob (2773, 17) and key_cipher 560', T.n == 2773 && T.e == 17 && T.key_cipher == 560};
c(end+1, :) = {'Alice sends the key 85 to Bob: key_cipher is the same with repeated multiplication', T.key_cipher == slow_pow(85, 17, 2773)};
c(end+1, :) = {'Alice sends the key 85 to Bob: Bob gets the key 85 and agree is true', T.key_received == 85 && T.agree == true};
c(end+1, :) = {'Alice sends the key 85 to Bob: the text is encrypted with k*m mod 97 (computed again here)', isequal(T.cipher, mod(85 * sym, 97))};
c(end+1, :) = {'Alice sends the key 85 to Bob: Bob gets the text and ok is true', strcmp(T.received, txt) && T.ok == true};
c(end+1, :) = {'rsa_key_transport(txt, 85, 1, 2) gives the same as with R and S', isequal(rsa_key_transport(txt, 85, 1, 2), T)};
Th = rsa_key_transport('Hello', 85, 3, 2, R, S);
c(end+1, :) = {'Carol sends the key 85 and ''Hello'' to Bob: the text numbers are 90 33 46 46 10', isequal(Th.cipher, [90 33 46 46 10]) && Th.ok == true && Th.key_cipher == 560};
keys_ok = true;
for j = 1:6
    a = mod(j, 6) + 1;
    Tj = rsa_key_transport(txt, 85, a, j, R, S);
    keys_ok = keys_ok && Tj.key_cipher == key85_ref(j) && Tj.agree && Tj.ok;
end
c(end+1, :) = {'the key 85 sent to each of the 6 users gives 2310 560 1977 582 1145 342 and arrives', keys_ok};
T1 = rsa_key_transport(txt, 1, 1, 2, R, S);
T96 = rsa_key_transport(txt, 96, 1, 2, R, S);
T2 = rsa_key_transport(txt, 2, 1, 2, R, S);
c(end+1, :) = {'the key 1 gives key_cipher 1, a text that is its own symbols, and arrives', T1.key_cipher == 1 && isequal(T1.cipher, sym) && T1.ok == true && T1.agree == true};
c(end+1, :) = {'the key 96 gives key_cipher 600 and the key 2 gives 741 (to Bob), and both arrive', T96.key_cipher == 600 && T96.ok == true && T2.key_cipher == 741 && T2.ok == true};
all_keys_ok = true;
for k = 1:96
    Tk = rsa_key_transport('Hello', k, 1, 2, R, S);
    all_keys_ok = all_keys_ok && Tk.agree && Tk.ok && Tk.key_received == k;
end
c(end+1, :) = {'every key from 1 to 96 goes from Alice to Bob (also 47 and 59, which divide n = 2773) and the text arrives', all_keys_ok};
keys96_ok = true;
for j = 1:6
    a = mod(j, 6) + 1;
    Tj = rsa_key_transport('Hi', 96, a, j, R, S);
    Tg = rsa_key_transport('Hi', 2, a, j, R, S);
    keys96_ok = keys96_ok && Tj.key_cipher == key96_ref(j) && Tg.key_cipher == key2_ref(j);
end
c(end+1, :) = {'the keys 96 and 2 sent to each of the 6 users give the numbers of the Python program', keys96_ok};
tpairs_ok = true;
for a = 1:6
    for b = 1:6
        if a ~= b
            Tq = rsa_key_transport(txt, 85, a, b, R, S);
            tpairs_ok = tpairs_ok && Tq.agree && Tq.ok && Tq.n == n_ref(b);
        end
    end
end
c(end+1, :) = {'all 30 pairs of different users: the receiver gets the key 85 and the text', tpairs_ok};
Talt = rsa_key_transport(txt, 85, 1, 2, Ralt, S);
c(end+1, :) = {'another key for the sender Alice gives the same encrypted key (560)', Talt.key_cipher == 560 && Talt.ok == true};
Tbob = rsa_key_transport(txt, 85, 1, 2, Rbob, S);
c(end+1, :) = {'another key for the receiver Bob gives another encrypted key, and Bob still gets the key', Tbob.key_cipher ~= 560 && Tbob.agree == true && Tbob.ok == true};
c(end+1, :) = {'rsa_key_transport: a bad key is rejected with :key (0, 97, 1.5, text, empty, list, -5, 1000)', all(strcmp({error_id(@() rsa_key_transport(txt, 0, 1, 2, R, S)), error_id(@() rsa_key_transport(txt, 97, 1, 2, R, S)), error_id(@() rsa_key_transport(txt, 1.5, 1, 2, R, S)), error_id(@() rsa_key_transport(txt, 'a', 1, 2, R, S)), error_id(@() rsa_key_transport(txt, [], 1, 2, R, S)), error_id(@() rsa_key_transport(txt, [1 2], 1, 2, R, S)), error_id(@() rsa_key_transport(txt, -5, 1, 2, R, S)), error_id(@() rsa_key_transport(txt, 1000, 1, 2, R, S))}, 'rsa_key_transport:key'))};
c(end+1, :) = {'rsa_key_transport: a bad sender is rejected with :sender', all(strcmp({error_id(@() rsa_key_transport(txt, 85, 0, 2, R, S)), error_id(@() rsa_key_transport(txt, 85, 7, 2, R, S)), error_id(@() rsa_key_transport(txt, 85, 1.5, 2, R, S)), error_id(@() rsa_key_transport(txt, 85, [], 2, R, S))}, 'rsa_key_transport:sender'))};
c(end+1, :) = {'rsa_key_transport: a bad receiver is rejected with :receiver', all(strcmp({error_id(@() rsa_key_transport(txt, 85, 1, 0, R, S)), error_id(@() rsa_key_transport(txt, 85, 1, 7, R, S)), error_id(@() rsa_key_transport(txt, 85, 1, 2.5, R, S)), error_id(@() rsa_key_transport(txt, 85, 1, [], R, S))}, 'rsa_key_transport:receiver'))};
c(end+1, :) = {'rsa_key_transport: sender = receiver is rejected with :same', strcmp(error_id(@() rsa_key_transport(txt, 85, 4, 4, R, S)), 'rsa_key_transport:same')};
c(end+1, :) = {'rsa_key_transport: a bad text is rejected with :text', all(strcmp({error_id(@() rsa_key_transport('', 85, 1, 2, R, S)), error_id(@() rsa_key_transport(5, 85, 1, 2, R, S)), error_id(@() rsa_key_transport(['ab'; 'cd'], 85, 1, 2, R, S))}, 'rsa_key_transport:text'))};
c(end+1, :) = {'rsa_key_transport: the sender is checked before the receiver, the text and the key', strcmp(error_id(@() rsa_key_transport('', 0, 0, 0, R, S)), 'rsa_key_transport:sender') && strcmp(error_id(@() rsa_key_transport('', 0, 1, 0, R, S)), 'rsa_key_transport:receiver') && strcmp(error_id(@() rsa_key_transport('', 0, 1, 1, R, S)), 'rsa_key_transport:same') && strcmp(error_id(@() rsa_key_transport('', 0, 1, 2, R, S)), 'rsa_key_transport:text')};
c(end+1, :) = {'rsa_key_transport: bad keys R are rejected with check_rsa_users:key', strcmp(error_id(@() rsa_key_transport(txt, 85, 1, 2, Rbad, S)), 'check_rsa_users:key') && strcmp(error_id(@() rsa_key_transport(txt, 85, 1, 2, Rbad2, S)), 'check_rsa_users:key')};

% --- eavesdrop_rsa ---
E = eavesdrop_rsa(2773, 17);
c(end+1, :) = {'eavesdrop_rsa has the fields n, e, p, q, phi, d, tries, worst in this order', isequal(fieldnames(E)', {'n', 'e', 'p', 'q', 'phi', 'd', 'tries', 'worst'})};
c(end+1, :) = {'eavesdrop_rsa(2773, 17): n, e, p = 47, q = 59, phi = 2668, d = 157', E.n == 2773 && E.e == 17 && E.p == 47 && E.q == 59 && E.phi == 2668 && E.d == 157};
c(end+1, :) = {'eavesdrop_rsa(2773, 17): 46 tries and at most 51', E.tries == 46 && E.worst == 51};
c(end+1, :) = {'eavesdrop_rsa(2773, 17): the tries are the same counted again here', E.tries == slow_tries(2773)};
E2 = eavesdrop_rsa(2881, 5);
c(end+1, :) = {'eavesdrop_rsa(2881, 5): p = 43, q = 67, phi = 2772, d = 1109, 42 tries, at most 52', E2.p == 43 && E2.q == 67 && E2.phi == 2772 && E2.d == 1109 && E2.tries == 42 && E2.worst == 52};
E3 = eavesdrop_rsa(143, 7);
c(end+1, :) = {'eavesdrop_rsa(143, 7): p = 11, q = 13, phi = 120, d = 103, 10 tries, at most 10', E3.p == 11 && E3.q == 13 && E3.phi == 120 && E3.d == 103 && E3.tries == 10 && E3.worst == 10};
E4 = eavesdrop_rsa(64160099, 17);
c(end+1, :) = {'eavesdrop_rsa(64160099, 17): p = 8009, q = 8011, phi = 64144080, d = 41504993, 8008 tries, at most 8008', E4.p == 8009 && E4.q == 8011 && E4.phi == 64144080 && E4.d == 41504993 && E4.tries == 8008 && E4.worst == 8008};
E5 = eavesdrop_rsa(66994189, 65537);
c(end+1, :) = {'eavesdrop_rsa(66994189, 65537) (just below 2^26): p = 8179, q = 8191, phi = 66977820, d = 60980813, 8178 tries, at most 8183', E5.p == 8179 && E5.q == 8191 && E5.phi == 66977820 && E5.d == 60980813 && E5.tries == 8178 && E5.worst == 8183};
E6 = eavesdrop_rsa(3233, 17);
c(end+1, :) = {'eavesdrop_rsa(3233, 17): the smaller prime is p = 53 and q = 61, d = 2753, 52 tries, at most 55', E6.p == 53 && E6.q == 61 && E6.d == 2753 && E6.tries == 52 && E6.worst == 55};
eve_ok = true;
for i = 1:6
    Ei = eavesdrop_rsa(R.n(i), R.e(i));
    eve_ok = eve_ok && Ei.d == R.d(i) && Ei.phi == R.phi(i) && Ei.p * Ei.q == R.n(i) && Ei.p < Ei.q && Ei.tries == slow_tries(R.n(i)) && mod(R.e(i) * Ei.d, Ei.phi) == 1;
end
c(end+1, :) = {'Eve gets the private exponent, phi and the tries of every one of the 6 users', eve_ok};
c(end+1, :) = {'Eve decrypts the message of Alice to Bob with her d and reads it', strcmp(rsa_decrypt_text(M.cipher, M.n, E.d), txt)};
c(end+1, :) = {'eavesdrop_rsa: a bad n is rejected with :modulus (96, 2^26+1, 100.5, text, list, empty, -5, Inf)', all(strcmp({error_id(@() eavesdrop_rsa(96, 17)), error_id(@() eavesdrop_rsa(2^26 + 1, 17)), error_id(@() eavesdrop_rsa(100.5, 17)), error_id(@() eavesdrop_rsa('a', 17)), error_id(@() eavesdrop_rsa([1 2], 17)), error_id(@() eavesdrop_rsa([], 17)), error_id(@() eavesdrop_rsa(-5, 17)), error_id(@() eavesdrop_rsa(Inf, 17))}, 'eavesdrop_rsa:modulus'))};
c(end+1, :) = {'eavesdrop_rsa: a bad e is rejected with :exponent (2, 2.5, text, empty, list)', all(strcmp({error_id(@() eavesdrop_rsa(2773, 2)), error_id(@() eavesdrop_rsa(2773, 2.5)), error_id(@() eavesdrop_rsa(2773, 'a')), error_id(@() eavesdrop_rsa(2773, [])), error_id(@() eavesdrop_rsa(2773, [3 5]))}, 'eavesdrop_rsa:exponent'))};
c(end+1, :) = {'eavesdrop_rsa: e with gcd(e, phi) not 1 is rejected with :exponent (15 and 3120 for n = 3233, 3 for n = 1022117)', strcmp(error_id(@() eavesdrop_rsa(3233, 15)), 'eavesdrop_rsa:exponent') && strcmp(error_id(@() eavesdrop_rsa(3233, 3120)), 'eavesdrop_rsa:exponent') && strcmp(error_id(@() eavesdrop_rsa(1022117, 3)), 'eavesdrop_rsa:exponent')};
c(end+1, :) = {'eavesdrop_rsa: the message for e = 15 and n = 3233 is the gcd message', strcmp(error_msg(@() eavesdrop_rsa(3233, 15)), 'e = 15 and phi = 3120 must have gcd 1.')};
c(end+1, :) = {'eavesdrop_rsa: a prime n (97, 101, 3 digits and 7 digits) is rejected with :prime', strcmp(error_id(@() eavesdrop_rsa(97, 17)), 'eavesdrop_rsa:prime') && strcmp(error_id(@() eavesdrop_rsa(101, 17)), 'eavesdrop_rsa:prime') && strcmp(error_id(@() eavesdrop_rsa(67108859, 17)), 'eavesdrop_rsa:prime')};
c(end+1, :) = {'eavesdrop_rsa: the message for n = 101 says that it is a prime and not p*q', ~isempty(strfind(error_msg(@() eavesdrop_rsa(101, 17)), 'n = 101 has no divisor from 2 to its square root, so it is a prime and not p*q.'))};
c(end+1, :) = {'eavesdrop_rsa: n that is not two different primes is rejected with :form (8191^2, 3*5*7, 2*3*17, 4*25, 2*49, 2^26)', all(strcmp({error_id(@() eavesdrop_rsa(67092481, 17)), error_id(@() eavesdrop_rsa(105, 7)), error_id(@() eavesdrop_rsa(102, 5)), error_id(@() eavesdrop_rsa(100, 3)), error_id(@() eavesdrop_rsa(98, 3)), error_id(@() eavesdrop_rsa(67108864, 3))}, 'eavesdrop_rsa:form'))};
c(end+1, :) = {'eavesdrop_rsa: the checks come in the order n, e, prime (e = 2 for n = 101 is :exponent, n = 96 with e = 2 is :modulus)', strcmp(error_id(@() eavesdrop_rsa(101, 2)), 'eavesdrop_rsa:exponent') && strcmp(error_id(@() eavesdrop_rsa(96, 2)), 'eavesdrop_rsa:modulus')};
c(end+1, :) = {'eavesdrop_rsa: no argument and one argument are rejected', raises_error(@() eavesdrop_rsa()) && raises_error(@() eavesdrop_rsa(2773))};

% --- eavesdrop_codebook ---
A = eavesdrop_codebook(M.cipher, M.n, M.e);
bookref = zeros(1, 96);
for t = 1:96
    bookref(t) = slow_pow(t, 17, 2773);
end
c(end+1, :) = {'eavesdrop_codebook has the fields n, e, tries, book, values, found, all_found, text in this order', isequal(fieldnames(A)', {'n', 'e', 'tries', 'book', 'values', 'found', 'all_found', 'text'})};
c(end+1, :) = {'the list of Bob: n = 2773, e = 17 and 96 encryptions', A.n == 2773 && A.e == 17 && A.tries == 96 && isequal(size(A.book), [1 96])};
c(end+1, :) = {'the list of Bob is the same with repeated multiplication', isequal(A.book, bookref)};
c(end+1, :) = {'the list of Bob: t = 1 gives 1, t = 46 gives 1315, t = 85 gives 560, t = 96 gives 600', A.book(1) == 1 && A.book(46) == 1315 && A.book(85) == 560 && A.book(96) == 600};
c(end+1, :) = {'the list of Bob has 96 different numbers and no 0', numel(unique(A.book)) == 96 && all(A.book > 0)};
c(end+1, :) = {'the list reads the message to Bob: the values are the symbols, 36 of 36 found', isequal(A.values, sym) && A.found == 36 && A.all_found == true};
c(end+1, :) = {'the list reads the message to Bob: the text is the message', strcmp(A.text, txt)};
Ac = eavesdrop_codebook(M3.cipher, 2881, 5);
c(end+1, :) = {'the list of Carol (2881, 5) reads the message to Carol, and t = 46 gives 286, t = 85 gives 1977, t = 96 gives 1444', strcmp(Ac.text, txt) && Ac.book(46) == 286 && Ac.book(85) == 1977 && Ac.book(96) == 1444};
Ag = eavesdrop_codebook(Mh.cipher, 2993, 7);
c(end+1, :) = {'the list of Grace (2993, 7) reads ''Hello, RSA!'' and t = 41 (the character H) gives 328', strcmp(Ag.text, 'Hello, RSA!') && Ag.book(41) == 328};
Ax = eavesdrop_codebook(ac_ref(1:4), 2773, 17);
c(end+1, :) = {'the list of Bob does not read numbers made with the key of Carol (286 2387 2387 1977): nothing found, empty text', isequal(Ax.values, [0 0 0 0]) && Ax.found == 0 && Ax.all_found == false && isempty(Ax.text)};
Ax = eavesdrop_codebook(ac_ref, 2773, 17);
c(end+1, :) = {'the list of Bob on the 8 numbers for Carol finds only the two numbers 1', isequal(Ax.values, [0 0 0 0 1 0 0 1]) && Ax.found == 2 && Ax.all_found == false && isempty(Ax.text)};
Ax = eavesdrop_codebook([1315 2], 2773, 17);
c(end+1, :) = {'a number that is not in the list (2) gives the value 0, found 1 of 2 and an empty text', isequal(Ax.values, [46 0]) && Ax.found == 1 && Ax.all_found == false && isempty(Ax.text)};
Ax = eavesdrop_codebook(600, 2773, 17);
c(end+1, :) = {'the number 600 is t = 96 (a key, not a symbol): found, but the text stays empty', isequal(Ax.values, 96) && Ax.all_found == true && isempty(Ax.text)};
Ax = eavesdrop_codebook(0, 2773, 17);
c(end+1, :) = {'the number 0 is not in the list', isequal(Ax.values, 0) && Ax.found == 0 && Ax.all_found == false};
A2 = eavesdrop_codebook(T.key_cipher, T.n, T.e);
c(end+1, :) = {'the list gives the key 85 for the encrypted key 560', A2.values(1) == 85 && A2.all_found == true && A2.book(85) == 560};
Ax = eavesdrop_codebook(1, 3233, 15);
c(end+1, :) = {'a list for e = 15 and n = 3233 (gcd 3) is still made, and the first match is used', Ax.values(1) == 1 && Ax.all_found == true};
c(end+1, :) = {'eavesdrop_codebook: a bad n is rejected with :modulus (96, 2^26+1, text, list)', all(strcmp({error_id(@() eavesdrop_codebook(1, 96, 17)), error_id(@() eavesdrop_codebook(1, 2^26 + 1, 17)), error_id(@() eavesdrop_codebook(1, 'a', 17)), error_id(@() eavesdrop_codebook(1, [1 2], 17))}, 'eavesdrop_codebook:modulus'))};
c(end+1, :) = {'eavesdrop_codebook: a bad e is rejected with :exponent (2, 2.5, text, empty)', all(strcmp({error_id(@() eavesdrop_codebook(1, 2773, 2)), error_id(@() eavesdrop_codebook(1, 2773, 2.5)), error_id(@() eavesdrop_codebook(1, 2773, 'a')), error_id(@() eavesdrop_codebook(1, 2773, []))}, 'eavesdrop_codebook:exponent'))};
c(end+1, :) = {'eavesdrop_codebook: a bad c is rejected with :cipher (-1, 2773, 1.5, empty, column, text, matrix, cell)', all(strcmp({error_id(@() eavesdrop_codebook(-1, 2773, 17)), error_id(@() eavesdrop_codebook(2773, 2773, 17)), error_id(@() eavesdrop_codebook(1.5, 2773, 17)), error_id(@() eavesdrop_codebook([], 2773, 17)), error_id(@() eavesdrop_codebook([1; 2], 2773, 17)), error_id(@() eavesdrop_codebook('abc', 2773, 17)), error_id(@() eavesdrop_codebook([1 2; 3 4], 2773, 17)), error_id(@() eavesdrop_codebook({}, 2773, 17))}, 'eavesdrop_codebook:cipher'))};
c(end+1, :) = {'eavesdrop_codebook: the largest number n-1 = 2772 is accepted', ~raises_error(@() eavesdrop_codebook(2772, 2773, 17))};

% --- show_rsa_users ---
out1 = evalc('show_rsa_users(S)');
c(end+1, :) = {'show_rsa_users prints its title and the public directory', ~isempty(strfind(out1, '=== RSA USERS AND MESSAGES ===')) && ~isempty(strfind(out1, 'The public directory (everybody can read it):'))};
c(end+1, :) = {'show_rsa_users prints the public key rows of Alice, Bob and Grace', ~isempty(strfind(out1, sprintf('  %-8s%-8d%d', 'Alice', 3233, 17))) && ~isempty(strfind(out1, sprintf('  %-8s%-8d%d', 'Bob', 2773, 17))) && ~isempty(strfind(out1, sprintf('  %-8s%-8d%d', 'Grace', 2993, 7)))};
c(end+1, :) = {'show_rsa_users prints the private rows of Bob and Carol', ~isempty(strfind(out1, sprintf('  %-8s%-6d%-6d%-8d%d', 'Bob', 47, 59, 2668, 157))) && ~isempty(strfind(out1, sprintf('  %-8s%-6d%-6d%-8d%d', 'Carol', 43, 67, 2772, 1109)))};
c(end+1, :) = {'show_rsa_users says that every n is different and e*d mod phi = 1', ~isempty(strfind(out1, 'Every user has a different n: yes. For every user e*d mod phi = 1: yes.'))};
c(end+1, :) = {'show_rsa_users prints the message, the key of Bob and the example 46^17 mod 2773 = 1315', ~isempty(strfind(out1, 'Alice looks up the public key of Bob in the directory: (n, e) = (2773, 17).')) && ~isempty(strfind(out1, 'Example: the first character M is the symbol 46, and 46^17 mod 2773 = 1315 (5 squaring steps and 2 multiplication steps).'))};
c(end+1, :) = {'show_rsa_users prints the 36 numbers (numbers from 0 to n-1 = 2772) and the first row', ~isempty(strfind(out1, 'The 36 numbers that cross the channel (numbers from 0 to n-1 = 2772):')) && ~isempty(strfind(out1, '   1315 1017 1017  560    1  728 1017    1  872  560    1  560'))};
c(end+1, :) = {'show_rsa_users prints what Bob gets with d = 157', ~isempty(strfind(out1, 'Bob decrypts every number c with the private key d = 157: m = c^d mod n. The text that Bob gets: Meet me at the library at 5 pm, Bob.')) && ~isempty(strfind(out1, 'It is the same as the message: yes'))};
c(end+1, :) = {'show_rsa_users prints what the 5 other users get with their own d', ~isempty(strfind(out1, 'Alice with d = 2753: the decryption stops')) && ~isempty(strfind(out1, 'Carol with d = 1109: the decryption stops')) && ~isempty(strfind(out1, 'Dave with d = 2291: the decryption stops')) && ~isempty(strfind(out1, 'Frank with d = 1003: the decryption stops')) && ~isempty(strfind(out1, 'Grace with d = 823: the decryption stops'))};
c(end+1, :) = {'show_rsa_users prints the 30 messages and the number of keys (15 pairs, 6 key pairs)', ~isempty(strfind(out1, '30 messages in all. The receiver gets the same text every time: yes.')) && ~isempty(strfind(out1, '6 users have 15 pairs, so 15 keys')) && ~isempty(strfind(out1, '6 users need 6 key pairs'))};
pos = strfind(out1, 'Checks:');
tail1 = out1(pos(end):end);
c(end+1, :) = {'show_rsa_users ends with 7 check lines that all say yes', numel(pos) == 1 && numel(strfind(tail1, ': yes')) == 7 && isempty(strfind(out1, ': NO'))};
c(end+1, :) = {'show_rsa_users() without an argument prints the same as show_rsa_users(S)', strcmp(evalc('show_rsa_users()'), out1)};
c(end+1, :) = {'show_rsa_users with 5 users stops with define_rsa_users:count', strcmp(error_id(@() show_rsa_users(S5)), 'define_rsa_users:count')};

% --- show_rsa_transport ---
out2 = evalc('show_rsa_transport(S)');
c(end+1, :) = {'show_rsa_transport prints its title and the cipher of Point 1', ~isempty(strfind(out2, '=== RSA KEY TRANSPORT ===')) && ~isempty(strfind(out2, 'E_k(m) = k*m mod 97, and the key k is a number from 1 to 96.'))};
c(end+1, :) = {'show_rsa_transport prints the key 85, the number 560 and the key that Bob gets', ~isempty(strfind(out2, 'Alice chooses the key k = 85')) && ~isempty(strfind(out2, 'c = k^e mod n = 85^17 mod 2773 = 560')) && ~isempty(strfind(out2, 'k = c^d mod n = 560^157 mod 2773 = 85.')) && ~isempty(strfind(out2, 'The key that Bob gets is the key that Alice chose: yes.'))};
c(end+1, :) = {'show_rsa_transport prints the example 85 * 46 mod 97 = 30, the inverse key 8 and the text', ~isempty(strfind(out2, 'and 85 * 46 mod 97 = 30.')) && ~isempty(strfind(out2, 'Bob finds the inverse key j = 8 (because 85 * 8 mod 97 = 1)')) && ~isempty(strfind(out2, 'The text that Bob gets: Meet me at the library at 5 pm, Bob.'))};
c(end+1, :) = {'show_rsa_transport prints the first row of the 36 numbers 30 33 33 47 85 34 33 85 81 47 85 47', ~isempty(strfind(out2, '    30  33  33  47  85  34  33  85  81  47  85  47'))};
c(end+1, :) = {'show_rsa_transport prints what Carol and Frank get (732 is not a key, 70 stops)', ~isempty(strfind(out2, 'Carol: 560^1109 mod 2881 = 732. This is not a key (a key is from 1 to 96)')) && ~isempty(strfind(out2, 'Frank: 560^1003 mod 2449 = 70. With this key the decryption stops'))};
c(end+1, :) = {'show_rsa_transport prints the multiplications: 13 for one RSA decryption, 36 * 13 = 468 and 13 + 36 = 49', ~isempty(strfind(out2, 'takes 8 squaring steps and 5 multiplication steps, 13 modular multiplications in all.')) && ~isempty(strfind(out2, '36 * 13 = 468 modular multiplications')) && ~isempty(strfind(out2, '13 + 36 = 49'))};
pos = strfind(out2, 'Checks:');
tail2 = out2(pos(end):end);
c(end+1, :) = {'show_rsa_transport ends with 9 check lines that all say yes', numel(pos) == 1 && numel(strfind(tail2, ': yes')) == 9 && isempty(strfind(out2, ': NO'))};
c(end+1, :) = {'show_rsa_transport() without an argument prints the same as show_rsa_transport(S)', strcmp(evalc('show_rsa_transport()'), out2)};

% --- show_rsa_eavesdropper ---
out3 = evalc('show_rsa_eavesdropper(S)');
c(end+1, :) = {'show_rsa_eavesdropper prints its title and what Eve sees', ~isempty(strfind(out3, '=== THE EAVESDROPPER AND RSA ===')) && ~isempty(strfind(out3, 'Eve listens to the channel between Alice and Bob. She knows no private key.')) && ~isempty(strfind(out3, 'the public key of Bob: (n, e) = (2773, 17)'))};
c(end+1, :) = {'show_rsa_eavesdropper prints the factoring: 47 after 46 tries, 59, phi = 2668 and d = 157', ~isempty(strfind(out3, 'She finds 47 after 46 tries. So p = 47 and q = n/p = 2773 / 47 = 59.')) && ~isempty(strfind(out3, 'phi = (p-1)*(q-1) = 46 * 58 = 2668')) && ~isempty(strfind(out3, 'd = 157.')) && ~isempty(strfind(out3, 'This is the private key of Bob: yes.')) && ~isempty(strfind(out3, 'there are only 51 numbers to try'))};
rows = {sprintf('  %-12d%-10d%-12d%-12d%s', 143, 8, 10, 10, 'yes'), sprintf('  %-12d%-10d%-12d%-12d%s', 10403, 14, 100, 100, 'yes'), sprintf('  %-12d%-10d%-12d%-12d%s', 1022117, 20, 1008, 1009, 'yes'), sprintf('  %-12d%-10d%-12d%-12d%s', 64160099, 26, 8008, 8008, 'yes')};
c(end+1, :) = {'show_rsa_eavesdropper prints the table with n = 143, 10403, 1022117 and 64160099 (bits, tries, most tries)', ~isempty(strfind(out3, rows{1})) && ~isempty(strfind(out3, rows{2})) && ~isempty(strfind(out3, rows{3})) && ~isempty(strfind(out3, rows{4})) && ~isempty(strfind(out3, 'most tries'))};
c(end+1, :) = {'show_rsa_eavesdropper prints the 2048 bits remark (617 digits, 2^1024 tries)', ~isempty(strfind(out3, 'A modulus with 2048 bits (a number with 617 digits) would need up to 2^1024 tries'))};
c(end+1, :) = {'show_rsa_eavesdropper prints the list: t = 46 gives 1315, 36 of 36 found, 96 encryptions', ~isempty(strfind(out3, 'For example t = 46 (the symbol of the character M) gives 46^17 mod 2773 = 1315.')) && ~isempty(strfind(out3, 'The numbers found: 36 of 36.')) && ~isempty(strfind(out3, 'She needed only 96 encryptions and no private key.'))};
c(end+1, :) = {'show_rsa_eavesdropper prints the key transport: c = 560, key 85 with d and with the list', ~isempty(strfind(out3, 'Eve sees the number c = 560 and the 36 numbers of the text.')) && ~isempty(strfind(out3, 'k = c^d mod n = 560^157 mod 2773 = 85.')) && ~isempty(strfind(out3, 'the list entry for t = 85 is 560, the number c.'))};
pos = strfind(out3, 'Checks:');
tail3 = out3(pos(end):end);
c(end+1, :) = {'show_rsa_eavesdropper ends with 10 check lines that all say yes', numel(pos) == 1 && numel(strfind(tail3, ': yes')) == 10 && isempty(strfind(out3, ': NO'))};
c(end+1, :) = {'show_rsa_eavesdropper() without an argument prints the same as show_rsa_eavesdropper(S)', strcmp(evalc('show_rsa_eavesdropper()'), out3)};

% --- demo_point7 ---
out4 = evalc('demo_point7()');
c(end+1, :) = {'demo_point7 prints its title and all four parts (7A and the three of 7B)', ~isempty(strfind(out4, 'POINT 7 DEMO: RSA PUBLIC-KEY ENCRYPTION')) && ~isempty(strfind(out4, '=== RSA PUBLIC-KEY ENCRYPTION ===')) && ~isempty(strfind(out4, '=== RSA USERS AND MESSAGES ===')) && ~isempty(strfind(out4, '=== RSA KEY TRANSPORT ===')) && ~isempty(strfind(out4, '=== THE EAVESDROPPER AND RSA ==='))};
titles = {'=== RSA PUBLIC-KEY ENCRYPTION ===', '=== RSA USERS AND MESSAGES ===', '=== RSA KEY TRANSPORT ===', '=== THE EAVESDROPPER AND RSA ==='};
counts = zeros(1, numel(titles));
for k = 1:numel(titles)
    first = strfind(out4, titles{k});
    if k < numel(titles)
        last = strfind(out4, titles{k + 1});
        part = out4(first(1):last(1) - 1);
    else
        part = out4(first(1):end);
    end
    cpos = strfind(part, 'Checks:');
    counts(k) = numel(strfind(part(cpos(end):end), ': yes'));
end
c(end+1, :) = {'demo_point7 has 4 blocks of checks with 8, 7, 9 and 10 lines that all say yes (34 in all)', isequal(counts, [8 7 9 10]) && isempty(strfind(out4, ': NO'))};
c(end+1, :) = {'the four parts come in the order 7A, users, key transport, eavesdropper', max(strfind(out4, '=== RSA PUBLIC-KEY ENCRYPTION ===')) < min(strfind(out4, '=== RSA USERS AND MESSAGES ===')) && max(strfind(out4, '=== RSA USERS AND MESSAGES ===')) < min(strfind(out4, '=== RSA KEY TRANSPORT ===')) && max(strfind(out4, '=== RSA KEY TRANSPORT ===')) < min(strfind(out4, '=== THE EAVESDROPPER AND RSA ==='))};

% --- project files ---
runtxt = fileread(which('run_all_tests'));
c(end+1, :) = {'run_all_tests runs test_rsa_users after test_rsa', ~isempty(strfind(runtxt, 'test_rsa();')) && ~isempty(strfind(runtxt, 'test_rsa_users();')) && strfind(runtxt, 'test_rsa();') < strfind(runtxt, 'test_rsa_users();')};
files = {'define_rsa_users', 'check_rsa_users', 'rsa_send_message', 'rsa_key_transport', 'eavesdrop_rsa', 'eavesdrop_codebook', 'show_rsa_users', 'show_rsa_transport', 'show_rsa_eavesdropper', 'demo_point7', 'test_rsa_users'};
ascii_ok = true;
for k = 1:numel(files)
    fid = fopen(which(files{k}), 'r');
    bytes = fread(fid);
    fclose(fid);
    ascii_ok = ascii_ok && ~isempty(bytes) && all(bytes < 128) && ~any(bytes == 13) && ~any(bytes == 9);
end
c(end+1, :) = {'the 11 new or changed files of packet 7B are plain ASCII, with no tab and no carriage return', ascii_ok};

summarize_checks('test_rsa_users', c);
end

function id = error_id(f)
% The identifier of the error that calling f gives (empty text when there is no error or no identifier).
id = '';
try
    f();
catch err
    id = err.identifier;
end
end

function msg = error_msg(f)
% The message of the error that calling f gives (empty text when there is no error).
msg = '';
try
    f();
catch err
    msg = err.message;
end
end

function r = slow_pow(m, e, n)
% m^e mod n by repeated multiplication (e multiplications), to check mod_pow.
r = 1;
for t = 1:e
    r = mod(r * m, n);
end
end

function t = slow_tries(n)
% The number of tries 2, 3, ... until a number divides n, counted by a plain loop.
k = 2;
while mod(n, k) ~= 0
    k = k + 1;
end
t = k - 1;
end
