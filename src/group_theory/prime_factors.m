function f = prime_factors(n)
% PRIME_FACTORS The prime factorization of n.
%   f = prime_factors(n) gives a matrix with one row [q k] for each prime q that divides n, where k is how often q divides n.
%   So n = q1^k1 * q2^k2 * ... The primes are in increasing order. For n = 1 there are no rows.
%   n is a whole number from 1 to 4294967296 (2^32). It is found by trial division.
if ~is_whole_number(n) || n < 1 || n > 2^32
    error('prime_factors:input', 'n must be one whole number from 1 to 4294967296.');
end
n = double(n);
f = zeros(0, 2);
d = 2;
while d * d <= n
    if mod(n, d) == 0
        k = 0;
        while mod(n, d) == 0
            n = n / d;
            k = k + 1;
        end
        f(end+1, :) = [d, k];
    end
    d = d + 1;
end
if n > 1
    f(end+1, :) = [n, 1];
end
end
