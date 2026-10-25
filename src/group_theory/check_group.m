function R = check_group(T)
% CHECK_GROUP Check the group rules for a multiplication table.
%   R = check_group(T) takes a square matrix T with n rows (n from 1 to 300). The elements are called 1 to n, and T(a, b) is the product of a and b.
%   R.n            the number of elements
%   R.closure      true when every product is a whole number from 1 to n (so a product never leaves the set)
%   R.identity     the identity element e (T(e, a) = a and T(a, e) = a for every a), or 0 when there is none
%   R.has_identity true when there is an identity element
%   R.inverses     a row with the inverse of each element (T(a, b) = e and T(b, a) = e), and 0 where there is none
%   R.has_inverses true when every element has an inverse
%   R.associative  true when (a*b)*c = a*(b*c) for all a, b and c
%   R.commutative  true when a*b = b*a for all a and b
%   R.is_group     true when closure, identity, inverses and associativity all hold
%   R.is_abelian   true when it is a group and it is commutative
%   When the table is not closed, the other rules cannot be checked and are reported as false (identity 0, inverses 0).
if ~isnumeric(T) || ndims(T) ~= 2 || size(T, 1) ~= size(T, 2) || size(T, 1) < 1 || size(T, 1) > 300
    error('check_group:table', 'T must be a square matrix of numbers with 1 to 300 rows.');
end
n = size(T, 1);
T = double(T);
R.n = n;
R.closure = all(T(:) == floor(T(:))) && all(T(:) >= 1) && all(T(:) <= n);
R.identity = 0;
R.has_identity = false;
R.inverses = zeros(1, n);
R.has_inverses = false;
R.associative = false;
R.commutative = false;
R.is_group = false;
R.is_abelian = false;
if ~R.closure
    return;
end
idx = 1:n;
for e = idx
    if isequal(T(e, :), idx) && isequal(T(:, e)', idx)
        R.identity = e;
        R.has_identity = true;
        break;
    end
end
if R.has_identity
    for a = idx
        b = find(T(a, :) == R.identity & T(:, a)' == R.identity);
        if ~isempty(b)
            R.inverses(a) = b(1);
        end
    end
    R.has_inverses = all(R.inverses > 0);
end
R.associative = true;
for a = idx
    r = T(a, :);
    left = T(r, :);
    right = r(T);
    if ~isequal(left, right)
        R.associative = false;
        break;
    end
end
R.commutative = isequal(T, T');
R.is_group = R.closure && R.has_identity && R.has_inverses && R.associative;
R.is_abelian = R.is_group && R.commutative;
end
