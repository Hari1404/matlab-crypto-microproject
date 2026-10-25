function k = element_order(a, p)
% ELEMENT_ORDER The order of the number a in the group Z_p*.
%   k = element_order(a, p) gives the smallest k >= 1 with a^k = 1 (mod p).
%   a is a whole number from 1 to p-1. p is a prime number up to 2^26 (67108864).
%   The order always divides p-1. It is found by starting with k = p-1 and dividing out each prime factor q of p-1 as long as a^(k/q) is still 1 (mod p).
if ~is_whole_number(p) || p < 2 || p > 2^26 || ~is_prime_number(p)
    error('element_order:prime', 'p must be a prime number from 2 to 67108864.');
end
if ~is_whole_number(a) || a < 1 || a > p - 1
    error('element_order:range', 'a must be one whole number from 1 to p-1.');
end
p = double(p);
a = double(a);
k = p - 1;
f = prime_factors(p - 1);
for r = 1:size(f, 1)
    q = f(r, 1);
    while mod(k, q) == 0 && mod_pow(a, k / q, p) == 1
        k = k / q;
    end
end
end
