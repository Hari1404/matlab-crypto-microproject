function test_modular()
% TEST_MODULAR Checks for the modular arithmetic tools: is_whole_number, mod_pow, euclid_gcd, ext_gcd, mod_inverse, show_modular and demo_point3.
S = define_sets();
c = cell(0, 2);

% --- is_whole_number ---
c(end+1, :) = {'0 is a whole number', is_whole_number(0)};
c(end+1, :) = {'7 is a whole number', is_whole_number(7)};
c(end+1, :) = {'-3 is a whole number', is_whole_number(-3)};
c(end+1, :) = {'2^53 is a whole number that is still exact', is_whole_number(2^53)};
c(end+1, :) = {'2^53 + 2 is too big', ~is_whole_number(2^53 + 2)};
c(end+1, :) = {'2.5 is not a whole number', ~is_whole_number(2.5)};
c(end+1, :) = {'NaN is not a whole number', ~is_whole_number(NaN)};
c(end+1, :) = {'Inf is not a whole number', ~is_whole_number(Inf)};
c(end+1, :) = {'a list of two numbers is not one whole number', ~is_whole_number([1 2])};
c(end+1, :) = {'an empty list is not a whole number', ~is_whole_number([])};
c(end+1, :) = {'a text is not a whole number', ~is_whole_number('a')};
c(end+1, :) = {'true is not a whole number', ~is_whole_number(true)};
c(end+1, :) = {'a complex number is not a whole number', ~is_whole_number(1 + 2i)};

% --- mod_pow: known values ---
c(end+1, :) = {'5^13 mod 97 is 29', mod_pow(5, 13, 97) == 29};
c(end+1, :) = {'2^10 mod 1000 is 24', mod_pow(2, 10, 1000) == 24};
c(end+1, :) = {'7^222 mod 1000 is 49', mod_pow(7, 222, 1000) == 49};
c(end+1, :) = {'5^96 mod 97 is 1 (Fermat)', mod_pow(5, 96, 97) == 1};
c(end+1, :) = {'5^1 mod 97 is 5', mod_pow(5, 1, 97) == 5};
c(end+1, :) = {'7^0 mod 97 is 1', mod_pow(7, 0, 97) == 1};
c(end+1, :) = {'0^0 is 1 by the usual rule', mod_pow(0, 0, 97) == 1};
c(end+1, :) = {'0^5 mod 97 is 0', mod_pow(0, 5, 97) == 0};
c(end+1, :) = {'1^100 mod 97 is 1', mod_pow(1, 100, 97) == 1};
c(end+1, :) = {'a base bigger than m is reduced: 100^2 mod 97 is 9', mod_pow(100, 2, 97) == 9};
c(end+1, :) = {'97^5 mod 97 is 0', mod_pow(97, 5, 97) == 0};
c(end+1, :) = {'modulus 2: 3^5 mod 2 is 1 and 4^5 mod 2 is 0', mod_pow(3, 5, 2) == 1 && mod_pow(4, 5, 2) == 0};
c(end+1, :) = {'a huge exponent: 3^(10^15) mod 7 is 4', mod_pow(3, 1e15, 7) == 4};
c(end+1, :) = {'a huge exponent: 3^(10^15) mod 2^26 is 20054017', mod_pow(3, 1e15, 2^26) == 20054017};
c(end+1, :) = {'123456789^987654321 mod 2^26 is 11249237', mod_pow(123456789, 987654321, 2^26) == 11249237};
c(end+1, :) = {'the biggest exponent 2^53: 5^(2^53) mod 97 is 35', mod_pow(5, 2^53, 97) == 35};
c(end+1, :) = {'the biggest base 2^53: (2^53)^3 mod 97 is 79', mod_pow(2^53, 3, 97) == 79};
c(end+1, :) = {'the biggest modulus 2^26: (2^26 - 1)^2 mod 2^26 is 1', mod_pow(2^26 - 1, 2, 2^26) == 1};
c(end+1, :) = {'the result is one number', isscalar(mod_pow(5, 13, 97))};

