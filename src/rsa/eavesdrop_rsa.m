function E = eavesdrop_rsa(n, e)
% EAVESDROP_RSA Eve factors the public modulus n by trial division and finds the private exponent.
%   E = eavesdrop_rsa(n, e) tries t = 2, 3, ... until t divides n. n is a whole number from 97 to 2^26 and e is the public exponent.
%   E has
%   E.n, E.e    the public key
%   E.p, E.q    the primes, p is the smaller one (p is the first number that divides n)
%   E.phi       (p-1)*(q-1)
%   E.d         the private exponent, mod_inverse(e, phi)
%   E.tries     the number of tries, p-1 (t = 2, ..., p)
%   E.worst     the most tries that are ever needed for this n: floor(sqrt(n)) - 1
%   The errors are eavesdrop_rsa:modulus (n is not a whole number from 97 to 2^26), :exponent (e is not a whole number of at least 3,
%   or gcd(e, phi) is not 1), :prime (n has no divisor up to its square root, so n is a prime) and
%   :form (n is not the product of two different primes).
if ~is_whole_number(n) || n < 97 || n > 2^26
    error('eavesdrop_rsa:modulus', 'n must be one whole number from 97 to 67108864.');
end
if ~is_whole_number(e) || e < 3
    error('eavesdrop_rsa:exponent', 'e must be one whole number, 3 or bigger.');
end
n = double(n);
e = double(e);
r = floor(sqrt(n));
t = 2:r;
hit = find(mod(n, t) == 0, 1);
if isempty(hit)
    error('eavesdrop_rsa:prime', 'n = %d has no divisor from 2 to its square root, so it is a prime and not p*q.', n);
end
p = t(hit);
q = n / p;
if p == q || ~is_prime_number(q)
    error('eavesdrop_rsa:form', 'n = %d is not the product of two different primes (it is %d * %d).', n, p, q);
end
phi = (p - 1) * (q - 1);
if euclid_gcd(e, phi) ~= 1
    error('eavesdrop_rsa:exponent', 'e = %d and phi = %d must have gcd 1.', e, phi);
end
E.n = n;
E.e = e;
E.p = p;
E.q = q;
E.phi = phi;
E.d = mod_inverse(e, phi);
E.tries = p - 1;
E.worst = r - 1;
end
