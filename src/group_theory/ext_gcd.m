function [g, x, y] = ext_gcd(a, b)
% EXT_GCD The extended Euclid algorithm: the gcd and numbers x and y with a*x + b*y = gcd(a, b).
%   [g, x, y] = ext_gcd(a, b) gives g = gcd(a, b) and whole numbers x and y (they can be negative or 0) with a*x + b*y = g.
%   a and b are whole numbers, 0 or bigger, and not both 0.
if ~is_whole_number(a) || ~is_whole_number(b) || a < 0 || b < 0 || (a == 0 && b == 0)
    error('ext_gcd:input', 'a and b must be whole numbers, 0 or bigger, and not both 0.');
end
r0 = double(a);
r1 = double(b);
s0 = 1;
s1 = 0;
t0 = 0;
t1 = 1;
while r1 ~= 0
    r2 = mod(r0, r1);
    q = (r0 - r2) / r1;
    s2 = s0 - q * s1;
    t2 = t0 - q * t1;
    r0 = r1;
    r1 = r2;
    s0 = s1;
    s1 = s2;
    t0 = t1;
    t1 = t2;
end
g = r0;
x = s0;
y = t0;
end
