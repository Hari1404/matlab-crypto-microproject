function test_route_picture()
% TEST_ROUTE_PICTURE Checks for route_picture_options, draw_route_picture, show_route_picture and option 7 of main_demo.
% Every picture is saved in a temporary folder, never in the outputs folder of the project, and no window stays open.
Y = define_system();
E = Y.G.edges;
c = cell(0, 2);
nl = char(10);
has = @(t, s) ~isempty(strfind(t, s));
near = @(a, b) isequal(size(a), size(b)) && (isempty(a) || max(abs(a(:) - b(:))) < 1e-9);
nfig = @() numel(findall(0, 'type', 'figure'));
n_open = nfig();
root = fileparts(fileparts(fileparts(which('main_demo'))));
outputs_dir = fullfile(root, 'outputs');
out_before = dir(outputs_dir);
tmp_root = tempname();
% the colors that the packet fixes
blue = [0.80 0.88 0.98];
lgreen = [0.60 0.85 0.60];
dgreen = [0.35 0.72 0.40];
egreen = [0.10 0.55 0.20];
egray = [0.35 0.35 0.35];
bgray = [0.55 0.55 0.55];
shades = [0.80 0.88 0.98; 0.80 0.92 0.80; 1.00 0.92 0.70; 0.95 0.80 0.90; 0.88 0.84 0.96; 0.85 0.85 0.85];
rows = @(M, ids) all(all(abs(M(ids, :) - repmat(M(ids(1), :), numel(ids), 1)) < 1e-9));
same = @(M, ids, col) ~isempty(ids) && rows(M, ids) && near(M(ids(1), :), col);
% Yb: Dave - Frank (e5) is broken. Y5: only Frank - Grace (e6) works. Y0: all channels are broken.
Yb = Y;
Yb.A = remove_channel(Y.A, 4, 5);
Y5 = Y;
Y0 = Y;
for e = 1:5
    Y5.A = remove_channel(Y5.A, E(e, 1), E(e, 2));
end
for e = 1:6
    Y0.A = remove_channel(Y0.A, E(e, 1), E(e, 2));
end
R16 = route_message('Hi', 1, 6, Y);
R61 = route_message('Hi', 6, 1, Y);
R12 = route_message('Hi', 1, 2, Y);
R13 = route_message('Hi', 1, 3, Y);
R16b = route_message('Hi', 1, 6, Yb);
R23b = route_message('Hi', 2, 3, Yb);

% --- route_picture_options: no route to show ---
o = route_picture_options(Y, []);
c(end+1, :) = {'options: the fields have the right sizes (6 users, 6 channels)', isequal(size(o.vertex_color), [6 3]) && isequal(size(o.edge_color), [6 3]) && isequal(size(o.edge_width), [1 6]) && iscell(o.edge_style) && numel(o.edge_style) == 6 && ischar(o.title)};
c(end+1, :) = {'options without a route and without a break: all channels gray, solid, width 1.5', same(o.edge_color, 1:6, egray) && all(o.edge_width == 1.5) && all(strcmp(o.edge_style, '-'))};
c(end+1, :) = {'options without a route and without a break: all users blue (one group)', same(o.vertex_color, 1:6, blue)};
c(end+1, :) = {'options without a route and without a break: the title counts the channels and the group', strcmp(o.title, 'The network now: 6 working channels, 0 broken, 1 group of users')};
o = route_picture_options(Yb, []);
c(end+1, :) = {'options after Dave - Frank broke: e5 is dotted and lighter gray, the others stay solid gray', near(o.edge_color(5, :), bgray) && strcmp(o.edge_style{5}, ':') && o.edge_width(5) == 1.5 && same(o.edge_color, [1 2 3 4 6], egray) && all(strcmp(o.edge_style([1 2 3 4 6]), '-'))};
c(end+1, :) = {'options after Dave - Frank broke: 2 groups with 2 colors', same(o.vertex_color, 1:4, shades(1, :)) && same(o.vertex_color, 5:6, shades(2, :))};
c(end+1, :) = {'options after Dave - Frank broke: the title says 5 working, 1 broken, 2 groups', strcmp(o.title, 'The network now: 5 working channels, 1 broken, 2 groups of users')};
o = route_picture_options(Y5, []);
c(end+1, :) = {'options with only 1 channel working: 1 channel and 5 groups are written without extra s for the channel', strcmp(o.title, 'The network now: 1 working channel, 5 broken, 5 groups of users')};
c(end+1, :) = {'options with 5 groups: users 1 to 4 have the shades 1 to 4 and Frank and Grace the shade 5', near(o.vertex_color(1, :), shades(1, :)) && near(o.vertex_color(2, :), shades(2, :)) && near(o.vertex_color(3, :), shades(3, :)) && near(o.vertex_color(4, :), shades(4, :)) && same(o.vertex_color, 5:6, shades(5, :))};
o = route_picture_options(Y0, []);
c(end+1, :) = {'options with every channel broken: 0 working, 6 broken, 6 groups, 6 different colors', strcmp(o.title, 'The network now: 0 working channels, 6 broken, 6 groups of users') && size(unique(o.vertex_color, 'rows'), 1) == 6 && all(strcmp(o.edge_style, ':'))};

