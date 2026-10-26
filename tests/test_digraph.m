function test_digraph()
% TEST_DIGRAPH Checks for the directed graph (packet 2D): arcs, adjacency, strong groups, arrows, picture options, printout.
% No figures are drawn here (test_digraph_pictures does that).
S = define_sets();
G = define_graph(S);
D = define_digraph(S, G);
near = @(a, b) isequal(size(a), size(b)) && (isempty(a) || max(abs(a(:) - b(:))) < 1e-9);
c = cell(0, 2);

% --- the default digraph ---
arcs0 = [1 2; 2 1; 2 4; 3 1; 4 3; 4 5; 5 4; 5 6];
c(end+1, :) = {'the digraph has 6 vertices and 8 arcs', D.n == 6 && D.m == 8};
c(end+1, :) = {'the vertices are the 6 users', isequal(D.vertices, S.users)};
c(end+1, :) = {'the arcs are the 8 arcs of the default example, sorted', isequal(D.arcs, arcs0)};
c(end+1, :) = {'the adjacency matrix is 6 by 6 and logical', isequal(size(D.adj), [6 6]) && islogical(D.adj)};
c(end+1, :) = {'the diagonal is all false', ~any(diag(D.adj))};
c(end+1, :) = {'the matrix is not symmetric', ~isequal(D.adj, D.adj')};
c(end+1, :) = {'Alice sends to Bob, Bob sends to Alice, Carol sends to Alice but Alice does not send to Carol', D.adj(1, 2) && D.adj(2, 1) && D.adj(3, 1) && ~D.adj(1, 3)};
c(end+1, :) = {'out-degrees are 1 2 1 2 2 0', isequal(D.out_degree, [1 2 1 2 2 0])};
c(end+1, :) = {'in-degrees are 2 1 1 2 1 1', isequal(D.in_degree, [2 1 1 2 1 1])};
c(end+1, :) = {'the sums of the degrees are both 8', sum(D.out_degree) == 8 && sum(D.in_degree) == 8};
c(end+1, :) = {'out_list of Bob is Alice, Dave', isequal(D.out_list{2}, [1 4])};
c(end+1, :) = {'in_list of Alice is Bob, Carol', isequal(D.in_list{1}, [2 3])};
c(end+1, :) = {'out_list of Grace is empty', isempty(D.out_list{6})};
c(end+1, :) = {'two-way channels are Alice-Bob and Dave-Frank', isequal(D.two_way, [1 2; 4 5])};
c(end+1, :) = {'one-way arcs are Carol->Alice, Bob->Dave, Dave->Carol, Frank->Grace', isequal(sortrows(D.one_way), sortrows([3 1; 2 4; 4 3; 5 6]))};
c(end+1, :) = {'the arcs ignoring direction are the 6 channels of G', isequal(D.adj | D.adj', G.adj)};

% --- define_digraph with other arcs and errors ---
D2 = define_digraph(S, G, [1 2; 2 1; 1 3; 3 1; 2 4; 4 2; 3 4; 4 3; 4 5; 5 4; 5 6; 6 5]);
c(end+1, :) = {'all channels two-way: 12 arcs, symmetric matrix, no one-way channel', D2.m == 12 && isequal(D2.adj, D2.adj') && isempty(D2.one_way) && size(D2.two_way, 1) == 6};
D3 = define_digraph(S, G, [2 1; 3 1; 4 2; 4 3; 5 4; 6 5]);
c(end+1, :) = {'all channels one-way: 6 arcs, no two-way channel', D3.m == 6 && isempty(D3.two_way) && size(D3.one_way, 1) == 6};
c(end+1, :) = {'unsorted arcs are sorted', isequal(define_digraph(S, G, flipud(arcs0)).arcs, arcs0)};
c(end+1, :) = {'an arc between users with no channel is refused', raises_error(@() define_digraph(S, G, [arcs0; 1 6]))};
c(end+1, :) = {'the error name is channel', strcmp(err_id(@() define_digraph(S, G, [arcs0; 1 6])), 'define_digraph:channel')};
c(end+1, :) = {'a channel without arc is refused (missing)', strcmp(err_id(@() define_digraph(S, G, arcs0(1:7, :))), 'define_digraph:missing')};

% --- arcs_to_adjacency / adjacency_to_arcs ---
A = arcs_to_adjacency([1 2; 2 3], 3);
c(end+1, :) = {'arcs_to_adjacency: only the direction given is set', isequal(A, logical([0 1 0; 0 0 1; 0 0 0]))};
c(end+1, :) = {'arcs_to_adjacency: an empty list gives a zero matrix', isequal(arcs_to_adjacency(zeros(0, 2), 3), false(3, 3))};
c(end+1, :) = {'arcs_to_adjacency: a single vertex gives 1 by 1 false', isequal(arcs_to_adjacency(zeros(0, 2), 1), false(1, 1))};
c(end+1, :) = {'arcs_to_adjacency: a loop is refused with :loop', strcmp(err_id(@() arcs_to_adjacency([2 2], 3)), 'arcs_to_adjacency:loop')};
c(end+1, :) = {'arcs_to_adjacency: a vertex out of range is refused with :range', strcmp(err_id(@() arcs_to_adjacency([1 4], 3)), 'arcs_to_adjacency:range')};
c(end+1, :) = {'arcs_to_adjacency: vertex 0 is refused with :range', strcmp(err_id(@() arcs_to_adjacency([0 1], 3)), 'arcs_to_adjacency:range')};
c(end+1, :) = {'arcs_to_adjacency: a half number is refused with :range', strcmp(err_id(@() arcs_to_adjacency([1 1.5], 3)), 'arcs_to_adjacency:range')};
c(end+1, :) = {'arcs_to_adjacency: three columns are refused with :range', strcmp(err_id(@() arcs_to_adjacency([1 2 3], 3)), 'arcs_to_adjacency:range')};
c(end+1, :) = {'arcs_to_adjacency: the same arc twice is refused with :repeat', strcmp(err_id(@() arcs_to_adjacency([1 2; 1 2], 3)), 'arcs_to_adjacency:repeat')};
Ab = arcs_to_adjacency([1 2; 2 1], 2);
c(end+1, :) = {'arcs_to_adjacency: 2->1 and 1->2 together are allowed', Ab(1, 2) && Ab(2, 1)};
c(end+1, :) = {'adjacency_to_arcs gives the arc list of the digraph', isequal(adjacency_to_arcs(D.adj), arcs0)};
c(end+1, :) = {'adjacency_to_arcs of a zero matrix has 0 rows and 2 columns', isequal(size(adjacency_to_arcs(false(3, 3))), [0 2])};
c(end+1, :) = {'adjacency_to_arcs of a 1 by 1 matrix has 0 arcs', isequal(size(adjacency_to_arcs(false(1, 1))), [0 2])};
c(end+1, :) = {'adjacency_to_arcs refuses a matrix that is not square with :size', strcmp(err_id(@() adjacency_to_arcs(false(2, 3))), 'adjacency_to_arcs:size')};
c(end+1, :) = {'the two functions undo each other', isequal(arcs_to_adjacency(adjacency_to_arcs(D.adj), 6), D.adj)};

% --- distances (bfs_search follows the out-arcs) ---
dist = distance_matrix(D.adj);
c(end+1, :) = {'Alice to Carol is 3 arcs', dist(1, 3) == 3};
c(end+1, :) = {'Carol to Alice is 1 arc', dist(3, 1) == 1};
c(end+1, :) = {'Alice to Grace is 4 arcs', dist(1, 6) == 4};
c(end+1, :) = {'Grace reaches nobody: the whole row except the diagonal is Inf', all(isinf(dist(6, 1:5))) && dist(6, 6) == 0};
c(end+1, :) = {'the distance table is not symmetric', ~isequal(dist, dist')};
[p, len] = shortest_path(D.adj, 1, 3);
c(end+1, :) = {'the shortest directed path Alice to Carol is Alice, Bob, Dave, Carol', isequal(p, [1 2 4 3]) && len == 3};
[p, len] = shortest_path(D.adj, 6, 1);
c(end+1, :) = {'there is no path from Grace to Alice', isempty(p) && isinf(len)};
c(end+1, :) = {'Alice reaches all 6 users', isequal(reachable_from(D.adj, 1), 1:6)};
c(end+1, :) = {'Grace reaches only herself', isequal(reachable_from(D.adj, 6), 6)};

% --- strong components ---
[comp, k] = strong_components(D.adj);
c(end+1, :) = {'there are 2 strongly connected groups', k == 2};
c(end+1, :) = {'the groups are {Alice, Bob, Carol, Dave, Frank} and {Grace}', isequal(comp, [1 1 1 1 1 2])};
c(end+1, :) = {'the digraph is not strongly connected', ~is_strongly_connected(D.adj)};
[wc, wk] = connected_components(D.adj | D.adj');
c(end+1, :) = {'there is 1 weakly connected group', wk == 1 && isequal(wc, ones(1, 6))};
[comp, k] = strong_components(D2.adj);
c(end+1, :) = {'all channels two-way: strongly connected, 1 group', k == 1 && isequal(comp, ones(1, 6)) && is_strongly_connected(D2.adj)};
[comp, k] = strong_components(D3.adj);
c(end+1, :) = {'all channels one-way (no cycle): every user is a group of its own', k == 6 && isequal(comp, 1:6)};
Aring = arcs_to_adjacency([1 2; 2 3; 3 4; 4 1], 4);
c(end+1, :) = {'a directed ring of 4 users is one group', is_strongly_connected(Aring)};
Apath = arcs_to_adjacency([1 2; 2 3; 3 4], 4);
c(end+1, :) = {'a directed path of 4 users is 4 groups', ~is_strongly_connected(Apath)};
Atwo = arcs_to_adjacency([1 2; 2 1; 3 4; 4 3; 2 3], 4);
[comp, k] = strong_components(Atwo);
c(end+1, :) = {'two two-way pairs joined by one one-way arc: 2 groups numbered by smallest user', k == 2 && isequal(comp, [1 1 2 2])};
[comp, k] = strong_components(false(3, 3));
c(end+1, :) = {'no arcs: every user is a group', k == 3 && isequal(comp, 1:3)};
[comp, k] = strong_components(false(1, 1));
c(end+1, :) = {'a single user is one group and is strongly connected', k == 1 && comp == 1 && is_strongly_connected(false(1, 1))};
sym = D2.adj;
c(end+1, :) = {'for a symmetric matrix the strong groups are the connected groups', isequal(strong_components(sym), connected_components(sym))};
c(end+1, :) = {'strong_components refuses a matrix that is not square with :size', strcmp(err_id(@() strong_components(false(2, 3))), 'strong_components:size')};

% --- reachability by matrix powers (independent of bfs_search) ---
n = 6;
M = double(D.adj) + eye(n);
Rm = M ^ (n - 1) > 0;
c(end+1, :) = {'reachability by matrix powers agrees with the distance table', isequal(Rm, isfinite(dist))};
c(end+1, :) = {'strong groups by matrix powers agree with strong_components', isequal(Rm & Rm', strong_pairs(strong_components(D.adj)))};
A2 = double(D.adj) ^ 2;
c(end+1, :) = {'the number of 2-arc walks Alice to Dave (matrix square) is 1', A2(1, 4) == 1};

% --- path_to_arcs ---
c(end+1, :) = {'the path Alice, Bob, Dave, Frank, Grace uses arcs 1 3 6 8', isequal(path_to_arcs(D.arcs, [1 2 4 5 6]), [1 3 6 8])};
c(end+1, :) = {'the directed cycle Alice, Bob, Dave, Carol, Alice uses arcs 1 3 5 4', isequal(path_to_arcs(D.arcs, [1 2 4 3 1]), [1 3 5 4])};
c(end+1, :) = {'a path with one vertex gives an empty row', isempty(path_to_arcs(D.arcs, 3))};
c(end+1, :) = {'going against an arc is refused (Alice to Carol directly)', strcmp(err_id(@() path_to_arcs(D.arcs, [1 3])), 'path_to_arcs:missing')};
c(end+1, :) = {'going against a one-way arc is refused (Dave to Bob)', strcmp(err_id(@() path_to_arcs(D.arcs, [4 2])), 'path_to_arcs:missing')};

% --- arrow_points ---
P = arrow_points([0 0], [2.4 0], 0.6, 0);
c(end+1, :) = {'arrow in the middle: start 0.6, tip 1.8, line end 1.45', near(P.start, [0.6 0]) && near(P.tip, [1.8 0]) && near(P.line_end, [1.45 0])};
c(end+1, :) = {'arrowhead corners: tip and two corners 0.14 each side of the base', near(P.head, [1.8 0; 1.45 0.14; 1.45 -0.14])};
P = arrow_points([0 0], [2.4 0], 0.6, 0.12);
s = sqrt(0.6 ^ 2 - 0.12 ^ 2);
c(end+1, :) = {'shifted arrow lies 0.12 to the left and starts on the circle', near(P.start, [s 0.12]) && near(P.tip, [2.4 - s 0.12]) && abs(norm(P.start - [0 0]) - 0.6) < 1e-9};
Pr = arrow_points([2.4 0], [0 0], 0.6, 0.12);
c(end+1, :) = {'the reverse arrow lies on the other side (y = -0.12)', near(Pr.start, [2.4 - s -0.12])};
P = arrow_points([0 0], [0 3], 0.6, 0);
c(end+1, :) = {'a vertical arrow points up', near(P.tip, [0 2.4]) && near(P.head(2, :), [-0.14 2.05])};
P = arrow_points([0 0], [3 4], 0.6, 0);
c(end+1, :) = {'a diagonal arrow starts on the circle and ends on the other circle', abs(norm(P.start) - 0.6) < 1e-9 && abs(norm(P.tip - [3 4]) - 0.6) < 1e-9};
c(end+1, :) = {'the same place is refused with :same', strcmp(err_id(@() arrow_points([1 1], [1 1], 0.6, 0)), 'arrow_points:same')};
c(end+1, :) = {'circles that are too close are refused with :short', strcmp(err_id(@() arrow_points([0 0], [1.4 0], 0.6, 0)), 'arrow_points:short')};
c(end+1, :) = {'a place that is not [x y] is refused with :size', strcmp(err_id(@() arrow_points([0 0 0], [1 1], 0.6, 0)), 'arrow_points:size')};
c(end+1, :) = {'a radius of 0 is refused with :size', strcmp(err_id(@() arrow_points([0 0], [3 0], 0, 0)), 'arrow_points:size')};
c(end+1, :) = {'a shift not smaller than the radius is refused with :size', strcmp(err_id(@() arrow_points([0 0], [3 0], 0.6, 0.6)), 'arrow_points:size')};
xy = graph_layout(D.adj | D.adj');
ok = true;
for a = 1:D.m
    try
        arrow_points(xy(D.arcs(a, 1), :), xy(D.arcs(a, 2), :), 0.6, 0.12 * double(D.adj(D.arcs(a, 2), D.arcs(a, 1))));
    catch
        ok = false;
    end
end
c(end+1, :) = {'every one of the 8 arcs of the default layout can be drawn as an arrow', ok};

% --- digraph_options ---
o1 = digraph_options(D, 1);
c(end+1, :) = {'picture 1: title tells 8 arcs, 2 two-way and 4 one-way channels', strcmp(o1.title, 'The directed network: 8 arcs, 2 two-way and 4 one-way channels')};
c(end+1, :) = {'picture 1: the 4 one-way arcs (a3 a4 a5 a8) are blue and wide', all(o1.arc_width([3 4 5 8]) == 2) && all(o1.arc_width([1 2 6 7]) == 1.5) && isequal(o1.arc_color(3, :), [0.15 0.35 0.75]) && isequal(o1.arc_color(1, :), [0.35 0.35 0.35])};
o2 = digraph_options(D, 2);
c(end+1, :) = {'picture 2: arcs a1 a3 a6 a8 are the green path, 3 wide', isequal(find(o2.arc_width == 3), [1 3 6 8]) && isequal(o2.arc_color(1, :), [0.10 0.55 0.20])};
c(end+1, :) = {'picture 2: title says 4 arcs and no path back from Grace to Alice', strcmp(o2.title, 'Alice to Grace: 4 arcs (green); no path back from Grace to Alice')};
c(end+1, :) = {'picture 2: the path users are green', isequal(o2.vertex_color(1, :), [0.60 0.85 0.60]) && isequal(o2.vertex_color(6, :), [0.60 0.85 0.60]) && isequal(o2.vertex_color(3, :), [0.80 0.88 0.98])};
o3 = digraph_options(D, 3);
c(end+1, :) = {'picture 3: the 5 users of the big group have one color, Grace another', size(unique(o3.vertex_color(1:5, :), 'rows'), 1) == 1 && ~isequal(o3.vertex_color(6, :), o3.vertex_color(1, :))};
c(end+1, :) = {'picture 3: the arc between the groups (a8) is red and 3 wide', isequal(find(o3.arc_width == 3), 8) && isequal(o3.arc_color(8, :), [0.80 0.10 0.10])};
c(end+1, :) = {'picture 3: title says 2 groups and 1 arc between groups', strcmp(o3.title, 'Strongly connected groups: 2 (one color each), 1 arc between groups (red)')};
c(end+1, :) = {'every picture has an n by 3 vertex_color and an m by 3 arc_color', isequal(size(o1.vertex_color), [6 3]) && isequal(size(o2.arc_color), [8 3]) && numel(o3.arc_width) == 8};
c(end+1, :) = {'picture number 4 is refused with :number', strcmp(err_id(@() digraph_options(D, 4)), 'digraph_options:number')};
D4 = define_digraph(S, G, [1 2; 2 1; 2 4; 3 1; 4 3; 4 5; 5 4; 6 5]);
o = digraph_options(D4, 2);
c(end+1, :) = {'picture 2 when Grace sends but nobody sends to her: title says no path', strcmp(o.title, 'No path from Alice to Grace along the arcs')};
o = digraph_options(D2, 2);
c(end+1, :) = {'picture 2 when there is a way back: the title gives the number of arcs back', ~isempty(strfind(o.title, 'back: 4 arcs'))};
o = digraph_options(D2, 3);
c(end+1, :) = {'picture 3 for a strongly connected digraph: 1 group, 0 arcs between groups', ~isempty(strfind(o.title, '1 (one color each), 0 arcs'))};

% --- show_digraph (the printout) ---
txt = evalc('show_digraph(D)');
nyes = numel(strfind(txt, ': yes'));
c(end+1, :) = {'show_digraph: all 8 check lines say yes', nyes == 8 && isempty(strfind(txt, ': NO'))};
c(end+1, :) = {'show_digraph: it says the matrix is NOT symmetric', ~isempty(strfind(txt, 'The matrix is NOT symmetric'))};
c(end+1, :) = {'show_digraph: it prints the path Alice to Grace in 4 arcs', ~isempty(strfind(txt, 'Alice to Grace: Alice -> Bob -> Dave -> Frank -> Grace (4 arcs)'))};
c(end+1, :) = {'show_digraph: it prints no path from Grace to Alice', ~isempty(strfind(txt, 'Grace to Alice: no path'))};
c(end+1, :) = {'show_digraph: it prints the 2 strongly connected groups', ~isempty(strfind(txt, 'Strongly connected groups (every user in a group can reach every other user in it): 2'))};
c(end+1, :) = {'show_digraph: Grace can receive but cannot send', ~isempty(strfind(txt, 'Grace can receive but cannot send'))};
c(end+1, :) = {'show_digraph: it says the digraph is connected only without directions', ~isempty(strfind(txt, 'connected only when the directions are ignored'))};
txt2 = evalc('show_digraph(D2)');
c(end+1, :) = {'show_digraph with all channels two-way: symmetric and strongly connected, 8 yes', ~isempty(strfind(txt2, 'The matrix is symmetric')) && ~isempty(strfind(txt2, 'The digraph is strongly connected')) && numel(strfind(txt2, ': yes')) == 8};
txt3 = evalc('show_digraph(D3)');
c(end+1, :) = {'show_digraph with only one-way channels: 6 groups, 8 yes', ~isempty(strfind(txt3, 'groups (every user in a group can reach every other user in it): 6')) && numel(strfind(txt3, ': yes')) == 8};
txt4 = evalc('show_digraph()');
c(end+1, :) = {'show_digraph() with no argument prints the same as for the default digraph', strcmp(txt4, txt)};

summarize_checks('test_digraph', c);
end

function id = err_id(f)
% The identifier of the error raised by calling f ('' when there is no error).
id = '';
try
    f();
catch err
    id = err.identifier;
end
end

function M = strong_pairs(comp)
% The matrix that is true where two users are in the same group.
M = false(numel(comp), numel(comp));
for i = 1:numel(comp)
    for j = 1:numel(comp)
        M(i, j) = comp(i) == comp(j);
    end
end
end
