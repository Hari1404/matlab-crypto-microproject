function j = mod_inverse(a, m)
% MOD_INVERSE The inverse of a modulo m, found with the extended Euclid algorithm.
%   j = mod_inverse(a, m) gives the number j from 1 to m-1 with a*j = 1 (mod m).
%   a is a whole number, 0 or bigger. m is a whole number, 2 or bigger.
%   The inverse exists exactly when gcd(a, m) = 1. Otherwise this stops with an error.
if ~is_whole_number(a) || a < 0
    error('mod_inverse:input', 'a must be one whole number, 0 or bigger.');
end
if ~is_whole_number(m) || m < 2
    error('mod_inverse:modulus', 'm must be one whole number, 2 or bigger.');
end
m = double(m);
[g, x] = ext_gcd(mod(double(a), m), m);
if g ~= 1
    error('mod_inverse:none', '%d has no inverse modulo %d, because gcd(%d, %d) = %d and not 1.', a, m, a, m, g);
end
j = mod(x, m);
end
