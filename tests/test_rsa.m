function test_rsa()
% TEST_RSA Checks for RSA: check_rsa_setup, rsa_make_keys, rsa_encrypt_number, rsa_decrypt_number, rsa_encrypt_text, rsa_decrypt_text, rsa_format_numbers, show_rsa and demo_point7.
S = define_sets();
c = cell(0, 2);

% --- check_rsa_setup ---
c(end+1, :) = {'p = 61 and q = 53 are accepted', ~raises_error(@() check_rsa_setup(61, 53))};
c(end+1, :) = {'p = 61, q = 53, e = 17 are accepted', ~raises_error(@() check_rsa_setup(61, 53, 17))};
c(end+1, :) = {'p = 11, q = 13 (n = 143) with e = 7 are accepted', ~raises_error(@() check_rsa_setup(11, 13, 7))};
c(end+1, :) = {'p = 2, q = 53 (n = 106) with e = 3 are accepted', ~raises_error(@() check_rsa_setup(2, 53, 3))};
c(end+1, :) = {'the order of p and q does not matter', ~raises_error(@() check_rsa_setup(53, 61, 17))};
c(end+1, :) = {'p = 8191, q = 8179 (n = 66994189, just below 2^26) with e = 65537 are accepted', ~raises_error(@() check_rsa_setup(8191, 8179, 65537))};
c(end+1, :) = {'p = 4 (not prime) is rejected', raises_error(@() check_rsa_setup(4, 53))};
c(end+1, :) = {'q = 51 (not prime) is rejected', raises_error(@() check_rsa_setup(61, 51))};
c(end+1, :) = {'p = 1, p = 0 and p = -7 are rejected', raises_error(@() check_rsa_setup(1, 53)) && raises_error(@() check_rsa_setup(0, 53)) && raises_error(@() check_rsa_setup(-7, 53))};
c(end+1, :) = {'p = 61.5 and a list as p are rejected', raises_error(@() check_rsa_setup(61.5, 53)) && raises_error(@() check_rsa_setup([61 67], 53))};
c(end+1, :) = {'a text as p or as q is rejected', raises_error(@() check_rsa_setup('a', 53)) && raises_error(@() check_rsa_setup(61, 'a'))};
c(end+1, :) = {'p = q = 61 is rejected', raises_error(@() check_rsa_setup(61, 61))};
c(end+1, :) = {'n = 7*13 = 91 (smaller than 97) is rejected', raises_error(@() check_rsa_setup(7, 13))};
c(end+1, :) = {'n = 3*5 = 15 is rejected', raises_error(@() check_rsa_setup(3, 5))};
c(end+1, :) = {'n = 8191*8209 = 67239919 (bigger than 2^26) is rejected', raises_error(@() check_rsa_setup(8191, 8209))};
c(end+1, :) = {'a prime bigger than 2^26 is rejected', raises_error(@() check_rsa_setup(67108879, 3))};
c(end+1, :) = {'e = 2 is rejected (too small)', raises_error(@() check_rsa_setup(61, 53, 2))};
c(end+1, :) = {'e = 3 is rejected for phi = 3120 (gcd is 3)', raises_error(@() check_rsa_setup(61, 53, 3))};
c(end+1, :) = {'e = 15 is rejected for phi = 3120 (gcd is 15)', raises_error(@() check_rsa_setup(61, 53, 15))};
c(end+1, :) = {'e = phi = 3120 and e = 3121 are rejected', raises_error(@() check_rsa_setup(61, 53, 3120)) && raises_error(@() check_rsa_setup(61, 53, 3121))};
c(end+1, :) = {'e = phi-1 = 3119 passes check_rsa_setup (the self-inverse test is in rsa_make_keys)', ~raises_error(@() check_rsa_setup(61, 53, 3119))};
c(end+1, :) = {'e = 17.5 and e = ''a'' are rejected', raises_error(@() check_rsa_setup(61, 53, 17.5)) && raises_error(@() check_rsa_setup(61, 53, 'a'))};
c(end+1, :) = {'a missing p or q is rejected', raises_error(@() check_rsa_setup(61)) && raises_error(@() check_rsa_setup())};
errid = '';
try
    check_rsa_setup(61, 61);
catch err
    errid = err.identifier;
