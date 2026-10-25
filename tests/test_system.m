function test_system()
% TEST_SYSTEM Checks for define_system, check_system, channel_key, route_message, show_system and demo_point5.
S = define_sets();
p = S.prime;
Y = define_system();
n = Y.n;
c = cell(0, 2);
nl = char(10);

% --- define_system ---
c(end+1, :) = {'define_system has the fields S, users, n, G, D, K, A and edge_keys', all(isfield(Y, {'S', 'users', 'n', 'G', 'D', 'K', 'A', 'edge_keys'}))};
c(end+1, :) = {'define_system: 6 users, the same names as define_sets', Y.n == 6 && isequal(Y.users, S.users)};
c(end+1, :) = {'define_system: the key table is symmetric with zeros on the diagonal', isequal(Y.K, Y.K') && all(diag(Y.K) == 0)};
c(end+1, :) = {'define_system: edge_keys are 85 12 42 90 32 72', isequal(Y.edge_keys, [85 12 42 90 32 72])};
c(end+1, :) = {'define_system: Y.A equals Y.G.adj', isequal(Y.A, Y.G.adj)};
S2 = S;
S2.prime = 101;
S2.generator = 2;
S2.cipher = 1:100;
S2.keys = 1:100;
Y2 = define_system(S2);
c(end+1, :) = {'define_system(S) with p = 101 and g = 2 works', Y2.n == 6 && Y2.S.prime == 101 && numel(Y2.edge_keys) == 6 && all(Y2.edge_keys >= 1 & Y2.edge_keys <= 100)};
Sbad = S;
Sbad.generator = 1;
c(end+1, :) = {'define_system refuses a g that is not a generator', raises_error(@() define_system(Sbad))};

% --- check_system ---
Yr = Y;
Yr.A = remove_channel(Y.A, 4, 5);
c(end+1, :) = {'check_system accepts Y and a Y with a removed channel', ~raises_error(@() check_system(Y)) && ~raises_error(@() check_system(Yr))};
c(end+1, :) = {'check_system refuses a Y that is not a struct', raises_error(@() check_system(5)) && raises_error(@() check_system('Y'))};
Yb = rmfield(Y, 'edge_keys');
c(end+1, :) = {'check_system refuses a missing field', raises_error(@() check_system(Yb))};
Yb = Y;
Yb.A = Y.A(1:5, 1:5);
c(end+1, :) = {'check_system refuses a wrong size of A', raises_error(@() check_system(Yb))};
Yb = Y;
Yb.A(1, 2) = false;
c(end+1, :) = {'check_system refuses a non-symmetric A', raises_error(@() check_system(Yb))};
Yb = Y;
Yb.A(2, 2) = true;
c(end+1, :) = {'check_system refuses a loop', raises_error(@() check_system(Yb))};
Yb = Y;
Yb.A(1, 6) = true;
Yb.A(6, 1) = true;
c(end+1, :) = {'check_system refuses a channel that is not in Y.G', raises_error(@() check_system(Yb))};
Yb = Y;
Yb.A = double(Y.A);
Yb.A(1, 2) = 2;
Yb.A(2, 1) = 2;
c(end+1, :) = {'check_system refuses a value that is not 0 or 1', raises_error(@() check_system(Yb))};
Yb = Y;
Yb.edge_keys = Y.edge_keys(1:5);
Yc = Y;
Yc.edge_keys = [Y.edge_keys 7];
c(end+1, :) = {'check_system refuses a wrong number of edge_keys', raises_error(@() check_system(Yb)) && raises_error(@() check_system(Yc))};
Yb = Y;
Yb.edge_keys(3) = 43;
c(end+1, :) = {'check_system refuses an edge key that is not in the table of keys', raises_error(@() check_system(Yb))};

% --- channel_key ---
E = Y.G.edges;
ok = true;
for e = 1:6
    ok = ok && channel_key(Y, E(e, 1), E(e, 2)) == Y.edge_keys(e) && channel_key(Y, E(e, 2), E(e, 1)) == Y.edge_keys(e);
end
c(end+1, :) = {'channel_key of all 6 channels in both orders', ok};
c(end+1, :) = {'channel_key: Alice-Bob is 85 and Dave-Frank is 32', channel_key(Y, 1, 2) == 85 && channel_key(Y, 5, 4) == 32};
c(end+1, :) = {'channel_key refuses Bob and Carol (no channel)', raises_error(@() channel_key(Y, 2, 3))};
c(end+1, :) = {'channel_key refuses the same user', raises_error(@() channel_key(Y, 2, 2))};
c(end+1, :) = {'channel_key refuses 0 and 7', raises_error(@() channel_key(Y, 0, 2)) && raises_error(@() channel_key(Y, 1, 7))};
c(end+1, :) = {'channel_key refuses 2.5, a list and a text', raises_error(@() channel_key(Y, 2.5, 1)) && raises_error(@() channel_key(Y, [1 2], 3)) && raises_error(@() channel_key(Y, 'a', 1))};
c(end+1, :) = {'channel_key refuses a removed channel', raises_error(@() channel_key(Yr, 4, 5)) && raises_error(@() channel_key(Yr, 5, 4))};
c(end+1, :) = {'channel_key refuses a Y that is not a struct', raises_error(@() channel_key(3, 1, 2))};

% --- route_message ---
txt = 'See you at 5 pm.';
sym = text_to_symbols(txt);
D = distance_matrix(Y.A);
ok_deliv = true;
ok_hops = true;
ok_path = true;
ok_keys = true;
ok_ciph = true;
ok_text = true;
ok_read = true;
ok_who = true;
for a = 1:n
    for b = 1:n
        if a ~= b
            R = route_message(txt, a, b, Y);
            pth = shortest_path(Y.A, a, b);
            ok_deliv = ok_deliv && R.delivered && R.reachable && strcmp(R.received, txt);
            ok_hops = ok_hops && R.hops == D(a, b);
            ok_path = ok_path && isequal(R.path, pth);
            kk = zeros(1, 0);
            for h = 1:(numel(pth) - 1)
                kk(h) = channel_key(Y, pth(h), pth(h + 1));
            end
            ok_keys = ok_keys && isequal(R.keys, kk);
            cc = true;
            for h = 1:numel(kk)
                cc = cc && isequal(R.ciphers{h}, mod(kk(h) * sym, p));
            end
            ok_ciph = ok_ciph && cc && numel(R.ciphers) == numel(kk);
            ok_text = ok_text && numel(R.texts) == numel(kk) && all(strcmp(R.texts, txt));
            ok_read = ok_read && isequal(R.relays, pth(2:end-1)) && isequal(R.readers, pth);
            ok_who = ok_who && strcmp(R.from, Y.users{a}) && strcmp(R.to, Y.users{b}) && R.i == a && R.j == b && strcmp(R.text, txt);
        end
    end
end
c(end+1, :) = {'route_message: all 30 pairs are delivered with the same text', ok_deliv};
c(end+1, :) = {'route_message: hops equal distance_matrix for all 30 pairs', ok_hops};
c(end+1, :) = {'route_message: path equals shortest_path for all 30 pairs', ok_path};
c(end+1, :) = {'route_message: keys equal channel_key of each hop', ok_keys};
c(end+1, :) = {'route_message: ciphers equal mod(key * symbols, p) on every hop', ok_ciph};
c(end+1, :) = {'route_message: the text after every hop is the text', ok_text};
c(end+1, :) = {'route_message: relays and readers are right', ok_read};
c(end+1, :) = {'route_message: names, numbers and text are filled in', ok_who};
R = route_message('Hello Grace, the meeting is at 5 pm.', 1, 6, Y);
c(end+1, :) = {'Alice to Grace: route Alice Bob Dave Frank Grace, 4 channels', isequal(R.path, [1 2 4 5 6]) && R.hops == 4};
c(end+1, :) = {'Alice to Grace: keys 85 42 32 72', isequal(R.keys, [85 42 32 72])};
c(end+1, :) = {'Alice to Grace: readers are the route, relays are Bob, Dave, Frank, Carol is not a reader', isequal(R.readers, [1 2 4 5 6]) && isequal(R.relays, [2 4 5]) && ~ismember(3, R.readers)};
c(end+1, :) = {'Alice to Grace: hop 1 starts 90 33 46 46 10 85', isequal(R.ciphers{1}(1:6), [90 33 46 46 10 85])};
c(end+1, :) = {'Alice to Grace: delivered', R.delivered && strcmp(R.received, 'Hello Grace, the meeting is at 5 pm.')};
R = route_message('Hello', 1, 2, Y);
c(end+1, :) = {'Alice to Bob: Hello gives 90 33 46 46 10 on one hop', R.hops == 1 && isequal(R.ciphers{1}, [90 33 46 46 10]) && R.delivered};

% unreachable
Yu = Y;
Yu.A = remove_channel(Y.A, 5, 4);
Ru = route_message(txt, 1, 6, Yu);
c(end+1, :) = {'unreachable: reachable false, hops Inf, path empty', ~Ru.reachable && isinf(Ru.hops) && isempty(Ru.path)};
c(end+1, :) = {'unreachable: keys, ciphers, texts and relays are empty', isempty(Ru.keys) && isempty(Ru.ciphers) && isempty(Ru.texts) && isempty(Ru.relays)};
c(end+1, :) = {'unreachable: received empty, delivered false, readers is the sender', isempty(Ru.received) && ~Ru.delivered && isequal(Ru.readers, 1)};
ok = true;
arrive = 0;
for a = 1:n
    for b = 1:n
        if a ~= b
            Rq = route_message(txt, a, b, Yu);
            arrive = arrive + double(Rq.delivered);
        end
    end
end
c(end+1, :) = {'after removing Dave-Frank 14 of 30 messages arrive', arrive == 14};

% wrong secret number
Yw = Y;
Yw.D.private(4) = 42;
Rw = [];
try
    Rw = route_message(txt, 1, 6, Yw);
    noerr = true;
catch
    noerr = false;
end
c(end+1, :) = {'a wrong secret number makes a hop fail: delivered false and no error', noerr && ~Rw.delivered && isempty(Rw.received)};
Rw = route_message(txt, 1, 2, Yw);
c(end+1, :) = {'a wrong secret number of Dave does not hurt Alice to Bob', Rw.delivered};

% bad input
c(end+1, :) = {'route_message refuses sender and receiver 0 and 7', raises_error(@() route_message(txt, 0, 2, Y)) && raises_error(@() route_message(txt, 7, 2, Y)) && raises_error(@() route_message(txt, 1, 0, Y)) && raises_error(@() route_message(txt, 1, 7, Y))};
c(end+1, :) = {'route_message refuses 2.5 and the same user', raises_error(@() route_message(txt, 2.5, 2, Y)) && raises_error(@() route_message(txt, 1, 2.5, Y)) && raises_error(@() route_message(txt, 3, 3, Y))};
c(end+1, :) = {'route_message refuses an empty text and a number as text', raises_error(@() route_message('', 1, 2, Y)) && raises_error(@() route_message(5, 1, 2, Y))};
c(end+1, :) = {'route_message refuses a text with a tab and a text with two lines', raises_error(@() route_message(['a' char(9) 'b'], 1, 2, Y)) && raises_error(@() route_message(['ab'; 'cd'], 1, 2, Y))};
c(end+1, :) = {'route_message refuses a Y that is not a struct', raises_error(@() route_message(txt, 1, 2, 5))};
c(end+1, :) = {'route_message refuses a list as sender', raises_error(@() route_message(txt, [1 2], 3, Y))};

% --- show_system ---
out = evalc('show_system(Y)');
c(end+1, :) = {'show_system prints the title and the 5 parts', ~isempty(strfind(out, '=== THE SECURE NETWORK ===')) && ~isempty(strfind(out, '1. The key of each channel')) && ~isempty(strfind(out, '2. One message on one channel')) && ~isempty(strfind(out, '3. One message along a path')) && ~isempty(strfind(out, '4. Every pair of users')) && ~isempty(strfind(out, '5. When a channel breaks'))};
rows = {'e1       Alice - Bob      8 and 46        85', 'e2       Alice - Carol    8 and 82        12', 'e3       Bob - Dave       46 and 80       42', 'e4       Carol - Dave     82 and 80       90', 'e5       Dave - Frank     80 and 44       32', 'e6       Frank - Grace    44 and 23       72'};
ok = true;
for t = 1:6
    ok = ok && ~isempty(strfind(out, rows{t}));
end
c(end+1, :) = {'show_system prints the 6 channel rows', ok};
c(end+1, :) = {'show_system names Bob and Carol as the first pair without a channel', ~isempty(strfind(out, 'Bob and Carol have no channel'))};
c(end+1, :) = {'show_system prints the 4-channel route', ~isempty(strfind(out, 'The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).'))};
c(end+1, :) = {'show_system prints the hop rows', ~isempty(strfind(out, '1     Alice     Bob       85    90 33 46 46 10 85 ...')) && ~isempty(strfind(out, '4     Frank     Grace     72    42 93 15 15 37 72 ...'))};
c(end+1, :) = {'show_system says Carol cannot read it and the relays can', ~isempty(strfind(out, 'Carol is not on the route and cannot read it.')) && ~isempty(strfind(out, 'The users in the middle (Bob, Dave, Frank) see the text'))};
c(end+1, :) = {'show_system prints the table 12 10 6 4 as 12 10 6 2', ~isempty(strfind(out, '  1           12        yes')) && ~isempty(strfind(out, '  2           10        yes')) && ~isempty(strfind(out, '  3           6         yes')) && ~isempty(strfind(out, '  4           2         yes'))};
c(end+1, :) = {'show_system prints the removal of Dave - Frank and 14 of 30', ~isempty(strfind(out, 'The channel Dave - Frank is removed')) && ~isempty(strfind(out, '{Alice, Bob, Carol, Dave}  {Frank, Grace}')) && ~isempty(strfind(out, 'Messages that still arrive: 14 of 30.'))};
k = strfind(out, 'Checks:');
tail = out(k:end);
c(end+1, :) = {'show_system prints a Checks block of 7 lines with yes and no NO', numel(strfind(tail, ': yes')) == 7 && isempty(strfind(out, ': NO'))};
c(end+1, :) = {'show_system() gives the same text as show_system(Y)', strcmp(evalc('show_system()'), out)};
c(end+1, :) = {'show_system refuses a Y with a removed channel', raises_error(@() show_system(Yr))};
Yd = Y;
Yd.G.edges = [1 2; 3 4; 5 6];
Yd.G.m = 3;
Yd.G.adj = false(6, 6);
Yd.G.adj(1, 2) = true; Yd.G.adj(2, 1) = true;
Yd.G.adj(3, 4) = true; Yd.G.adj(4, 3) = true;
Yd.G.adj(5, 6) = true; Yd.G.adj(6, 5) = true;
Yd.A = Yd.G.adj;
Yd.edge_keys = [Y.K(1, 2) Y.K(3, 4) Y.K(5, 6)];
c(end+1, :) = {'show_system refuses a disconnected network', ~raises_error(@() check_system(Yd)) && raises_error(@() show_system(Yd))};
out2 = evalc('show_system(Y2)');
k2 = strfind(out2, 'Checks:');
c(end+1, :) = {'show_system works with p = 101 and all checks are yes', ~isempty(strfind(out2, 'mod 101')) && numel(strfind(out2(k2:end), ': yes')) == 7};

% the network without a bridge
Yn = Y;
Yn.G.edges = [1 2; 1 3; 1 6; 2 4; 3 4; 4 5; 5 6];
Yn.G.m = 7;
Yn.G.adj(1, 6) = true;
Yn.G.adj(6, 1) = true;
Yn.A = Yn.G.adj;
Yn.edge_keys = zeros(1, 7);
for e = 1:7
    Yn.edge_keys(e) = Yn.K(Yn.G.edges(e, 1), Yn.G.edges(e, 2));
end
out3 = evalc('show_system(Yn)');
k3 = strfind(out3, 'Checks:');
c(end+1, :) = {'no-bridge branch: the text says there is no bridge and removes Alice - Bob', ~isempty(strfind(out3, 'The network has no bridge channel')) && ~isempty(strfind(out3, 'The channel Alice - Bob is removed.'))};
c(end+1, :) = {'no-bridge branch: still 1 group, all checks yes', ~isempty(strfind(out3, 'The network now has 1 group:')) && numel(strfind(out3(k3:end), ': yes')) == 7 && isempty(strfind(out3, ': NO'))};

% --- demo_point5 ---
outd = evalc('demo_point5()');
title = '##### POINT 5 DEMO: THE SECURE NETWORK #####';
c(end+1, :) = {'demo_point5 prints the title', ~isempty(strfind(outd, title))};
kd = strfind(outd, 'Checks:');
c(end+1, :) = {'demo_point5 has one Checks block of 7 yes and no NO', numel(kd) == 1 && numel(strfind(outd(kd:end), ': yes')) == 7 && isempty(strfind(outd, ': NO'))};
c(end+1, :) = {'demo_point5 is the title and show_system(define_system())', strcmp(outd, [nl title nl evalc('show_system(define_system())')])};

summarize_checks('test_system', c);
end
