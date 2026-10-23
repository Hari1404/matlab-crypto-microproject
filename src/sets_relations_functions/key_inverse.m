function j = key_inverse(k, S)
% KEY_INVERSE Find the inverse of the key k in the group Z_97*.
%   The inverse j is the number in K with k*j = 1 (mod p).
%   It is found by trying every number in K. (Point 3 adds the faster method.)
%   key_inverse(k)     uses the sets from define_sets.
%   key_inverse(k, S)  uses the sets in the struct S.
if nargin < 2
    S = define_sets();
end
if ~isnumeric(k) || ~isscalar(k) || ~ismember(k, S.keys)
    error('key_inverse:range', 'The key must be one whole number from the set K.');
end
j = S.keys(mod(double(k) * S.keys, S.prime) == 1);
end