% --- mod_pow: the steps ---
[r, st] = mod_pow(5, 13, 97);
c(end+1, :) = {'steps of 5^13 mod 97 are [1 1 5; 1 25 28; 0 8 8; 1 64 29]', isequal(st, [1 1 5; 1 25 28; 0 8 8; 1 64 29])};
c(end+1, :) = {'the last value in the steps is the result', st(end, 3) == r};
[r, st] = mod_pow(7, 0, 97);
c(end+1, :) = {'for e = 0 there are no steps and the result is 1', isempty(st) && size(st, 2) == 3 && r == 1};
[r, st] = mod_pow(5, 1, 97);
c(end+1, :) = {'for e = 1 there is one step [1 1 5]', isequal(st, [1 1 5])};
ok = true;
for e = 1:200
    [r, st] = mod_pow(3, e, 1009);
    ok = ok && isequal(sprintf('%d', st(:, 1)'), dec2bin(e)) && st(1, 1) == 1 && st(end, 3) == r && size(st, 2) == 3;
end
c(end+1, :) = {'for e = 1 to 200 the bits in the steps are the binary digits of e', ok};
ok = true;
for e = 1:200
    [r, st] = mod_pow(3, e, 1009);
    for i = 2:size(st, 1)
        ok = ok && st(i, 2) == mod(st(i - 1, 3) ^ 2, 1009);
        if st(i, 1) == 1
            ok = ok && st(i, 3) == mod(st(i, 2) * 3, 1009);
        else
            ok = ok && st(i, 3) == st(i, 2);
        end
    end
end
c(end+1, :) = {'in every step: square the last value, multiply by b only when the bit is 1', ok};

% --- mod_pow: agrees with plain multiplication ---
ok = true;
for b = 0:96
    plain = 1;
    for e = 0:8
        ok = ok && mod_pow(b, e, 97) == plain;
        plain = mod(plain * b, 97);
    end
end
c(end+1, :) = {'mod 97: b^e agrees with plain multiplication for b = 0 to 96, e = 0 to 8', ok};
ok = true;
for m = 2:40
    for b = 0:(m + 3)
        plain = 1;
        for e = 0:12
            ok = ok && mod_pow(b, e, m) == plain;
            plain = mod(plain * b, m);
        end
    end
end
c(end+1, :) = {'for m = 2 to 40: b^e agrees with plain multiplication for b = 0 to m+3, e = 0 to 12', ok};
ok = true;
for a = 1:96
    ok = ok && mod_pow(a, 96, 97) == 1;
end
c(end+1, :) = {'a^96 mod 97 is 1 for every a from 1 to 96', ok};
ok = true;
for a = 1:96
    ok = ok && mod_pow(a, 97, 97) == a;
end
c(end+1, :) = {'a^97 mod 97 is a for every a from 1 to 96', ok};
vals = zeros(1, 96);
for e = 0:95
    vals(e + 1) = mod_pow(5, e, 97);
end
c(end+1, :) = {'the powers 5^0 to 5^95 mod 97 are all different (5 is a generator)', numel(unique(vals)) == 96};
c(end+1, :) = {'the product rule: 5^30 * 5^40 = 5^70 (mod 97)', mod(mod_pow(5, 30, 97) * mod_pow(5, 40, 97), 97) == mod_pow(5, 70, 97)};
c(end+1, :) = {'the power rule: (5^6)^7 = 5^42 (mod 97)', mod_pow(mod_pow(5, 6, 97), 7, 97) == mod_pow(5, 42, 97)};

% --- mod_pow: bad input ---
c(end+1, :) = {'a negative base is rejected by mod_pow', raises_error(@() mod_pow(-1, 2, 97))};
c(end+1, :) = {'a negative exponent is rejected by mod_pow', raises_error(@() mod_pow(2, -1, 97))};
c(end+1, :) = {'a base 2.5 is rejected by mod_pow', raises_error(@() mod_pow(2.5, 2, 97))};
c(end+1, :) = {'an exponent 2.5 is rejected by mod_pow', raises_error(@() mod_pow(2, 2.5, 97))};
c(end+1, :) = {'modulus 1 is rejected by mod_pow', raises_error(@() mod_pow(2, 2, 1))};
c(end+1, :) = {'modulus 0 is rejected by mod_pow', raises_error(@() mod_pow(2, 2, 0))};
c(end+1, :) = {'modulus 2^26 + 1 is rejected by mod_pow', raises_error(@() mod_pow(2, 2, 2^26 + 1))};
c(end+1, :) = {'modulus 97.5 is rejected by mod_pow', raises_error(@() mod_pow(2, 2, 97.5))};
c(end+1, :) = {'a list as base is rejected by mod_pow', raises_error(@() mod_pow([1 2], 2, 97))};
c(end+1, :) = {'NaN as exponent is rejected by mod_pow', raises_error(@() mod_pow(2, NaN, 97))};
c(end+1, :) = {'Inf as base is rejected by mod_pow', raises_error(@() mod_pow(Inf, 2, 97))};
c(end+1, :) = {'a text as base is rejected by mod_pow', raises_error(@() mod_pow('a', 2, 97))};
c(end+1, :) = {'a missing argument is rejected by mod_pow', raises_error(@() mod_pow(2, 2))};

% --- euclid_gcd ---
c(end+1, :) = {'gcd(85, 97) is 1', euclid_gcd(85, 97) == 1};
c(end+1, :) = {'gcd(84, 36) is 12', euclid_gcd(84, 36) == 12};
c(end+1, :) = {'gcd(12, 18) is 6', euclid_gcd(12, 18) == 6};
c(end+1, :) = {'gcd(0, 5) is 5 and gcd(5, 0) is 5', euclid_gcd(0, 5) == 5 && euclid_gcd(5, 0) == 5};
c(end+1, :) = {'gcd(7, 7) is 7 and gcd(1, 1) is 1', euclid_gcd(7, 7) == 7 && euclid_gcd(1, 1) == 1};
c(end+1, :) = {'gcd(96, 97) is 1', euclid_gcd(96, 97) == 1};
c(end+1, :) = {'gcd(2^53, 2^40) is 2^40', euclid_gcd(2^53, 2^40) == 2^40};
c(end+1, :) = {'gcd(1071, 462) is 21', euclid_gcd(1071, 462) == 21};
[g, st] = euclid_gcd(85, 97);
c(end+1, :) = {'the steps of gcd(85, 97) are [85 97 0 85; 97 85 1 12; 85 12 7 1; 12 1 12 0]', isequal(st, [85 97 0 85; 97 85 1 12; 85 12 7 1; 12 1 12 0])};
[g, st] = euclid_gcd(5, 0);
c(end+1, :) = {'gcd(5, 0) has no steps', g == 5 && isempty(st) && size(st, 2) == 4};
[g, st] = euclid_gcd(832040, 514229);
c(end+1, :) = {'two neighbors of the Fibonacci numbers: gcd(832040, 514229) is 1 after 28 steps', g == 1 && size(st, 1) == 28};
ok = true;
for a = 0:60
    for b = 0:60
        if a + b > 0
            ok = ok && euclid_gcd(a, b) == gcd(a, b) && euclid_gcd(a, b) == euclid_gcd(b, a);
        end
    end
end
c(end+1, :) = {'euclid_gcd agrees with the built-in gcd and is symmetric (a, b = 0 to 60)', ok};
ok = true;
for a = 0:60
    for b = 0:60
        if a + b > 0
            [g, st] = euclid_gcd(a, b);
            n = size(st, 1);
            ok = ok && all(st(:, 1) == st(:, 3) .* st(:, 2) + st(:, 4)) && all(st(:, 4) >= 0) && all(st(:, 4) < st(:, 2));
            if b == 0
                ok = ok && n == 0 && g == a;
            else
                ok = ok && n >= 1 && st(1, 1) == a && st(1, 2) == b && st(n, 4) == 0 && st(n, 2) == g;
                ok = ok && all(st(2:n, 1) == st(1:(n - 1), 2)) && all(st(2:n, 2) == st(1:(n - 1), 4));
            end
        end
    end
end
c(end+1, :) = {'every step is a = q*b + r with 0 <= r < b, the next step uses (b, r), the last r is 0', ok};
c(end+1, :) = {'gcd(0, 0) is rejected by euclid_gcd', raises_error(@() euclid_gcd(0, 0))};
c(end+1, :) = {'a negative number is rejected by euclid_gcd', raises_error(@() euclid_gcd(-1, 5))};
c(end+1, :) = {'a negative second number is rejected by euclid_gcd', raises_error(@() euclid_gcd(5, -1))};
c(end+1, :) = {'2.5 is rejected by euclid_gcd', raises_error(@() euclid_gcd(2.5, 3))};
c(end+1, :) = {'a list is rejected by euclid_gcd', raises_error(@() euclid_gcd([1 2], 3))};
c(end+1, :) = {'NaN is rejected by euclid_gcd', raises_error(@() euclid_gcd(1, NaN))};
c(end+1, :) = {'a missing argument is rejected by euclid_gcd', raises_error(@() euclid_gcd(5))};

% --- ext_gcd ---
[g, x, y] = ext_gcd(85, 97);
c(end+1, :) = {'ext_gcd(85, 97): g = 1, x = 8, y = -7', g == 1 && x == 8 && y == -7};
[g, x, y] = ext_gcd(240, 46);
c(end+1, :) = {'ext_gcd(240, 46): g = 2, x = -9, y = 47', g == 2 && x == -9 && y == 47};
[g, x, y] = ext_gcd(0, 5);
c(end+1, :) = {'ext_gcd(0, 5): g = 5, x = 0, y = 1', g == 5 && x == 0 && y == 1};
[g, x, y] = ext_gcd(5, 0);
c(end+1, :) = {'ext_gcd(5, 0): g = 5, x = 1, y = 0', g == 5 && x == 1 && y == 0};
[g, x, y] = ext_gcd(1071, 462);
c(end+1, :) = {'ext_gcd(1071, 462): g = 21, x = -3, y = 7', g == 21 && x == -3 && y == 7};
[g, x, y] = ext_gcd(832040, 514229);
c(end+1, :) = {'ext_gcd(832040, 514229): g = 1, x = 196418, y = -317811', g == 1 && x == 196418 && y == -317811};
[g, x, y] = ext_gcd(12345678901, 98765432);
c(end+1, :) = {'ext_gcd(12345678901, 98765432): g = 1, x = 7981045, y = -997630617', g == 1 && x == 7981045 && y == -997630617};
[g, x, y] = ext_gcd(2^53, 2^40);
c(end+1, :) = {'ext_gcd(2^53, 2^40): g = 2^40, x = 0, y = 1', g == 2^40 && x == 0 && y == 1};
ok = true;
for a = 0:60
    for b = 0:60
        if a + b > 0
            [g, x, y] = ext_gcd(a, b);
            ok = ok && a * x + b * y == g && g == gcd(a, b) && x == floor(x) && y == floor(y);
        end
    end
end
c(end+1, :) = {'a*x + b*y = gcd(a, b) with whole x and y for a, b = 0 to 60', ok};
ok = true;
for a = 1:60
    for b = 1:60
        [g, x, y] = ext_gcd(a, b);
        ok = ok && abs(x) <= b && abs(y) <= a;
    end
end
c(end+1, :) = {'the numbers x and y stay small: |x| <= b and |y| <= a for a, b = 1 to 60', ok};
c(end+1, :) = {'gcd(0, 0) is rejected by ext_gcd', raises_error(@() ext_gcd(0, 0))};
c(end+1, :) = {'a negative number is rejected by ext_gcd', raises_error(@() ext_gcd(5, -1))};
c(end+1, :) = {'a negative first number is rejected by ext_gcd', raises_error(@() ext_gcd(-1, 5))};
c(end+1, :) = {'2.5 is rejected by ext_gcd', raises_error(@() ext_gcd(2.5, 3))};
c(end+1, :) = {'a missing argument is rejected by ext_gcd', raises_error(@() ext_gcd(5))};

% --- mod_inverse ---
c(end+1, :) = {'the inverse of 5 mod 97 is 39', mod_inverse(5, 97) == 39};
c(end+1, :) = {'the inverse of 85 mod 97 is 8', mod_inverse(85, 97) == 8};
c(end+1, :) = {'the inverse of 96 mod 97 is 96', mod_inverse(96, 97) == 96};
c(end+1, :) = {'the inverse of 1 mod 97 is 1', mod_inverse(1, 97) == 1};
c(end+1, :) = {'the inverse of 3 mod 7 is 5', mod_inverse(3, 7) == 5};
c(end+1, :) = {'the inverse of 10 mod 17 is 12', mod_inverse(10, 17) == 12};
c(end+1, :) = {'the inverse of 1 mod 2 is 1', mod_inverse(1, 2) == 1};
c(end+1, :) = {'a is reduced first: the inverse of 102 mod 97 is 39', mod_inverse(102, 97) == 39};
c(end+1, :) = {'the inverse of 3 mod 1000000007 is 333333336', mod_inverse(3, 1000000007) == 333333336};
c(end+1, :) = {'the inverse also exists when m is not prime: 7 * 13 = 91 = 1 (mod 18)', mod_inverse(7, 18) == 13};
ok = true;
for k = S.keys
    j = mod_inverse(k, S.prime);
    ok = ok && isscalar(j) && ismember(j, S.keys) && mod(k * j, S.prime) == 1 && j == key_inverse(k, S);
end
c(end+1, :) = {'for every key k from 1 to 96: k * j = 1 (mod 97) and j is the same as key_inverse', ok};
ok = true;
for m = 2:60
    for a = 0:(2 * m)
        if gcd(a, m) == 1
            j = mod_inverse(a, m);
            ok = ok && j >= 1 && j <= m - 1 && mod(a * j, m) == 1;
        else
            ok = ok && raises_error(@() mod_inverse(a, m));
        end
    end
end
c(end+1, :) = {'for m = 2 to 60, a = 0 to 2m: an inverse exists exactly when gcd(a, m) = 1, and it works', ok};
c(end+1, :) = {'6 has no inverse mod 9', raises_error(@() mod_inverse(6, 9))};
c(end+1, :) = {'0 has no inverse mod 97', raises_error(@() mod_inverse(0, 97))};
c(end+1, :) = {'97 has no inverse mod 97', raises_error(@() mod_inverse(97, 97))};
c(end+1, :) = {'4 has no inverse mod 8', raises_error(@() mod_inverse(4, 8))};
c(end+1, :) = {'modulus 1 is rejected by mod_inverse', raises_error(@() mod_inverse(1, 1))};
c(end+1, :) = {'modulus 0 is rejected by mod_inverse', raises_error(@() mod_inverse(1, 0))};
c(end+1, :) = {'modulus 2.5 is rejected by mod_inverse', raises_error(@() mod_inverse(1, 2.5))};
c(end+1, :) = {'a negative modulus is rejected by mod_inverse', raises_error(@() mod_inverse(5, -7))};
c(end+1, :) = {'a negative number is rejected by mod_inverse', raises_error(@() mod_inverse(-1, 97))};
c(end+1, :) = {'2.5 is rejected by mod_inverse', raises_error(@() mod_inverse(2.5, 97))};
c(end+1, :) = {'a missing argument is rejected by mod_inverse', raises_error(@() mod_inverse(5))};
msg = '';
try
    mod_inverse(6, 9);
catch err
    msg = err.message;
end
c(end+1, :) = {'the error of mod_inverse(6, 9) names the gcd 3', ~isempty(strfind(msg, '6 has no inverse modulo 9')) && ~isempty(strfind(msg, 'gcd(6, 9) = 3'))};

% --- show_modular and demo_point3 ---
txt = evalc('show_modular(S)');
c(end+1, :) = {'show_modular prints its title and p and g', ~isempty(strfind(txt, '=== MODULAR ARITHMETIC TOOLS ===')) && ~isempty(strfind(txt, 'with p = 97. The generator is g = 5.'))};
c(end+1, :) = {'show_modular prints the binary digits 1101 of 13', ~isempty(strfind(txt, 'the exponent 13 in binary: 1101.'))};
c(end+1, :) = {'show_modular prints the steps of 5^13 mod 97', ~isempty(strfind(txt, '  1     25                28')) && ~isempty(strfind(txt, '0     8                 8 (bit 0: no multiplication)')) && ~isempty(strfind(txt, '  1     64                29'))};
c(end+1, :) = {'show_modular prints 5^13 mod 97 = 29 and the plain way agrees', ~isempty(strfind(txt, 'So 5^13 mod 97 = 29.')) && ~isempty(strfind(txt, 'also gives 29: yes'))};
c(end+1, :) = {'show_modular prints 5^96 mod 97 = 1 with 7 squaring and 2 multiplication steps', ~isempty(strfind(txt, '5^96 mod 97 = 1 with 7 squaring steps and 2 multiplication steps (the plain way needs 95 multiplications)'))};
c(end+1, :) = {'show_modular prints the steps of gcd(85, 97)', ~isempty(strfind(txt, '  97 = 1 * 85 + 12')) && ~isempty(strfind(txt, '  So gcd(85, 97) = 1.'))};
c(end+1, :) = {'show_modular prints the steps of gcd(84, 36)', ~isempty(strfind(txt, '  84 = 2 * 36 + 12')) && ~isempty(strfind(txt, '  So gcd(84, 36) = 12.'))};
c(end+1, :) = {'show_modular prints 85 * (8) + 97 * (-7) = 1', ~isempty(strfind(txt, '85 * (8) + 97 * (-7) = 1 = gcd(85, 97).'))};
c(end+1, :) = {'show_modular prints that the inverse of 85 is 8 and checks it', ~isempty(strfind(txt, 'The inverse of 85 is x mod 97 = 8 mod 97 = 8.')) && ~isempty(strfind(txt, 'Check: 85 * 8 = 680 = 7 * 97 + 1'))};
c(end+1, :) = {'show_modular prints that 6 has no inverse mod 9', ~isempty(strfind(txt, '6 has no inverse modulo 9, because gcd(6, 9) = 3 and not 1.'))};
pos = strfind(txt, 'Checks:');
tail = txt(pos(end):end);
c(end+1, :) = {'show_modular ends with 5 check lines that all say yes', numel(strfind(tail, ': yes')) == 5 && isempty(strfind(tail, ': NO'))};
txt2 = evalc('demo_point3()');
c(end+1, :) = {'demo_point3 prints its title and the tools', ~isempty(strfind(txt2, 'POINT 3 DEMO: GROUP THEORY AND MODULAR ARITHMETIC')) && ~isempty(strfind(txt2, '=== MODULAR ARITHMETIC TOOLS ==='))};
pos2 = strfind(txt2, 'Checks:');
c(end+1, :) = {'demo_point3 has 5 check lines that all say yes and none says NO', numel(strfind(txt2(pos2(end):end), ': yes')) == 5 && isempty(strfind(txt2, ': NO'))};

summarize_checks('test_modular', c);
end
