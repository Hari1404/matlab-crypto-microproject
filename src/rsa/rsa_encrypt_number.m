function c = rsa_encrypt_number(m, n, e)
% RSA_ENCRYPT_NUMBER Encrypt one number m with the public key (n, e): c = m^e mod n.
%   m is a whole number from 0 to n-1. n is a whole number from 97 to 67108864. e is a whole number, 3 or bigger.
%   The power is found with mod_pow (repeated squaring).
if ~is_whole_number(n) || n < 97 || n > 2^26
    error('rsa_encrypt_number:modulus', 'n must be one whole number from 97 to 67108864.');
end
if ~is_whole_number(e) || e < 3
    error('rsa_encrypt_number:exponent', 'e must be one whole number, 3 or bigger.');
end
if ~is_whole_number(m) || m < 0 || m > n - 1
    error('rsa_encrypt_number:message', 'm must be one whole number from 0 to n-1 = %d.', n - 1);
end
c = mod_pow(m, e, n);
end
