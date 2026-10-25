function show_group(S)
% SHOW_GROUP Print the group Z_p*: a small example, then the group rules checked for Z_p* with p = 97.
%   show_group()   uses define_sets.
%   show_group(S)  uses the prime p in the struct S (p must be a prime number from 2 to 300).
if nargin < 1
    S = define_sets();
end
p = S.prime;
answer = {'NO', 'yes'};
f = prime_factors(p - 1);
factor_text = '';
for r = 1:size(f, 1)
    if r > 1
        factor_text = [factor_text ' * '];
    end
    if f(r, 2) == 1
        factor_text = [factor_text sprintf('%d', f(r, 1))];
    else
        factor_text = [factor_text sprintf('%d^%d', f(r, 1), f(r, 2))];
    end
end

fprintf('\n=== THE GROUP Z_p* (THE NUMBERS 1 TO p-1 WITH MULTIPLICATION MOD p) ===\n');
fprintf('Here p = %d. Is p prime? %s. The group has p - 1 = %d elements, and %d = %s.\n', p, answer{double(is_prime_number(p)) + 1}, p - 1, p - 1, factor_text);

% 1. a small example
T7 = group_table(7);
R7 = check_group(T7);
fprintf('\n1. A small example first: the group Z_7*\n');
fprintf('The multiplication table mod 7 (row a, column b, entry a*b mod 7):\n');
fprintf('   * |%s\n', sprintf('%3d', 1:6));
fprintf('  ---+%s\n', repmat('-', 1, 18));
for a = 1:6
    fprintf('  %2d |%s\n', a, sprintf('%3d', T7(a, :)));
end
inv_text = '';
for a = 1:6
    if a > 1
        inv_text = [inv_text ', '];
    end
    inv_text = [inv_text sprintf('%d -> %d', a, R7.inverses(a))];
end
fprintf('Every product is in 1 to 6: %s. The identity is %d. The inverses are: %s.\n', answer{double(R7.closure) + 1}, R7.identity, inv_text);
v = 1:5;
R6 = check_group(mod(v' * v, 6));
fprintf('For comparison, the numbers 1 to 5 with multiplication mod 6 are not a group: 2 * 3 = 6 = 0 (mod 6), and 0 is not in 1 to 5. Closed? %s. That is why p must be prime.\n', answer{double(R6.closure) + 1});

% 2. the group rules for Z_p*
T = group_table(p);
R = check_group(T);
fprintf('\n2. The group rules for Z_%d* (checked on the whole table of %d x %d products)\n', p, p - 1, p - 1);
fprintf('  Closure       : every product a*b mod %d is again a number from 1 to %d: %s\n', p, p - 1, answer{double(R.closure) + 1});
fprintf('  Identity      : the element e = %d has e*a = a*e = a for every a: %s\n', R.identity, answer{double(R.has_identity) + 1});
ex = [5, 85];
ex_text = '';
for i = 1:numel(ex)
    if ex(i) <= p - 1
        if ~isempty(ex_text)
            ex_text = [ex_text ' and '];
        end
        ex_text = [ex_text sprintf('%d has the inverse %d', ex(i), R.inverses(ex(i)))];
    end
end
fprintf('  Inverses      : every a has a number b with a*b = b*a = %d (for example %s): %s\n', R.identity, ex_text, answer{double(R.has_inverses) + 1});
fprintf('  Associativity : (a*b)*c = a*(b*c) for all %d x %d x %d = %d triples: %s\n', p - 1, p - 1, p - 1, (p - 1)^3, answer{double(R.associative) + 1});
fprintf('  Commutativity : a*b = b*a for all a and b: %s\n', answer{double(R.commutative) + 1});
if R.is_group
    kind = 'a group';
    if R.is_abelian
        kind = 'an abelian (commutative) group';
    end
    fprintf('So Z_%d* is %s with %d elements.\n', p, kind, p - 1);
else
    fprintf('So Z_%d* is not a group.\n', p);
end

% 3. self-checks
n = p - 1;
ok_latin = true;
for k = 1:n
    ok_latin = ok_latin && isequal(sort(T(k, :)), 1:n) && isequal(sort(T(:, k))', 1:n);
end
ok_inv = true;
for a = 1:n
    ok_inv = ok_inv && (R.inverses(a) == mod_inverse(a, p));
end
ok_prime = true;
for k = 0:200
    ok_prime = ok_prime && (is_prime_number(k) == isprime(k));
end
ok_factor = true;
for k = 1:500
    g = prime_factors(k);
    ok_factor = ok_factor && (prod(g(:, 1) .^ g(:, 2)) == k);
end
checks = {
    'check_group says that Z_p* is an abelian group', R.is_abelian;
    'every row and every column of the table holds each of 1 to p-1 exactly once', ok_latin;
    'the inverses found in the table are the same as mod_inverse gives', ok_inv;
    'check_group says that the numbers 1 to 5 with multiplication mod 6 are not a group', ~R6.is_group;
    'is_prime_number agrees with the built-in isprime (n from 0 to 200)', ok_prime;
    'prime_factors multiplies back to n (n from 1 to 500)', ok_factor};
w = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(w) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
