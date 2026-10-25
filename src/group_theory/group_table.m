function T = group_table(p)
% GROUP_TABLE The multiplication table of the group Z_p*.
%   T = group_table(p) gives the (p-1) by (p-1) matrix with T(a, b) = a*b mod p for the numbers a and b from 1 to p-1.
%   p must be a prime number from 2 to 300.
if ~is_whole_number(p) || p < 2 || p > 300 || ~is_prime_number(p)
    error('group_table:prime', 'p must be a prime number from 2 to 300.');
end
v = 1:(double(p) - 1);
T = mod(v' * v, double(p));
end