end
c(end+1, :) = {'the error for p = q is check_rsa_setup:same', strcmp(errid, 'check_rsa_setup:same')};
errid = '';
try
    check_rsa_setup(61, 53, 15);
catch err
    errid = err.identifier;
end
c(end+1, :) = {'the error for e = 15 is check_rsa_setup:gcd', strcmp(errid, 'check_rsa_setup:gcd')};

% --- rsa_make_keys ---
K = rsa_make_keys(61, 53, 17);
c(end+1, :) = {'p = 61, q = 53, e = 17: n = 3233, phi = 3120, d = 2753', K.p == 61 && K.q == 53 && K.n == 3233 && K.phi == 3120 && K.e == 17 && K.d == 2753};
c(end+1, :) = {'the key struct has the fields p, q, n, phi, e, d', isequal(fieldnames(K), {'p'; 'q'; 'n'; 'phi'; 'e'; 'd'})};
K2 = rsa_make_keys(11, 13, 7);
c(end+1, :) = {'p = 11, q = 13, e = 7: n = 143, phi = 120, d = 103', K2.n == 143 && K2.phi == 120 && K2.d == 103};
known = [47 59 17 2773 2668 157; 43 67 5 2881 2772 1109; 71 37 11 2627 2520 2291; 79 31 7 2449 2340 1003; 73 41 7 2993 2880 823; 13 17 5 221 192 77; 2 53 3 106 52 35];
ok = true;
for k = 1:size(known, 1)
    Kk = rsa_make_keys(known(k, 1), known(k, 2), known(k, 3));
    ok = ok && isequal([Kk.n Kk.phi Kk.d], known(k, 4:6));
end
c(end+1, :) = {'7 more keys give the n, phi and d of an independent Python program', ok};
Kb = rsa_make_keys(8191, 8179, 65537);
c(end+1, :) = {'the big key p = 8191, q = 8179, e = 65537: n = 66994189, d = 60980813', Kb.n == 66994189 && Kb.phi == 66977820 && Kb.d == 60980813};
primes_list = [11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97];
ok = true;
count = 0;
for a = 1:numel(primes_list)
    for b = (a + 1):numel(primes_list)
        pp = primes_list(a);
        qq = primes_list(b);
        phi = (pp - 1) * (qq - 1);
        e = 3;
        while e < phi - 1 && (gcd(e, phi) ~= 1 || mod(e * e, phi) == 1)
            e = e + 2;
        end
        Kq = rsa_make_keys(pp, qq, e);
        dsearch = find(mod(e * (1:(phi - 1)), phi) == 1);
        ok = ok && Kq.n == pp * qq && Kq.phi == phi && isequal(Kq.d, dsearch) && mod(Kq.e * Kq.d, Kq.phi) == 1 && Kq.d ~= Kq.e;
        count = count + 1;
    end
end
c(end+1, :) = {sprintf('for all %d pairs of primes from 11 to 97: d is the one number with e*d = 1 (mod phi), found by trying every number', count), ok && count == 210};
Ki = rsa_make_keys(int32(61), int32(53), int32(17));
c(end+1, :) = {'integer types are accepted and the key is the same as with doubles', isequal(Ki, K) && isa(Ki.n, 'double')};
errid = '';
try
    rsa_make_keys(61, 53, 3119);
catch err
    errid = err.identifier;
end
c(end+1, :) = {'e = 3119 (its own inverse mod 3120) is refused with rsa_make_keys:selfinverse', strcmp(errid, 'rsa_make_keys:selfinverse')};
c(end+1, :) = {'rsa_make_keys refuses p = q, e = 15, n = 91 and a missing e', raises_error(@() rsa_make_keys(61, 61, 17)) && raises_error(@() rsa_make_keys(61, 53, 15)) && raises_error(@() rsa_make_keys(7, 13, 5)) && raises_error(@() rsa_make_keys(61, 53))};

% --- rsa_encrypt_number and rsa_decrypt_number ---
c(end+1, :) = {'65 encrypts to 2790 and 2790 decrypts to 65', rsa_encrypt_number(65, 3233, 17) == 2790 && rsa_decrypt_number(2790, 3233, 2753) == 65};
c(end+1, :) = {'41 encrypts to 3199 and 74 encrypts to 1877 (Python values)', rsa_encrypt_number(41, 3233, 17) == 3199 && rsa_encrypt_number(74, 3233, 17) == 1877};
c(end+1, :) = {'65 with the big key encrypts to 7069219 and decrypts back', rsa_encrypt_number(65, Kb.n, Kb.e) == 7069219 && rsa_decrypt_number(7069219, Kb.n, Kb.d) == 65};
n = 3233;
x = 0:(n - 1);
r = ones(1, n);
for k = 1:17
    r = mod(r .* x, n);