% --- route_picture_options: a route ---
o = route_picture_options(Y, R16);
c(end+1, :) = {'options for Alice to Grace: channels e1 e3 e5 e6 are thick and green', same(o.edge_color, [1 3 5 6], egreen) && all(o.edge_width([1 3 5 6]) == 3) && all(strcmp(o.edge_style([1 3 5 6]), '-'))};
c(end+1, :) = {'options for Alice to Grace: e2 and e4 stay gray, solid, width 1.5', same(o.edge_color, [2 4], egray) && all(o.edge_width([2 4]) == 1.5) && all(strcmp(o.edge_style([2 4]), '-'))};
c(end+1, :) = {'options for Alice to Grace: sender and receiver dark green', same(o.vertex_color, [1 6], dgreen)};
c(end+1, :) = {'options for Alice to Grace: Bob, Dave and Frank light green, Carol blue', same(o.vertex_color, [2 4 5], lgreen) && near(o.vertex_color(3, :), blue)};
c(end+1, :) = {'options for Alice to Grace: the title names the route and the 4 channels', strcmp(o.title, 'Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)')};
o = route_picture_options(Y, R61);
c(end+1, :) = {'options for Grace to Alice: the same channels, the reverse route in the title', same(o.edge_color, [1 3 5 6], egreen) && strcmp(o.title, 'Grace to Alice: Grace - Frank - Dave - Bob - Alice (4 channels)') && same(o.vertex_color, [1 6], dgreen)};
o = route_picture_options(Y, R12);
c(end+1, :) = {'options for neighbours Alice and Bob: only e1 is green, 1 channel, nobody light green', same(o.edge_color, 1, egreen) && same(o.edge_color, 2:6, egray) && strcmp(o.title, 'Alice to Bob: Alice - Bob (1 channel)') && same(o.vertex_color, [1 2], dgreen) && same(o.vertex_color, 3:6, blue)};
o = route_picture_options(Y, R13);
c(end+1, :) = {'options for Alice to Carol: only e2 is green', same(o.edge_color, 2, egreen) && same(o.edge_color, [1 3 4 5 6], egray)};
ids = path_to_edges(E, R23b.path);
o = route_picture_options(Yb, R23b);
others = setdiff(1:6, [ids 5]);
c(end+1, :) = {'options for Bob to Carol with e5 broken: the channels of the route are green', same(o.edge_color, ids, egreen) && all(o.edge_width(ids) == 3) && numel(ids) == 2};
c(end+1, :) = {'options for Bob to Carol with e5 broken: e5 is still dotted gray and the other channels are plain', near(o.edge_color(5, :), bgray) && strcmp(o.edge_style{5}, ':') && same(o.edge_color, others, egray) && all(o.edge_width(others) == 1.5)};
c(end+1, :) = {'options for Bob to Carol with e5 broken: users off the route are blue, not group colors', same(o.vertex_color, [5 6], blue) && same(o.vertex_color, R23b.path([1 end]), dgreen) && strcmp(o.title, sprintf('Bob to Carol: %s (2 channels)', format_names(Y.users, R23b.path, ' - ')))};

