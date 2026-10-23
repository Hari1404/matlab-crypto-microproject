function test_graph_pictures()
% TEST_GRAPH_PICTURES Checks for the pictures of the network: places, picture options, drawing, PNG files and the demo.
% Every picture is saved in a temporary folder, never in the outputs folder of the project.
S = define_sets();
R = define_relations(S);
G = define_graph(S, R);
% mk makes a graph struct from user names and an edge list. near compares numbers with a tiny tolerance.
mk = @(names, E) struct('vertices', {names}, 'n', numel(names), 'm', size(E, 1), 'edges', E, 'adj', edges_to_adjacency(E, numel(names)));
near = @(a, b) isequal(size(a), size(b)) && (isempty(a) || max(abs(a(:) - b(:))) < 1e-9);
nfig = @() numel(findall(0, 'type', 'figure'));
blue = [0.80 0.88 0.98];
green = [0.60 0.85 0.60];
outputs_dir = fullfile(fileparts(which('setup_project')), 'outputs');
if exist(outputs_dir, 'dir')
    out_before = sort({dir(outputs_dir).name});
else
    out_before = {};
end
tmp_root = tempname();
% Au: users 1-2 and 3-4 joined, user 5 alone. Ap4: a path 1-2-3-4. Atri: a triangle. Ar4: a ring of 4.
% Ast: a star with centre 1 and 4 leaves. Ak4: all 4 users joined. Asq: a square and a triangle apart.
A = G.adj;
Au = edges_to_adjacency([1 2; 3 4], 5);
Ap4 = edges_to_adjacency([1 2; 2 3; 3 4], 4);
Atri = edges_to_adjacency([1 2; 2 3; 1 3], 3);
Ar4 = edges_to_adjacency([1 2; 2 3; 3 4; 1 4], 4);
Ast = edges_to_adjacency([1 2; 1 3; 1 4; 1 5], 5);
Ak4 = ~logical(eye(4));
Asq = edges_to_adjacency([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 5], 7);
mats = {A, Au, Ap4, Atri, Ar4, Ast, Ak4, Asq};
% Small graphs with user names, for the picture options and the drawing.
Gpath = mk({'P', 'Q', 'R', 'S'}, [1 2; 2 3; 3 4]);
Gsplit = mk({'A', 'B', 'C', 'D'}, [1 2; 3 4]);
Gnone = mk({'A', 'B', 'C'}, zeros(0, 2));
Gtri = mk({'A', 'B', 'C'}, [1 2; 1 3; 2 3]);
Gone = mk({'A'}, zeros(0, 2));
Gtwo = mk({'A', 'B'}, [1 2]);
Gpath3 = mk({'A', 'B', 'C'}, [1 2; 2 3]);
Gempty = struct('vertices', {{}}, 'n', 0, 'm', 0, 'edges', zeros(0, 2), 'adj', false(0, 0));
c = cell(0, 2);

% --- plural_s ---
c(end+1, :) = {'plural_s gives an empty text for 1', isempty(plural_s(1)) && ischar(plural_s(1))};
c(end+1, :) = {'plural_s gives s for 0 and for 2', strcmp(plural_s(0), 's') && strcmp(plural_s(2), 's')};

% --- path_to_edges ---
E = G.edges;
c(end+1, :) = {'the path Alice-Bob-Dave-Frank-Grace uses edges 1 3 5 6', isequal(path_to_edges(E, [1 2 4 5 6]), [1 3 5 6])};
c(end+1, :) = {'the same path read backwards uses edges 6 5 3 1', isequal(path_to_edges(E, [6 5 4 2 1]), [6 5 3 1])};
c(end+1, :) = {'the cycle 1 2 4 3 1 (first vertex repeated) uses edges 1 3 4 2', isequal(path_to_edges(E, [1 2 4 3 1]), [1 3 4 2])};
c(end+1, :) = {'the result is a row with one edge for each step', isequal(size(path_to_edges(E, [1 2 4])), [1 2])};
c(end+1, :) = {'a path with one vertex gives an empty row', isequal(size(path_to_edges(E, 3)), [1 0])};
c(end+1, :) = {'an empty path gives an empty row', isequal(size(path_to_edges(E, [])), [1 0])};
c(end+1, :) = {'two users that are not joined are rejected', raises_error(@() path_to_edges(E, [1 4]))};
c(end+1, :) = {'a path that leaves the network by a missing edge is rejected', raises_error(@() path_to_edges(E, [1 2 5]))};
c(end+1, :) = {'staying on one vertex is not an edge', raises_error(@() path_to_edges(E, [2 2]))};

