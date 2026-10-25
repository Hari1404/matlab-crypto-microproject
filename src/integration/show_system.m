function show_system(Y)
% SHOW_SYSTEM Print the secure network: the key of each channel, messages along paths, every pair of users and a broken channel.
%   show_system()   uses define_system.
%   show_system(Y)  uses the system Y. It must be the full connected network (Y.A equal to Y.G.adj, at least one channel).
if nargin < 1
    Y = define_system();
end
check_system(Y);
if ~isequal(logical(Y.A), logical(Y.G.adj)) || Y.G.m < 1
    error('show_system:network', 'show_system needs the full network (Y.A equal to Y.G.adj, with at least one channel).');
end
if ~is_connected(Y.A)
    error('show_system:connected', 'show_system needs a connected network.');
end
answer = {'NO', 'yes'};
p = Y.S.prime;
n = Y.n;
names = Y.users;
E = Y.G.edges;
txt1 = 'Hello Bob, are you free at 5 pm?';
txt2 = 'Hello Grace, the meeting is at 5 pm.';
txt3 = 'See you at 5 pm.';
R2 = route_message(txt1, 1, 2, Y);
R3 = route_message(txt2, 1, 6, Y);
D = distance_matrix(Y.A);

% every pair of users, with the network as it is
allpairs = true;
maxhop = 0;
cnt = zeros(1, n);
sametext = true;
distok = true;
for a = 1:n
    for b = 1:n
        if a ~= b
            Rq = route_message(txt3, a, b, Y);
            allpairs = allpairs && Rq.delivered;
            sametext = sametext && all(strcmp(Rq.texts, txt3));
            distok = distok && (Rq.hops == D(a, b));
            if Rq.delivered
                cnt(Rq.hops) = cnt(Rq.hops) + 1;
                maxhop = max(maxhop, Rq.hops);
            end
        end
    end
end

fprintf('\n=== THE SECURE NETWORK ===\n');
fprintf('The network of Point 2 and the keys of Point 4 work together. Every channel is a Diffie-Hellman exchange between its two users, so every channel has its own key k, and the cipher E_k(m) = k*m mod %d protects what crosses it.\n', p);

% 1. the key of each channel
w = 0;
for e = 1:Y.G.m
    w = max(w, numel(names{E(e, 1)}) + 3 + numel(names{E(e, 2)}));
end
w = w + 4;
fprintf('\n1. The key of each channel\n');
fprintf(['  %-9s%-' num2str(w) 's%-16s%s\n'], 'Channel', 'Users', 'Public values', 'Key');
for e = 1:Y.G.m
    u = [names{E(e, 1)} ' - ' names{E(e, 2)}];
    pv = sprintf('%d and %d', Y.D.public(E(e, 1)), Y.D.public(E(e, 2)));
    fprintf(['  %-9s%-' num2str(w) 's%-16s%d\n'], sprintf('e%d', e), u, pv, Y.edge_keys(e));
end
nop = [];
for b = 2:n
    for a = 1:(b - 1)
        if isempty(nop) && ~Y.A(a, b)
            nop = [a b];
        end
    end
end
if isempty(nop)
    fprintf('  Every two users have a channel.\n');
else
    fprintf('  %s and %s have no channel, so a message from one to the other needs other users on the way (see 3 and 4).\n', names{nop(1)}, names{nop(2)});
end

% 2. one message on one channel
fprintf('\n2. One message on one channel\n');
fprintf('  %s sends to %s: %s\n', R2.from, R2.to, txt1);
fprintf('  The route is %s (%d channel%s). The key of the channel is %d.\n', format_names(names, R2.path, ' - '), R2.hops, plural_s(R2.hops), R2.keys(1));
fprintf('  The %d numbers that cross the channel:\n', numel(R2.ciphers{1}));
fprintf('%s\n', format_numbers(R2.ciphers{1}, 12));
fprintf('  %s decrypts them with the key %d and gets: %s\n', R2.to, R2.keys(1), R2.received);
fprintf('  It is the same as the message: %s\n', answer{double(R2.delivered) + 1});

% 3. one message along a path
fprintf('\n3. One message along a path\n');
fprintf('  %s sends to %s: %s\n', R3.from, R3.to, txt2);
fprintf('  The shortest route is %s (%d channel%s).\n', format_names(names, R3.path, ' - '), R3.hops, plural_s(R3.hops));
fprintf('  Hop   From      To        Key   The first numbers that cross the channel\n');
for h = 1:R3.hops
    c = R3.ciphers{h};
    fprintf('  %-6d%-10s%-10s%-6d%s ...\n', h, names{R3.path(h)}, names{R3.path(h + 1)}, R3.keys(h), strtrim(sprintf('%d ', c(1:min(6, numel(c))))));