% --- route_picture_options: no route ---
o = route_picture_options(Yb, R16b);
c(end+1, :) = {'options for Alice to Grace with e5 broken: the title says there is no route', strcmp(o.title, 'No route from Alice to Grace: they are in different groups of users')};
c(end+1, :) = {'options with no route: group colors, e5 dotted, no green channel', same(o.vertex_color, 1:4, shades(1, :)) && same(o.vertex_color, 5:6, shades(2, :)) && near(o.edge_color(5, :), bgray) && strcmp(o.edge_style{5}, ':') && same(o.edge_color, [1 2 3 4 6], egray) && all(o.edge_width == 1.5)};

% --- route_picture_options: wrong use ---
Y2 = Y;
Y2.A = remove_channel(Y.A, 2, 4);
try
    route_picture_options(Y2, R16);
    errid = '';
catch err
    errid = err.identifier;
end
c(end+1, :) = {'options: a route through a broken channel is refused as out of date', strcmp(errid, 'route_picture_options:stale')};
Rbad = R16;
Rbad.i = 0;
Rbad2 = R16;
Rbad2.path = [2 4 5 6];
Rbad3 = rmfield(R16, 'hops');
c(end+1, :) = {'options: bad routes are refused (a number, a text, a struct without fields, i = 0, a path that does not start at the sender)', raises_error(@() route_picture_options(Y, 5)) && raises_error(@() route_picture_options(Y, 'x')) && raises_error(@() route_picture_options(Y, struct('a', 1))) && raises_error(@() route_picture_options(Y, Rbad)) && raises_error(@() route_picture_options(Y, Rbad2)) && raises_error(@() route_picture_options(Y, Rbad3))};
c(end+1, :) = {'options: a system that is not a proper system is refused', raises_error(@() route_picture_options(5, [])) && raises_error(@() route_picture_options(rmfield(Y, 'A'), []))};
Ycopy = Y;
Rcopy = R16;
route_picture_options(Y, R16);
c(end+1, :) = {'options do not change the system or the route and open no figure', isequal(Y, Ycopy) && isequal(R16, Rcopy) && nfig() == n_open};

% --- draw_route_picture ---
xy = graph_layout(Y.G.adj);
fig = figure('Visible', 'off');
ax = axes('Parent', fig);
[h, op] = draw_route_picture(ax, Y, R16);
ok_col = true;
ok_geo = true;
for e = 1:6
    ok_col = ok_col && near(get(h.edge{e}, 'Color'), op.edge_color(e, :)) && get(h.edge{e}, 'LineWidth') == op.edge_width(e) && strcmp(get(h.edge{e}, 'LineStyle'), op.edge_style{e});
    ok_geo = ok_geo && near(get(h.edge{e}, 'XData'), [xy(E(e, 1), 1) xy(E(e, 2), 1)]) && near(get(h.edge{e}, 'YData'), [xy(E(e, 1), 2) xy(E(e, 2), 2)]);
end
ok_fill = true;
for v = 1:6
    ok_fill = ok_fill && near(get(h.vertex{v}, 'FaceColor'), op.vertex_color(v, :)) && strcmp(get(h.vertex_label{v}, 'String'), Y.users{v});
end
c(end+1, :) = {'draw_route_picture draws the channels with the colors, widths and styles of the options', ok_col};
c(end+1, :) = {'draw_route_picture puts the users at the places of graph_layout of the whole network', ok_geo};
c(end+1, :) = {'draw_route_picture fills the circles with the user colors and writes the names', ok_fill};
c(end+1, :) = {'draw_route_picture writes the title of the options', strcmp(get(h.title, 'String'), 'Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)') && isequaln(op, route_picture_options(Y, R16))};
close(fig);
fig = figure('Visible', 'off');
ax = axes('Parent', fig);
hb = draw_route_picture(ax, Yb, []);
ok_same = true;
for e = 1:6
    ok_same = ok_same && near(get(hb.edge{e}, 'XData'), [xy(E(e, 1), 1) xy(E(e, 2), 1)]) && near(get(hb.edge{e}, 'YData'), [xy(E(e, 1), 2) xy(E(e, 2), 2)]);
