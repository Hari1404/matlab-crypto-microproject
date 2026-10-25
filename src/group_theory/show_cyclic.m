function show_cyclic(S)
% SHOW_CYCLIC Print the orders, the generators and the cyclic subgroups of Z_p*.
%   show_cyclic()   uses define_sets.
%   show_cyclic(S)  uses the prime p and the generator g in the struct S (p must be a prime number from 2 to 5000).
if nargin < 1
    S = define_sets();
end
p = S.prime;
g = S.generator;
n = p - 1;
answer = {'NO', 'yes'};

fprintf('\n=== ORDERS, GENERATORS AND CYCLIC SUBGROUPS OF Z_p* ===\n');
fprintf('The order of a number a is the smallest k >= 1 with a^k = 1 (mod p). Here p = %d.\n', p);

ord = zeros(1, n);
for a = 1:n
    ord(a) = element_order(a, p);
end

% 1. some orders
fprintf('\n1. Some orders (found with mod_pow and the prime factors of p-1)\n');
ex = [g, 2, p - 1, 1];
for i = 1:numel(ex)
    a = ex(i);
    if a >= 1 && a <= n
        fprintf('  The order of %d is %d: %d^%d mod %d = %d, and no smaller power gives 1.\n', a, ord(a), a, ord(a), p, mod_pow(a, ord(a), p));
    end
end

% 2. how many numbers have each order
fprintf('\n2. How many numbers have each order\n');
fprintf('  %-10s%-16s%s\n', 'order d', 'how many', 'the smallest such number');
ds = find(mod(n, 1:n) == 0);
for d = ds
    fprintf('  %-10d%-16d%d\n', d, sum(ord == d), find(ord == d, 1));
end
fprintf('Every order divides p-1 = %d (Lagrange), and the counts add up to %d.\n', n, sum(arrayfun(@(d) sum(ord == d), ds)));

% 3. generators
gens = find_generators(p);
fprintf('\n3. The generators (the numbers of order %d)\n', n);
fprintf('There are %d generators. The smallest is %d. They are:\n', numel(gens), gens(1));
for i = 1:12:numel(gens)
    fprintf('  %s\n', strtrim(sprintf('%d ', gens(i:min(i + 11, numel(gens))))));
end
fprintf('The generator g = %d from define_sets is one of them: %s\n', g, answer{double(is_generator(g, p)) + 1});

% 4. the powers of g
H = cyclic_subgroup(g, p);
fprintf('\n4. The powers of g = %d give every number from 1 to %d\n', g, n);
fprintf('  %d^0, %d^1, %d^2, ... = %s, ...\n', g, g, g, strtrim(sprintf('%d ', H(1:min(12, numel(H))))));
fprintf('There are %d powers before the first one repeats, and they are all different: %s\n', numel(H), answer{double(numel(unique(H)) == n) + 1});
fprintf('So Z_%d* is a cyclic group: it has a generator.\n', p);

% 5. cyclic subgroups
fprintf('\n5. Cyclic subgroups: the powers of a smaller number\n');
for d = [2 3 4 6]
    if mod(n, d) == 0
        a = find(ord == d, 1);
        Hd = cyclic_subgroup(a, p);
        fprintf('  The powers of %d form a subgroup with %d elements: %s\n', a, numel(Hd), strtrim(sprintf('%d ', Hd)));
    end
end
fprintf('For every divisor d of %d there is exactly one subgroup with d elements.\n', n);

% 6. self-checks
ok_brute = true;
ok_divides = true;
ok_gen = true;
ok_sub = true;
for a = 1:n
    v = a;
    k = 1;
    while v ~= 1
        v = mod(v * a, p);
        k = k + 1;
    end
    ok_brute = ok_brute && (k == ord(a));
    ok_divides = ok_divides && (mod(n, ord(a)) == 0);
    ok_gen = ok_gen && (is_generator(a, p) == (ord(a) == n));
    Ha = cyclic_subgroup(a, p);
    ok_sub = ok_sub && (numel(Ha) == ord(a)) && all(ismember(mod(Ha' * Ha, p), Ha));
end
ok_count = (numel(gens) == sum(gcd(1:n, n) == 1));
ok_phi = true;
for d = ds
    ok_phi = ok_phi && (sum(ord == d) == sum(gcd(1:d, d) == 1));
end
checks = {
    'element_order agrees with multiplying again and again until 1 (every a)', ok_brute;
    'every order divides p-1', ok_divides;
    'is_generator agrees with order = p-1 (every a)', ok_gen;
    'the number of generators is phi(p-1), counted with the built-in gcd', ok_count;
    'the number of numbers of order d is phi(d) for every divisor d of p-1', ok_phi;
    'every cyclic subgroup has as many elements as the order and is closed under multiplication', ok_sub;
    'the powers of g give every number from 1 to p-1 once (Z_p* is cyclic)', numel(unique(H)) == n};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
