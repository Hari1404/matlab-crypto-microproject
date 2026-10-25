function test_group()
% TEST_GROUP Checks for the group Z_p*: is_prime_number, prime_factors, group_table, check_group, element_order, is_generator, find_generators, cyclic_subgroup, show_group, show_cyclic and demo_point3.
S = define_sets();
c = cell(0, 2);
primes_300 = [];
primes_120 = [];
for n = 2:300
    if isprime(n)
        primes_300(end+1) = n;
        if n <= 120
            primes_120(end+1) = n;
        end
    end
end

% --- is_prime_number ---
c(end+1, :) = {'0 and 1 are not prime', ~is_prime_number(0) && ~is_prime_number(1)};
c(end+1, :) = {'2, 3, 5, 7, 11 and 97 are prime', all(arrayfun(@is_prime_number, [2 3 5 7 11 97]))};
c(end+1, :) = {'4, 9, 25, 91 and 100 are not prime', ~any(arrayfun(@is_prime_number, [4 9 25 91 100]))};
c(end+1, :) = {'4294967291 (the biggest prime below 2^32) is prime', is_prime_number(4294967291)};
c(end+1, :) = {'4294967295 and 2^32 are not prime', ~is_prime_number(4294967295) && ~is_prime_number(2^32)};
c(end+1, :) = {'65521^2 is not prime and 65521 is prime', ~is_prime_number(65521^2) && is_prime_number(65521)};
ok = true;
for n = 0:2000
    ok = ok && (is_prime_number(n) == isprime(n));
end
c(end+1, :) = {'is_prime_number agrees with the built-in isprime for n = 0 to 2000', ok};
c(end+1, :) = {'the answer is true or false (one logical value)', islogical(is_prime_number(7)) && isscalar(is_prime_number(7))};
c(end+1, :) = {'a negative number is rejected by is_prime_number', raises_error(@() is_prime_number(-1))};
c(end+1, :) = {'2.5 is rejected by is_prime_number', raises_error(@() is_prime_number(2.5))};
c(end+1, :) = {'2^32 + 1 is rejected by is_prime_number', raises_error(@() is_prime_number(2^32 + 1))};
c(end+1, :) = {'a list is rejected by is_prime_number', raises_error(@() is_prime_number([2 3]))};
c(end+1, :) = {'a text is rejected by is_prime_number', raises_error(@() is_prime_number('a'))};
c(end+1, :) = {'NaN is rejected by is_prime_number', raises_error(@() is_prime_number(NaN))};

