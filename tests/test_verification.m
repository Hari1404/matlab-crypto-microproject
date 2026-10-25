function test_verification()
% TEST_VERIFICATION Checks for reach_by_matrix, verify_system, show_verification and demo_point6.
Y = define_system();
c = cell(0, 2);
has = @(t, s) ~isempty(strfind(t, s));
root = fileparts(fileparts(fileparts(which('verify_system'))));
before = dir(fullfile(root, 'outputs'));

% --- reach_by_matrix ---
A4 = false(4);
A4(1, 2) = true; A4(2, 1) = true; A4(2, 3) = true; A4(3, 2) = true; A4(3, 4) = true; A4(4, 3) = true;
[r4, k4] = reach_by_matrix(A4);
c(end+1, :) = {'reach_by_matrix: a chain of 4 users is one group and everyone reaches everyone', k4 == 1 && all(r4(:))};
A5 = false(5);
A5(1, 2) = true; A5(2, 1) = true; A5(3, 4) = true; A5(4, 3) = true;
[r5, k5] = reach_by_matrix(A5);
c(end+1, :) = {'reach_by_matrix: two pairs and one lonely user make 3 groups', k5 == 3 && r5(1, 2) && ~r5(1, 3) && r5(3, 4) && ~r5(4, 5) && r5(5, 5)};
[r1, k1] = reach_by_matrix(false(1));
c(end+1, :) = {'reach_by_matrix: one user is one group', k1 == 1 && isequal(r1, true)};
[r0, k0] = reach_by_matrix(false(0));
c(end+1, :) = {'reach_by_matrix: no user is no group', k0 == 0 && isempty(r0)};
[rn, kn] = reach_by_matrix(false(6));
c(end+1, :) = {'reach_by_matrix: 6 users without channels are 6 groups', kn == 6 && isequal(rn, logical(eye(6)))};
[rd, kd] = reach_by_matrix(Y.A);
[cd, kc] = connected_components(Y.A);
c(end+1, :) = {'reach_by_matrix: the default network is one group and everyone reaches everyone', kd == 1 && kc == 1 && all(rd(:))};
same = true;
for n = 2:9
    Q = false(n);
    for i = 1:n
        for j = (i + 1):n
            if mod(i * j + i + j + n, 3) == 0
                Q(i, j) = true;
                Q(j, i) = true;
            end
        end
    end
    [rq, kq] = reach_by_matrix(Q);
    [cq, kk] = connected_components(Q);
    ok = (kq == kk);
    for u = 1:n
        for v = 1:n
            ok = ok && ((cq(u) == cq(v)) == rq(u, v));
        end
    end
    same = same && ok;
end
c(end+1, :) = {'reach_by_matrix: the same groups as connected_components for 8 other graphs (2 to 9 users)', same};