end
enc = zeros(1, n);
for m = x
    enc(m + 1) = rsa_encrypt_number(m, n, 17);
end
c(end+1, :) = {'for every m from 0 to 3232: m^17 mod 3233 is m multiplied 17 times (mod 3233)', isequal(enc, r)};
r = ones(1, n);
for k = 1:2753
    r = mod(r .* x, n);
end
dec = zeros(1, n);
for m = x
    dec(m + 1) = rsa_decrypt_number(m, n, 2753);
end
c(end+1, :) = {'for every c from 0 to 3232: c^2753 mod 3233 is c multiplied 2753 times (mod 3233)', isequal(dec, r)};
c(end+1, :) = {'every number from 0 to 3232 comes back after encryption and decryption', isequal(dec(enc + 1), x)};
c(end+1, :) = {'encryption is one-to-one on 0 to 3232 (3233 different values)', numel(unique(enc)) == n};
c(end+1, :) = {'0, 1 and n-1 stay the same under encryption', enc(1) == 0 && enc(2) == 1 && enc(n) == n - 1};
c(end+1, :) = {'25 numbers stay the same under encryption (the formula (1 + gcd(e-1, p-1)) * (1 + gcd(e-1, q-1)) gives 25)', sum(enc == x) == 25 && (1 + gcd(16, 60)) * (1 + gcd(16, 52)) == 25};
ok = true;
for a = 1:numel(primes_list)
    for b = (a + 1):numel(primes_list)
        pp = primes_list(a);
        qq = primes_list(b);
        phi = (pp - 1) * (qq - 1);
        e = 3;
        while e < phi - 1 && (gcd(e, phi) ~= 1 || mod(e * e, phi) == 1)
            e = e + 2;
        end
        Kq = rsa_make_keys(pp, qq, e);
        for m = [0 1 2 50 95 floor(Kq.n / 2) Kq.n - 1]
            ok = ok && rsa_decrypt_number(rsa_encrypt_number(m, Kq.n, Kq.e), Kq.n, Kq.d) == m;
        end
    end
end
c(end+1, :) = {'210 keys: 7 numbers each come back after encryption and decryption', ok};
ok = true;
for k = 1:size(known, 1)
    Kk = rsa_make_keys(known(k, 1), known(k, 2), known(k, 3));
    for m = 0:(Kk.n - 1)
        ok = ok && rsa_decrypt_number(rsa_encrypt_number(m, Kk.n, Kk.e), Kk.n, Kk.d) == m;
    end
end
c(end+1, :) = {'7 keys: every number from 0 to n-1 comes back (n = 106 to 2993)', ok};
c(end+1, :) = {'decrypting with the public exponent e instead of d does not give 65 back', rsa_decrypt_number(rsa_encrypt_number(65, 3233, 17), 3233, 17) ~= 65};
c(end+1, :) = {'encrypting m = n is rejected', raises_error(@() rsa_encrypt_number(3233, 3233, 17))};
c(end+1, :) = {'encrypting m = -1 and m = 2.5 is rejected', raises_error(@() rsa_encrypt_number(-1, 3233, 17)) && raises_error(@() rsa_encrypt_number(2.5, 3233, 17))};
c(end+1, :) = {'a text or a list as m is rejected', raises_error(@() rsa_encrypt_number('a', 3233, 17)) && raises_error(@() rsa_encrypt_number([1 2], 3233, 17))};
c(end+1, :) = {'n = 96 and n = 2^26 + 1 are rejected by rsa_encrypt_number', raises_error(@() rsa_encrypt_number(5, 96, 17)) && raises_error(@() rsa_encrypt_number(5, 2^26 + 1, 17))};
c(end+1, :) = {'n = 97 is accepted by rsa_encrypt_number (the number check does not test for primes)', ~raises_error(@() rsa_encrypt_number(5, 97, 17))};
c(end+1, :) = {'e = 2 and e = 17.5 are rejected by rsa_encrypt_number', raises_error(@() rsa_encrypt_number(5, 3233, 2)) && raises_error(@() rsa_encrypt_number(5, 3233, 17.5))};
c(end+1, :) = {'a missing argument is rejected by rsa_encrypt_number', raises_error(@() rsa_encrypt_number(5, 3233))};
c(end+1, :) = {'decrypting c = n is rejected', raises_error(@() rsa_decrypt_number(3233, 3233, 2753))};
c(end+1, :) = {'decrypting c = -1 and c = 2.5 is rejected', raises_error(@() rsa_decrypt_number(-1, 3233, 2753)) && raises_error(@() rsa_decrypt_number(2.5, 3233, 2753))};
c(end+1, :) = {'d = 0 and d = 2.5 are rejected by rsa_decrypt_number', raises_error(@() rsa_decrypt_number(5, 3233, 0)) && raises_error(@() rsa_decrypt_number(5, 3233, 2.5))};
c(end+1, :) = {'n = 96 and a text as n are rejected by rsa_decrypt_number', raises_error(@() rsa_decrypt_number(5, 96, 2753)) && raises_error(@() rsa_decrypt_number(5, 'a', 2753))};
c(end+1, :) = {'a missing argument is rejected by rsa_decrypt_number', raises_error(@() rsa_decrypt_number(5, 3233))};

