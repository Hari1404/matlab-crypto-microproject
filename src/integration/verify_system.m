function V = verify_system(Y)
% VERIFY_SYSTEM Check the shared keys, the decryption and the graph of the system Y, each with a second method.
%   V = verify_system() uses define_system. V = verify_system(Y) uses the system Y.
%   V is a cell array with one row for each check: {group, label, cases, ok}.
%   group is 1 (the shared key), 2 (encryption and decryption) or 3 (the graph).
%   cases is how many cases were tried. ok is true when all of them agree.
%   Y.A is the network in use, so a network with a broken channel can be checked too.
%   The second methods use only plain arithmetic: repeated multiplication instead of mod_pow, the formula k*m mod p
%   instead of encrypt_symbols, matrix products instead of breadth-first search, and removing a channel or a user
%   and counting the groups instead of bridge_channels and cut_users.
if nargin < 1
    Y = define_system();
end
check_system(Y);
S = Y.S;
p = S.prime;
g = S.generator;
n = Y.n;
sec = Y.D.private;
pub = Y.D.public;
A = logical(Y.A);
V = cell(0, 4);
pairs = zeros(0, 2);
for j = 2:n
    for i = 1:(j - 1)
        pairs(end + 1, :) = [i j];
    end
end
np = size(pairs, 1);
npr = n * (n - 1);
[reach, k0] = reach_by_matrix(A);
txt = char(32:126);
sym = double(txt) - 31;

