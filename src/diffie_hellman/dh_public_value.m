function A = dh_public_value(a, p, g)
% DH_PUBLIC_VALUE The public value A = g^a mod p that a user sends in the Diffie-Hellman exchange.
%   a is the secret number of the user, a whole number from 1 to p-2. p is a prime number from 5 to 67108864. g is a generator of Z_p*.
check_dh_setup(p, g);
if ~is_whole_number(a) || a < 1 || a > p - 2
    error('dh_public_value:secret', 'The secret number a must be one whole number from 1 to p-2.');
end
A = mod_pow(g, a, p);
end