% --- mark_edges ---
opts = struct('edge_color', repmat([0.35 0.35 0.35], 6, 1), 'edge_width', 1.5 * ones(1, 6), 'title', 'T');
o2 = mark_edges(opts, [2 5], [1 0 0], 4);
c(end+1, :) = {'mark_edges gives edges 2 and 5 the new color', isequal(o2.edge_color([2 5], :), [1 0 0; 1 0 0])};
c(end+1, :) = {'mark_edges gives edges 2 and 5 the new width', isequal(o2.edge_width([2 5]), [4 4])};
c(end+1, :) = {'mark_edges leaves the other colors and widths alone', isequal(o2.edge_color([1 3 4 6], :), opts.edge_color([1 3 4 6], :)) && isequal(o2.edge_width([1 3 4 6]), opts.edge_width([1 3 4 6]))};
c(end+1, :) = {'mark_edges keeps the other fields (the title)', strcmp(o2.title, 'T')};
c(end+1, :) = {'mark_edges with no edge numbers changes nothing', isequal(mark_edges(opts, zeros(1, 0), [1 0 0], 4), opts)};
c(end+1, :) = {'the order of the edge numbers does not matter', isequal(mark_edges(opts, [5 2], [1 0 0], 4), o2)};

% --- graph_layout: the places of the users ---
xy = graph_layout(A);
c(end+1, :) = {'the network of 6 users gets 6 places [x y]', isequal(size(xy), [6 2])};
c(end+1, :) = {'the places of the network are the layers 0, 2.4, 4.8, 7.2, 9.6 from Alice', near(xy, [0 0; 2.4 0.8; 2.4 -0.8; 4.8 0; 7.2 0; 9.6 0])};
c(end+1, :) = {'a path of 4 users is a straight line', near(graph_layout(Ap4), [0 0; 2.4 0; 4.8 0; 7.2 0])};
c(end+1, :) = {'a triangle: one user on the left, two under each other on the right', near(graph_layout(Atri), [0 0; 2.4 0.8; 2.4 -0.8])};
c(end+1, :) = {'a star: the 4 leaves are 1.6 apart in increasing order from the top', near(graph_layout(Ast), [0 0; 2.4 2.4; 2.4 0.8; 2.4 -0.8; 2.4 -2.4])};
c(end+1, :) = {'a ring of 4: the opposite user is in layer 2', near(graph_layout(Ar4), [0 0; 2.4 0.8; 4.8 0; 2.4 -0.8])};
c(end+1, :) = {'three groups are stacked from the top, 1.8 apart, the group of user 1 first', near(graph_layout(Au), [0 1.8; 2.4 1.8; 0 0; 2.4 0; 0 -1.8])};
c(end+1, :) = {'a square and a triangle apart are stacked and centered on y = 0', near(graph_layout(Asq), [0 1.7; 2.4 2.5; 4.8 1.7; 2.4 0.9; 0 -1.7; 2.4 -0.9; 2.4 -2.5])};
c(end+1, :) = {'users without channels are stacked 1.8 apart in one column', near(graph_layout(Gnone.adj), [0 1.8; 0 0; 0 -1.8])};
c(end+1, :) = {'one user is placed at [0 0]', near(graph_layout(false(1, 1)), [0 0])};
c(end+1, :) = {'no users give a 0 by 2 list', isequal(size(graph_layout(false(0, 0))), [0 2])};
c(end+1, :) = {'a matrix that is not square is rejected by graph_layout', raises_error(@() graph_layout(false(2, 3)))};
c(end+1, :) = {'the same matrix always gives the same places', isequal(graph_layout(A), graph_layout(A)) && isequal(graph_layout(Asq), graph_layout(Asq))};
ok_center = true;
ok_apart = true;
ok_layers = true;
for q = 1:numel(mats)
    M = mats{q};
    p = graph_layout(M);
    ok_center = ok_center && abs(max(p(:, 2)) + min(p(:, 2))) < 1e-9;
    for i = 1:size(M, 1)
        for j = (i + 1):size(M, 1)
            ok_apart = ok_apart && norm(p(i, :) - p(j, :)) > 1.6 - 1e-9;
        end
    end
    [comp, k] = connected_components(M);
    for g = 1:k
        members = find(comp == g);
        dist = bfs_search(M, members(1));
        ok_layers = ok_layers && near(p(members, 1)', 2.4 * dist(members));
    end
end
c(end+1, :) = {'in 8 different networks the drawing is centered on y = 0', ok_center};
c(end+1, :) = {'in 8 different networks no two circles touch (places at least 1.6 apart)', ok_apart};
c(end+1, :) = {'in 8 different networks x is 2.4 times the distance from the smallest user of the group', ok_layers};

% --- picture_options: the 5 pictures of the network ---
ok = true;
for k = 1:5
    o = picture_options(G, k);
    ok = ok && isequal(size(o.vertex_color), [6 3]) && isequal(size(o.edge_color), [6 3]) && numel(o.edge_width) == 6 && iscell(o.edge_style) && numel(o.edge_style) == 6;
    ok = ok && ischar(o.title) && ~isempty(o.title) && all(o.vertex_color(:) >= 0 & o.vertex_color(:) <= 1) && all(o.edge_color(:) >= 0 & o.edge_color(:) <= 1);
end
c(end+1, :) = {'each of the 5 option sets has the 6 colors, widths and styles that draw_network needs', ok};
t1 = picture_options(G, 1);
t2 = picture_options(G, 2);
t3 = picture_options(G, 3);
t4 = picture_options(G, 4);
t5 = picture_options(G, 5);
c(end+1, :) = {'title 1 is The communication network: users are vertices, channels are edges', strcmp(t1.title, 'The communication network: users are vertices, channels are edges')};
c(end+1, :) = {'title 2 is the shortest path Alice to Grace, length 4', strcmp(t2.title, 'Shortest path: Alice - Bob - Dave - Frank - Grace (length 4)')};
c(end+1, :) = {'title 3 is the shortest cycle, length 4', strcmp(t3.title, 'A shortest cycle: Alice - Bob - Dave - Carol - Alice (length 4)')};
c(end+1, :) = {'title 4 counts 2 bridge channels and 2 cut users', strcmp(t4.title, 'Weak points: 2 bridge channels (red), 2 cut users (orange)')};
c(end+1, :) = {'title 5 says channel Dave - Frank is removed and 2 groups remain', strcmp(t5.title, 'Channel Dave - Frank removed: 2 group(s) of users (one color each)')};
c(end+1, :) = {'picture 1 has the default colors, width 1.5 and solid lines', all(t1.edge_width == 1.5) && all(strcmp(t1.edge_style, '-')) && isequal(t1.vertex_color, repmat(blue, 6, 1)) && isequal(t1.edge_color, repmat([0.35 0.35 0.35], 6, 1))};
c(end+1, :) = {'picture 2 draws edges 1 3 5 6 wide, the other edges stay thin', isequal(find(t2.edge_width == 3), [1 3 5 6]) && all(t2.edge_width([2 4]) == 1.5)};
c(end+1, :) = {'picture 2 draws the path in green', isequal(t2.edge_color([1 3 5 6], :), repmat([0.10 0.55 0.20], 4, 1)) && isequal(t2.edge_color([2 4], :), repmat([0.35 0.35 0.35], 2, 1))};
c(end+1, :) = {'picture 2 colors the users on the path (all but Carol) green', isequal(find(all(t2.vertex_color == repmat(green, 6, 1), 2))', [1 2 4 5 6]) && isequal(t2.vertex_color(3, :), blue)};
c(end+1, :) = {'picture 3 draws the cycle edges 1 2 3 4 wide, in purple', isequal(find(t3.edge_width == 3), [1 2 3 4]) && isequal(t3.edge_color(1:4, :), repmat([0.45 0.20 0.70], 4, 1))};
c(end+1, :) = {'picture 3 colors the 4 users of the cycle purple and the others blue', isequal(find(all(t3.vertex_color == repmat([0.82 0.72 0.95], 6, 1), 2))', [1 2 3 4]) && isequal(t3.vertex_color(5:6, :), repmat(blue, 2, 1))};
c(end+1, :) = {'picture 4 draws the bridge channels 5 and 6 wide, in red', isequal(find(t4.edge_width == 3), [5 6]) && isequal(t4.edge_color(5:6, :), repmat([0.80 0.10 0.10], 2, 1))};
c(end+1, :) = {'picture 4 colors the cut users Dave and Frank orange and the others blue', isequal(find(all(t4.vertex_color == repmat([1.00 0.62 0.15], 6, 1), 2))', [4 5]) && isequal(t4.vertex_color([1 2 3 6], :), repmat(blue, 4, 1))};
c(end+1, :) = {'picture 5 draws only the removed channel (edge 5) dotted and gray', isequal(find(strcmp(t5.edge_style, ':')), 5) && isequal(t5.edge_color(5, :), [0.55 0.55 0.55]) && t5.edge_width(5) == 1.5};
c(end+1, :) = {'picture 5 gives each group of users its own color', isequal(t5.vertex_color(1, :), t5.vertex_color(4, :)) && isequal(t5.vertex_color(5, :), t5.vertex_color(6, :)) && ~isequal(t5.vertex_color(1, :), t5.vertex_color(5, :))};
c(end+1, :) = {'picture number 0 is rejected', raises_error(@() picture_options(G, 0))};
c(end+1, :) = {'picture number 6 is rejected', raises_error(@() picture_options(G, 6))};
c(end+1, :) = {'picture number 1.5 is rejected', raises_error(@() picture_options(G, 1.5))};

% --- picture_options: special networks ---
p2 = picture_options(Gpath, 2);
p3 = picture_options(Gpath, 3);
p4 = picture_options(Gpath, 4);
p5 = picture_options(Gpath, 5);
c(end+1, :) = {'path of 4 users: picture 2 shows the path P to S of length 3', strcmp(p2.title, 'Shortest path: P - Q - R - S (length 3)')};
c(end+1, :) = {'a tree has no cycle: picture 3 says so and marks nothing', strcmp(p3.title, 'The network has no cycle (it is a tree or a forest)') && all(p3.edge_width == 1.5) && isequal(p3.vertex_color, repmat(blue, 4, 1))};
c(end+1, :) = {'path of 4 users: picture 4 has 3 bridge channels and 2 cut users', strcmp(p4.title, 'Weak points: 3 bridge channels (red), 2 cut users (orange)') && all(p4.edge_width == 3) && isequal(find(all(p4.vertex_color == repmat([1.00 0.62 0.15], 4, 1), 2))', [2 3])};
c(end+1, :) = {'path of 4 users: picture 5 removes the first bridge P - Q and shows 2 groups', strcmp(p5.title, 'Channel P - Q removed: 2 group(s) of users (one color each)') && isequal(find(strcmp(p5.edge_style, ':')), 1)};
s2 = picture_options(Gsplit, 2);
s5 = picture_options(Gsplit, 5);
c(end+1, :) = {'split network: picture 2 says there is no path from A to D', strcmp(s2.title, 'No path from A to D: they are in different groups of users')};
c(end+1, :) = {'split network: picture 2 marks no edge and colors only A and D green', all(s2.edge_width == 1.5) && isequal(find(all(s2.vertex_color == repmat(green, 4, 1), 2))', [1 4])};
c(end+1, :) = {'split network: picture 5 removes A - B and shows 3 groups', strcmp(s5.title, 'Channel A - B removed: 3 group(s) of users (one color each)')};
n1 = picture_options(Gnone, 1);
n4 = picture_options(Gnone, 4);
n5 = picture_options(Gnone, 5);
c(end+1, :) = {'no channels: the option lists for the edges are empty', isempty(n1.edge_width) && isempty(n1.edge_style) && isequal(size(n1.edge_color), [0 3])};
c(end+1, :) = {'no channels: picture 4 has 0 bridge channels and 0 cut users', strcmp(n4.title, 'Weak points: 0 bridge channels (red), 0 cut users (orange)')};
c(end+1, :) = {'no channels: picture 5 says there is no channel to remove', strcmp(n5.title, 'No channel to remove: the network has no channels')};
r3 = picture_options(Gtri, 3);
r4 = picture_options(Gtri, 4);
r5 = picture_options(Gtri, 5);
c(end+1, :) = {'triangle: picture 3 is the cycle A - B - C - A of length 3, all 3 edges wide', strcmp(r3.title, 'A shortest cycle: A - B - C - A (length 3)') && all(r3.edge_width == 3)};
c(end+1, :) = {'triangle: picture 4 has no weak point', strcmp(r4.title, 'Weak points: 0 bridge channels (red), 0 cut users (orange)') && all(r4.edge_width == 1.5)};
c(end+1, :) = {'triangle: picture 5 removes the first channel and one group remains', strcmp(r5.title, 'Channel A - B removed: 1 group(s) of users (one color each)') && isequal(find(strcmp(r5.edge_style, ':')), 1)};
o1a = picture_options(Gone, 2);
o1b = picture_options(Gone, 3);
o1c = picture_options(Gone, 5);
c(end+1, :) = {'one user: picture 2 is the path A of length 0', strcmp(o1a.title, 'Shortest path: A (length 0)')};
c(end+1, :) = {'one user: picture 3 has no cycle and picture 5 has no channel to remove', strcmp(o1b.title, 'The network has no cycle (it is a tree or a forest)') && strcmp(o1c.title, 'No channel to remove: the network has no channels')};
w4 = picture_options(Gtwo, 4);
x4 = picture_options(Gpath3, 4);
c(end+1, :) = {'one channel is written as 1 bridge channel, with no s', strcmp(w4.title, 'Weak points: 1 bridge channel (red), 0 cut users (orange)')};
c(end+1, :) = {'one cut user is written as 1 cut user, with no s', strcmp(x4.title, 'Weak points: 2 bridge channels (red), 1 cut user (orange)')};

% --- draw_network ---
fig = figure('Visible', 'off');
ax = axes('Parent', fig);
h = draw_network(ax, G, xy, t2);
c(end+1, :) = {'draw_network keeps one handle for each channel, channel name, user and user name', iscell(h.edge) && iscell(h.edge_label) && iscell(h.vertex) && iscell(h.vertex_label) && numel(h.edge) == 6 && numel(h.edge_label) == 6 && numel(h.vertex) == 6 && numel(h.vertex_label) == 6};
ok = ishghandle(h.title);
for k = 1:6
    ok = ok && ishghandle(h.edge{k}) && ishghandle(h.edge_label{k}) && ishghandle(h.vertex{k}) && ishghandle(h.vertex_label{k});
end
c(end+1, :) = {'all handles are valid graphics objects', ok};
c(end+1, :) = {'the axes hold 24 objects: 6 lines, 6 circles, 6 user names, 6 channel names', numel(get(ax, 'Children')) == 24};
ok_geo = true;
ok_sty = true;
ok_circle = true;
ok_label = true;
ok_text = true;
for e = 1:6
    i = G.edges(e, 1);
    j = G.edges(e, 2);
    ok_geo = ok_geo && near(get(h.edge{e}, 'XData'), [xy(i, 1) xy(j, 1)]) && near(get(h.edge{e}, 'YData'), [xy(i, 2) xy(j, 2)]);
    ok_sty = ok_sty && near(get(h.edge{e}, 'Color'), t2.edge_color(e, :)) && get(h.edge{e}, 'LineWidth') == t2.edge_width(e) && strcmp(get(h.edge{e}, 'LineStyle'), t2.edge_style{e});
    mid = (xy(i, :) + xy(j, :)) / 2;
    d = xy(j, :) - xy(i, :);
    pos = get(h.edge_label{e}, 'Position');
    w = pos(1:2) - mid;
    ok_label = ok_label && abs(norm(w) - 0.3) < 1e-9 && abs(w * d') < 1e-9 && w(2) > 0;
    ok_text = ok_text && strcmp(get(h.edge_label{e}, 'String'), sprintf('e%d', e));
end
for v = 1:6
    cx = get(h.vertex{v}, 'XData');
    cy = get(h.vertex{v}, 'YData');
    ok_circle = ok_circle && numel(cx) == 61 && near([(max(cx) + min(cx)) / 2, (max(cy) + min(cy)) / 2], xy(v, :)) && abs((max(cx) - min(cx)) - 1.2) < 1e-9 && abs((max(cy) - min(cy)) - 1.2) < 1e-9;
    ok_circle = ok_circle && near(get(h.vertex{v}, 'FaceColor'), t2.vertex_color(v, :));
    pos = get(h.vertex_label{v}, 'Position');
    ok_text = ok_text && strcmp(get(h.vertex_label{v}, 'String'), G.vertices{v}) && near(pos(1:2), xy(v, :));
end
c(end+1, :) = {'each line runs from one user to the other', ok_geo};
c(end+1, :) = {'each line has the color, width and style of the options', ok_sty};
c(end+1, :) = {'each circle has radius 0.6, its center on the place of the user and the color of the options', ok_circle};
c(end+1, :) = {'each channel name sits 0.3 above the middle of its line, at a right angle to it', ok_label};
c(end+1, :) = {'the channels are named e1 to e6 and the circles carry the user names', ok_text};
c(end+1, :) = {'the limits are the places plus 1.1 on each side', near(h.xlim, [-1.1 10.7]) && near(h.ylim, [-1.9 1.9])};
c(end+1, :) = {'the title is the text of the options', strcmp(get(h.title, 'String'), t2.title)};
cla(ax);
h5 = draw_network(ax, G, xy, t5);
ok = true;
for e = 1:6
    ok = ok && strcmp(get(h5.edge{e}, 'LineStyle'), t5.edge_style{e});
end
c(end+1, :) = {'picture 5 draws the removed channel dotted and the other channels solid', ok && strcmp(get(h5.edge{5}, 'LineStyle'), ':') && strcmp(get(h5.edge{1}, 'LineStyle'), '-')};
cla(ax);
hd = draw_network(ax, G, xy);
c(end+1, :) = {'without options there is no title', isempty(hd.title)};
c(end+1, :) = {'without options the lines are gray with width 1.5 and the circles light blue', near(get(hd.edge{1}, 'Color'), [0.35 0.35 0.35]) && get(hd.edge{1}, 'LineWidth') == 1.5 && near(get(hd.vertex{1}, 'FaceColor'), blue)};
cla(ax);
hp = draw_network(ax, G, xy, struct('edge_width', 5 * ones(1, 6)));
c(end+1, :) = {'an option that is given is used and the others stay at their default', get(hp.edge{4}, 'LineWidth') == 5 && near(get(hp.vertex{3}, 'FaceColor'), blue) && isempty(hp.title)};
c(end+1, :) = {'xy with the wrong number of rows is rejected', raises_error(@() draw_network(ax, G, xy(1:3, :)))};
c(end+1, :) = {'a vertex_color list of the wrong size is rejected', raises_error(@() draw_network(ax, G, xy, struct('vertex_color', ones(2, 3))))};
c(end+1, :) = {'an edge_color list of the wrong size is rejected', raises_error(@() draw_network(ax, G, xy, struct('edge_color', ones(2, 3))))};
c(end+1, :) = {'an edge_width list of the wrong size is rejected', raises_error(@() draw_network(ax, G, xy, struct('edge_width', ones(1, 2))))};
c(end+1, :) = {'an edge_style list with too few texts is rejected', raises_error(@() draw_network(ax, G, xy, struct('edge_style', {{'-'}})))};
c(end+1, :) = {'an edge_style that is not a cell array is rejected', raises_error(@() draw_network(ax, G, xy, struct('edge_style', '------')))};
cla(ax);
ht = draw_network(ax, Gtri, graph_layout(Gtri.adj), picture_options(Gtri, 1));
pos = get(ht.edge_label{3}, 'Position');
c(end+1, :) = {'the name of a vertical channel is put to the right of the line', near(pos(1:2), [2.7 0])};
cla(ax);
hn = draw_network(ax, Gnone, graph_layout(Gnone.adj), picture_options(Gnone, 1));
c(end+1, :) = {'a network without channels draws 3 circles and 3 user names and no line', isempty(hn.edge) && numel(hn.vertex) == 3 && numel(get(ax, 'Children')) == 6};
cla(ax);
h1 = draw_network(ax, Gone, [0 0]);
c(end+1, :) = {'one user at [0 0] gives the limits -1.1 to 1.1', near(h1.xlim, [-1.1 1.1]) && near(h1.ylim, [-1.1 1.1])};
cla(ax);
he = draw_network(ax, Gempty, zeros(0, 2));
c(end+1, :) = {'an empty network gives the limits -1 to 1 and draws nothing', near(he.xlim, [-1 1]) && near(he.ylim, [-1 1]) && isempty(get(ax, 'Children'))};
close(fig);

% --- save_network_pictures: the PNG files ---
n_open = nfig();
dgood = fullfile(tmp_root, 'new_folder', 'pictures');
[files, titles] = save_network_pictures(G, dgood, 'off');
c(end+1, :) = {'a folder that does not exist is made', exist(dgood, 'dir') == 7};
c(end+1, :) = {'there are 5 file names and 5 titles, each in a 5 by 1 cell array', iscell(files) && iscell(titles) && isequal(size(files), [5 1]) && isequal(size(titles), [5 1])};
want = {'point2_network.png'; 'point2_shortest_path.png'; 'point2_cycle.png'; 'point2_weak_points.png'; 'point2_split.png'};
ok = true;
ok_titles = true;
for k = 1:5
    [fp, fn, fe] = fileparts(files{k});
    ok = ok && strcmp([fn fe], want{k}) && strcmp(fp, dgood);
    o = picture_options(G, k);
    ok_titles = ok_titles && strcmp(titles{k}, o.title);
end
c(end+1, :) = {'the files are point2_network, shortest_path, cycle, weak_points and split, all in the given folder', ok};
c(end+1, :) = {'the titles are the titles of the 5 option sets', ok_titles};
names = {dir(dgood).name};
names = names(~ismember(names, {'.', '..'}));
c(end+1, :) = {'the folder holds exactly the 5 PNG files', numel(names) == 5 && numel(dir(fullfile(dgood, '*.png'))) == 5};
[e1, p1, d1] = check_picture_files(files);
c(end+1, :) = {'all 5 files exist and are not empty', e1};
c(end+1, :) = {'all 5 files start with the PNG signature', p1};
c(end+1, :) = {'the 5 pictures are all different from each other', d1};
ok = true;
for k = 1:5
    fid = fopen(files{k}, 'r');
    b = fread(fid, 24, 'uint8')';
    fclose(fid);
    if numel(b) == 24 && strcmp(char(b(13:16)), 'IHDR')
        pw = b(17:20) * [2^24; 2^16; 2^8; 1];
        ph = b(21:24) * [2^24; 2^16; 2^8; 1];
        ok = ok && pw >= 100 && ph >= 100;
    else
        ok = false;
    end
end
c(end+1, :) = {'each PNG is at least 100 pixels wide and 100 pixels high', ok};
c(end+1, :) = {'the 5 figures are closed again (visible = off)', nfig() == n_open};
[files2, titles2] = save_network_pictures(G, dgood);
[e2, p2f, d2f] = check_picture_files(files2);
names2 = {dir(dgood).name};
names2 = names2(~ismember(names2, {'.', '..'}));
c(end+1, :) = {'without the third argument the pictures are saved and the figures closed', isequal(files2, files) && isequal(titles2, titles) && e2 && p2f && d2f && nfig() == n_open};
c(end+1, :) = {'saving again into the same folder overwrites: still exactly 5 files', numel(names2) == 5};
dbad = fullfile(tmp_root, 'never_made');
c(end+1, :) = {'a visible value other than on or off is rejected', raises_error(@() save_network_pictures(G, dbad, 'maybe'))};
c(end+1, :) = {'a visible value that is not text is rejected', raises_error(@() save_network_pictures(G, dbad, 1))};
c(end+1, :) = {'a network without users is rejected', raises_error(@() save_network_pictures(Gempty, dbad, 'off'))};
c(end+1, :) = {'after these errors no folder was made and no figure is left open', exist(dbad, 'dir') ~= 7 && nfig() == n_open};
small = {Gone, Gnone, Gpath};
small_text = {'one user and no channel', 'three users and no channel', 'a path of 4 users (a tree)'};
for q = 1:3
    [fs, ts] = save_network_pictures(small{q}, fullfile(tmp_root, sprintf('small%d', q)), 'off');
    [es, ps, ds] = check_picture_files(fs);
    ok = es && ps && ds && nfig() == n_open;
    for k = 1:5
        o = picture_options(small{q}, k);
        ok = ok && strcmp(ts{k}, o.title);
    end
    c(end+1, :) = {['all 5 pictures are saved for ' small_text{q}], ok};
end

% --- check_picture_files ---
dchk = fullfile(tmp_root, 'check');
mkdir(dchk);
fa = fullfile(dchk, 'a.png');
fb = fullfile(dchk, 'b.png');
ft = fullfile(dchk, 'text.png');
fe0 = fullfile(dchk, 'empty.png');
fs3 = fullfile(dchk, 'short.png');
fmiss = fullfile(dchk, 'missing.png');
copyfile(files{1}, fa);
copyfile(files{1}, fb);
fid = fopen(ft, 'w');
fprintf(fid, 'hello world, this is not a png');
fclose(fid);
fid = fopen(fe0, 'w');
fclose(fid);
fid = fopen(fs3, 'w');
fprintf(fid, 'abc');
fclose(fid);
[x1, x2, x3] = check_picture_files({fa, files{2}});
c(end+1, :) = {'two different PNG files: yes, yes, yes', isequal([x1 x2 x3], [1 1 1])};
[x1, x2, x3] = check_picture_files({fa, fb});
c(end+1, :) = {'two copies of the same picture: files and PNG fine, but not different', isequal([x1 x2 x3], [1 1 0])};
[x1, x2, x3] = check_picture_files({fa, fmiss});
c(end+1, :) = {'a missing file: it does not exist and is not a PNG', x1 == false && x2 == false};
[x1, x2, x3] = check_picture_files({fa, ft});
c(end+1, :) = {'a text file with the name .png: it exists but is not a PNG', x1 == true && x2 == false && x3 == true};
[x1, x2, x3] = check_picture_files({fa, fe0});
c(end+1, :) = {'an empty file does not count as written and is not a PNG', x1 == false && x2 == false};
[x1, x2, x3] = check_picture_files({fa, fs3});
c(end+1, :) = {'a file shorter than the 8 signature bytes is not a PNG', x1 == true && x2 == false};
[x1, x2, x3] = check_picture_files({});
c(end+1, :) = {'an empty list of files gives yes for all three questions', isequal([x1 x2 x3], [1 1 1])};
[x1, x2, x3] = check_picture_files({fa});
c(end+1, :) = {'one PNG file alone gives yes for all three questions', isequal([x1 x2 x3], [1 1 1])};

% --- the demo ---
ddemo = fullfile(tmp_root, 'demo');
txt = evalc('demo_point2(ddemo, ''off'')');
c(end+1, :) = {'demo_point2 still prints the title, the graph and the analysis', ~isempty(strfind(txt, 'POINT 2 DEMO: THE GRAPH NETWORK')) && ~isempty(strfind(txt, 'ANALYSIS OF THE COMMUNICATION NETWORK'))};
c(end+1, :) = {'demo_point2 prints the pictures part and the folder it saved in', ~isempty(strfind(txt, '=== PICTURES OF THE COMMUNICATION NETWORK ===')) && ~isempty(strfind(txt, ddemo))};
ok = true;
for k = 1:5
    o = picture_options(G, k);
    ok = ok && ~isempty(strfind(txt, want{k})) && ~isempty(strfind(txt, o.title));
end
c(end+1, :) = {'demo_point2 lists the 5 file names, each with its title', ok};
c(end+1, :) = {'demo_point2 says the figure windows are closed when visible is off', ~isempty(strfind(txt, 'the figure windows are closed'))};
pos = strfind(txt, 'Checks:');
tail = txt(pos(end):end);
c(end+1, :) = {'demo_point2 ends with 3 picture checks that all say yes', numel(strfind(tail, ': yes')) == 3 && isempty(strfind(tail, ': NO'))};
c(end+1, :) = {'no check line in the whole demo says NO and there are 3 Checks parts', isempty(strfind(txt, ': NO')) && numel(strfind(txt, 'Checks:')) == 3};
c(end+1, :) = {'demo_point2 wrote the 5 pictures into the folder it was given', numel(dir(fullfile(ddemo, '*.png'))) == 5};
c(end+1, :) = {'demo_point2 with visible off leaves no figure open', nfig() == n_open};

% --- the tests leave no trace in the project ---
if exist(outputs_dir, 'dir')
    out_after = sort({dir(outputs_dir).name});
else
    out_after = {};
end
c(end+1, :) = {'the tests wrote nothing into the outputs folder of the project', isequal(out_before, out_after)};
rmdir(tmp_root, 's');

summarize_checks('test_graph_pictures', c);
end
