function gens = find_generators(p)
% FIND_GENERATORS All generators of the group Z_p*, as a row in increasing order.
%   gens = find_generators(p) tests every number a from 1 to p-1 with is_generator.
%   p must be a prime number from 2 to 5000. There are always phi(p-1) generators.
if ~is_whole_number(p) || p < 2 || p > 5000 || ~is_prime_number(p)
    error('find_generators:prime', 'p must be a prime number from 2 to 5000.');
end
gens = zeros(1, 0);
for a = 1:(double(p) - 1)
    if is_generator(a, p)
        gens(end+1) = a;
    end
end
end