% --- rsa_encrypt_text and rsa_decrypt_text ---
txt = 'Meet me at the library at 5 pm, Bob.';
ct = rsa_encrypt_text(txt, 3233, 17);
c(end+1, :) = {'the demo text encrypts to the numbers of the Python program', isequal(ct(1:12), [2825 325 325 2310 1 3165 325 1 524 2310 1 2310])};
c(end+1, :) = {'the ciphertext is one row with one number for each character', isequal(size(ct), [1 numel(txt)])};
c(end+1, :) = {'every ciphertext number is from 0 to n-1', all(ct >= 0) && all(ct <= 3232)};
sym = double(txt) - 31;
second = zeros(1, numel(sym));
for k = 1:numel(sym)
    v = 1;
    for t = 1:17
        v = mod(v * sym(k), 3233);
    end
    second(k) = v;
end
c(end+1, :) = {'the ciphertext is every symbol multiplied 17 times (mod 3233)', isequal(ct, second)};
c(end+1, :) = {'the 8 spaces of the demo text give the number 1', sum(txt == ' ') == 8 && all(ct(txt == ' ') == 1)};
c(end+1, :) = {'equal characters give equal numbers (the 4 letters t of the text)', numel(unique(ct(txt == 't'))) == 1 && sum(txt == 't') == 4};
c(end+1, :) = {'the same text gives the same numbers again', isequal(rsa_encrypt_text(txt, 3233, 17), ct)};
c(end+1, :) = {'the text comes back after decryption', strcmp(rsa_decrypt_text(ct, 3233, 2753), txt)};
alltext = char(32:126);
ok = true;
for k = 1:size(known, 1)
    Kk = rsa_make_keys(known(k, 1), known(k, 2), known(k, 3));
    ok = ok && strcmp(rsa_decrypt_text(rsa_encrypt_text(alltext, Kk.n, Kk.e), Kk.n, Kk.d), alltext);
end
c(end+1, :) = {'all 95 printable characters come back, for 7 keys', ok};
c(end+1, :) = {'all 95 printable characters come back with the big key', strcmp(rsa_decrypt_text(rsa_encrypt_text(alltext, Kb.n, Kb.e), Kb.n, Kb.d), alltext)};
c(end+1, :) = {'a text of one character works', strcmp(rsa_decrypt_text(rsa_encrypt_text('x', 3233, 17), 3233, 2753), 'x')};
errid = '';
try
    rsa_decrypt_text(ct, 3233, 2752);
catch err
    errid = err.identifier;
end
c(end+1, :) = {'a wrong private key (d - 1) stops with rsa_decrypt_text:symbols', strcmp(errid, 'rsa_decrypt_text:symbols')};
other = rsa_make_keys(47, 59, 17);
wrong_ok = true;
for k = 1:size(known, 1)
    Kk = rsa_make_keys(known(k, 1), known(k, 2), known(k, 3));
    if Kk.n >= 97 && Kk.d ~= 2753
        try
            back = rsa_decrypt_text(ct, 3233, Kk.d);
            wrong_ok = wrong_ok && ~strcmp(back, txt);
        catch
        end
    end