% --- verify_system on the default network ---
V = verify_system();
c(end+1, :) = {'verify_system: a cell array with 21 rows and 4 columns', iscell(V) && isequal(size(V), [21 4])};
g = cell2mat(V(:, 1))';
c(end+1, :) = {'verify_system: 6 checks on the key, 6 on the decryption and 9 on the graph', isequal(g, [1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3])};
c(end+1, :) = {'verify_system: all 21 checks agree on the default network', all(cellfun(@(x) isequal(x, true), V(:, 4)))};
c(end+1, :) = {'verify_system: the numbers of cases', isequal(cell2mat(V(:, 3))', [15 15 15 15 6 15 30 15 1425 30 30 30 36 6 6 36 36 30 6 6 6])};
c(end+1, :) = {'verify_system: every label is a text', all(cellfun(@ischar, V(:, 2)))};
V0 = verify_system(Y);
c(end+1, :) = {'verify_system(Y) gives the same rows as verify_system()', isequal(V, V0)};

% --- verify_system on other networks ---
allok = true;
E = Y.G.edges;
for e = 1:Y.G.m
    Y2 = Y;
    Y2.A = remove_channel(Y.A, E(e, 1), E(e, 2));
    V2 = verify_system(Y2);
    allok = allok && all(cellfun(@(x) isequal(x, true), V2(:, 4))) && isequal(size(V2), [21 4]);
end
c(end+1, :) = {'verify_system: all 21 checks agree after each one of the 6 channels is removed', allok};
Yn = Y;
Yn.A = false(6);
Vn = verify_system(Yn);
c(end+1, :) = {'verify_system: all 21 checks agree when no channel works (6 groups)', all(cellfun(@(x) isequal(x, true), Vn(:, 4)))};
Yt = Y;
Yt.A = remove_channel(remove_channel(Y.A, 4, 5), 5, 6);
Vt = verify_system(Yt);
c(end+1, :) = {'verify_system: all 21 checks agree for the cycle with 2 lonely users (no bridge, no cut user)', all(cellfun(@(x) isequal(x, true), Vt(:, 4)))};

% --- verify_system finds a wrong key ---
Yw = Y;
Yw.K(1, 2) = 1;
Yw.K(2, 1) = 1;
Yw.edge_keys(1) = 1;
Vw = verify_system(Yw);
okw = cellfun(@(x) isequal(x, true), Vw(:, 4))';
c(end+1, :) = {'verify_system: a wrong key for a channel fails exactly the rows 4 (table), 5 (channel) and 11 (hop)', isequal(find(~okw), [4 5 11])};
Yp = Y;
Yp.D.public(2) = mod(Y.D.public(2), 90) + 2;
Vp = verify_system(Yp);
okp = cellfun(@(x) isequal(x, true), Vp(:, 4))';
c(end+1, :) = {'verify_system: a wrong public value fails exactly the rows 1, 2, 4, 5, 6, 7 and 10 (keys, table, channel, eavesdropper, messages, routes)', isequal(find(~okp), [1 2 4 5 6 7 10])};

% --- verify_system refuses bad input ---
c(end+1, :) = {'verify_system refuses a Y that is not a system', raises_error(@() verify_system(5)) && raises_error(@() verify_system(struct('n', 3)))};

% --- show_verification ---
o = evalc('show_verification()');
c(end+1, :) = {'show_verification: title and the explanation', has(o, '=== VERIFICATION: THE KEY, THE DECRYPTION AND THE GRAPH ===') && has(o, 'Every check is made a second way with plain arithmetic or matrix products')};
c(end+1, :) = {'show_verification: the 3 tables', has(o, '1. The shared key') && has(o, '2. Encryption and decryption') && has(o, '3. The graph') && numel(strfind(o, 'What is checked')) == 3};
c(end+1, :) = {'show_verification: 21 checks, all of them yes', has(o, 'In all: 21 of 21 checks agree.') && numel(strfind(o, '  yes')) == 21 && isempty(strfind(o, '  NO'))};
c(end+1, :) = {'show_verification: the case numbers 1425 and 15 are printed', has(o, '1425  yes') && has(o, '     15  yes')};
c(end+1, :) = {'show_verification: the labels of a row in each table', has(o, 'both users of a pair compute the same key') && has(o, 'every key but the right one fails to give the text back') && has(o, 'a user is a cut user exactly when removing him makes more groups')};
c(end+1, :) = {'show_verification: the broken network Dave - Frank and its 2 groups', has(o, 'The same checks after the channel Dave - Frank is removed (2 groups: {Alice, Bob, Carol, Dave}  {Frank, Grace}):') && has(o, '  21 of 21 checks agree.')};
o2 = evalc('show_verification(Yt)');
c(end+1, :) = {'show_verification: without a bridge channel the first channel Alice - Bob is removed (3 groups)', has(o2, 'The same checks after the channel Alice - Bob is removed (3 groups:') && has(o2, 'In all: 21 of 21 checks agree.')};
o3 = evalc('show_verification(Yn)');
c(end+1, :) = {'show_verification: with no channel it says that there is no broken network to check', has(o3, 'The network has no channel, so there is no broken network to check.') && has(o3, 'In all: 21 of 21 checks agree.')};
o4 = evalc('show_verification(Yw)');
c(end+1, :) = {'show_verification: a wrong key shows NO in 3 rows and 18 of 21', has(o4, 'In all: 18 of 21 checks agree.') && numel(strfind(o4, '  NO')) >= 3};
o7 = evalc('show_verification(Yp)');
c(end+1, :) = {'show_verification: a wrong public value shows 14 of 21 and the same 14 of 21 for the broken network', has(o7, 'In all: 14 of 21 checks agree.') && has(o7, '  14 of 21 checks agree.') && numel(strfind(o7, '  NO')) == 7};
o5 = evalc('show_verification()');
c(end+1, :) = {'show_verification: the same text twice', strcmp(o, o5)};

% --- demo_point6 ---
o6 = evalc('demo_point6()');
c(end+1, :) = {'demo_point6 shows the verification', strcmp(o6, o)};

% --- no files written ---
after = dir(fullfile(root, 'outputs'));
c(end+1, :) = {'these tests do not change the files in outputs', isequal({before.name}, {after.name})};

summarize_checks('test_verification', c);
end
