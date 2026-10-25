function check_dh_setup(p, g)
% CHECK_DH_SETUP Stop with an error when the public numbers of the Diffie-Hellman exchange are not usable.
%   check_dh_setup(p) checks that p is a prime number from 5 to 67108864.
%   check_dh_setup(p, g) also checks that g is a generator of the group Z_p*.
if ~is_whole_number(p) || p < 5 || p > 2^26 || ~is_prime_number(p)
    error('check_dh_setup:prime', 'p must be a prime number from 5 to 67108864.');
end
if nargin > 1
    if ~is_whole_number(g) || g < 2 || g > p - 1 || ~is_generator(g, p)
        error('check_dh_setup:generator', 'g must be a generator of the group Z_p* (a number from 2 to p-1 whose powers give every number from 1 to p-1).');
    end
end
end
