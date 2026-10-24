function [r, steps] = mod_pow(b, e, m)
% MOD_POW Fast modular exponentiation: b^e mod m by repeated squaring (square and multiply).
%   r = mod_pow(b, e, m) gives b^e mod m. b and e are whole numbers, 0 or bigger. m is a whole number from 2 to 67108864.
%   b^0 is 1, also for b = 0. The result is exact because m is at most 2^26, so every product stays below 2^52.
%   [r, steps] = mod_pow(b, e, m) also gives the steps: one row for each binary digit (bit) of e, from the left.
%   The 3 columns of steps are: the bit, the value after squaring, the value after the multiplication by b (a bit 0 skips it).
%   For e = 0 there are no bits, so steps has no rows.
if ~is_whole_number(b) || b < 0
    error('mod_pow:base', 'The base b must be one whole number, 0 or bigger.');
end
if ~is_whole_number(e) || e < 0
    error('mod_pow:exponent', 'The exponent e must be one whole number, 0 or bigger.');
end
if ~is_whole_number(m) || m < 2 || m > 2^26
    error('mod_pow:modulus', 'The modulus m must be one whole number from 2 to 67108864.');
end
m = double(m);
b = mod(double(b), m);
t = double(e);
bits = [];
while t > 0
    bits = [mod(t, 2), bits];
    t = (t - mod(t, 2)) / 2;
end
r = 1;
steps = zeros(numel(bits), 3);
for i = 1:numel(bits)
    r = mod(r * r, m);
    after_square = r;
    if bits(i) == 1
        r = mod(r * b, m);
    end
    steps(i, :) = [bits(i), after_square, r];
end
end
