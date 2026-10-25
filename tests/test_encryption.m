function test_encryption()
% TEST_ENCRYPTION Checks for format_numbers, send_message, try_all_keys, eavesdrop_dh, show_encryption, show_eavesdropper and demo_point4.
S = define_sets();
D = define_secrets(S);
p = S.prime;
g = S.generator;
msg = 'Meet me at the library at 5 pm, Bob.';
c = cell(0, 2);

% --- format_numbers ---
c(end+1, :) = {'format_numbers puts 2 numbers in each line, 4 places each, 2 spaces first', isequal(format_numbers([1 2 3], 2), ['  ' '   1' '   2' char(10) '  ' '   3'])};
c(end+1, :) = {'format_numbers of one number', isequal(format_numbers(7, 5), ['  ' '   7'])};
c(end+1, :) = {'format_numbers accepts 0 and 9999', isequal(format_numbers([0 9999], 2), ['  ' '   0' '9999'])};
f25 = format_numbers(1:25, 12);
c(end+1, :) = {'format_numbers of 25 numbers with 12 in each line has 3 lines and no new line at the end', numel(strfind(f25, char(10))) == 2 && f25(end) ~= char(10)};
c(end+1, :) = {'format_numbers of 12 numbers with 12 in each line has no new line', isempty(strfind(format_numbers(1:12, 12), char(10)))};
c(end+1, :) = {'format_numbers with 1 in each line has one line for each number', numel(strfind(format_numbers([5 6 7], 1), char(10))) == 2};
c(end+1, :) = {'format_numbers gives the same text for a column of numbers', isequal(format_numbers([1 2 3]', 3), format_numbers([1 2 3], 3))};
c(end+1, :) = {'format_numbers: every line has at most 2 + 4 * 12 characters and the numbers are all there', isequal(sscanf(format_numbers(1:30, 12), '%d')', 1:30) && max(cellfun(@numel, strsplit(format_numbers(1:30, 12), char(10)))) == 50};
c(end+1, :) = {'format_numbers rejects no numbers and a negative number', raises_error(@() format_numbers([], 3)) && raises_error(@() format_numbers([1 -1], 3))};
c(end+1, :) = {'format_numbers rejects 10000 and 2.5', raises_error(@() format_numbers(10000, 3)) && raises_error(@() format_numbers(2.5, 3))};
c(end+1, :) = {'format_numbers rejects a text as numbers', raises_error(@() format_numbers('abc', 3))};
c(end+1, :) = {'format_numbers rejects per_row 0, 2.5 and a list', raises_error(@() format_numbers(1:3, 0)) && raises_error(@() format_numbers(1:3, 2.5)) && raises_error(@() format_numbers(1:3, [1 2]))};
c(end+1, :) = {'format_numbers rejects a missing argument', raises_error(@() format_numbers(1:3))};

% --- send_message ---
M = send_message('Hello', 1, 2, D, S);
c(end+1, :) = {'Alice to Bob: the names, the user numbers and the text', strcmp(M.from, 'Alice') && strcmp(M.to, 'Bob') && M.i == 1 && M.j == 2 && strcmp(M.text, 'Hello')};
c(end+1, :) = {'Alice to Bob: the public values are 8 and 46', M.public_from == 8 && M.public_to == 46};
c(end+1, :) = {'Alice to Bob: both keys are 85 and they agree', M.key_sender == 85 && M.key_receiver == 85 && M.agree};
c(end+1, :) = {'Alice to Bob: Hello gives the numbers 90 33 46 46 10', isequal(M.cipher, [90 33 46 46 10])};
c(end+1, :) = {'Alice to Bob: Bob gets Hello', strcmp(M.received, 'Hello') && M.ok};
M2 = send_message('Hello', 2, 1, D, S);
c(end+1, :) = {'Bob to Alice: the same key and the same numbers', M2.key_sender == 85 && isequal(M2.cipher, M.cipher) && strcmp(M2.from, 'Bob') && strcmp(M2.to, 'Alice') && M2.ok};
M3 = send_message('Hello', 3, 6);
c(end+1, :) = {'Carol to Grace without D and S: the key is 60 and the numbers are 60 * symbol mod 97', M3.key_sender == 60 && M3.key_receiver == 60 && strcmp(M3.to, 'Grace') && M3.ok && isequal(M3.cipher, mod(60 * (double('Hello') - 31), 97))};
K = dh_key_table(D, p);
ok1 = true;
ok2 = true;
ok3 = true;
for a = 1:6
    for b = 1:6
        if a ~= b
            Mq = send_message(msg, a, b, D, S);
            ok1 = ok1 && Mq.ok && Mq.agree && strcmp(Mq.received, msg);
            ok2 = ok2 && Mq.key_sender == K(a, b) && Mq.key_receiver == K(b, a);
            ok3 = ok3 && isequal(Mq.cipher, mod(K(a, b) * (double(msg) - 31), p));
        end
    end
end
c(end+1, :) = {'all 30 ordered pairs of users: the keys agree and the receiver gets the text', ok1};
c(end+1, :) = {'all 30 ordered pairs of users: the keys are the keys of the table dh_key_table', ok2};
c(end+1, :) = {'all 30 ordered pairs of users: the numbers are key * symbol mod 97', ok3};
Ma = send_message(char(32:126), 1, 2, D, S);
c(end+1, :) = {'all 95 printable characters go through and come back', Ma.ok && isequal(Ma.cipher, mod(85 * (1:95), 97))};
c(end+1, :) = {'one character A gives the number 77 (85 * 34 mod 97)', isequal(send_message('A', 1, 2, D, S).cipher, 77)};
Db = D;
Db.private(2) = 16;
Mb = send_message('Hello', 1, 2, Db, S);
c(end+1, :) = {'a wrong secret number of the receiver: the keys differ and the text is not read', ~Mb.agree && Mb.key_receiver ~= Mb.key_sender && ~Mb.ok};
c(end+1, :) = {'a wrong secret number of the receiver does not change the key of the sender', Mb.key_sender == 85};
c(end+1, :) = {'sender 0 and sender 7 are rejected', raises_error(@() send_message('Hello', 0, 2, D, S)) && raises_error(@() send_message('Hello', 7, 2, D, S))};
c(end+1, :) = {'receiver 0 and receiver 7 are rejected', raises_error(@() send_message('Hello', 1, 0, D, S)) && raises_error(@() send_message('Hello', 1, 7, D, S))};
c(end+1, :) = {'sender 2.5, a list and a text as sender are rejected', raises_error(@() send_message('Hello', 2.5, 2, D, S)) && raises_error(@() send_message('Hello', [1 2], 3, D, S)) && raises_error(@() send_message('Hello', 'a', 2, D, S))};
c(end+1, :) = {'receiver 2.5 and a list as receiver are rejected', raises_error(@() send_message('Hello', 1, 2.5, D, S)) && raises_error(@() send_message('Hello', 1, [2 3], D, S))};
c(end+1, :) = {'the same user as sender and receiver is rejected', raises_error(@() send_message('Hello', 3, 3, D, S))};
c(end+1, :) = {'an empty text is rejected', raises_error(@() send_message('', 1, 2, D, S))};
c(end+1, :) = {'a number as text and a cell as text are rejected', raises_error(@() send_message(5, 1, 2, D, S)) && raises_error(@() send_message({'Hello'}, 1, 2, D, S))};
c(end+1, :) = {'a text with a tab, with code 127 and with code 200 is rejected', raises_error(@() send_message(['a' char(9)], 1, 2, D, S)) && raises_error(@() send_message(['a' char(127)], 1, 2, D, S)) && raises_error(@() send_message(['a' char(200)], 1, 2, D, S))};
c(end+1, :) = {'a text with two lines (a matrix of characters) is rejected', raises_error(@() send_message(['ab'; 'cd'], 1, 2, D, S))};
c(end+1, :) = {'D that is not a struct and D without the right fields are rejected', raises_error(@() send_message('Hello', 1, 2, 5, S)) && raises_error(@() send_message('Hello', 1, 2, struct('a', 1), S))};
Dc = D;
Dc.private = Dc.private(1:5);
Dd = D;
Dd.public = Dd.public(1:5);
c(end+1, :) = {'D with 5 secret numbers or 5 public values is rejected', raises_error(@() send_message('Hello', 1, 2, Dc, S)) && raises_error(@() send_message('Hello', 1, 2, Dd, S))};
c(end+1, :) = {'a missing receiver is rejected', raises_error(@() send_message('Hello', 1))};
S2 = S;
S2.prime = 101;
S2.generator = 2;
S2.cipher = 1:100;
S2.keys = 1:100;
D2 = define_secrets(S2);
ok = true;
for a = 1:6
    for b = 1:6
        if a ~= b
            Mq = send_message(msg, a, b, D2, S2);
            ok = ok && Mq.ok && Mq.agree;
        end
    end
end
c(end+1, :) = {'p = 101, g = 2: every user sends to every other user and the receiver gets the text', ok};
M101 = send_message(msg, 1, 2, D2, S2);
c(end+1, :) = {'p = 101, g = 2: the key of Alice and Bob is 2^(6*15 mod 100) mod 101 = 65', M101.key_sender == 65 && M101.key_sender == mod_pow(2, mod(6 * 15, 100), 101) && isequal(M101.cipher, mod(65 * (double(msg) - 31), 101))};
S3 = S;
S3.prime = 10007;
S3.generator = 5;
S3.cipher = 1:10006;
S3.keys = 1:10006;
D3 = define_secrets(S3);
M10 = send_message(msg, 1, 2, D3, S3);
c(end+1, :) = {'p = 10007, g = 5: the keys agree, the key is 5^90 mod 10007 and Bob gets the text', M10.agree && M10.ok && M10.key_sender == mod_pow(5, 90, 10007)};

% --- try_all_keys ---
Mt = send_message(msg, 1, 2, D, S);
T = try_all_keys(Mt.cipher, S);
c(end+1, :) = {'try_all_keys tries the 96 keys 1 to 96', isequal(T.keys, 1:96) && numel(T.stopped) == 96 && numel(T.readable) == 96 && numel(T.texts) == 96};
c(end+1, :) = {'try_all_keys: the key 85 gives the message back and is readable', strcmp(T.texts{85}, msg) && ~T.stopped(85) && T.readable(85)};
c(end+1, :) = {'try_all_keys: 18 keys stop, the number of different values in the ciphertext', T.count_stopped == 18 && T.count_stopped == numel(unique(Mt.cipher)) && sum(T.stopped) == 18};
ok = true;
for k = 1:96
    ok = ok && (T.stopped(k) == ismember(97 - k, Mt.cipher));
end
c(end+1, :) = {'try_all_keys: the key k stops exactly when the value 97-k is in the ciphertext (all 96 keys)', ok};
ok = true;
for k = 1:96
    if T.stopped(k)
        ok = ok && isempty(T.texts{k});
    else
        ok = ok && strcmp(T.texts{k}, char(mod(key_inverse(k, S) * Mt.cipher, 97) + 31));
    end
end
c(end+1, :) = {'try_all_keys: every key that does not stop gives the text j*c mod 97 (all 96 keys)', ok};
c(end+1, :) = {'try_all_keys: only the key 85 gives a readable text for this message', T.count_readable == 1 && isequal(find(T.readable), 85) && T.count_readable == sum(T.readable)};
T1 = try_all_keys(77, S);
got = cell2mat(T1.texts(T1.readable));
want = [char(65:90) char(97:122) char(48:57) char([32 33 39 44 45 46 63])];
c(end+1, :) = {'try_all_keys: for the one value 77 only the key 20 stops, and 69 keys give a readable text', T1.count_stopped == 1 && T1.stopped(20) && T1.count_readable == 69};
c(end+1, :) = {'try_all_keys: the readable characters are letters, digits, space and . , ! ? and the apostrophe and the hyphen', isequal(sort(got), sort(want))};
Tn = try_all_keys(encrypt_text('Hello #', 85, S), S);
c(end+1, :) = {'try_all_keys: a text with the character # is not readable', ~Tn.readable(85) && strcmp(Tn.texts{85}, 'Hello #')};
Tq = try_all_keys(encrypt_text('Aa0 .,!?''-', 85, S), S);
c(end+1, :) = {'try_all_keys: a text with all the allowed kinds of characters is readable', Tq.readable(85) && strcmp(Tq.texts{85}, 'Aa0 .,!?''-')};
c(end+1, :) = {'try_all_keys works without the sets argument', isequal(try_all_keys(Mt.cipher).texts, T.texts)};
c(end+1, :) = {'try_all_keys rejects the value 0, the value 97 and 2.5', raises_error(@() try_all_keys(0, S)) && raises_error(@() try_all_keys(97, S)) && raises_error(@() try_all_keys(2.5, S))};
c(end+1, :) = {'try_all_keys rejects no values and a text', raises_error(@() try_all_keys([], S)) && raises_error(@() try_all_keys('abc', S))};
S6 = S;
S6.prime = 1009;
S6.generator = 11;
S6.cipher = 1:1008;
S6.keys = 1:1008;
c(end+1, :) = {'try_all_keys rejects a prime bigger than 1000', raises_error(@() try_all_keys(5, S6))};
T2 = try_all_keys(Mt.cipher(1:3), S);
c(end+1, :) = {'try_all_keys: a short ciphertext (3 values) gives a text for every key that does not stop', T2.count_stopped == numel(unique(Mt.cipher(1:3))) && sum(~T2.stopped) == 96 - T2.count_stopped && strcmp(T2.texts{85}, 'Mee')};
Ts = try_all_keys(encrypt_text(msg, 65, S2), S2);
c(end+1, :) = {'try_all_keys with p = 101: 100 keys, the key 65 gives the text and is the only readable key', numel(Ts.keys) == 100 && strcmp(Ts.texts{65}, msg) && Ts.count_readable == 1 && Ts.readable(65)};

% --- eavesdrop_dh ---
E = eavesdrop_dh(8, 46, 97, 5);
c(end+1, :) = {'Eve: the public value 8 gives the secret number 6 after 6 tries and the key 85', E.secret == 6 && E.tries == 6 && E.key == 85};
c(end+1, :) = {'Eve: p, g, A and B are kept and the worst case is 95 tries', E.p == 97 && E.g == 5 && E.A == 8 && E.B == 46 && E.worst == 95};
ok = true;
for a = 1:95
    Ea = eavesdrop_dh(dh_public_value(a, 97, 5), 46, 97, 5);
    ok = ok && Ea.secret == a && Ea.tries == a && Ea.key == mod_pow(46, a, 97);
end
c(end+1, :) = {'p = 97: for every secret number from 1 to 95 Eve finds it with that many tries and gets the key B^a', ok};
ok = true;
for a = 1:7:95
    for b = 1:9:95
        Ex = dh_exchange(a, b, 97, 5);
        Ev = eavesdrop_dh(Ex.A, Ex.B, 97, 5);
        ok = ok && Ev.key == Ex.key && Ev.secret == a;
    end
end
c(end+1, :) = {'p = 97: for 14 x 11 pairs of users Eve gets the key of the users', ok};
Ed = eavesdrop_dh(D.public(2), D.public(1), p, g);
c(end+1, :) = {'Eve finds the secret number 15 of Bob after 15 tries', Ed.secret == 15 && Ed.tries == 15 && Ed.key == 85};
ok = true;
for a = 1:5
    ok = ok && eavesdrop_dh(mod_pow(3, a, 7), 5, 7, 3).secret == a;
end
for a = 1:3
    ok = ok && eavesdrop_dh(mod_pow(2, a, 5), 3, 5, 2).secret == a;
end
c(end+1, :) = {'p = 7 with g = 3 and p = 5 with g = 2: Eve finds every secret number', ok};
E2 = eavesdrop_dh(mod_pow(11, 1007, 1009), 5, 1009, 11);
c(end+1, :) = {'p = 1009, g = 11: the secret number 1007 needs 1007 tries and gives the key 5^1007 mod 1009', E2.secret == 1007 && E2.tries == 1007 && E2.worst == 1007 && E2.key == mod_pow(5, 1007, 1009)};
E3 = eavesdrop_dh(mod_pow(5, 10005, 10007), 2, 10007, 5);
c(end+1, :) = {'p = 10007, g = 5: the secret number 10005 needs 10005 tries', E3.secret == 10005 && E3.tries == 10005 && E3.key == mod_pow(2, 10005, 10007)};
E4 = eavesdrop_dh(mod_pow(2, 100001, 100003), 2, 100003, 2);
c(end+1, :) = {'p = 100003, g = 2: the secret number 100001 needs 100001 tries', E4.secret == 100001 && E4.tries == 100001 && E4.worst == 100001};
g5 = 2;
while ~is_generator(g5, 999983)
    g5 = g5 + 1;
end
E5 = eavesdrop_dh(mod_pow(g5, 6, 999983), 5, 999983, g5);
c(end+1, :) = {'p = 999983 (just under the limit) is accepted and a small secret number is found at once', E5.secret == 6 && E5.tries == 6};
g6 = 2;
while ~is_generator(g6, 1000003)
    g6 = g6 + 1;
end
c(end+1, :) = {'p = 1000003 (over the limit of 1000000) is rejected', raises_error(@() eavesdrop_dh(mod_pow(g6, 6, 1000003), 5, 1000003, g6))};
c(end+1, :) = {'A = 1, A = 0, A = 97 and A = 2.5 are rejected by eavesdrop_dh', raises_error(@() eavesdrop_dh(1, 46, 97, 5)) && raises_error(@() eavesdrop_dh(0, 46, 97, 5)) && raises_error(@() eavesdrop_dh(97, 46, 97, 5)) && raises_error(@() eavesdrop_dh(2.5, 46, 97, 5))};
c(end+1, :) = {'A = 2 is accepted by eavesdrop_dh and A = 96 is accepted', ~raises_error(@() eavesdrop_dh(2, 46, 97, 5)) && ~raises_error(@() eavesdrop_dh(96, 46, 97, 5))};
c(end+1, :) = {'B = 0, B = 97 and B = 2.5 are rejected by eavesdrop_dh', raises_error(@() eavesdrop_dh(8, 0, 97, 5)) && raises_error(@() eavesdrop_dh(8, 97, 97, 5)) && raises_error(@() eavesdrop_dh(8, 2.5, 97, 5))};
c(end+1, :) = {'B = 1 and B = 96 are accepted by eavesdrop_dh', ~raises_error(@() eavesdrop_dh(8, 1, 97, 5)) && ~raises_error(@() eavesdrop_dh(8, 96, 97, 5))};
c(end+1, :) = {'a text and a list as A are rejected by eavesdrop_dh', raises_error(@() eavesdrop_dh('a', 46, 97, 5)) && raises_error(@() eavesdrop_dh([8 9], 46, 97, 5))};
c(end+1, :) = {'p = 91 (not prime) and p = 4 are rejected by eavesdrop_dh', raises_error(@() eavesdrop_dh(8, 46, 91, 5)) && raises_error(@() eavesdrop_dh(8, 46, 4, 2))};
c(end+1, :) = {'g = 2 (not a generator) is rejected by eavesdrop_dh for p = 97', raises_error(@() eavesdrop_dh(8, 46, 97, 2))};
c(end+1, :) = {'a missing argument is rejected by eavesdrop_dh', raises_error(@() eavesdrop_dh(8, 46, 97))};

% --- show_encryption ---
t1 = evalc('show_encryption(S)');
c(end+1, :) = {'show_encryption prints its title and the cipher', ~isempty(strfind(t1, '=== ENCRYPTION WITH THE SHARED KEY ===')) && ~isempty(strfind(t1, 'the cipher E_k(m) = k*m mod 97.'))};
c(end+1, :) = {'show_encryption prints the message and the two keys', ~isempty(strfind(t1, 'The message: Meet me at the library at 5 pm, Bob.')) && ~isempty(strfind(t1, 'Alice computes the key B^a mod p = 46^6 mod 97 = 85.')) && ~isempty(strfind(t1, 'Bob computes the key A^b mod p = 8^15 mod 97 = 85.')) && ~isempty(strfind(t1, 'Both keys are the same: yes.'))};
c(end+1, :) = {'show_encryption prints the example of the first character', ~isempty(strfind(t1, 'The text has 36 characters.')) && ~isempty(strfind(t1, 'Example: the first character M is the symbol 46, and k*m mod p = 85 * 46 mod 97 = 30.'))};
c(end+1, :) = {'show_encryption prints the 36 numbers in 3 lines', ~isempty(strfind(t1, '  The 36 numbers that cross the channel:')) && ~isempty(strfind(t1, [char(10) '    30  33  33  47  85  34  33  85  81  47  85  47' char(10) '    94  33  85  46  82  69  71  81  71  84  85  81' char(10) '    47  85  27  85  95  34  38  85  65  10  69  14' char(10)]))};
c(end+1, :) = {'show_encryption prints the inverse key and the text that Bob gets', ~isempty(strfind(t1, 'Bob finds the inverse key j = 8 (because 85 * 8 mod 97 = 1)')) && ~isempty(strfind(t1, 'The text that Bob gets: Meet me at the library at 5 pm, Bob.')) && ~isempty(strfind(t1, 'It is the same as the message: yes'))};
c(end+1, :) = {'show_encryption prints the wrong key 12 and that the decryption stops', ~isempty(strfind(t1, 'with the key of Alice and Carol, which is 12.')) && ~isempty(strfind(t1, 'The decryption stops, because a number turns into a value that is not a symbol (not from 1 to 95).'))};
c(end+1, :) = {'show_encryption prints the 30 messages of the 6 users', ~isempty(strfind(t1, '30 messages in all. The receiver gets the same text every time: yes.'))};
pos = strfind(t1, 'Checks:');
tail = t1(pos(end):end);
c(end+1, :) = {'show_encryption ends with 7 check lines that all say yes', numel(pos) == 1 && numel(strfind(tail, ': yes')) == 7 && isempty(strfind(t1, ': NO'))};
c(end+1, :) = {'show_encryption() gives the same text as show_encryption(S)', isequal(evalc('show_encryption()'), t1)};
t101 = evalc('show_encryption(S2)');
c(end+1, :) = {'show_encryption also works for p = 101 with g = 2 and says the decryption stops', ~isempty(strfind(t101, 'mod 101.')) && ~isempty(strfind(t101, 'The decryption stops')) && isempty(strfind(t101, ': NO'))};
S103 = S;
S103.prime = 103;
S103.generator = 5;
S103.cipher = 1:102;
S103.keys = 1:102;
t103 = evalc('show_encryption(S103)');
c(end+1, :) = {'show_encryption also works for p = 103 with g = 5 and then the wrong key gives only nonsense', ~isempty(strfind(t103, 'The result is only nonsense: ')) && isempty(strfind(t103, 'The decryption stops')) && isempty(strfind(t103, ': NO'))};

% --- show_eavesdropper ---
t2 = evalc('show_eavesdropper(S)');
c(end+1, :) = {'show_eavesdropper prints its title and what Eve sees', ~isempty(strfind(t2, '=== THE EAVESDROPPER ===')) && ~isempty(strfind(t2, 'the public numbers p = 97 and g = 5')) && ~isempty(strfind(t2, 'the public values A = 8 (from Alice) and B = 46 (from Bob)')) && ~isempty(strfind(t2, 'the encrypted message, 36 numbers:'))};
c(end+1, :) = {'show_eavesdropper prints the 6 tries and the secret number 6', ~isempty(strfind(t2, 'She gets 5^6 mod 97 = 8 after 6 tries. So the secret number of Alice is 6.'))};
c(end+1, :) = {'show_eavesdropper prints the key 85 and the text that Eve reads', ~isempty(strfind(t2, 'She computes B^a mod p = 46^6 mod 97 = 85. This is the key of Alice and Bob.')) && ~isempty(strfind(t2, 'She decrypts the message with the key 85: Meet me at the library at 5 pm, Bob.')) && ~isempty(strfind(t2, 'Eve reads the message: yes'))};
c(end+1, :) = {'show_eavesdropper prints the 4 rows of the table of primes', ~isempty(strfind(t2, '  97        5             95          yes')) && ~isempty(strfind(t2, '  1009      11            1007        yes')) && ~isempty(strfind(t2, '  10007     5             10005       yes')) && ~isempty(strfind(t2, '  100003    2             100001      yes'))};
c(end+1, :) = {'show_eavesdropper prints that 18 of 96 keys stop and 1 key gives a readable text', ~isempty(strfind(t2, 'Keys where the decryption stops (a value that is not a symbol): 18 of 96')) && ~isempty(strfind(t2, 'Keys that give a readable text (only letters, digits, spaces and . , ! ? '' -): 1'))};
c(end+1, :) = {'show_eavesdropper prints the one readable key 85 with the text', ~isempty(strfind(t2, '  key 85  gives: Meet me at the library at 5 pm, Bob.'))};
pos = strfind(t2, 'Checks:');
tail = t2(pos(end):end);
c(end+1, :) = {'show_eavesdropper ends with 7 check lines that all say yes', numel(pos) == 1 && numel(strfind(tail, ': yes')) == 7 && isempty(strfind(t2, ': NO'))};
c(end+1, :) = {'show_eavesdropper() gives the same text as show_eavesdropper(S)', isequal(evalc('show_eavesdropper()'), t2)};
t102 = evalc('show_eavesdropper(S2)');
c(end+1, :) = {'show_eavesdropper also works for p = 101 with g = 2', ~isempty(strfind(t102, 'the public numbers p = 101 and g = 2')) && ~isempty(strfind(t102, '2^6 mod 101 = 64 after 6 tries')) && isempty(strfind(t102, ': NO'))};
t104 = evalc('show_eavesdropper(S103)');
c(end+1, :) = {'show_eavesdropper also works for p = 103 with g = 5', ~isempty(strfind(t104, 'the public numbers p = 103 and g = 5')) && isempty(strfind(t104, ': NO'))};

% --- demo_point4 ---
t3 = evalc('demo_point4()');
h1 = strfind(t3, '=== DIFFIE-HELLMAN KEY EXCHANGE ===');
h2 = strfind(t3, '=== ENCRYPTION WITH THE SHARED KEY ===');
h3 = strfind(t3, '=== THE EAVESDROPPER ===');
c(end+1, :) = {'demo_point4 prints its title and the three parts in this order', ~isempty(strfind(t3, 'POINT 4 DEMO: DIFFIE-HELLMAN KEY EXCHANGE AND ENCRYPTION')) && numel(h1) == 1 && numel(h2) == 1 && numel(h3) == 1 && h1 < h2 && h2 < h3};
pos = strfind(t3, 'Checks:');
nyes = zeros(1, numel(pos));
for q = 1:numel(pos)
    rest = t3(pos(q):end);
    stop = strfind(rest, [char(10) char(10)]);
    if ~isempty(stop)
        rest = rest(1:stop(1));
    end
    nyes(q) = numel(strfind(rest, ': yes'));
end
c(end+1, :) = {'demo_point4 has 3 Checks: blocks with 7 lines each, all yes, and none says NO', numel(pos) == 3 && isequal(nyes, [7 7 7]) && isempty(strfind(t3, ': NO'))};
c(end+1, :) = {'demo_point4 is the three parts one after the other', numel(h1) == 1 && isequal(t3(h1 - 1:end), [evalc('show_dh(S)') evalc('show_encryption(S)') evalc('show_eavesdropper(S)')])};

summarize_checks('test_encryption', c);
end
