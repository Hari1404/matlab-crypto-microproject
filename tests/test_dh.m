function test_dh()
% TEST_DH Checks for the Diffie-Hellman key exchange: check_dh_setup, dh_public_value, dh_shared_key, dh_exchange, define_secrets, dh_key_table, show_dh and demo_point4.
S = define_sets();
p = S.prime;
g = S.generator;
c = cell(0, 2);

% --- check_dh_setup ---
c(end+1, :) = {'p = 97 is accepted', ~raises_error(@() check_dh_setup(97))};
c(end+1, :) = {'p = 97 with g = 5 is accepted', ~raises_error(@() check_dh_setup(97, 5))};
c(end+1, :) = {'p = 7 with g = 3 is accepted and p = 5 with g = 2 is accepted', ~raises_error(@() check_dh_setup(7, 3)) && ~raises_error(@() check_dh_setup(5, 2))};
c(end+1, :) = {'p = 2^26 - 5 with g = 2 is accepted', ~raises_error(@() check_dh_setup(2^26 - 5, 2))};
c(end+1, :) = {'p = 4 is rejected', raises_error(@() check_dh_setup(4))};
c(end+1, :) = {'p = 3 is rejected (too small)', raises_error(@() check_dh_setup(3))};
c(end+1, :) = {'p = 91 (not prime) is rejected', raises_error(@() check_dh_setup(91))};
c(end+1, :) = {'p = 67108879 (prime, but bigger than 2^26) is rejected', raises_error(@() check_dh_setup(67108879))};
c(end+1, :) = {'p = 97.5 is rejected', raises_error(@() check_dh_setup(97.5))};
c(end+1, :) = {'a list as p is rejected', raises_error(@() check_dh_setup([97 101]))};
c(end+1, :) = {'g = 2 is rejected for p = 97 (not a generator)', raises_error(@() check_dh_setup(97, 2))};
c(end+1, :) = {'g = 1, g = 0 and g = 96 are rejected for p = 97', raises_error(@() check_dh_setup(97, 1)) && raises_error(@() check_dh_setup(97, 0)) && raises_error(@() check_dh_setup(97, 96))};
c(end+1, :) = {'g = 97 and g = 5.5 are rejected for p = 97', raises_error(@() check_dh_setup(97, 97)) && raises_error(@() check_dh_setup(97, 5.5))};
c(end+1, :) = {'g = 2 is rejected for p = 7', raises_error(@() check_dh_setup(7, 2))};

% --- dh_public_value ---
c(end+1, :) = {'5^6 mod 97 is 8 and 5^15 mod 97 is 46', dh_public_value(6, 97, 5) == 8 && dh_public_value(15, 97, 5) == 46};
ok = true;
vals = zeros(1, 95);
for a = 1:95
    v = 1;
    for k = 1:a
        v = mod(v * 5, 97);
    end
    vals(a) = dh_public_value(a, 97, 5);
    ok = ok && vals(a) == v;
end
c(end+1, :) = {'for every secret number a from 1 to 95: the public value is 5 multiplied a times (mod 97)', ok};
c(end+1, :) = {'the 95 public values are all different and none is 1', numel(unique(vals)) == 95 && ~any(vals == 1)};
c(end+1, :) = {'p = 7, g = 3: the public values for a = 1 to 5 are 3 2 6 4 5', isequal(arrayfun(@(a) dh_public_value(a, 7, 3), 1:5), [3 2 6 4 5])};
c(end+1, :) = {'a = 0 is rejected', raises_error(@() dh_public_value(0, 97, 5))};
c(end+1, :) = {'a = p-1 = 96 is rejected', raises_error(@() dh_public_value(96, 97, 5))};
c(end+1, :) = {'a = p-2 = 95 is accepted', ~raises_error(@() dh_public_value(95, 97, 5))};
c(end+1, :) = {'a = 2.5 is rejected', raises_error(@() dh_public_value(2.5, 97, 5))};
c(end+1, :) = {'a negative a is rejected', raises_error(@() dh_public_value(-3, 97, 5))};
c(end+1, :) = {'a text as a is rejected', raises_error(@() dh_public_value('a', 97, 5))};
c(end+1, :) = {'g = 2 is rejected by dh_public_value for p = 97', raises_error(@() dh_public_value(6, 97, 2))};
c(end+1, :) = {'p = 91 is rejected by dh_public_value', raises_error(@() dh_public_value(6, 91, 5))};
c(end+1, :) = {'a missing argument is rejected by dh_public_value', raises_error(@() dh_public_value(6, 97))};

% --- dh_shared_key ---
c(end+1, :) = {'Alice: 46^6 mod 97 is 85, and Bob: 8^15 mod 97 is 85', dh_shared_key(6, 46, 97) == 85 && dh_shared_key(15, 8, 97) == 85};
ok = true;
for a = [1 2 3 10 50 95]
    for B = [1 2 3 46 96]
        v = 1;
        for k = 1:a
            v = mod(v * B, 97);
        end
        ok = ok && dh_shared_key(a, B, 97) == v;
    end
