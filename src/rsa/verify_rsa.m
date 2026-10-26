function V = verify_rsa(R, S)
% VERIFY_RSA Check the RSA keys, the encryption and the eavesdropper of the users, each with a second method.
%   V = verify_rsa() uses define_sets and define_rsa_users.
%   V = verify_rsa(R, S) uses the RSA keys R (the struct of define_rsa_users) and the sets S.
%   V is a cell array with one row for each of the 15 checks: {group, label, cases, ok}.
%   group is 1 (the RSA keys), 2 (encryption and decryption) or 3 (key transport and the eavesdropper).
%   cases is how many cases were tried. ok is true when all of them agree.
%   The second methods use only plain arithmetic: trial division instead of is_prime_number, trying every number
%   instead of mod_inverse, repeated multiplication instead of mod_pow, counting instead of the formula for phi.
%   R is not checked with check_rsa_users, so keys that are wrong (for example a wrong d) are found by the checks.
%   The errors are verify_rsa:sets, verify_rsa:fields (R is not a struct with one row of numbers for each user) and
%   verify_rsa:size (p, q, n, phi, e or d is not a whole number from 1 to 10000, p or q is smaller than 2, or n is smaller
%   than 97: the checks multiply step by step, so they need small numbers).
if nargin < 2
    S = define_sets();
end
if nargin < 1
    R = define_rsa_users(S);
end
if ~isstruct(S) || ~isscalar(S) || ~isfield(S, 'users') || ~iscell(S.users)
    error('verify_rsa:sets', 'S must be the struct of define_sets, with a list of users.');
end
nu = numel(S.users);
names = {'p', 'q', 'n', 'phi', 'e', 'd'};
if ~isstruct(R) || ~isscalar(R)
    error('verify_rsa:fields', 'R must be the struct of define_rsa_users.');
end
for k = 1:numel(names)
    if ~isfield(R, names{k})
        error('verify_rsa:fields', 'R has no field %s.', names{k});
    end
    v = R.(names{k});
    if ~isnumeric(v) || ~isreal(v) || size(v, 1) ~= 1 || size(v, 2) ~= nu
        error('verify_rsa:fields', 'R.%s must be one row with one number for each of the %d users.', names{k}, nu);
    end
    if any(~isfinite(v)) || any(v ~= round(v)) || any(v < 1) || any(v > 10000)
        error('verify_rsa:size', 'R.%s must hold whole numbers from 1 to 10000.', names{k});
    end
end
if any(R.p < 2) || any(R.q < 2) || any(R.n < 97)
    error('verify_rsa:size', 'p and q must be at least 2 and n at least 97.');
end
txt = char(32:126);
sym = 1:95;
npr = nu * (nu - 1);
ok11 = (numel(unique(R.n)) == nu);
ok12 = true;
ok13 = true;
ok14 = true;
ok21 = true;
ok22 = true;
ok23 = true;
ok24 = true;
ok25 = true;
cases14 = 0;
cases23 = 0;
cases24 = 0;
cip = cell(1, nu);
kc = cell(1, nu);
ok31 = true;
ok33 = true;
ok34 = true;
for i = 1:nu
    p = R.p(i);
    q = R.q(i);
    n = R.n(i);
    phi = R.phi(i);
    e = R.e(i);
    d = R.d(i);
    % ---- group 1: the keys ----
    ok11 = ok11 && is_prime_by_hand(p) && is_prime_by_hand(q) && (p ~= q) && (n == p * q) && (phi == (p - 1) * (q - 1));
    dt = 0;
    for t = 1:(phi - 1)
        if dt == 0 && mod(e * t, phi) == 1
            dt = t;
        end
    end
    ok12 = ok12 && (dt == d);
    a = 1:(n - 1);
    cop = a(gcd(a, n) == 1);
    ok13 = ok13 && (numel(cop) == phi);
    m = 0:(n - 1);
    c = powmat(m, e, n);
    lam = (p - 1) * (q - 1) / gcd(p - 1, q - 1);
    v = ones(1, n);
    works = false(1, phi - 1);
    for t = 1:(phi - 1)
        v = mod(v .* c, n);
        works(t) = isequal(v, m);
    end
    pred = (mod(e * (1:(phi - 1)) - 1, lam) == 0);
    ok14 = ok14 && isequal(works, pred) && (d <= phi - 1) && works(d);
    cases14 = cases14 + (phi - 1);
    % ---- group 2: encryption and decryption ----
    m2 = powmat(c, d, n);
    for s = sym
        ok21 = ok21 && (try_num(@() rsa_encrypt_number(s, n, e)) == c(s + 1));
        ok22 = ok22 && (try_num(@() rsa_decrypt_number(c(s + 1), n, d)) == m2(s + 1)) && (m2(s + 1) == s);
    end
    ok23 = ok23 && isequal(m2, m);
    cases23 = cases23 + n;
    w = ones(size(cop));
    for t = 1:phi
        w = mod(w .* cop, n);
    end
    ok24 = ok24 && all(w == 1);
    cases24 = cases24 + numel(cop);
    cip{i} = c(sym + 1);
    cc = [];
    dtxt = '';
    try
        cc = rsa_encrypt_text(txt, n, e);
        dtxt = rsa_decrypt_text(cc, n, d);
    catch
        dtxt = '';
    end
    ok25 = ok25 && isequal(cc, cip{i}) && strcmp(dtxt, txt);
    % ---- group 3: key transport and the eavesdropper (keys and Eve) ----
    kk = 1:96;
    kc{i} = powmat(kk, e, n);
    ok31 = ok31 && isequal(powmat(kc{i}, d, n), kk);
    t = 2;
    while mod(n, t) ~= 0
        t = t + 1;
    end
    good = false;
    try
        E = eavesdrop_rsa(n, e);
        good = (E.p == t) && (E.q == n / t) && (E.d == dt) && (E.d == d) && (E.tries == t - 1);
    catch
        good = false;
    end
    ok33 = ok33 && good;
    good = false;
    try
        A = eavesdrop_codebook(cip{i}, n, e);
        good = A.all_found && strcmp(A.text, txt) && isequal(A.book, powmat(kk, e, n)) && (A.tries == 96);
    catch
        good = false;
    end
    ok34 = ok34 && good;
