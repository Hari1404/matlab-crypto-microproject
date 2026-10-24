function show_modular(S)
% SHOW_MODULAR Print the modular arithmetic tools: fast powers, Euclid's gcd, the extended gcd and the inverse.
%   show_modular()   uses define_sets.
%   show_modular(S)  uses the prime p, the generator g and the keys in the struct S.
if nargin < 1
    S = define_sets();
end
p = S.prime;
g = S.generator;
answer = {'NO', 'yes'};

fprintf('\n=== MODULAR ARITHMETIC TOOLS ===\n');
fprintf('All numbers are taken mod p, with p = %d. The generator is g = %d.\n', p, g);

% 1. fast modular exponentiation
e = 13;
[r, steps] = mod_pow(g, e, p);
nb = size(steps, 1);
fprintf('\n1. Fast modular exponentiation (repeated squaring)\n');
fprintf('To find %d^%d mod %d, write the exponent %d in binary: %s.\n', g, e, p, e, sprintf('%d', steps(:, 1)));
fprintf('Start with 1. For each bit from the left: square the value, and if the bit is 1 also multiply it by %d (all mod %d).\n', g, p);
fprintf('  %-6s%-18s%s\n', 'bit', 'after squaring', ['after multiplying by ' num2str(g)]);
for i = 1:nb
    if steps(i, 1) == 1
        fprintf('  %-6d%-18d%d\n', steps(i, 1), steps(i, 2), steps(i, 3));
    else
        fprintf('  %-6d%-18d%d (bit 0: no multiplication)\n', steps(i, 1), steps(i, 2), steps(i, 3));
    end
end
plain = 1;
for i = 1:e
    plain = mod(plain * g, p);
end
fprintf('So %d^%d mod %d = %d. Multiplying %d by itself the plain way (%d multiplications) also gives %d: %s\n', g, e, p, r, g, e - 1, plain, answer{double(r == plain) + 1});
[r2, steps2] = mod_pow(g, p - 1, p);
fprintf('Repeated squaring needs few steps even for a big exponent: %d^%d mod %d = %d with %d squaring steps and %d multiplication steps (the plain way needs %d multiplications).\n', ...
    g, p - 1, p, r2, size(steps2, 1), sum(steps2(:, 1)), p - 2);
fprintf('Fermat''s little theorem says a^(p-1) = 1 (mod p) for every a from 1 to p-1 when p is prime.\n');

% 2. Euclid's algorithm
k = 85;
pairs = [k, p; 84, 36];
fprintf('\n2. The greatest common divisor (Euclid''s algorithm)\n');
fprintf('Each step divides: a = q * b + r. Then the pair (a, b) becomes (b, r). The last b, when r is 0, is the gcd.\n');
for row = 1:size(pairs, 1)
    [d, st] = euclid_gcd(pairs(row, 1), pairs(row, 2));
    fprintf('gcd(%d, %d):\n', pairs(row, 1), pairs(row, 2));
    for i = 1:size(st, 1)
        fprintf('  %d = %d * %d + %d\n', st(i, 1), st(i, 3), st(i, 2), st(i, 4));
    end
    fprintf('  So gcd(%d, %d) = %d.\n', pairs(row, 1), pairs(row, 2), d);
end

% 3. extended Euclid and the inverse
fprintf('\n3. The extended Euclid algorithm and the inverse\n');
[d, x, y] = ext_gcd(k, p);
j = mod_inverse(k, p);
fprintf('Going back through the steps gives whole numbers x and y with a*x + b*y = gcd(a, b).\n');
fprintf('For a = %d and b = %d: %d * (%d) + %d * (%d) = %d = gcd(%d, %d).\n', k, p, k, x, p, y, k * x + p * y, k, p);
fprintf('Mod %d the part %d * (%d) is 0, so %d * (%d) = 1 (mod %d). The inverse of %d is x mod %d = %d mod %d = %d.\n', p, p, y, k, x, p, k, p, x, p, j);
fprintf('Check: %d * %d = %d = %d * %d + 1, so %d * %d = 1 (mod %d).\n', k, j, k * j, (k * j - 1) / p, p, k, j, p);
msg = 'mod_inverse did not stop with an error (this is not expected)';
try
    mod_inverse(6, 9);
catch err
    msg = err.message;
end
fprintf('An inverse exists only when gcd = 1. Example: %s\n', msg);
fprintf('Because %d is prime, every key from 1 to %d has gcd(k, %d) = 1, so every key has an inverse.\n', p, p - 1, p);

% 4. self-checks
ok_pow = true;
for b = 0:(p - 1)
    plain = 1;
    for e2 = 0:8
        ok_pow = ok_pow && (mod_pow(b, e2, p) == plain);
        plain = mod(plain * b, p);
    end
end
ok_fermat = true;
for a = 1:(p - 1)
    ok_fermat = ok_fermat && (mod_pow(a, p - 1, p) == 1);
end
ok_gcd = true;
ok_ext = true;
for a = 0:40
    for b = 0:40
        if a + b > 0
            ok_gcd = ok_gcd && (euclid_gcd(a, b) == gcd(a, b));
            [d, x, y] = ext_gcd(a, b);
            ok_ext = ok_ext && (a * x + b * y == d) && (d == gcd(a, b));
        end
    end
end
ok_inv = true;
for kk = S.keys
    jj = mod_inverse(kk, p);
    ok_inv = ok_inv && (mod(kk * jj, p) == 1) && (jj == key_inverse(kk, S));
end
checks = {
    'mod_pow agrees with plain multiplication (b from 0 to p-1, e from 0 to 8)', ok_pow;
    'a^(p-1) = 1 (mod p) for every a from 1 to p-1, found with mod_pow', ok_fermat;
    'euclid_gcd agrees with the built-in gcd (a and b from 0 to 40)', ok_gcd;
    'ext_gcd gives a*x + b*y = gcd(a, b) (a and b from 0 to 40)', ok_ext;
    'mod_inverse agrees with the search in key_inverse for every key', ok_inv};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
