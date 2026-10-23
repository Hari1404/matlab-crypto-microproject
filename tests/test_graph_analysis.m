function test_graph_analysis()
% TEST_GRAPH_ANALYSIS Checks for the graph analysis: search, distances, groups, paths, cycles and removals.
S = define_sets();
R = define_relations(S);
G = define_graph(S, R);
A = G.adj;
% Au: users 1-2 and 3-4 joined, user 5 alone (three groups). Ap4: a path 1-2-3-4. Atri: a triangle.
% Ar4: a ring of 4. Ast: a star with centre 1 and 4 leaves. Ak4: all 4 users joined. Asq: a square and a triangle apart.
Au = edges_to_adjacency([1 2; 3 4], 5);
Ap4 = edges_to_adjacency([1 2; 2 3; 3 4], 4);
Atri = edges_to_adjacency([1 2; 2 3; 1 3], 3);
Ar4 = edges_to_adjacency([1 2; 2 3; 3 4; 1 4], 4);
Ast = edges_to_adjacency([1 2; 1 3; 1 4; 1 5], 5);
Ak4 = ~logical(eye(4));
Asq = edges_to_adjacency([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 5], 7);
c = cell(0, 2);

% --- adjacency_to_edges ---
c(end+1, :) = {'the edges read from the matrix are the edges of define_graph', isequal(adjacency_to_edges(A), G.edges)};
c(end+1, :) = {'the edges of a path 1-2-3 are [1 2] and [2 3]', isequal(adjacency_to_edges(edges_to_adjacency([2 3; 1 2], 3)), [1 2; 2 3])};
c(end+1, :) = {'a graph with no edges gives a 0 by 2 list', isequal(size(adjacency_to_edges(false(4, 4))), [0 2])};
c(end+1, :) = {'matrix to edges to matrix gives the same matrix', isequal(edges_to_adjacency(adjacency_to_edges(A), 6), A)};
c(end+1, :) = {'a matrix that is not square is rejected by adjacency_to_edges', raises_error(@() adjacency_to_edges(false(2, 3)))};

% --- breadth-first search ---
[d1, p1, o1] = bfs_search(A, 1);
c(end+1, :) = {'search from Alice: the distances are 0 1 1 2 3 4', isequal(d1, [0 1 1 2 3 4])};
c(end+1, :) = {'search from Alice: the parents are 0 1 1 2 4 5', isequal(p1, [0 1 1 2 4 5])};
c(end+1, :) = {'search from Alice: the visit order is 1 2 3 4 5 6', isequal(o1, [1 2 3 4 5 6])};
[d6, p6, o6] = bfs_search(A, 6);
c(end+1, :) = {'search from Grace: the distances are 4 3 3 2 1 0', isequal(d6, [4 3 3 2 1 0])};
c(end+1, :) = {'search from Grace: the parents are 2 4 4 5 6 0', isequal(p6, [2 4 4 5 6 0])};
c(end+1, :) = {'search from Grace: the visit order is 6 5 4 2 3 1', isequal(o6, [6 5 4 2 3 1])};
[d4, p4, o4] = bfs_search(A, 4);
c(end+1, :) = {'search from Dave: the distances are 2 1 1 0 1 2', isequal(d4, [2 1 1 0 1 2])};
c(end+1, :) = {'search from Dave: the parents are 2 4 4 0 4 5', isequal(p4, [2 4 4 0 4 5])};
c(end+1, :) = {'search from Dave: the visit order is 4 2 3 5 1 6', isequal(o4, [4 2 3 5 1 6])};
c(end+1, :) = {'the start vertex has distance 0 and no parent', d1(1) == 0 && p1(1) == 0};
c(end+1, :) = {'every vertex is visited exactly once', isequal(sort(o1), 1:6) && isequal(sort(o6), 1:6)};
ok = true;
for v = 2:6
    ok = ok && d1(v) == d1(p1(v)) + 1 && A(v, p1(v));
