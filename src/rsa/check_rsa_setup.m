function check_rsa_setup(p, q, e)
% CHECK_RSA_SETUP Stop with an error when p, q and e cannot make an RSA key pair.
%   check_rsa_setup(p, q) checks that p and q are two different prime numbers (each from 2 to 67108864)
%   and that n = p*q is from 97 to 67108864. n must be bigger than 96 so that every plaintext symbol (1 to 95)
%   and every cipher key (1 to 96) is smaller than n. n must be at most 2^26 so that mod_pow stays exact.
%   check_rsa_setup(p, q, e) also checks that e is a whole number from 3 to phi-1 with gcd(e, phi) = 1,
%   where phi = (p-1)*(q-1).
if ~is_whole_number(p) || p < 2 || p > 2^26 || ~is_prime_number(p)
    error('check_rsa_setup:prime', 'p must be a prime number (a whole number from 2 to 67108864).');
end
if ~is_whole_number(q) || q < 2 || q > 2^26 || ~is_prime_number(q)
    error('check_rsa_setup:prime', 'q must be a prime number (a whole number from 2 to 67108864).');
end
if p == q
    error('check_rsa_setup:same', 'p and q must be two different primes.');
end
n = double(p) * double(q);
if n < 97 || n > 2^26
    error('check_rsa_setup:size', 'n = p*q must be from 97 to 67108864, but it is %d.', n);
end
if nargin > 2
    phi = (double(p) - 1) * (double(q) - 1);
    if ~is_whole_number(e) || e < 3 || e > phi - 1
        error('check_rsa_setup:exponent', 'e must be one whole number from 3 to phi-1 = %d.', phi - 1);
    end
    g = euclid_gcd(e, phi);
    if g ~= 1
        error('check_rsa_setup:gcd', 'e = %d and phi = %d must have gcd 1, but the gcd is %d.', e, phi, g);
    end
end
end
