function R = define_relations(S)
% DEFINE_RELATIONS Build the relations of the system and return them in a struct.
%   R.channels       the 6 channels, one row per channel, with two user names in each row
%   R.talk_pairs     R1, the ordered pairs (u, v) where user u can talk to user v (user numbers)
%   R.talk           R1 as a matrix of true and false (one row and one column per user)
%   R.private_keys   the private key of each user (a number from K for each user)
%   R.owns_pairs     R2, the pairs (u, k) where user u owns the private key k
%   R.owns           R2 as a matrix of true and false (one row per user, one column per key)
%   The channels and the private keys can be changed here.
if nargin < 1
    S = define_sets();
end
nu = numel(S.users);

R.channels = {'Alice', 'Bob'; 'Alice', 'Carol'; 'Bob', 'Dave'; 'Carol', 'Dave'; 'Dave', 'Frank'; 'Frank', 'Grace'};
nc = size(R.channels, 1);
ch = zeros(nc, 2);
for r = 1:nc
    for c = 1:2
        ch(r, c) = user_number(S, R.channels{r, c});
    end
end
R.talk_pairs = [ch; ch(:, [2 1])];
R.talk = pairs_to_matrix(R.talk_pairs, nu, nu);

R.private_keys = [6 15 23 37 41 58];
if numel(R.private_keys) ~= nu
    error('define_relations:keys', 'There must be exactly one private key for each user.');
end
if ~all(ismember(R.private_keys, S.keys))
    error('define_relations:keys', 'Every private key must be a number from the set K.');
end
R.owns_pairs = [(1:nu)', R.private_keys(:)];
R.owns = pairs_to_matrix(R.owns_pairs, nu, numel(S.keys));
end

function n = user_number(S, name)
n = find(strcmp(S.users, name), 1);
if isempty(n)
    error('define_relations:user', 'The user %s is not in the set U.', name);
end
end
