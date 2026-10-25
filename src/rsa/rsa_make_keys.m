function K = rsa_make_keys(p, q, e)
% RSA_MAKE_KEYS Make an RSA key pair from two primes p and q and the public exponent e.
%   K = rsa_make_keys(p, q, e) gives a struct with
%   K.p, K.q   the two primes (secret)
%   K.n        the modulus p*q (public)
%   K.phi      (p-1)*(q-1), the number of elements of the group Z_n* (secret)
%   K.e        the public exponent
%   K.d        the private exponent: the inverse of e mod phi, so e*d = 1 (mod phi) (secret)
%   The public key is (K.n, K.e). The private key is K.d.
%   check_rsa_setup refuses bad p, q or e. The keys are also refused when e*e = 1 (mod phi),
%   because then d = e and encrypting twice would give the message back.
check_rsa_setup(p, q, e);
K.p = double(p);
K.q = double(q);
K.n = K.p * K.q;
K.phi = (K.p - 1) * (K.q - 1);
K.e = double(e);
if mod(K.e * K.e, K.phi) == 1
    error('rsa_make_keys:selfinverse', 'e = %d is its own inverse mod phi = %d, so d = e. Choose another e.', K.e, K.phi);
end
K.d = mod_inverse(K.e, K.phi);
end
