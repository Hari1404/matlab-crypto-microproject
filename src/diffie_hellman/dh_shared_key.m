function K = dh_shared_key(a, B, p)
% DH_SHARED_KEY The shared key K = B^a mod p that a user computes from the public value B of the other user.
%   a is the own secret number, a whole number from 1 to p-2. B is the public value of the other user, a whole number from 1 to p-1. p is a prime number from 5 to 67108864.
%   If the other user has the secret number b, then B = g^b and K = g^(a*b) (mod p), the same key that the other user gets.
check_dh_setup(p);
if ~is_whole_number(a) || a < 1 || a > p - 2
    error('dh_shared_key:secret', 'The secret number a must be one whole number from 1 to p-2.');
end
if ~is_whole_number(B) || B < 1 || B > p - 1
    error('dh_shared_key:public', 'The public value B must be one whole number from 1 to p-1.');
end
K = mod_pow(B, a, p);
end
