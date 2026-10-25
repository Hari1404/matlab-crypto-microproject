function show_rsa(S)
% SHOW_RSA Print RSA public-key encryption: making the keys, encrypting a number and a text, why it works and a wrong key.
%   show_rsa()   uses define_sets.
%   show_rsa(S)  uses the sets S (the prime p of Diffie-Hellman is only used for the comparison with RSA).
%   The example uses the small primes p = 61 and q = 53 and the public exponent e = 17.
if nargin < 1
    S = define_sets();
end
dp = S.prime;
p = 61;
q = 53;
e = 17;
answer = {'NO', 'yes'};
K = rsa_make_keys(p, q, e);
n = K.n;
phi = K.phi;
d = K.d;
[g, gsteps] = euclid_gcd(e, phi);
[g2, x, y] = ext_gcd(e, phi);

fprintf('\n=== RSA PUBLIC-KEY ENCRYPTION ===\n');
fprintf('RSA has two keys. The public key (n, e) can be known by everyone and is used to encrypt. The private key d is known only by its owner and is used to decrypt.\n');
fprintf('It works in the group Z_n* (the numbers that have no common factor with n = p*q), like Diffie-Hellman works in Z_%d*. The numbers are small on purpose, so that every step can be checked by hand.\n', dp);

% 1. making the keys
fprintf('\n1. Making the keys\n');
fprintf('  Choose two different primes p = %d and q = %d. Prime: %s and %s.\n', p, q, answer{double(is_prime_number(p)) + 1}, answer{double(is_prime_number(q)) + 1});
fprintf('  n = p*q = %d * %d = %d. This is the modulus. It is public.\n', p, q, n);
fprintf('  phi = (p-1)*(q-1) = %d * %d = %d. This is the number of elements of the group Z_n*. It is secret: it is easy to find only when p and q are known.\n', p - 1, q - 1, phi);
fprintf('  Choose the public exponent e = %d. Euclid''s algorithm gives gcd(e, phi) = gcd(%d, %d) = %d in %d divisions, so e has an inverse mod phi.\n', e, e, phi, g, size(gsteps, 1));
fprintf('  The extended Euclid algorithm gives e*x + phi*y = gcd: %d * (%d) + %d * (%d) = %d.\n', e, x, phi, y, g2);
fprintf('  So d = x mod phi = %d mod %d = %d. Check: e*d mod phi = %d * %d mod %d = %d.\n', x, phi, d, e, d, phi, mod(e * d, phi));
fprintf('  Public key: (n, e) = (%d, %d). Private key: d = %d. The numbers p, q and phi must stay secret too.\n', n, e, d);

% 2. one number
m = 65;
c = rsa_encrypt_number(m, n, e);
back = rsa_decrypt_number(c, n, d);
[c2, st1] = mod_pow(m, e, n);
[m2, st2] = mod_pow(c, d, n);
fprintf('\n2. Encrypting and decrypting one number\n');
fprintf('  Take the message m = %d. It must be a number from 0 to n-1 = %d.\n', m, n - 1);
fprintf('  Encrypt with the public key: c = m^e mod n = %d^%d mod %d = %d.\n', m, e, n, c);
fprintf('  The power is found by repeated squaring. The exponent %d is %s in binary, so it takes %d squaring steps and %d multiplication steps (the plain way takes %d multiplications).\n', e, sprintf('%d', st1(:, 1)), size(st1, 1), sum(st1(:, 1)), e - 1);
fprintf('  Decrypt with the private key: m = c^d mod n = %d^%d mod %d = %d.\n', c, d, n, back);
fprintf('  The exponent %d is %s in binary, so it takes %d squaring steps and %d multiplication steps (the plain way takes %d multiplications).\n', d, sprintf('%d', st2(:, 1)), size(st2, 1), sum(st2(:, 1)), d - 1);
fprintf('  The decrypted number is the same as the message: %s\n', answer{double(back == m && c2 == c && m2 == back) + 1});