% ---- group 1: the shared key ----
same = true;
plain = true;
inset = true;
tbl = isequal(Y.K, Y.K') && all(diag(Y.K) == 0);
eve = true;
for q = 1:np
    i = pairs(q, 1);
    j = pairs(q, 2);
    ki = dh_shared_key(sec(i), pub(j), p);
    kj = dh_shared_key(sec(j), pub(i), p);
    same = same && (ki == kj);
    v = 1;
    for t = 1:(sec(i) * sec(j))
        v = mod(v * g, p);
    end
    plain = plain && (v == ki);
    inset = inset && ismember(ki, S.keys);
    tbl = tbl && (Y.K(i, j) == ki) && (Y.K(j, i) == ki);
    E = eavesdrop_dh(pub(i), pub(j), p, g);
    eve = eve && (E.key == ki);
end
chk = true;
for e = 1:Y.G.m
    chk = chk && (Y.edge_keys(e) == dh_shared_key(sec(Y.G.edges(e, 1)), pub(Y.G.edges(e, 2)), p));
end
V(end + 1, :) = {1, 'both users of a pair compute the same key', np, same};
V(end + 1, :) = {1, sprintf('the key is g^(a*b) mod %d, worked out by plain repeated multiplication', p), np, plain};
V(end + 1, :) = {1, sprintf('the key is a key of the cipher (a number from 1 to %d)', p - 1), np, inset};
V(end + 1, :) = {1, 'the table of keys is symmetric, has 0 on the diagonal and holds these keys', np, tbl};
V(end + 1, :) = {1, 'every channel has the key of its two users', Y.G.m, chk};
V(end + 1, :) = {1, 'an eavesdropper who tries every secret number finds the same key', np, eve};

% ---- group 2: encryption and decryption (the text has all 95 characters) ----
okmsg = true;
for i = 1:n
    for j = 1:n
        if i ~= j
            M = send_message(txt, i, j, Y.D, S);
            okmsg = okmsg && M.ok && strcmp(M.received, txt);
        end
    end
end
byhand = true;
wrong = true;
for q = 1:np
    kk = Y.K(pairs(q, 1), pairs(q, 2));
    c = mod(kk * sym, p);
    jinv = 0;
    for t = 1:(p - 1)
        if jinv == 0 && mod(kk * t, p) == 1
            jinv = t;
        end
    end
    byhand = byhand && isequal(c, encrypt_text(txt, kk, S)) && isequal(mod(jinv * c, p), sym) && strcmp(decrypt_text(c, kk, S), txt);
    for k2 = 1:(p - 1)
        if k2 ~= kk
            rec = '';
            try
                rec = decrypt_text(c, k2, S);
            catch
                rec = '';
            end
            wrong = wrong && ~strcmp(rec, txt);
        end
    end
end
rt = true;
hk = true;
cv = true;
for i = 1:n
    for j = 1:n
        if i ~= j
            Rq = route_message(txt, i, j, Y);
            rt = rt && (Rq.delivered == reach(i, j));
            if Rq.delivered
                rt = rt && strcmp(Rq.received, txt) && all(strcmp(Rq.texts, txt)) && (numel(Rq.texts) == Rq.hops);
                for h = 1:Rq.hops
                    hk = hk && (Rq.keys(h) == dh_shared_key(sec(Rq.path(h)), pub(Rq.path(h + 1)), p));
                    cv = cv && all(Rq.ciphers{h} >= 1 & Rq.ciphers{h} <= p - 1);
                end
            end
        end
    end
end
V(end + 1, :) = {2, 'a text with all 95 characters arrives the same for every sender and receiver', npr, okmsg};
V(end + 1, :) = {2, 'encryption k*m mod p and decryption j*c mod p worked out by hand (j by trial)', np, byhand};
V(end + 1, :) = {2, 'every key but the right one fails to give the text back', np * (p - 2), wrong};
V(end + 1, :) = {2, 'a message arrives with the same text exactly when there is a route', npr, rt};
V(end + 1, :) = {2, 'every hop of a route uses the key of its channel', npr, hk};
V(end + 1, :) = {2, sprintf('the numbers that cross a channel are values of the ciphertext set (1 to %d)', p - 1), npr, cv};

% ---- group 3: the graph ----
D = distance_matrix(A);
sh = true;
for s = 1:n
    for t = 1:n
        if s ~= t
            [path, len] = shortest_path(A, s, t);
            if reach(s, t)
                sh = sh && (path(1) == s) && (path(end) == t) && (numel(path) - 1 == len) && (len == D(s, t));
                for h = 1:(numel(path) - 1)
                    sh = sh && A(path(h), path(h + 1));
                end
            else
                sh = sh && isempty(path) && isinf(len);
            end
        end
    end
end
P = eye(n);
Dp = inf(n);
Dp(logical(eye(n))) = 0;
for t = 1:(n - 1)
    P = P * double(A);
    fresh = (P > 0) & isinf(Dp);
    Dp(fresh) = t;
end
[comp, kc] = connected_components(A);
agree = true;
for u = 1:n
    for v = 1:n
        agree = agree && ((comp(u) == comp(v)) == reach(u, v));
    end
end
[ii, jj] = find(triu(A, 1));
Eg = sortrows([ii jj]);
if isempty(Eg)
    Eg = zeros(0, 2);
end
m = size(Eg, 1);
mybr = zeros(0, 2);
for e = 1:m
    B = A;
    B(Eg(e, 1), Eg(e, 2)) = false;
    B(Eg(e, 2), Eg(e, 1)) = false;
    [rb, kb] = reach_by_matrix(B);
    if kb > k0
        mybr(end + 1, :) = Eg(e, :);
    end
end
br = bridge_channels(A);
mycut = zeros(1, 0);
for v = 1:n
    keep = [1:(v - 1), (v + 1):n];
    [rb, kb] = reach_by_matrix(A(keep, keep));
    if kb > k0
        mycut(end + 1) = v;
    end
end
cu = cut_users(A);
V(end + 1, :) = {3, 'the adjacency matrix is symmetric and has no loops', n * n, isequal(A, A') && ~any(diag(A))};
V(end + 1, :) = {3, 'the degrees add up to twice the number of channels (handshake rule)', n, sum(sum(A)) == 2 * m && size(adjacency_to_edges(A), 1) == m};
V(end + 1, :) = {3, 'the adjacency list gives back the same adjacency matrix', n, isequal(list_to_adjacency(adjacency_to_list(A)), A)};
V(end + 1, :) = {3, 'distance_matrix is finite exactly where the matrix products show a path', n * n, isequal(isfinite(D), reach)};
V(end + 1, :) = {3, 'every distance is the smallest power k of the matrix with a path of k channels', n * n, isequal(Dp, D)};
V(end + 1, :) = {3, 'every shortest path uses only channels and has the length of the distance', npr, sh};
V(end + 1, :) = {3, 'the groups of users are the same as the groups found with matrix products', n, (kc == k0) && agree};
V(end + 1, :) = {3, 'a channel is a bridge exactly when removing it makes more groups', m, (size(mybr, 1) == size(br, 1)) && all(all(mybr == br))};
V(end + 1, :) = {3, 'a user is a cut user exactly when removing him makes more groups', n, isequal(mycut(:)', cu(:)')};
end
