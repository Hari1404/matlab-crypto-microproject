function D = define_secrets(S)
% DEFINE_SECRETS The secret numbers and the public values of the users for the Diffie-Hellman exchange.
%   D = define_secrets(S) uses the sets S from define_sets (default). D has
%   D.users    the names of the users
%   D.private  the secret number of each user (a number from 1 to p-2)
%   D.public   the public value g^secret mod p of each user
%   The secret numbers are set here and can be changed here.
if nargin < 1
    S = define_sets();
end
D.users = S.users;
D.private = [6 15 23 41 58 77];
if numel(D.private) ~= numel(S.users)
    error('define_secrets:count', 'There must be one secret number for each user.');
end
D.public = zeros(1, numel(D.private));
for i = 1:numel(D.private)
    D.public(i) = dh_public_value(D.private(i), S.prime, S.generator);
end
end
