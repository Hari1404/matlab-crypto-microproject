function flag = is_prime_number(n)
% IS_PRIME_NUMBER True when n is a prime number (2, 3, 5, 7, 11, ...).
%   n is a whole number from 0 to 4294967296 (2^32). It is found by trial division: n is prime when no number from 2 up to the square root of n divides it.
%   Numbers smaller than 2 are not prime. (The built-in isprime gives the same answers; this function shows the method.)
if ~is_whole_number(n) || n < 0 || n > 2^32
    error('is_prime_number:input', 'n must be one whole number from 0 to 4294967296.');
end
n = double(n);
if n < 2
    flag = false;
elseif n < 4
    flag = true;
else
    d = 2:floor(sqrt(n));
    flag = ~any(mod(n, d) == 0);
end
end
