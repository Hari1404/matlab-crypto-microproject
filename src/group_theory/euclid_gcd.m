function [g, steps] = euclid_gcd(a, b)
% EUCLID_GCD The greatest common divisor by Euclid's algorithm.
%   g = euclid_gcd(a, b) gives gcd(a, b). a and b are whole numbers, 0 or bigger, and not both 0.
%   [g, steps] = euclid_gcd(a, b) also gives the steps: one row [a b q r] for each division a = q*b + r.
%   The last r is 0 and the gcd is the last b. If b is 0 there are no steps and the gcd is a.
if ~is_whole_number(a) || ~is_whole_number(b) || a < 0 || b < 0 || (a == 0 && b == 0)
    error('euclid_gcd:input', 'a and b must be whole numbers, 0 or bigger, and not both 0.');
end
a = double(a);
b = double(b);
steps = zeros(0, 4);
while b ~= 0
    r = mod(a, b);
    q = (a - r) / b;
    steps(end+1, :) = [a, b, q, r];
    a = b;
    b = r;
end
g = a;
end
