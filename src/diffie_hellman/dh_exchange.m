function E = dh_exchange(a, b, p, g)
% DH_EXCHANGE One Diffie-Hellman key exchange between two users, called Alice (secret number a) and Bob (secret number b).
%   E = dh_exchange(a, b, p, g) gives a struct with
%   E.p, E.g, E.a, E.b   the numbers that were used
%   E.A, E.B             the public values g^a mod p and g^b mod p (these cross the insecure channel)
%   E.key_alice          B^a mod p, the key that Alice computes
%   E.key_bob            A^b mod p, the key that Bob computes
%   E.agree              true when both keys are the same
%   E.key                the shared key (the key of Alice)
%   E.exponent           a*b mod (p-1), because g^(p-1) = 1 (mod p)
%   E.key_formula        g^(a*b mod (p-1)) mod p, which must be the same key
check_dh_setup(p, g);
E.p = p;
E.g = g;
E.a = a;
E.b = b;
E.A = dh_public_value(a, p, g);
E.B = dh_public_value(b, p, g);
E.key_alice = dh_shared_key(a, E.B, p);
E.key_bob = dh_shared_key(b, E.A, p);
E.agree = (E.key_alice == E.key_bob);
E.key = E.key_alice;
E.exponent = mod(a * b, p - 1);
E.key_formula = mod_pow(g, E.exponent, p);
end
