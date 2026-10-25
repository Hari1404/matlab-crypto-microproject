function K = dh_key_table(D, p)
% DH_KEY_TABLE The shared key of every pair of users.
%   K = dh_key_table(D, p) gives the n by n matrix with K(i, j) = the key that user i computes from the public value of user j (D from define_secrets).
%   K(i, i) is 0, because a user does not need a key with himself.
n = numel(D.private);
K = zeros(n, n);
for i = 1:n
    for j = 1:n
        if i ~= j
            K(i, j) = dh_shared_key(D.private(i), D.public(j), p);
        end
    end
end
end
