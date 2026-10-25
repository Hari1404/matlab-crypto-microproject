function flag = is_generator(a, p)
% IS_GENERATOR True when a is a generator of the group Z_p*, that is, when the powers of a give every number from 1 to p-1.
%   a is a whole number from 1 to p-1. p is a prime number up to 2^26 (67108864).
%   a is a generator exactly when a^((p-1)/q) is not 1 (mod p) for every prime factor q of p-1.
if ~is_whole_number(p) || p < 2 || p > 2^26 || ~is_prime_number(p)
    error('is_generator:prime', 'p must be a prime number from 2 to 67108864.');
end
if ~is_whole_number(a) || a < 1 || a > p - 1
    error('is_generator:range', 'a must be one whole number from 1 to p-1.');
end
p = double(p);
a = double(a);
f = prime_factors(p - 1);
flag = true;
for r = 1:size(f, 1)
    if mod_pow(a, (p - 1) / f(r, 1), p) == 1
        flag = false;
    end
end
end
