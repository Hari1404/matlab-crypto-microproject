function m = rsa_decrypt_number(c, n, d)
% RSA_DECRYPT_NUMBER Decrypt one number c with the private key d: m = c^d mod n.
%   c is a whole number from 0 to n-1. n is a whole number from 97 to 67108864. d is a whole number, 1 or bigger.
%   The power is found with mod_pow (repeated squaring).
if ~is_whole_number(n) || n < 97 || n > 2^26
    error('rsa_decrypt_number:modulus', 'n must be one whole number from 97 to 67108864.');
end
if ~is_whole_number(d) || d < 1
    error('rsa_decrypt_number:exponent', 'd must be one whole number, 1 or bigger.');
end
if ~is_whole_number(c) || c < 0 || c > n - 1
    error('rsa_decrypt_number:cipher', 'c must be one whole number from 0 to n-1 = %d.', n - 1);
end
m = mod_pow(c, d, n);
end