end
c(end+1, :) = {'the private keys of 7 other users never give the text back', wrong_ok};
c(end+1, :) = {'the same text encrypted for another user (n = 2773) does not decrypt with the key of n = 3233', raises_error(@() rsa_decrypt_text(rsa_encrypt_text(txt, other.n, other.e), 3233, 2753)) || ~strcmp(rsa_decrypt_text(rsa_encrypt_text(txt, other.n, other.e), 3233, 2753), txt)};
c(end+1, :) = {'an empty text is rejected', raises_error(@() rsa_encrypt_text('', 3233, 17))};
c(end+1, :) = {'a number as text is rejected', raises_error(@() rsa_encrypt_text(65, 3233, 17))};
c(end+1, :) = {'a text with 2 rows is rejected', raises_error(@() rsa_encrypt_text(['ab'; 'cd'], 3233, 17))};
c(end+1, :) = {'a character outside the 95 printable characters is rejected', raises_error(@() rsa_encrypt_text(['a' char(10) 'b'], 3233, 17))};
c(end+1, :) = {'a cell as text is rejected', raises_error(@() rsa_encrypt_text({'abc'}, 3233, 17))};
c(end+1, :) = {'a bad n or e is rejected by rsa_encrypt_text', raises_error(@() rsa_encrypt_text('abc', 96, 17)) && raises_error(@() rsa_encrypt_text('abc', 3233, 2))};
c(end+1, :) = {'a missing argument is rejected by rsa_encrypt_text', raises_error(@() rsa_encrypt_text('abc', 3233))};
c(end+1, :) = {'an empty ciphertext is rejected', raises_error(@() rsa_decrypt_text([], 3233, 2753))};
c(end+1, :) = {'a column of numbers is rejected as ciphertext', raises_error(@() rsa_decrypt_text([2825; 325], 3233, 2753))};
c(end+1, :) = {'a text as ciphertext is rejected', raises_error(@() rsa_decrypt_text('abc', 3233, 2753))};
c(end+1, :) = {'a ciphertext number n or bigger is rejected', raises_error(@() rsa_decrypt_text([2825 3233], 3233, 2753))};
errid = '';
try
    rsa_decrypt_text([2825 0], 3233, 2753);
catch err
    errid = err.identifier;
end
c(end+1, :) = {'a ciphertext number 0 gives the error rsa_decrypt_text:symbols (0 is not a symbol)', strcmp(errid, 'rsa_decrypt_text:symbols')};
errid = '';
try
    rsa_decrypt_text(rsa_encrypt_number(96, 3233, 17), 3233, 2753);
catch err
    errid = err.identifier;
end
c(end+1, :) = {'a ciphertext number that decrypts to 96 (just above the last symbol 95) gives the error rsa_decrypt_text:symbols', strcmp(errid, 'rsa_decrypt_text:symbols')};
c(end+1, :) = {'a missing argument is rejected by rsa_decrypt_text', raises_error(@() rsa_decrypt_text(ct, 3233))};

% --- rsa_format_numbers ---
expected = ['  ' '    1' '   22' char(10) '  ' '  333' ' 4444'];
c(end+1, :) = {'rsa_format_numbers puts the numbers in fields one place wider than the biggest', strcmp(rsa_format_numbers([1 22 333 4444], 2), expected)};
c(end+1, :) = {'rsa_format_numbers: 12 numbers of 4 digits in a row do not run together', isempty(strfind(rsa_format_numbers(3000:3011, 12), '30003001'))};
c(end+1, :) = {'rsa_format_numbers: one number gives one short line without new line', strcmp(rsa_format_numbers(7, 5), '  7') || strcmp(rsa_format_numbers(7, 5), '   7')};
c(end+1, :) = {'rsa_format_numbers: an empty list, a negative number and 1.5 are rejected', raises_error(@() rsa_format_numbers([], 3)) && raises_error(@() rsa_format_numbers(-1, 3)) && raises_error(@() rsa_format_numbers(1.5, 3))};
c(end+1, :) = {'rsa_format_numbers: per_row 0 and a text are rejected', raises_error(@() rsa_format_numbers([1 2], 0)) && raises_error(@() rsa_format_numbers('abc', 3))};
c(end+1, :) = {'rsa_format_numbers: numbers bigger than 9999 are accepted', ~isempty(strfind(rsa_format_numbers([66994189 5], 2), '66994189'))};

