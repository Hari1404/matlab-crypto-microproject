function P = relation_properties(M)
% RELATION_PROPERTIES Check the properties of a relation on one set.
%   M is a square matrix of 0 and 1 (or false and true). M(a, b) = 1 means a is related to b.
%   P.reflexive          every a is related to itself
%   P.irreflexive        no a is related to itself
%   P.symmetric          if a is related to b, then b is related to a
%   P.antisymmetric      a and b are related both ways only when a and b are the same
%   P.transitive         if a is related to b and b to c, then a is related to c
%   P.equivalence        reflexive, symmetric and transitive
%   P.partial_order      reflexive, antisymmetric and transitive
%   P.transitive_witness [a b c] that breaks transitivity, or [] when the relation is transitive
if ~(isnumeric(M) || islogical(M)) || size(M, 1) ~= size(M, 2) || any(M(:) ~= 0 & M(:) ~= 1)
    error('relation_properties:input', 'The relation must be a square matrix of 0 and 1.');
end
M = logical(M);
n = size(M, 1);
I = logical(eye(n));

P.reflexive = all(diag(M));
P.irreflexive = ~any(diag(M));
P.symmetric = isequal(M, M');

both = M & M';
both(I) = false;
P.antisymmetric = ~any(both(:));

two_steps = (double(M) * double(M)) > 0;
missing = two_steps & ~M;
P.transitive = ~any(missing(:));

P.equivalence = P.reflexive && P.symmetric && P.transitive;
P.partial_order = P.reflexive && P.antisymmetric && P.transitive;

P.transitive_witness = [];
if ~P.transitive
    pick = missing & ~I;
    if ~any(pick(:))
        pick = missing;
    end
    [a, c] = find(pick, 1);
    b = find(M(a, :) & M(:, c).', 1);
    P.transitive_witness = [a b c];
end
end