end
fprintf('  Every user on the route decrypts what he gets with the key of the channel it came on and encrypts it again with the key of the next channel.\n');
fprintf('  The users who can read the message: %s.\n', format_names(names, R3.readers));
others = setdiff(1:n, R3.readers);
if numel(others) == 1
    fprintf('  %s is not on the route and cannot read it.\n', names{others});
elseif numel(others) > 1
    fprintf('  %s are not on the route and cannot read it.\n', format_names(names, others));
end
if ~isempty(R3.relays)
    fprintf('  The users in the middle (%s) see the text, because every channel has its own key. The encryption protects each channel, but not the whole route.\n', format_names(names, R3.relays));
end
fprintf('  %s gets: %s\n', R3.to, R3.received);
fprintf('  It is the same as the message: %s\n', answer{double(R3.delivered) + 1});

% 4. every pair of users
fprintf('\n4. Every pair of users\n');
fprintf('  The same message goes from every user to every other user, %d messages in all.\n', n * (n - 1));
fprintf('  Channels    Messages  All arrive\n');
for h = 1:maxhop
    fprintf('  %-12s%-10s%s\n', num2str(h), num2str(cnt(h)), 'yes');
end
fprintf('  Every message arrives with the same text: %s.\n', answer{double(allpairs && sametext) + 1});

% 5. a channel breaks
fprintf('\n5. When a channel breaks\n');
B = bridge_channels(Y.A);
if isempty(B)
    r = E(1, :);
    fprintf('  The network has no bridge channel, so it stays in one piece when a channel breaks.\n');
    fprintf('  The channel %s - %s is removed.\n', names{r(1)}, names{r(2)});
else
    r = B(1, :);
    fprintf('  The channel %s - %s is removed (it is the first bridge channel, so the network falls apart).\n', names{r(1)}, names{r(2)});
end
Y2 = Y;
Y2.A = remove_channel(Y.A, r(1), r(2));
[comp, k] = connected_components(Y2.A);
fprintf('  The network now has %d group%s: %s\n', k, plural_s(k), format_groups(names, comp));
R5 = route_message(txt3, 1, 6, Y2);
if R5.reachable
    fprintf('  %s sends the message to %s again. It still arrives, along the route %s (%d channel%s).\n', R5.from, R5.to, format_names(names, R5.path, ' - '), R5.hops, plural_s(R5.hops));
else
    fprintf('  %s sends the message to %s again. There is no route, so the message cannot be sent.\n', R5.from, R5.to);
end
arrive = 0;
rightpairs = true;
for a = 1:n
    for b = 1:n
        if a ~= b
            Rq = route_message(txt3, a, b, Y2);
            arrive = arrive + double(Rq.delivered);
            rightpairs = rightpairs && (Rq.delivered == (comp(a) == comp(b)));
        end
    end
end
fprintf('  Messages that still arrive: %d of %d.\n', arrive, n * (n - 1));

% checks
tbl = true;
inset = true;
for e = 1:Y.G.m
    a = E(e, 1);
    b = E(e, 2);
    tbl = tbl && Y.edge_keys(e) == dh_shared_key(Y.D.private(a), Y.D.public(b), p) && Y.edge_keys(e) == dh_shared_key(Y.D.private(b), Y.D.public(a), p);
    inset = inset && ismember(Y.edge_keys(e), Y.S.keys);
end
checks = {
    'every channel has the Diffie-Hellman key of its two users (the table of keys)', tbl;
    'every channel key is a key of the cipher (a number from 1 to p-1)', inset;
    'a message on one channel arrives with the same text', R2.delivered && strcmp(R2.received, txt1) && R2.hops == 1;
    sprintf('the route %s to %s is the shortest path of Point 2 and the message arrives', R3.from, R3.to), isequal(R3.path, shortest_path(Y.A, 1, 6)) && R3.delivered;
    'every user on the route has the same text after his hop', all(strcmp(R3.texts, txt2)) && numel(R3.texts) == R3.hops;
    'every message arrives, and the number of channels on its route is the distance of Point 2', allpairs && distok;
    'after the channel is removed, exactly the pairs in the same group can still send', rightpairs};
wl = max(cellfun(@numel, checks(:, 1)));
fprintf('\nChecks:\n');
for q = 1:size(checks, 1)
    fprintf(['  %-' num2str(wl) 's: %s\n'], checks{q, 1}, answer{double(checks{q, 2}) + 1});
end
end