end
c(end+1, :) = {'the distance of a vertex is the distance of its parent plus 1, and it is joined to its parent', ok};
[du, pu, ou] = bfs_search(Au, 1);
c(end+1, :) = {'vertices that cannot be reached have distance Inf', isequal(du, [0 1 Inf Inf Inf])};
c(end+1, :) = {'vertices that cannot be reached have parent 0 and are not visited', isequal(pu, [0 1 0 0 0]) && isequal(ou, [1 2])};
[d0, p0, o0] = bfs_search(false(1, 1), 1);
c(end+1, :) = {'the search works on a graph with one vertex', d0 == 0 && p0 == 0 && o0 == 1};
c(end+1, :) = {'start vertex 0 is rejected', raises_error(@() bfs_search(A, 0))};
c(end+1, :) = {'a start vertex larger than n is rejected', raises_error(@() bfs_search(A, 7))};
c(end+1, :) = {'a fractional start vertex is rejected', raises_error(@() bfs_search(A, 1.5))};
c(end+1, :) = {'two start vertices are rejected', raises_error(@() bfs_search(A, [1 2]))};
c(end+1, :) = {'a matrix that is not square is rejected by bfs_search', raises_error(@() bfs_search(false(2, 3), 1))};

% --- reachability and distances ---
c(end+1, :) = {'from Alice all 6 users can be reached', isequal(reachable_from(A, 1), 1:6)};
c(end+1, :) = {'in the small graph, user 1 reaches 1 and 2', isequal(reachable_from(Au, 1), [1 2])};
c(end+1, :) = {'in the small graph, user 4 reaches 3 and 4', isequal(reachable_from(Au, 4), [3 4])};
c(end+1, :) = {'in the small graph, user 5 reaches only itself', isequal(reachable_from(Au, 5), 5)};
D = distance_matrix(A);
c(end+1, :) = {'the distance matrix is 6 by 6', isequal(size(D), [6 6])};
c(end+1, :) = {'the distance from every user to itself is 0', all(diag(D) == 0)};
c(end+1, :) = {'the distance matrix is symmetric', isequal(D, D')};
c(end+1, :) = {'Alice to Grace is 4, Bob to Carol is 2, Alice to Dave is 2', D(1, 6) == 4 && D(2, 3) == 2 && D(1, 4) == 2};
c(end+1, :) = {'the first row of the distance matrix is 0 1 1 2 3 4', isequal(D(1, :), [0 1 1 2 3 4])};
c(end+1, :) = {'the largest distance in the network is 4', max(D(:)) == 4};
c(end+1, :) = {'all distances in the network are finite', all(isfinite(D(:)))};
ok = true;
for v = 1:6
    ok = ok && isequal(D(v, :), bfs_search(A, v));
end
c(end+1, :) = {'every row of the distance matrix is a search result', ok};
Du = distance_matrix(Au);
c(end+1, :) = {'in the small graph the distance 1 to 2 is 1 and 1 to 3 is Inf', Du(1, 2) == 1 && isinf(Du(1, 3))};
c(end+1, :) = {'in the small graph user 5 is at distance Inf from all others and 0 from itself', Du(5, 5) == 0 && all(isinf(Du(5, 1:4))) && all(isinf(Du(1:4, 5)))};

% --- connectivity ---
[comp, k] = connected_components(A);
c(end+1, :) = {'the network is one group', isequal(comp, ones(1, 6)) && k == 1};
c(end+1, :) = {'the network is connected', is_connected(A) == true};
[cu, ku] = connected_components(Au);
c(end+1, :) = {'the small graph has the groups 1 1 2 2 3', isequal(cu, [1 1 2 2 3]) && ku == 3};
c(end+1, :) = {'the small graph is not connected', is_connected(Au) == false};
[cn, kn] = connected_components(false(4, 4));
c(end+1, :) = {'a graph with no edges has one group for each vertex', isequal(cn, 1:4) && kn == 4};
c(end+1, :) = {'a graph with one vertex is connected', is_connected(false(1, 1)) == true};
c(end+1, :) = {'a graph with no vertices is not connected', is_connected(false(0, 0)) == false};
ok = true;
for v = 1:5
    r = reachable_from(Au, v);
    ok = ok && all(cu(r) == cu(v)) && numel(r) == sum(cu == cu(v));
end
c(end+1, :) = {'the users reached from v are exactly the users in the group of v', ok};

% --- shortest path ---
[pa, la] = shortest_path(A, 1, 6);
c(end+1, :) = {'shortest path Alice to Grace is 1 2 4 5 6 with length 4', isequal(pa, [1 2 4 5 6]) && la == 4};
[pb, lb] = shortest_path(A, 6, 1);
c(end+1, :) = {'shortest path Grace to Alice is 6 5 4 2 1 with length 4', isequal(pb, [6 5 4 2 1]) && lb == 4};
[pc, lc] = shortest_path(A, 2, 3);
c(end+1, :) = {'shortest path Bob to Carol is 2 1 3 with length 2', isequal(pc, [2 1 3]) && lc == 2};
[pd, ld] = shortest_path(A, 3, 3);
c(end+1, :) = {'the shortest path from a user to itself is that user, with length 0', isequal(pd, 3) && ld == 0};
ok = true;
for i = 1:(numel(pa) - 1)
    ok = ok && A(pa(i), pa(i + 1));
end
c(end+1, :) = {'every two neighbors on the path are joined by a channel', ok && numel(unique(pa)) == numel(pa)};
[pe, le] = shortest_path(Au, 1, 3);
c(end+1, :) = {'no path to a user in another group: empty path and length Inf', isempty(pe) && isinf(le)};
ok = true;
for s = 1:6
    for t = 1:6
        [pp, ll] = shortest_path(A, s, t);
        ok = ok && numel(pp) - 1 == D(s, t) && ll == D(s, t) && pp(1) == s && pp(end) == t;
    end
end
c(end+1, :) = {'for every pair of users the path length is the distance and the path runs from s to t', ok};
c(end+1, :) = {'target 0 is rejected by shortest_path', raises_error(@() shortest_path(A, 1, 0))};
c(end+1, :) = {'a target larger than n is rejected by shortest_path', raises_error(@() shortest_path(A, 1, 7))};
c(end+1, :) = {'a start larger than n is rejected by shortest_path', raises_error(@() shortest_path(A, 7, 1))};

% --- cycles ---
c(end+1, :) = {'the network has 1 independent cycle (6 - 6 + 1)', cycle_rank(A) == 1};
c(end+1, :) = {'the shortest cycle of the network is Alice, Bob, Dave, Carol', isequal(find_cycle(A), [1 2 4 3])};
c(end+1, :) = {'a path has no cycle', cycle_rank(Ap4) == 0 && isempty(find_cycle(Ap4))};
c(end+1, :) = {'a triangle has 1 cycle, which is 1 2 3', cycle_rank(Atri) == 1 && isequal(find_cycle(Atri), [1 2 3])};
c(end+1, :) = {'all 4 users joined has 3 independent cycles and a shortest cycle 1 2 3', cycle_rank(Ak4) == 3 && isequal(find_cycle(Ak4), [1 2 3])};
c(end+1, :) = {'a square and a triangle apart: 2 independent cycles and the triangle 5 6 7 is found', cycle_rank(Asq) == 2 && isequal(find_cycle(Asq), [5 6 7])};
c(end+1, :) = {'a graph with no edges has no cycle', cycle_rank(false(4, 4)) == 0 && isempty(find_cycle(false(4, 4)))};
cyc = find_cycle(A);
ok = numel(cyc) >= 3 && numel(unique(cyc)) == numel(cyc);
for i = 1:numel(cyc)
    j = mod(i, numel(cyc)) + 1;
    ok = ok && A(cyc(i), cyc(j));
end
c(end+1, :) = {'the cycle of the network has no repeated user and is closed by a channel', ok};
ok = true;
graphs = {A, Au, Ap4, Atri, Ar4, Ast, Ak4, Asq};
for q = 1:numel(graphs)
    ok = ok && (isempty(find_cycle(graphs{q})) == (cycle_rank(graphs{q}) == 0));
end
c(end+1, :) = {'a cycle is found exactly when the cycle number is larger than 0', ok};

% --- removing a channel ---
B = remove_channel(A, 4, 5);
c(end+1, :) = {'removing Dave-Frank leaves 5 channels (10 ones) and the matrix stays symmetric', sum(B(:)) == 10 && isequal(B, B') && ~B(4, 5) && ~B(5, 4)};
c(end+1, :) = {'removing a channel does not change the original matrix', sum(A(:)) == 12 && A(4, 5) && A(5, 4)};
c(end+1, :) = {'removing a channel keeps the other channels', B(1, 2) && B(3, 4) && B(5, 6)};
c(end+1, :) = {'removing Frank-Dave is the same as removing Dave-Frank', isequal(remove_channel(A, 5, 4), B)};
c(end+1, :) = {'removing a channel that does not exist is rejected', raises_error(@() remove_channel(A, 1, 4))};
c(end+1, :) = {'removing a channel from a user to itself is rejected', raises_error(@() remove_channel(A, 2, 2))};
c(end+1, :) = {'removing a channel with a vertex larger than n is rejected', raises_error(@() remove_channel(A, 1, 7))};
c(end+1, :) = {'removing a channel with vertex 0 is rejected', raises_error(@() remove_channel(A, 0, 1))};
c(end+1, :) = {'removing a channel with a fractional vertex is rejected', raises_error(@() remove_channel(A, 1.5, 2))};
ok = true;
for e = 1:4
    ok = ok && is_connected(remove_channel(A, G.edges(e, 1), G.edges(e, 2)));
end
c(end+1, :) = {'after removing any one of the first 4 channels the network is still connected', ok};
c(end+1, :) = {'after removing Dave-Frank the network is not connected', ~is_connected(B)};
c(end+1, :) = {'after removing Dave-Frank the groups are 1 1 1 1 2 2', isequal(connected_components(B), [1 1 1 1 2 2])};
c(end+1, :) = {'after removing Dave-Frank Alice cannot reach Grace', isempty(shortest_path(B, 1, 6)) && ~ismember(6, reachable_from(B, 1))};
Bg = remove_channel(A, 5, 6);
c(end+1, :) = {'after removing Frank-Grace the groups are 1 1 1 1 1 2', isequal(connected_components(Bg), [1 1 1 1 1 2])};
Bb = remove_channel(A, 2, 4);
[pr, lr] = shortest_path(Bb, 1, 6);
c(end+1, :) = {'after removing Bob-Dave the path Alice to Grace is 1 3 4 5 6', isequal(pr, [1 3 4 5 6]) && lr == 4};

% --- removing a user ---
[Bd, kd] = remove_user(A, 4);
c(end+1, :) = {'removing Dave gives a 5 by 5 matrix and keeps users 1 2 3 5 6', isequal(size(Bd), [5 5]) && isequal(kd, [1 2 3 5 6])};
c(end+1, :) = {'removing Dave removes his 3 channels (6 ones remain) and the matrix stays symmetric', sum(Bd(:)) == 6 && isequal(Bd, Bd')};
c(end+1, :) = {'the matrix after removing Dave is the original with row and column 4 cut out', isequal(Bd, A(kd, kd))};
c(end+1, :) = {'after removing Dave the groups are 1 1 1 2 2', isequal(connected_components(Bd), [1 1 1 2 2]) && ~is_connected(Bd)};
[Bf, kf] = remove_user(A, 5);
[cf, kkf] = connected_components(Bf);
c(end+1, :) = {'after removing Frank, Grace is alone: users 1 2 3 4 6, groups 1 1 1 1 2', isequal(kf, [1 2 3 4 6]) && isequal(cf, [1 1 1 1 2]) && kkf == 2};
[Bg6, kg6] = remove_user(A, 6);
c(end+1, :) = {'after removing Grace the others are still connected', isequal(kg6, 1:5) && is_connected(Bg6)};
[Ba, ka] = remove_user(A, 1);
c(end+1, :) = {'after removing Alice the others are still connected', isequal(ka, [2 3 4 5 6]) && is_connected(Ba)};
[B1, k1] = remove_user(false(1, 1), 1);
c(end+1, :) = {'removing the only user gives a 0 by 0 matrix', isequal(size(B1), [0 0]) && isempty(k1)};
c(end+1, :) = {'removing a user does not change the original matrix', isequal(A, G.adj) && sum(A(:)) == 12};
c(end+1, :) = {'removing user 0 is rejected', raises_error(@() remove_user(A, 0))};
c(end+1, :) = {'removing a user larger than n is rejected', raises_error(@() remove_user(A, 7))};
c(end+1, :) = {'removing a fractional user is rejected', raises_error(@() remove_user(A, 1.5))};
c(end+1, :) = {'a matrix that is not square is rejected by remove_user', raises_error(@() remove_user(false(2, 3), 1))};

% --- bridges and cut users ---
c(end+1, :) = {'the bridge channels of the network are Dave-Frank and Frank-Grace', isequal(bridge_channels(A), [4 5; 5 6])};
c(end+1, :) = {'the cut users of the network are Dave and Frank', isequal(cut_users(A), [4 5])};
c(end+1, :) = {'in a path of 4 every channel is a bridge and users 2 and 3 are cut users', isequal(bridge_channels(Ap4), [1 2; 2 3; 3 4]) && isequal(cut_users(Ap4), [2 3])};
c(end+1, :) = {'a triangle has no bridge and no cut user', isequal(size(bridge_channels(Atri)), [0 2]) && isempty(cut_users(Atri))};
c(end+1, :) = {'a ring of 4 has no bridge and no cut user', isempty(bridge_channels(Ar4)) && isempty(cut_users(Ar4))};
c(end+1, :) = {'a star has 4 bridges and only the centre is a cut user', size(bridge_channels(Ast), 1) == 4 && isequal(cut_users(Ast), 1)};
c(end+1, :) = {'in the small graph both channels are bridges and no user is a cut user', isequal(bridge_channels(Au), [1 2; 3 4]) && isempty(cut_users(Au))};
ok = true;
Eb = bridge_channels(A);
for r = 1:size(Eb, 1)
    [cb, kb] = connected_components(remove_channel(A, Eb(r, 1), Eb(r, 2)));
    ok = ok && kb == k + 1;
end
c(end+1, :) = {'removing a bridge always adds one group', ok};
ok = true;
cyc = find_cycle(A);
for i = 1:numel(cyc)
    j = mod(i, numel(cyc)) + 1;
    a = min(cyc(i), cyc(j));
    b = max(cyc(i), cyc(j));
    ok = ok && ~ismember([a b], bridge_channels(A), 'rows');
end
c(end+1, :) = {'no channel of the cycle is a bridge', ok};

% --- text helpers ---
names = {'Ann', 'Bo', 'Cy'};
c(end+1, :) = {'format_names joins the names with commas', strcmp(format_names(names, [3 1]), 'Cy, Ann')};
c(end+1, :) = {'format_names uses the separator it is given', strcmp(format_names(names, [1 2 3], ' - '), 'Ann - Bo - Cy')};
c(end+1, :) = {'format_names gives (none) for no names', strcmp(format_names(names, []), '(none)')};
c(end+1, :) = {'format_groups writes each group in braces', strcmp(format_groups(names, [1 2 1]), '{Ann, Cy}  {Bo}')};
c(end+1, :) = {'format_groups gives (none) for no users', strcmp(format_groups({}, zeros(1, 0)), '(none)')};
c(end+1, :) = {'yes_no gives yes and no', strcmp(yes_no(true), 'yes') && strcmp(yes_no(false), 'no')};

% --- the printed analysis ---
txt = evalc('show_analysis(G)');
c(end+1, :) = {'show_analysis prints the shortest path Alice to Grace', ~isempty(strfind(txt, 'Alice - Bob - Dave - Frank - Grace (length 4)'))};
c(end+1, :) = {'show_analysis prints the shortest cycle', ~isempty(strfind(txt, 'A shortest cycle: Alice - Bob - Dave - Carol - Alice (length 4)'))};
c(end+1, :) = {'show_analysis prints the cycle number', ~isempty(strfind(txt, 'channels - users + groups = 6 - 6 + 1 = 1'))};
c(end+1, :) = {'show_analysis prints the bridge channels', ~isempty(strfind(txt, 'Dave - Frank, Frank - Grace'))};
c(end+1, :) = {'show_analysis prints the cut users', ~isempty(strfind(txt, 'removing one splits the network): Dave, Frank'))};
pos = strfind(txt, 'Checks:');
tail = txt(pos(end):end);
c(end+1, :) = {'show_analysis ends with 4 check lines that all say yes', numel(strfind(tail, ': yes')) == 4 && isempty(strfind(tail, ': NO'))};
Gs = G;
Gs.adj = B;
txt2 = evalc('show_analysis(Gs)');
c(end+1, :) = {'show_analysis on the split network says there is no path from Alice to Grace', ~isempty(strfind(txt2, 'There is no path: Alice cannot reach Grace.'))};
c(end+1, :) = {'show_analysis on the split network says 2 groups and not connected', ~isempty(strfind(txt2, 'The network has 2 connected group(s)')) && ~isempty(strfind(txt2, 'Is the network connected? no'))};
pos2 = strfind(txt2, 'Checks:');
c(end+1, :) = {'show_analysis on the split network: all 4 checks still say yes', numel(strfind(txt2(pos2(end):end), ': yes')) == 4};
txt3 = evalc('show_analysis(G, 6, 1)');
c(end+1, :) = {'show_analysis(G, 6, 1) prints the path Grace to Alice', ~isempty(strfind(txt3, 'Grace - Frank - Dave - Bob - Alice (length 4)'))};
txt4 = evalc('demo_point2(tempname(), ''off'')');
c(end+1, :) = {'demo_point2 prints the title and the analysis', ~isempty(strfind(txt4, 'POINT 2 DEMO: THE GRAPH NETWORK')) && ~isempty(strfind(txt4, 'ANALYSIS OF THE COMMUNICATION NETWORK'))};

summarize_checks('test_graph_analysis', c);
end
