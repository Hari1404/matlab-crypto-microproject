function R = define_rsa_users(S)
% DEFINE_RSA_USERS Give every user an RSA key pair and return the keys in a struct.
%   R = define_rsa_users()   uses define_sets.
%   R = define_rsa_users(S)  uses the sets S (there must be 6 users).
%   R has the fields (one number for each user, in the order of S.users)
%   R.users   the names of the users
%   R.p, R.q  the two primes of the user (secret)
%   R.n       the modulus p*q (public)
%   R.phi     (p-1)*(q-1) (secret)
%   R.e       the public exponent (public)
%   R.d       the private exponent, e*d = 1 (mod phi) (secret)
%   The primes and the exponents are set here and can be changed: Alice 61*53 with e = 17, Bob 47*59 with e = 17,
%   Carol 43*67 with e = 5, Dave 71*37 with e = 11, Frank 79*31 with e = 7 and Grace 73*41 with e = 7.
%   The keys are made with rsa_make_keys and the whole struct is checked with check_rsa_users (every user needs a different n).
if nargin < 1
    S = define_sets();
end
if ~isstruct(S) || ~isfield(S, 'users') || ~iscell(S.users)
    error('define_rsa_users:sets', 'S must be the struct of define_sets, with a list of users.');
end
nu = numel(S.users);
if nu ~= 6
    error('define_rsa_users:count', 'There must be 6 users, but there are %d.', nu);
end
p = [61 47 43 71 79 73];
q = [53 59 67 37 31 41];
e = [17 17 5 11 7 7];
R.users = S.users;
R.p = zeros(1, nu);
R.q = zeros(1, nu);
R.n = zeros(1, nu);
R.phi = zeros(1, nu);
R.e = zeros(1, nu);
R.d = zeros(1, nu);
for i = 1:nu
    K = rsa_make_keys(p(i), q(i), e(i));
    R.p(i) = K.p;
    R.q(i) = K.q;
    R.n(i) = K.n;
    R.phi(i) = K.phi;
    R.e(i) = K.e;
    R.d(i) = K.d;
end
check_rsa_users(R, S);
end