% 3. a text
txt = 'Meet me at the library at 5 pm, Bob.';
sym = text_to_symbols(txt);
ct = rsa_encrypt_text(txt, n, e);
got = rsa_decrypt_text(ct, n, d);
nspace = sum(sym == 1);
fprintf('\n3. Encrypting and decrypting a text\n');
fprintf('  The message: %s\n', txt);
fprintf('  Every character becomes a symbol (a space is 1, the character ~ is %d) and every symbol is encrypted alone: c = m^e mod n.\n', numel(S.plain));
fprintf('  Example: the first character %s is the symbol %d, and %d^%d mod %d = %d.\n', txt(1), sym(1), sym(1), e, n, ct(1));
fprintf('  The %d numbers that cross the channel (numbers from 0 to n-1 = %d):\n', numel(ct), n - 1);
fprintf('%s\n', rsa_format_numbers(ct, 12));
fprintf('  The owner decrypts every number c with the private key: m = c^d mod n. The text that comes out: %s\n', got);
fprintf('  It is the same as the message: %s\n', answer{double(strcmp(got, txt)) + 1});
fprintf('  Look at the spaces: the space is the symbol 1 and 1^e = 1, so each of the %d spaces stays the number 1. Every character is encrypted alone, so equal characters always give equal numbers. Real RSA adds padding to avoid this.\n', nspace);

% 4. why it works
units = find(gcd(1:(n - 1), n) == 1);
euler_ok = (numel(units) == phi);
for a = units
    euler_ok = euler_ok && (mod_pow(a, phi, n) == 1);
end
kk = (e * d - 1) / phi;
roundtrip_ok = true;
for mm = 0:(n - 1)
    roundtrip_ok = roundtrip_ok && (rsa_decrypt_number(rsa_encrypt_number(mm, n, e), n, d) == mm);
end
fprintf('\n4. Why it works: the group Z_n*\n');
fprintf('  The group Z_n* has the numbers from 1 to n-1 that have no common factor with n. Counting them with gcd(a, n) = 1 gives %d numbers, and phi = %d: %s.\n', numel(units), phi, answer{double(numel(units) == phi) + 1});
fprintf('  By Lagrange''s theorem the order of every element divides the number of elements, so a^phi = 1 (mod n) for every a in Z_n*. Checked for all %d elements: %s.\n', numel(units), answer{double(euler_ok) + 1});
fprintf('  e*d = %d * %d = %d = 1 + %d * phi. So for m in Z_n*: (m^e)^d = m^(1 + k*phi) = m * (m^phi)^k = m (mod n), with k = %d.\n', e, d, e * d, kk, kk);
fprintf('  It also works for the other numbers (those with the factor p or q), because n = p*q has two different primes. Encrypting and then decrypting every number from 0 to n-1 gives the number back: %s (%d numbers).\n', answer{double(roundtrip_ok) + 1}, n);
fprintf('  Compare Diffie-Hellman: the group was Z_%d* with %d elements. Here the group has phi = %d elements, and the exponents e and d are inverses mod phi.\n', dp, dp - 1, phi);

% 5. a wrong key
wrongd = d - 1;
try
    wtxt = rsa_decrypt_text(ct, n, wrongd);
    stopped = false;
catch
    wtxt = '';
    stopped = true;
end
fprintf('\n5. What a wrong key gives\n');
fprintf('  Suppose someone decrypts the same numbers with a wrong private key, d = %d instead of %d.\n', wrongd, d);
if stopped
    fprintf('  The decryption stops, because a number turns into a value that is not a symbol (not from 1 to %d). This is not the right key.\n', numel(S.plain));
else
    fprintf('  The result is only nonsense: %s\n', wtxt);
end
fprintf('  The private key d cannot be found from (n, e) without phi, and phi needs the factors p and q of n. Finding them is the factoring problem. For n = %d it is easy (try the numbers up to the square root of n). For an n with 2048 bits no fast method is known. This project uses small numbers on purpose, so it is a learning model and not secure.\n', n);

% 6. self-checks
checks = {
    'p and q are different primes', is_prime_number(p) && is_prime_number(q) && p ~= q;
    'n = p*q and phi = (p-1)*(q-1)', K.n == p * q && K.phi == (p - 1) * (q - 1);
    'e and phi have gcd 1', g == 1;
    'e*d mod phi = 1', mod(e * d, phi) == 1;
    'the text comes back after encryption and decryption', strcmp(got, txt);
    'every number from 0 to n-1 comes back after encryption and decryption', roundtrip_ok;
    'the group Z_n* has phi elements and a^phi = 1 (mod n) for all of them', euler_ok;
    'a wrong private key does not give the text back', stopped || ~strcmp(wtxt, txt)};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for k = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{k, 1}, answer{double(checks{k, 2}) + 1});
end
end