end
c(end+1, :) = {'the key is B multiplied a times (mod 97) for several a and B', ok};
c(end+1, :) = {'a = 0 and a = 96 are rejected by dh_shared_key', raises_error(@() dh_shared_key(0, 8, 97)) && raises_error(@() dh_shared_key(96, 8, 97))};
c(end+1, :) = {'B = 0 and B = 97 are rejected by dh_shared_key', raises_error(@() dh_shared_key(6, 0, 97)) && raises_error(@() dh_shared_key(6, 97, 97))};
c(end+1, :) = {'B = 2.5 is rejected by dh_shared_key', raises_error(@() dh_shared_key(6, 2.5, 97))};
c(end+1, :) = {'p = 4 is rejected by dh_shared_key', raises_error(@() dh_shared_key(1, 2, 4))};
c(end+1, :) = {'a missing argument is rejected by dh_shared_key', raises_error(@() dh_shared_key(6, 46))};

% --- dh_exchange ---
E = dh_exchange(6, 15, 97, 5);
c(end+1, :) = {'the exchange of 6 and 15: A = 8, B = 46', E.A == 8 && E.B == 46 && E.a == 6 && E.b == 15 && E.p == 97 && E.g == 5};
c(end+1, :) = {'the exchange of 6 and 15: both keys are 85 and they agree', E.key_alice == 85 && E.key_bob == 85 && E.agree && E.key == 85};
c(end+1, :) = {'the exchange of 6 and 15: a*b = 90, exponent 90, key from the formula 85', E.exponent == 90 && E.key_formula == 85};
ok = true;
for a = 1:5:95
    for b = 1:5:95
        E = dh_exchange(a, b, 97, 5);
        ok = ok && E.agree && E.key == E.key_formula && E.exponent == mod(a * b, 96) && E.key >= 1 && E.key <= 96 && E.A == dh_public_value(a, 97, 5) && E.B == dh_public_value(b, 97, 5);
    end
end
c(end+1, :) = {'p = 97: for 19 x 19 pairs of secret numbers both users agree and the formula holds', ok};
ok = true;
for a = 1:12
    for b = 1:12
        v = 1;
        for k = 1:(a * b)
            v = mod(v * 5, 97);
        end
        ok = ok && dh_exchange(a, b, 97, 5).key == v;
    end
end
c(end+1, :) = {'p = 97: the key is 5 multiplied a*b times (mod 97), for a, b = 1 to 12', ok};
ok = true;
for a = 1:5
    for b = 1:5
        ok = ok && dh_exchange(a, b, 7, 3).agree && dh_exchange(a, b, 7, 5).agree && dh_exchange(a, b, 7, 3).key == dh_exchange(b, a, 7, 3).key;
    end
end
c(end+1, :) = {'p = 7 (g = 3 and g = 5): all pairs agree, and swapping the users gives the same key', ok};
ok = true;
for a = 1:7:99
    for b = 1:9:99
        ok = ok && dh_exchange(a, b, 101, 2).agree;
    end
end
c(end+1, :) = {'p = 101, g = 2: the users agree', ok};
E = dh_exchange(123456, 654321, 2^26 - 5, 2);
c(end+1, :) = {'p = 2^26 - 5 with big secret numbers: both users agree and the formula holds', E.agree && E.key == E.key_formula && E.exponent == mod(123456 * 654321, 2^26 - 6)};
c(end+1, :) = {'secret numbers 0 and 96 are rejected by dh_exchange', raises_error(@() dh_exchange(0, 15, 97, 5)) && raises_error(@() dh_exchange(6, 96, 97, 5))};
c(end+1, :) = {'g = 2 is rejected by dh_exchange for p = 97', raises_error(@() dh_exchange(6, 15, 97, 2))};
c(end+1, :) = {'p = 91 is rejected by dh_exchange', raises_error(@() dh_exchange(6, 15, 91, 5))};
c(end+1, :) = {'a missing argument is rejected by dh_exchange', raises_error(@() dh_exchange(6, 15, 97))};

% --- define_secrets ---
D = define_secrets();
c(end+1, :) = {'the secret numbers are 6 15 23 41 58 77', isequal(D.private, [6 15 23 41 58 77])};
c(end+1, :) = {'the public values are 8 46 82 80 44 23', isequal(D.public, [8 46 82 80 44 23])};
c(end+1, :) = {'define_secrets gives the users of define_sets', isequal(D.users, S.users) && isequal(size(D.private), [1 6]) && isequal(size(D.public), [1 6])};
c(end+1, :) = {'the secret numbers are all different and from 1 to p-2', numel(unique(D.private)) == 6 && all(D.private >= 1) && all(D.private <= p - 2)};
ok = true;
for i = 1:6
    v = 1;
    for k = 1:D.private(i)
        v = mod(v * g, p);
    end
    ok = ok && D.public(i) == v;