% --- prime_factors ---
c(end+1, :) = {'prime_factors(1) has no rows (and 2 columns)', isempty(prime_factors(1)) && size(prime_factors(1), 2) == 2};
c(end+1, :) = {'prime_factors(2) is [2 1]', isequal(prime_factors(2), [2 1])};
c(end+1, :) = {'prime_factors(96) is [2 5; 3 1]', isequal(prime_factors(96), [2 5; 3 1])};
c(end+1, :) = {'prime_factors(97) is [97 1]', isequal(prime_factors(97), [97 1])};
c(end+1, :) = {'prime_factors(360) is [2 3; 3 2; 5 1]', isequal(prime_factors(360), [2 3; 3 2; 5 1])};
c(end+1, :) = {'prime_factors(4294967295) is 3, 5, 17, 257, 65537', isequal(prime_factors(4294967295), [3 1; 5 1; 17 1; 257 1; 65537 1])};
c(end+1, :) = {'prime_factors(2^32) is [2 32]', isequal(prime_factors(2^32), [2 32])};
c(end+1, :) = {'prime_factors(65521^2) is [65521 2]', isequal(prime_factors(65521^2), [65521 2])};
c(end+1, :) = {'prime_factors(67108858) is [2 1; 479 1; 70051 1]', isequal(prime_factors(67108858), [2 1; 479 1; 70051 1])};
ok = true;
for n = 1:2000
    f = prime_factors(n);
    ok = ok && (isempty(f) || prod(f(:, 1) .^ f(:, 2)) == n) && (n > 1 || isempty(f));
    ok = ok && all(arrayfun(@is_prime_number, f(:, 1)')) && all(f(:, 2) >= 1) && issorted(f(:, 1));
end
c(end+1, :) = {'for n = 1 to 2000: the primes are prime and increasing, and they multiply back to n', ok};
c(end+1, :) = {'0 is rejected by prime_factors', raises_error(@() prime_factors(0))};
c(end+1, :) = {'a negative number is rejected by prime_factors', raises_error(@() prime_factors(-6))};
c(end+1, :) = {'2.5 is rejected by prime_factors', raises_error(@() prime_factors(2.5))};
c(end+1, :) = {'2^32 + 1 is rejected by prime_factors', raises_error(@() prime_factors(2^32 + 1))};
c(end+1, :) = {'a list is rejected by prime_factors', raises_error(@() prime_factors([4 6]))};

% --- group_table ---
c(end+1, :) = {'group_table(7) is the known 6 x 6 table', isequal(group_table(7), [1 2 3 4 5 6; 2 4 6 1 3 5; 3 6 2 5 1 4; 4 1 5 2 6 3; 5 3 1 6 4 2; 6 5 4 3 2 1])};
c(end+1, :) = {'group_table(2) is 1 and group_table(3) is [1 2; 2 1]', isequal(group_table(2), 1) && isequal(group_table(3), [1 2; 2 1])};
T = group_table(97);
c(end+1, :) = {'group_table(97) has 96 rows and 96 columns', isequal(size(T), [96 96])};
c(end+1, :) = {'in group_table(97): 5 * 39 = 1 and 85 * 8 = 1 and 96 * 96 = 1', T(5, 39) == 1 && T(85, 8) == 1 && T(96, 96) == 1};
c(end+1, :) = {'in group_table(97) the first row and the first column are 1 to 96', isequal(T(1, :), 1:96) && isequal(T(:, 1)', 1:96)};
c(end+1, :) = {'group_table(97) is symmetric', isequal(T, T')};
ok = true;
for a = 1:96
    ok = ok && isequal(sort(T(a, :)), 1:96) && isequal(sort(T(:, a))', 1:96);
end
c(end+1, :) = {'every row and column of group_table(97) holds 1 to 96 once', ok};
ok = true;
for a = 1:96
    for b = [1 2 50 96]
        ok = ok && T(a, b) == mod(a * b, 97);
    end
end
c(end+1, :) = {'entries of group_table(97) are a*b mod 97', ok};
c(end+1, :) = {'p = 4 is rejected by group_table', raises_error(@() group_table(4))};
c(end+1, :) = {'p = 1 is rejected by group_table', raises_error(@() group_table(1))};
c(end+1, :) = {'p = 0 is rejected by group_table', raises_error(@() group_table(0))};
c(end+1, :) = {'p = 307 (prime, but bigger than 300) is rejected by group_table', raises_error(@() group_table(307))};
c(end+1, :) = {'p = 97.5 is rejected by group_table', raises_error(@() group_table(97.5))};
c(end+1, :) = {'a list is rejected by group_table', raises_error(@() group_table([5 7]))};

% --- check_group: groups ---
R = check_group(group_table(7));
c(end+1, :) = {'Z_7*: closed, identity 1, inverses [1 4 5 2 3 6]', R.n == 6 && R.closure && R.identity == 1 && R.has_identity && isequal(R.inverses, [1 4 5 2 3 6]) && R.has_inverses};
c(end+1, :) = {'Z_7*: associative, commutative, a group, abelian', R.associative && R.commutative && R.is_group && R.is_abelian};
R = check_group(group_table(97));
c(end+1, :) = {'Z_97*: 96 elements, closed, identity 1, inverses exist', R.n == 96 && R.closure && R.identity == 1 && R.has_inverses};
c(end+1, :) = {'Z_97*: associative, commutative, a group, abelian', R.associative && R.commutative && R.is_group && R.is_abelian};
ok = true;
for a = 1:96
    ok = ok && R.inverses(a) == mod_inverse(a, 97);
end
c(end+1, :) = {'Z_97*: the inverse of every a is the same as mod_inverse gives', ok};
ok = true;
for p = primes_300
    Rp = check_group(group_table(p));
    ok = ok && Rp.is_group && Rp.is_abelian && Rp.identity == 1 && Rp.n == p - 1;
end
c(end+1, :) = {'Z_p* is an abelian group for every prime p from 2 to 300', ok};
[i, j] = ndgrid(1:4, 1:4);
R = check_group(mod(i + j - 2, 4) + 1);
c(end+1, :) = {'adding mod 4 (elements 1 to 4 stand for 0 to 3): a group with identity 1 and inverses [1 4 3 2]', R.is_group && R.is_abelian && R.identity == 1 && isequal(R.inverses, [1 4 3 2])};
R = check_group(uint8(group_table(7)));
c(end+1, :) = {'a table of whole numbers of another type (uint8) works too', R.is_group};
c(end+1, :) = {'a 1 x 1 table [1] is a group with identity 1', check_group(1).is_group && check_group(1).identity == 1};
P = [1 2 3; 1 3 2; 2 1 3; 2 3 1; 3 1 2; 3 2 1];
T6 = zeros(6, 6);
for a = 1:6
    for b = 1:6
        [tf, idx] = ismember(P(a, P(b, :)), P, 'rows');
        T6(a, b) = idx;
    end
end
R = check_group(T6);
c(end+1, :) = {'the 6 permutations of 3 things (S_3): a group, but not commutative', R.is_group && ~R.commutative && ~R.is_abelian && R.identity == 1 && R.associative};

% --- check_group: not groups ---
v = 1:5;
R = check_group(mod(v' * v, 6));
c(end+1, :) = {'1 to 5 times mod 6: not closed, so not a group (identity 0, inverses 0)', ~R.closure && ~R.is_group && R.identity == 0 && ~R.has_identity && isequal(R.inverses, zeros(1, 5))};
R = check_group(mod((0:5)' * (0:5), 6) + 1);
c(end+1, :) = {'0 to 5 times mod 6: closed, associative, identity (the residue 1), but not every element has an inverse', R.closure && R.associative && R.has_identity && R.identity == 2 && ~R.has_inverses && ~R.is_group};
c(end+1, :) = {'0 to 5 times mod 6: the inverses are [0 2 0 0 0 6], it is commutative, but it is not an abelian group', isequal(R.inverses, [0 2 0 0 0 6]) && R.commutative && ~R.is_abelian};
[i, j] = ndgrid(1:3, 1:3);
R = check_group(mod(i - j, 3) + 1);
c(end+1, :) = {'subtracting mod 3: closed, but no identity and not associative, so not a group', R.closure && ~R.has_identity && ~R.associative && ~R.is_group};
R = check_group([1 2; 2 3]);
c(end+1, :) = {'a table with an entry bigger than n is not closed', ~R.closure && ~R.is_group};
R = check_group([1 2; 2 0]);
c(end+1, :) = {'a table with the entry 0 is not closed', ~R.closure && ~R.is_group};
R = check_group([1 2; 2 1.5]);
c(end+1, :) = {'a table with the entry 1.5 is not closed', ~R.closure && ~R.is_group};
R = check_group([1 2; 2 NaN]);
c(end+1, :) = {'a table with NaN is not closed', ~R.closure && ~R.is_group};
R = check_group([1 1; 1 1]);
c(end+1, :) = {'the table [1 1; 1 1] is closed and associative, but has no identity', R.closure && R.associative && ~R.has_identity && ~R.is_group};
R = check_group([1 2; 1 2]);
c(end+1, :) = {'the table [1 2; 1 2] has a left identity only, so no identity', R.closure && ~R.has_identity};
R = check_group([1 1; 2 2]);
c(end+1, :) = {'the table [1 1; 2 2] has a right identity only, so no identity', R.closure && ~R.has_identity && ~R.is_group};
R = check_group([1 2 3 4 5; 2 1 4 5 3; 3 5 1 2 4; 4 3 5 1 2; 5 4 2 3 1]);
c(end+1, :) = {'a closed table with identity 1 and inverses [1 2 3 4 5], but not associative: not a group', R.closure && R.identity == 1 && R.has_inverses && isequal(R.inverses, [1 2 3 4 5]) && ~R.associative && ~R.is_group && ~R.is_abelian};
c(end+1, :) = {'a non-square table is rejected by check_group', raises_error(@() check_group(ones(2, 3)))};
c(end+1, :) = {'an empty table is rejected by check_group', raises_error(@() check_group([]))};
c(end+1, :) = {'a table with 301 rows is rejected by check_group', raises_error(@() check_group(ones(301, 301)))};
c(end+1, :) = {'a 3-dimensional table is rejected by check_group', raises_error(@() check_group(ones(2, 2, 2)))};
c(end+1, :) = {'a text is rejected by check_group', raises_error(@() check_group('ab'))};

% --- element_order ---
ord7 = zeros(1, 6);
for a = 1:6
    ord7(a) = element_order(a, 7);
end
c(end+1, :) = {'the orders in Z_7* are [1 3 6 3 6 2]', isequal(ord7, [1 3 6 3 6 2])};
c(end+1, :) = {'in Z_97*: the order of 5 is 96, of 96 is 2, of 1 is 1, of 35 is 3, of 2 is 48', element_order(5, 97) == 96 && element_order(96, 97) == 2 && element_order(1, 97) == 1 && element_order(35, 97) == 3 && element_order(2, 97) == 48};
c(end+1, :) = {'in Z_2*: the order of 1 is 1', element_order(1, 2) == 1};
c(end+1, :) = {'p = 2^26 - 5: the orders of 3, 2 and p-1 are 33554429, 67108858 and 2', element_order(3, 2^26 - 5) == 33554429 && element_order(2, 2^26 - 5) == 67108858 && element_order(2^26 - 5 - 1, 2^26 - 5) == 2};
ok = true;
for p = primes_120
    for a = 1:(p - 1)
        v = a;
        k = 1;
        while v ~= 1
            v = mod(v * a, p);
            k = k + 1;
        end
        ok = ok && element_order(a, p) == k;
    end
end
c(end+1, :) = {'element_order agrees with multiplying until 1 (every a, every prime p up to 120)', ok};
ok = true;
for p = primes_120
    for a = 1:(p - 1)
        k = element_order(a, p);
        ok = ok && mod(p - 1, k) == 0 && mod_pow(a, k, p) == 1;
    end
end
c(end+1, :) = {'the order always divides p-1 and a^order = 1 (every a, every prime p up to 120)', ok};
cnt = zeros(1, 96);
for a = 1:96
    cnt(element_order(a, 97)) = cnt(element_order(a, 97)) + 1;
end
c(end+1, :) = {'Z_97*: how many numbers have order 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 96', isequal(cnt([1 2 3 4 6 8 12 16 24 32 48 96]), [1 1 2 2 2 4 4 8 8 16 16 32]) && sum(cnt) == 96};
c(end+1, :) = {'a = 0 is rejected by element_order', raises_error(@() element_order(0, 97))};
c(end+1, :) = {'a = p is rejected by element_order', raises_error(@() element_order(97, 97))};
c(end+1, :) = {'a = 2.5 is rejected by element_order', raises_error(@() element_order(2.5, 97))};
c(end+1, :) = {'p = 91 (not prime) is rejected by element_order', raises_error(@() element_order(2, 91))};
c(end+1, :) = {'p = 1 is rejected by element_order', raises_error(@() element_order(1, 1))};
c(end+1, :) = {'p = 67108879 (prime, but bigger than 2^26) is rejected by element_order', raises_error(@() element_order(2, 67108879))};
c(end+1, :) = {'a missing argument is rejected by element_order', raises_error(@() element_order(2))};

% --- is_generator ---
c(end+1, :) = {'the generators of Z_7* are 3 and 5 only', isequal(arrayfun(@(a) is_generator(a, 7), 1:6), [0 0 1 0 1 0] == 1)};
c(end+1, :) = {'5 is a generator of Z_97*, but 1, 2, 35 and 96 are not', is_generator(5, 97) && ~is_generator(1, 97) && ~is_generator(2, 97) && ~is_generator(35, 97) && ~is_generator(96, 97)};
c(end+1, :) = {'1 is a generator of Z_2*, and 2 is the generator of Z_3* but 1 is not', is_generator(1, 2) && is_generator(2, 3) && ~is_generator(1, 3)};
c(end+1, :) = {'p = 2^26 - 5: 2 is a generator (order 67108858) and 3 is not (order 33554429)', is_generator(2, 2^26 - 5) && ~is_generator(3, 2^26 - 5)};
c(end+1, :) = {'the answer is true or false (one logical value)', islogical(is_generator(5, 97)) && isscalar(is_generator(5, 97))};
ok = true;
for p = primes_120
    for a = 1:(p - 1)
        v = a;
        seen = a;
        while v ~= 1
            v = mod(v * a, p);
            seen(end+1) = v;
        end
        ok = ok && (is_generator(a, p) == (numel(unique(seen)) == p - 1));
    end
end
c(end+1, :) = {'is_generator agrees with the powers giving all of 1 to p-1 (every a, every prime p up to 120)', ok};
ok = true;
for p = primes_120
    for a = 1:(p - 1)
        ok = ok && (is_generator(a, p) == (element_order(a, p) == p - 1));
    end
end
c(end+1, :) = {'is_generator agrees with order = p-1 (every a, every prime p up to 120)', ok};
c(end+1, :) = {'a = 0 is rejected by is_generator', raises_error(@() is_generator(0, 97))};
c(end+1, :) = {'a = p is rejected by is_generator', raises_error(@() is_generator(97, 97))};
c(end+1, :) = {'p = 91 (not prime) is rejected by is_generator', raises_error(@() is_generator(2, 91))};
c(end+1, :) = {'a = 2.5 is rejected by is_generator', raises_error(@() is_generator(2.5, 97))};
c(end+1, :) = {'a missing argument is rejected by is_generator', raises_error(@() is_generator(2))};

% --- find_generators ---
gens97 = [5 7 10 13 14 15 17 21 23 26 29 37 38 39 40 41 56 57 58 59 60 68 71 74 76 80 82 83 84 87 90 92];
c(end+1, :) = {'the 32 generators of Z_97*', isequal(find_generators(97), gens97)};
c(end+1, :) = {'the generators of Z_7* are [3 5]', isequal(find_generators(7), [3 5])};
c(end+1, :) = {'the generators of Z_2*, Z_3*, Z_5*, Z_11* and Z_13*', isequal(find_generators(2), 1) && isequal(find_generators(3), 2) && isequal(find_generators(5), [2 3]) && isequal(find_generators(11), [2 6 7 8]) && isequal(find_generators(13), [2 6 7 11])};
ok = true;
for p = primes_120
    ok = ok && numel(find_generators(p)) == sum(gcd(1:(p - 1), p - 1) == 1);
end
c(end+1, :) = {'the number of generators is phi(p-1) for every prime p up to 120', ok};
c(end+1, :) = {'the generator g from define_sets is in the list for p', ismember(S.generator, find_generators(S.prime))};
c(end+1, :) = {'p = 5003 (prime, but bigger than 5000) is rejected by find_generators', raises_error(@() find_generators(5003))};
c(end+1, :) = {'p = 91 is rejected by find_generators', raises_error(@() find_generators(91))};

% --- cyclic_subgroup ---
c(end+1, :) = {'in Z_7*: the powers of 2 are [1 2 4], of 3 are [1 3 2 6 4 5], of 6 are [1 6], of 1 is 1', isequal(cyclic_subgroup(2, 7), [1 2 4]) && isequal(cyclic_subgroup(3, 7), [1 3 2 6 4 5]) && isequal(cyclic_subgroup(6, 7), [1 6]) && isequal(cyclic_subgroup(1, 7), 1)};
H = cyclic_subgroup(5, 97);
c(end+1, :) = {'in Z_97*: the powers of 5 start 1 5 25 28 43 21 8 40 6 30 53 71', isequal(H(1:12), [1 5 25 28 43 21 8 40 6 30 53 71])};
c(end+1, :) = {'in Z_97*: the powers of 35 are [1 35 61], of 96 are [1 96], of 22 are [1 22 96 75]', isequal(cyclic_subgroup(35, 97), [1 35 61]) && isequal(cyclic_subgroup(96, 97), [1 96]) && isequal(cyclic_subgroup(22, 97), [1 22 96 75])};
c(end+1, :) = {'the powers of a generator give every number from 1 to p-1 once', isequal(sort(H), 1:96)};
ok = true;
for p = [2 3 5 7 11 13 97 101 257]
    for a = 1:(p - 1)
        Ha = cyclic_subgroup(a, p);
        ok = ok && numel(Ha) == element_order(a, p) && Ha(1) == 1 && numel(unique(Ha)) == numel(Ha) && all(ismember(mod(Ha' * Ha, p), Ha)) && mod(Ha(end) * a, p) == 1;
    end
end
c(end+1, :) = {'each cyclic subgroup starts with 1, has no repeats, is closed, and the order is its size (primes 2 to 257)', ok};
ok = true;
for a = 1:96
    ok = ok && mod(96, numel(cyclic_subgroup(a, 97))) == 0;
end
c(end+1, :) = {'Lagrange: the size of every cyclic subgroup of Z_97* divides 96', ok};
c(end+1, :) = {'p = 5003 is rejected by cyclic_subgroup', raises_error(@() cyclic_subgroup(2, 5003))};
c(end+1, :) = {'a = 0 is rejected by cyclic_subgroup', raises_error(@() cyclic_subgroup(0, 97))};
c(end+1, :) = {'a = p is rejected by cyclic_subgroup', raises_error(@() cyclic_subgroup(97, 97))};
c(end+1, :) = {'p = 91 is rejected by cyclic_subgroup', raises_error(@() cyclic_subgroup(2, 91))};

% --- show_group ---
txt = evalc('show_group(S)');
c(end+1, :) = {'show_group prints its title, p is prime and 96 = 2^5 * 3', ~isempty(strfind(txt, '=== THE GROUP Z_p* (THE NUMBERS 1 TO p-1 WITH MULTIPLICATION MOD p) ===')) && ~isempty(strfind(txt, 'Here p = 97. Is p prime? yes. The group has p - 1 = 96 elements, and 96 = 2^5 * 3.'))};
c(end+1, :) = {'show_group prints the table of Z_7* (row 2 is 2 4 6 1 3 5)', ~isempty(strfind(txt, '   2 |  2  4  6  1  3  5')) && ~isempty(strfind(txt, '   * |  1  2  3  4  5  6'))};
c(end+1, :) = {'show_group prints the identity and the inverses of Z_7*', ~isempty(strfind(txt, 'The identity is 1. The inverses are: 1 -> 1, 2 -> 4, 3 -> 5, 4 -> 2, 5 -> 3, 6 -> 6.'))};
c(end+1, :) = {'show_group prints that mod 6 is not closed', ~isempty(strfind(txt, 'Closed? NO. That is why p must be prime.'))};
c(end+1, :) = {'show_group prints the 5 group rules of Z_97* with yes', ~isempty(strfind(txt, 'a number from 1 to 96: yes')) && ~isempty(strfind(txt, 'for every a: yes')) && ~isempty(strfind(txt, '(for example 5 has the inverse 39 and 85 has the inverse 8): yes')) && ~isempty(strfind(txt, 'all 96 x 96 x 96 = 884736 triples: yes')) && ~isempty(strfind(txt, 'for all a and b: yes'))};
c(end+1, :) = {'show_group prints that Z_97* is an abelian group with 96 elements', ~isempty(strfind(txt, 'So Z_97* is an abelian (commutative) group with 96 elements.'))};
pos = strfind(txt, 'Checks:');
tail = txt(pos(end):end);
c(end+1, :) = {'show_group ends with 6 check lines that all say yes', numel(strfind(tail, ': yes')) == 6 && isempty(strfind(tail, ': NO'))};
S5 = S;
S5.prime = 5;
txt5 = evalc('show_group(S5)');
c(end+1, :) = {'show_group also works for p = 5 and prints 96 nowhere', ~isempty(strfind(txt5, 'p - 1 = 4 elements, and 4 = 2^2.')) && ~isempty(strfind(txt5, 'So Z_5* is an abelian (commutative) group with 4 elements.')) && isempty(strfind(txt5, '5 has the inverse'))};

% --- show_cyclic ---
txt = evalc('show_cyclic(S)');
c(end+1, :) = {'show_cyclic prints its title', ~isempty(strfind(txt, '=== ORDERS, GENERATORS AND CYCLIC SUBGROUPS OF Z_p* ==='))};
c(end+1, :) = {'show_cyclic prints the orders of 5, 2, 96 and 1', ~isempty(strfind(txt, 'The order of 5 is 96: 5^96 mod 97 = 1')) && ~isempty(strfind(txt, 'The order of 2 is 48: 2^48 mod 97 = 1')) && ~isempty(strfind(txt, 'The order of 96 is 2: 96^2 mod 97 = 1')) && ~isempty(strfind(txt, 'The order of 1 is 1: 1^1 mod 97 = 1'))};
c(end+1, :) = {'show_cyclic prints the table of orders (order 3: 2 numbers, smallest 35; order 96: 32 numbers, smallest 5)', ~isempty(strfind(txt, '  3         2               35')) && ~isempty(strfind(txt, '  96        32              5')) && ~isempty(strfind(txt, 'the counts add up to 96.'))};
c(end+1, :) = {'show_cyclic prints that there are 32 generators, the smallest is 5, and g = 5 is one', ~isempty(strfind(txt, 'There are 32 generators. The smallest is 5.')) && ~isempty(strfind(txt, '  5 7 10 13 14 15 17 21 23 26 29 37')) && ~isempty(strfind(txt, 'from define_sets is one of them: yes'))};
c(end+1, :) = {'show_cyclic prints the powers of 5 and that the group is cyclic', ~isempty(strfind(txt, '= 1 5 25 28 43 21 8 40 6 30 53 71, ...')) && ~isempty(strfind(txt, 'There are 96 powers before the first one repeats, and they are all different: yes')) && ~isempty(strfind(txt, 'So Z_97* is a cyclic group: it has a generator.'))};
c(end+1, :) = {'show_cyclic prints the subgroups of 2, 3, 4 and 6 elements', ~isempty(strfind(txt, 'The powers of 96 form a subgroup with 2 elements: 1 96')) && ~isempty(strfind(txt, 'The powers of 35 form a subgroup with 3 elements: 1 35 61')) && ~isempty(strfind(txt, 'The powers of 22 form a subgroup with 4 elements: 1 22 96 75')) && ~isempty(strfind(txt, 'The powers of 36 form a subgroup with 6 elements: 1 36 35 96 61 62'))};
pos = strfind(txt, 'Checks:');
tail = txt(pos(end):end);
c(end+1, :) = {'show_cyclic ends with 7 check lines that all say yes', numel(strfind(tail, ': yes')) == 7 && isempty(strfind(tail, ': NO'))};
S7 = S;
S7.prime = 7;
S7.generator = 3;
txt7 = evalc('show_cyclic(S7)');
c(end+1, :) = {'show_cyclic also works for p = 7 with g = 3 (2 generators: 3 and 5)', ~isempty(strfind(txt7, 'There are 2 generators. The smallest is 3.')) && ~isempty(strfind(txt7, 'So Z_7* is a cyclic group')) && isempty(strfind(txt7, ': NO'))};

% --- demo_point3 ---
txt2 = evalc('demo_point3()');
c(end+1, :) = {'demo_point3 prints its title and the three parts', ~isempty(strfind(txt2, 'POINT 3 DEMO: GROUP THEORY AND MODULAR ARITHMETIC')) && ~isempty(strfind(txt2, '=== MODULAR ARITHMETIC TOOLS ===')) && ~isempty(strfind(txt2, '=== THE GROUP Z_p* (THE NUMBERS 1 TO p-1 WITH MULTIPLICATION MOD p) ===')) && ~isempty(strfind(txt2, '=== ORDERS, GENERATORS AND CYCLIC SUBGROUPS OF Z_p* ==='))};
pos = strfind(txt2, 'Checks:');
n_yes = 0;
for k = 1:numel(pos)
    rest = txt2(pos(k):end);
    stop = strfind(rest, '=== ');
    if ~isempty(stop)
        rest = rest(1:(stop(1) - 1));
    end
    n_yes = n_yes + numel(strfind(rest, ': yes'));
end
c(end+1, :) = {'demo_point3 has 3 Checks blocks with 18 check lines that all say yes, and none says NO', numel(pos) == 3 && n_yes == 18 && isempty(strfind(txt2, ': NO'))};

summarize_checks('test_group', c);
end