end
c(end+1, :) = {'draw_route_picture: the users stay at the same places when a channel is broken', ok_same && near(hb.xlim, h.xlim) && near(hb.ylim, h.ylim)};
c(end+1, :) = {'draw_route_picture: the broken channel is drawn dotted and the title counts the groups', strcmp(get(hb.edge{5}, 'LineStyle'), ':') && strcmp(get(hb.title, 'String'), 'The network now: 5 working channels, 1 broken, 2 groups of users')};
close(fig);
c(end+1, :) = {'draw_route_picture: no figure is left open after the test closes its own', nfig() == n_open};

% --- show_route_picture ---
d1 = fullfile(tmp_root, 'new_folder', 'pictures');
[f1, t1, g1] = show_route_picture(Y, R16, 'off', d1);
[e1, p1, ~] = check_picture_files({f1});
c(end+1, :) = {'show_route_picture: the folder is made and point5_route.png is a PNG file', exist(d1, 'dir') == 7 && strcmp(f1, fullfile(d1, 'point5_route.png')) && e1 && p1};
c(end+1, :) = {'show_route_picture: the title is the title of the options and visible off closes the figure', strcmp(t1, 'Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)') && isempty(g1) && nfig() == n_open};
d2 = fullfile(tmp_root, 'second');
f2 = show_route_picture(Yb, R16b, 'off', d2);
d3 = fullfile(tmp_root, 'third');
f3 = show_route_picture(Yb, [], 'off', d3);
[e2, p2, df] = check_picture_files({f1, f2, f3});
c(end+1, :) = {'show_route_picture: a route, no route and the plain network give 3 different PNG files', e2 && p2 && df};
d4 = fullfile(tmp_root, 'again');
f4 = show_route_picture(Y, R16, 'off', d4);
im1 = double(imread(f1));
im4 = double(imread(f4));
same_picture = isequal(size(im1), size(im4)) && mean(abs(im1(:) - im4(:))) < 0.5;
c(end+1, :) = {'show_route_picture: the same input gives the same picture', same_picture};
d5 = fullfile(tmp_root, 'old');
mkdir(d5);
fid = fopen(fullfile(d5, 'point5_route.png'), 'w');
fprintf(fid, 'old');
fclose(fid);
f5 = show_route_picture(Y, R16, 'off', d5);
[e5, p5, ~] = check_picture_files({f5});
c(end+1, :) = {'show_route_picture replaces an older file with the same name', e5 && p5};
dbad = fullfile(tmp_root, 'never_made');
c(end+1, :) = {'show_route_picture: visible must be on or off', raises_error(@() show_route_picture(Y, R16, 'maybe', dbad)) && raises_error(@() show_route_picture(Y, R16, 1, dbad))};
c(end+1, :) = {'show_route_picture: outdir must be a text', raises_error(@() show_route_picture(Y, R16, 'off', 5))};
c(end+1, :) = {'show_route_picture: an out of date route is refused', raises_error(@() show_route_picture(Y2, R16, 'off', dbad))};
c(end+1, :) = {'show_route_picture: after these errors no folder was made and no figure is left open', exist(dbad, 'dir') ~= 7 && nfig() == n_open};