% --- show_rsa ---
out = evalc('show_rsa(S)');
c(end+1, :) = {'show_rsa prints its title', ~isempty(strfind(out, '=== RSA PUBLIC-KEY ENCRYPTION ==='))};
c(end+1, :) = {'show_rsa prints n and phi', ~isempty(strfind(out, 'n = p*q = 61 * 53 = 3233.')) && ~isempty(strfind(out, 'phi = (p-1)*(q-1) = 60 * 52 = 3120.'))};
c(end+1, :) = {'show_rsa prints the extended Euclid algorithm and d', ~isempty(strfind(out, '17 * (-367) + 3120 * (2) = 1.')) && ~isempty(strfind(out, 'So d = x mod phi = -367 mod 3120 = 2753.'))};
c(end+1, :) = {'show_rsa prints the public and the private key', ~isempty(strfind(out, 'Public key: (n, e) = (3233, 17). Private key: d = 2753.'))};
c(end+1, :) = {'show_rsa prints the encryption and the decryption of 65', ~isempty(strfind(out, 'c = m^e mod n = 65^17 mod 3233 = 2790.')) && ~isempty(strfind(out, 'm = c^d mod n = 2790^2753 mod 3233 = 65.'))};
c(end+1, :) = {'show_rsa prints the binary exponents and the step counts', ~isempty(strfind(out, 'The exponent 17 is 10001 in binary, so it takes 5 squaring steps and 2 multiplication steps')) && ~isempty(strfind(out, 'The exponent 2753 is 101011000001 in binary, so it takes 12 squaring steps and 5 multiplication steps'))};
c(end+1, :) = {'show_rsa prints the first character M and its number 2825', ~isempty(strfind(out, 'the first character M is the symbol 46, and 46^17 mod 3233 = 2825.'))};
c(end+1, :) = {'show_rsa prints the text that comes out', ~isempty(strfind(out, 'The text that comes out: Meet me at the library at 5 pm, Bob.')) && ~isempty(strfind(out, 'It is the same as the message: yes'))};
c(end+1, :) = {'show_rsa prints the remark about the 8 spaces', ~isempty(strfind(out, 'each of the 8 spaces stays the number 1.'))};
c(end+1, :) = {'show_rsa prints the group: 3120 elements and k = 15', ~isempty(strfind(out, 'gives 3120 numbers, and phi = 3120: yes.')) && ~isempty(strfind(out, 'e*d = 17 * 2753 = 46801 = 1 + 15 * phi.'))};
c(end+1, :) = {'show_rsa prints the comparison with Z_97*', ~isempty(strfind(out, 'the group was Z_97* with 96 elements. Here the group has phi = 3120 elements'))};
c(end+1, :) = {'show_rsa prints what a wrong key gives', ~isempty(strfind(out, 'with a wrong private key, d = 2752 instead of 2753.'))};
pos = strfind(out, 'Checks:');
tail = out(pos(end):end);
c(end+1, :) = {'show_rsa ends with 8 check lines that all say yes', numel(strfind(tail, ': yes')) == 8 && isempty(strfind(tail, ': NO'))};
c(end+1, :) = {'show_rsa() without an argument prints the same as show_rsa(S)', strcmp(evalc('show_rsa()'), out)};
S2 = S;
S2.prime = 101;
S2.generator = 2;
out2 = evalc('show_rsa(S2)');
c(end+1, :) = {'show_rsa with p = 101 for Diffie-Hellman says Z_101* with 100 elements and still checks yes', ~isempty(strfind(out2, 'the group was Z_101* with 100 elements.')) && isempty(strfind(out2, ': NO'))};

% --- demo_point7 ---
out3 = evalc('demo_point7()');
c(end+1, :) = {'demo_point7 prints its title and the RSA part', ~isempty(strfind(out3, 'POINT 7 DEMO: RSA PUBLIC-KEY ENCRYPTION')) && ~isempty(strfind(out3, '=== RSA PUBLIC-KEY ENCRYPTION ==='))};
c(end+1, :) = {'demo_point7 has 8 check lines that all say yes', numel(strfind(out3, ': yes')) >= 8 && isempty(strfind(out3, ': NO'))};

summarize_checks('test_rsa', c);
end
