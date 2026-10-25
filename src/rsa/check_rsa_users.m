function check_rsa_users(R, S)
% CHECK_RSA_USERS Stop with an error when R is not a proper set of RSA keys for the users.
%   check_rsa_users(R)     uses define_sets.
%   check_rsa_users(R, S)  uses the sets S.
%   R is the struct of define_rsa_users. The errors are
%   check_rsa_users:fields  R is not a struct, a field is missing or is not numeric, or a field does not have one number for each user
%   check_rsa_users:key     the key of one user is not proper: p, q or e is refused by check_rsa_setup, n or phi does not fit p and q,
%                           or e*d is not 1 mod phi (the message names the user)
%   check_rsa_users:same    two users have the same n
if nargin < 2
    S = define_sets();
end
nu = numel(S.users);
names = {'p', 'q', 'n', 'phi', 'e', 'd'};
if ~isstruct(R) || ~isscalar(R)
    error('check_rsa_users:fields', 'R must be the struct of define_rsa_users.');
end
if ~isfield(R, 'users') || ~iscell(R.users) || numel(R.users) ~= nu
    error('check_rsa_users:fields', 'R.users must be a list with the %d names of the users.', nu);
end
for k = 1:numel(names)
    if ~isfield(R, names{k})
        error('check_rsa_users:fields', 'R has no field %s.', names{k});
    end
    v = R.(names{k});
    if ~isnumeric(v) || ~isreal(v) || size(v, 1) ~= 1 || size(v, 2) ~= nu
        error('check_rsa_users:fields', 'R.%s must be one row with one number for each of the %d users.', names{k}, nu);
    end
end
for i = 1:nu
    nm = S.users{i};
    try
        check_rsa_setup(R.p(i), R.q(i), R.e(i));
    catch err
        error('check_rsa_users:key', 'The key of %s is not proper: %s', nm, err.message);
    end
    if R.n(i) ~= R.p(i) * R.q(i) || R.phi(i) ~= (R.p(i) - 1) * (R.q(i) - 1)
        error('check_rsa_users:key', 'The key of %s is not proper: n or phi does not fit p and q.', nm);
    end
    if ~is_whole_number(R.d(i)) || R.d(i) < 1 || R.d(i) > R.phi(i) - 1 || mod(R.e(i) * R.d(i), R.phi(i)) ~= 1
        error('check_rsa_users:key', 'The key of %s is not proper: e*d is not 1 mod phi.', nm);
    end
end
if numel(unique(R.n)) ~= nu
    error('check_rsa_users:same', 'Two users have the same modulus n. Every user must have a different n.');
end
end