% --- main_demo option 7 (visible off, temporary folder) ---
dm = fullfile(tmp_root, 'demo');
pf = fullfile(dm, 'point5_route.png');
o = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''7'', ''0''}, ''off'', dm)');
[e7, p7, ~] = check_picture_files({pf});
c(end+1, :) = {'main_demo: the menu has the line for option 7', has(o, '  7  Picture of the network (with the route of the last message)') && has(o, '  6  The whole report (show_system)') && has(o, '  0  Quit')};
c(end+1, :) = {'main_demo option 7 after Alice to Grace: the title of the picture and the saved file', has(o, 'Picture: Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)') && has(o, ['The picture is saved as ' pf '.']) && e7 && p7};
c(end+1, :) = {'main_demo option 7 after a message: no note about a missing route', ~has(o, 'There is no route to show')};
o = evalc('main_demo({''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo option 7 at once: the note and the picture of the whole network', has(o, 'There is no route to show: no message was sent since the start or since the last change of the channels.') && has(o, 'Picture: The network now: 6 working channels, 0 broken, 1 group of users')};
c(end+1, :) = {'main_demo option 7 does not count as a message', has(o, 'Messages sent: 0. Messages that arrived: 0.')};
o = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''4'', ''Dave'', ''Frank'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: breaking a channel makes the picture forget the old route', has(o, 'There is no route to show') && has(o, 'Picture: The network now: 5 working channels, 1 broken, 2 groups of users') && ~has(o, 'Picture: Alice to Grace')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Alice'', ''Grace'', ''x'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo option 7 after a message with no route: the no route picture', has(o, 'Picture: No route from Alice to Grace: they are in different groups of users') && ~has(o, 'There is no route to show') && has(o, 'Messages sent: 1. Messages that arrived: 0.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Bob'', ''Carol'', ''y'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo option 7 after a message inside a group with a broken channel', has(o, 'Picture: Bob to Carol: Bob - Alice - Carol (2 channels)') && has(o, 'Messages sent: 1. Messages that arrived: 1.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Alice'', ''Grace'', ''x'', ''5'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: repairing the channels makes the picture forget the old message too', has(o, '1 channel repaired.') && has(o, 'There is no route to show') && has(o, 'Picture: The network now: 6 working channels, 0 broken, 1 group of users')};
o = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''5'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: repairing when nothing is broken keeps the route of the last message', has(o, 'No channel was broken.') && has(o, 'Picture: Alice to Grace: Alice - Bob - Dave - Frank - Grace (4 channels)') && ~has(o, 'There is no route to show')};
o = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''a'', ''1'', ''Grace'', ''Alice'', ''b'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo option 7 shows the last of two messages', has(o, 'Picture: Grace to Alice: Grace - Frank - Dave - Bob - Alice (4 channels)') && ~has(o, 'Picture: Alice to Grace') && has(o, 'Messages sent: 2. Messages that arrived: 2.')};
o = evalc('main_demo({''4'', ''Alice'', ''Alice'', ''Bob'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo option 7 after Alice - Bob breaks: 5 working, 1 broken and still 1 group (Alice - Carol - Dave - Bob)', has(o, 'Please choose a different user than Alice.') && has(o, 'Picture: The network now: 5 working channels, 1 broken, 1 group of users')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''4'', ''Dave'', ''Frank'', ''1'', ''Alice'', ''Grace'', ''x'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: breaking an already broken channel changes nothing for the next picture', has(o, 'There is no working channel between Dave and Frank') && has(o, 'Picture: No route from Alice to Grace')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Bob'', ''Carol'', ''y'', ''4'', ''Dave'', ''Frank'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: breaking an already broken channel does not make the picture forget the route', has(o, 'There is no working channel between Dave and Frank') && has(o, 'Picture: Bob to Carol: Bob - Alice - Carol (2 channels)') && ~has(o, 'There is no route to show')};
o = evalc('main_demo({''7'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: option 7 twice gives two pictures and no window stays open', numel(strfind(o, 'Picture: The network now')) == 2 && nfig() == n_open};
o1 = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''7'', ''0''}, ''off'', dm)');
o2 = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''7'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: the same answers give the same text twice', strcmp(o1, o2)};
o = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''8'', ''0''}, ''off'', dm)');
c(end+1, :) = {'main_demo: 8 is not on the menu and asks again with the new range', has(o, 'Please type a number from 0 to 7.') && ~has(o, 'Please type a number from 0 to 6.')};
c(end+1, :) = {'main_demo: visible must be on or off and outdir a text', raises_error(@() evalc('main_demo({''0''}, ''maybe'', dm)')) && raises_error(@() evalc('main_demo({''0''}, 1, dm)')) && raises_error(@() evalc('main_demo({''0''}, ''off'', 5)'))};
try
    evalc('main_demo({''0''}, ''maybe'')');
    errid = '';
catch err
    errid = err.identifier;
end
c(end+1, :) = {'main_demo: the error for a bad visible is main_demo:visible', strcmp(errid, 'main_demo:visible')};
c(end+1, :) = {'main_demo with visible off leaves no figure open', nfig() == n_open};

% --- the files in outputs do not change ---
rmdir(tmp_root, 's');
out_after = dir(outputs_dir);
c(end+1, :) = {'the pictures of this test do not change the files in outputs', isequal({out_before.name}, {out_after.name}) && isequal([out_before.bytes], [out_after.bytes]) && isequal([out_before.datenum], [out_after.datenum])};

summarize_checks('test_route_picture', c);
end