end
% ---- pairs of users: messages, other exponents, key transport ----
ok26 = true;
ok27 = true;
ok32 = true;
for i = 1:nu
    for j = 1:nu
        if i ~= j
            good = false;
            try
                M = rsa_send_message(txt, i, j, R, S);
                good = M.ok && strcmp(M.received, txt) && isequal(M.cipher, cip{j}) && (M.n == R.n(j)) && (M.e == R.e(j));
            catch
                good = false;
            end
            ok26 = ok26 && good;
            back = powmat(cip{j}, R.d(i), R.n(j));
            rec = '';
            try
                rec = rsa_decrypt_text(cip{j}, R.n(j), R.d(i));
            catch
                rec = '';
            end
            ok27 = ok27 && (strcmp(rec, txt) == isequal(back, sym));
            good = false;
            try
                T = rsa_key_transport(txt, 85, i, j, R, S);
                good = T.agree && T.ok && (T.key_received == 85) && (T.key_cipher == kc{j}(85)) && (T.n == R.n(j)) && (T.e == R.e(j));
            catch
                good = false;
            end
            ok32 = ok32 && good;
        end
    end
end
V = cell(0, 4);
V(end + 1, :) = {1, 'p and q are primes (trial division), n = p*q, phi = (p-1)*(q-1), all n are different', nu, ok11};
V(end + 1, :) = {1, 'd is the inverse of e mod phi, found by trying every number', nu, ok12};
V(end + 1, :) = {1, 'phi is how many numbers from 1 to n-1 have no common divisor with n (counted)', nu, ok13};
V(end + 1, :) = {1, 'd works for all numbers 0 to n-1 exactly when e*d = 1 mod lcm(p-1, q-1) (every d tried)', cases14, ok14};
V(end + 1, :) = {2, 'm^e mod n by repeated multiplication is rsa_encrypt_number (symbols 1 to 95)', nu * 95, ok21};
V(end + 1, :) = {2, 'c^d mod n by repeated multiplication is rsa_decrypt_number and gives the symbol back', nu * 95, ok22};
V(end + 1, :) = {2, 'every number from 0 to n-1 comes back after encrypting and decrypting', cases23, ok23};
V(end + 1, :) = {2, 'Euler: a^phi = 1 mod n for every a with no common divisor with n (why RSA works)', cases24, ok24};
V(end + 1, :) = {2, 'a text with all 95 characters: the cipher is the one by hand and the text comes back', nu, ok25};
V(end + 1, :) = {2, 'a message from every user to every other one arrives, with the cipher worked out by hand', npr, ok26};
V(end + 1, :) = {2, 'the d of another user gives the text back exactly when plain multiplication does', npr, ok27};
V(end + 1, :) = {3, 'a key of the cipher (1 to 96) sent with RSA arrives the same (repeated multiplication)', npr * 96, ok31};
V(end + 1, :) = {3, 'rsa_key_transport for every pair: the key and the text arrive, the key cipher is the one by hand', npr, ok32};
V(end + 1, :) = {3, 'Eve finds the primes by trying divisors one by one, and the same private exponent', nu, ok33};
V(end + 1, :) = {3, 'Eve reads the text with a list of all small numbers made by repeated multiplication', nu, ok34};
end

function v = powmat(b, ex, n)
% b^ex mod n for every number of b, by repeated multiplication (plain, no mod_pow).
v = ones(size(b));
for t = 1:ex
    v = mod(v .* b, n);
end
end

function r = try_num(f)
% The number that f() gives, or -1 when f stops with an error.
r = -1;
try
    r = f();
catch
    r = -1;
end
end

function flag = is_prime_by_hand(x)
% True when x is a prime: no divisor from 2 to the square root (plain trial division).
flag = (x >= 2) && all(mod(x, 2:floor(sqrt(x))) ~= 0);
end