end
c(end+1, :) = {'every public value is g multiplied (secret number) times (mod p)', ok};
c(end+1, :) = {'define_secrets(S) gives the same as define_secrets()', isequal(define_secrets(S), D)};
S2 = S;
S2.prime = 101;
S2.generator = 2;
D2 = define_secrets(S2);
c(end+1, :) = {'with p = 101 and g = 2 the public values are g^secret mod 101', isequal(D2.public, arrayfun(@(a) mod_pow(2, a, 101), D2.private))};
S3 = S;
S3.prime = 61;
S3.generator = 2;
c(end+1, :) = {'a prime that is too small for the secret numbers (p = 61) is refused', raises_error(@() define_secrets(S3))};
S4 = S;
S4.users = {'Alice', 'Bob'};
c(end+1, :) = {'a wrong number of users is refused', raises_error(@() define_secrets(S4))};

% --- dh_key_table ---
K = dh_key_table(D, p);
c(end+1, :) = {'the table of keys is known', isequal(K, [0 85 12 89 33 18; 85 0 67 42 8 28; 12 67 0 90 11 60; 89 42 90 0 32 41; 33 8 11 32 0 72; 18 28 60 41 72 0])};
c(end+1, :) = {'the table of keys is 6 x 6, symmetric, and has 0 on the diagonal', isequal(size(K), [6 6]) && isequal(K, K') && all(diag(K) == 0)};
ok = true;
for i = 1:6
    for j = 1:6
        if i ~= j
            ok = ok && K(i, j) == mod_pow(g, mod(D.private(i) * D.private(j), p - 1), p);
        end
    end
end
c(end+1, :) = {'every key in the table is g^(secret i * secret j mod (p-1)) mod p', ok};
off = ~eye(6);
c(end+1, :) = {'every key in the table is a key from 1 to p-1', all(ismember(K(off)', S.keys))};
c(end+1, :) = {'the key of Alice and Bob in the table is the key of dh_exchange', K(1, 2) == dh_exchange(D.private(1), D.private(2), p, g).key};

% --- show_dh ---
txt = evalc('show_dh(S)');
c(end+1, :) = {'show_dh prints its title and the public numbers', ~isempty(strfind(txt, '=== DIFFIE-HELLMAN KEY EXCHANGE ===')) && ~isempty(strfind(txt, 'the public numbers p = 97 and g = 5, also an eavesdropper.'))};
c(end+1, :) = {'show_dh prints the public values A = 8 and B = 46', ~isempty(strfind(txt, 'Alice picks the secret number a = 6 and sends A = g^a mod p = 5^6 mod 97 = 8.')) && ~isempty(strfind(txt, 'Bob picks the secret number b = 15 and sends B = g^b mod p = 5^15 mod 97 = 46.'))};
c(end+1, :) = {'show_dh prints that both compute the key 85', ~isempty(strfind(txt, 'Alice computes B^a mod p = 46^6 mod 97 = 85.')) && ~isempty(strfind(txt, 'Bob computes A^b mod p = 8^15 mod 97 = 85.')) && ~isempty(strfind(txt, 'Both keys are the same: yes. The key is 85, a number from 1 to 96'))};
c(end+1, :) = {'show_dh prints why it works (a*b = 90, 5^90 mod 97 = 85)', ~isempty(strfind(txt, 'Here a*b = 90, a*b mod 96 = 90, and 5^90 mod 97 = 85.')) && ~isempty(strfind(txt, 'Only A = 8 and B = 46 did.'))};
c(end+1, :) = {'show_dh prints the secret numbers and public values of the users', ~isempty(strfind(txt, '  Alice     6         8')) && ~isempty(strfind(txt, '  Grace     77        23'))};
c(end+1, :) = {'show_dh prints the rows of Alice and Grace in the table of keys', ~isempty(strfind(txt, '  Alice     -       85      12      89      33      18')) && ~isempty(strfind(txt, '  Grace     18      28      60      41      72      -'))};
c(end+1, :) = {'show_dh prints that the table is symmetric', ~isempty(strfind(txt, 'so two users always get the same key: yes'))};
pos = strfind(txt, 'Checks:');
tail = txt(pos(end):end);
c(end+1, :) = {'show_dh ends with 7 check lines that all say yes', numel(strfind(tail, ': yes')) == 7 && isempty(strfind(tail, ': NO'))};
S5 = S;
S5.prime = 101;
S5.generator = 2;
txt5 = evalc('show_dh(S5)');
c(end+1, :) = {'show_dh also works for p = 101 with g = 2', ~isempty(strfind(txt5, 'p = 101 and g = 2')) && isempty(strfind(txt5, ': NO'))};

% --- demo_point4 ---
txt2 = evalc('demo_point4()');
c(end+1, :) = {'demo_point4 prints its title and the key exchange', ~isempty(strfind(txt2, 'POINT 4 DEMO: DIFFIE-HELLMAN KEY EXCHANGE AND ENCRYPTION')) && ~isempty(strfind(txt2, '=== DIFFIE-HELLMAN KEY EXCHANGE ==='))};
pos2 = strfind(txt2, 'Checks:');
c(end+1, :) = {'demo_point4 has 7 check lines that all say yes and none says NO', numel(pos2) == 1 && numel(strfind(txt2(pos2(1):end), ': yes')) == 7 && isempty(strfind(txt2, ': NO'))};

summarize_checks('test_dh', c);
end
