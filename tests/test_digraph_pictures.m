function test_digraph_pictures()
% TEST_DIGRAPH_PICTURES Checks for the pictures of the directed network: drawing, PNG files and the demo.
% Every picture is saved in a temporary folder, never in the outputs folder of the project.
S = define_sets();
G = define_graph(S);
D = define_digraph(S, G);
nfig = @() numel(findall(0, 'type', 'figure'));
outputs_dir = fullfile(fileparts(which('setup_project')), 'outputs');
if exist(outputs_dir, 'dir')
    out_before = sort({dir(outputs_dir).name});
else
    out_before = {};
end
tmp_root = tempname();
xy = graph_layout(G.adj);
c = cell(0, 2);

% --- draw_digraph ---
f0 = nfig();
fig = figure('Visible', 'off');
ax = axes('Parent', fig);
h = draw_digraph(ax, D, xy, digraph_options(D, 1));
c(end+1, :) = {'draw_digraph gives one line and one arrowhead for each of the 8 arcs', numel(h.arc) == 8 && numel(h.head) == 8 && all(cellfun(@ishghandle, h.arc)) && all(cellfun(@ishghandle, h.head))};
c(end+1, :) = {'draw_digraph gives 6 circles with 6 name labels and 8 arc labels', numel(h.vertex) == 6 && numel(h.vertex_label) == 6 && numel(h.arc_label) == 8};
c(end+1, :) = {'the name label of vertex 1 says Alice', strcmp(get(h.vertex_label{1}, 'String'), 'Alice')};
c(end+1, :) = {'the label of arc 3 says a3', strcmp(get(h.arc_label{3}, 'String'), 'a3')};
c(end+1, :) = {'the title is written', ~isempty(h.title) && ~isempty(strfind(get(h.title, 'String'), '8 arcs'))};
c(end+1, :) = {'the arc color and width options reach the lines (arc 3 is blue and wide)', isequal(get(h.arc{3}, 'Color'), [0.15 0.35 0.75]) && get(h.arc{3}, 'LineWidth') == 2};
c(end+1, :) = {'the limits cover all the places with a margin', h.xlim(1) < min(xy(:, 1)) && h.xlim(2) > max(xy(:, 1)) && h.ylim(1) < min(xy(:, 2)) && h.ylim(2) > max(xy(:, 2))};
close(fig);
fig = figure('Visible', 'off');
ax = axes('Parent', fig);
h = draw_digraph(ax, D, xy);
c(end+1, :) = {'draw_digraph without options draws with the default colors and no title', isempty(h.title) && numel(h.arc) == 8};
c(end+1, :) = {'a wrong number of places is refused with :size', strcmp(err_id(@() draw_digraph(ax, D, xy(1:5, :))), 'draw_digraph:size')};
c(end+1, :) = {'a wrong vertex_color is refused with :option', strcmp(err_id(@() draw_digraph(ax, D, xy, struct('vertex_color', ones(5, 3)))), 'draw_digraph:option')};
c(end+1, :) = {'a wrong arc_color is refused with :option', strcmp(err_id(@() draw_digraph(ax, D, xy, struct('arc_color', ones(7, 3)))), 'draw_digraph:option')};
c(end+1, :) = {'a wrong arc_width is refused with :option', strcmp(err_id(@() draw_digraph(ax, D, xy, struct('arc_width', ones(1, 3)))), 'draw_digraph:option')};
close(fig);
c(end+1, :) = {'the drawing tests leave no figure open', nfig() == f0};

% --- save_digraph_pictures ---
[files, titles] = save_digraph_pictures(D, tmp_root, 'off');
[ok_exist, ok_png, ok_diff] = check_picture_files(files);
c(end+1, :) = {'3 files and 3 titles come back', numel(files) == 3 && numel(titles) == 3};
c(end+1, :) = {'the files are point2d_digraph.png, point2d_path.png, point2d_strong.png', isequal(cellfun(@(f) [fileparts_name(f)], files, 'UniformOutput', false), {'point2d_digraph.png'; 'point2d_path.png'; 'point2d_strong.png'})};
c(end+1, :) = {'all 3 files exist and are not empty', ok_exist};
c(end+1, :) = {'all 3 files are PNG pictures', ok_png};
c(end+1, :) = {'the 3 pictures are different', ok_diff};
c(end+1, :) = {'the figures are closed again with visible off', nfig() == f0};
c(end+1, :) = {'the folder is made when missing', exist(tmp_root, 'dir') == 7};
c(end+1, :) = {'visible must be on or off (error :visible)', strcmp(err_id(@() save_digraph_pictures(D, tmp_root, 'maybe')), 'save_digraph_pictures:visible')};
Dempty = struct('vertices', {{}}, 'n', 0, 'm', 0, 'arcs', zeros(0, 2), 'adj', false(0, 0));
c(end+1, :) = {'a digraph with no users is refused with :empty', strcmp(err_id(@() save_digraph_pictures(Dempty, tmp_root, 'off')), 'save_digraph_pictures:empty')};

% --- demo_point2d ---
demo_dir = fullfile(tmp_root, 'demo');
txt = evalc('demo_point2d(demo_dir, ''off'')');
c(end+1, :) = {'demo_point2d prints the digraph and the 3 picture checks (all yes)', ~isempty(strfind(txt, 'POINT 2D DEMO')) && numel(strfind(txt, ': yes')) == 11 && isempty(strfind(txt, ': NO'))};
c(end+1, :) = {'demo_point2d wrote the 3 files in the folder it was given', exist(fullfile(demo_dir, 'point2d_path.png'), 'file') == 2};
c(end+1, :) = {'demo_point2d leaves no figure open', nfig() == f0};

% --- nothing was written into outputs ---
if exist(outputs_dir, 'dir')
    out_after = sort({dir(outputs_dir).name});
else
    out_after = {};
end
c(end+1, :) = {'the outputs folder of the project did not change', isequal(out_before, out_after)};
if exist(tmp_root, 'dir')
    rmdir(tmp_root, 's');
end
summarize_checks('test_digraph_pictures', c);
end

function id = err_id(f)
id = '';
try
    f();
catch err
    id = err.identifier;
end
end

function nm = fileparts_name(f)
[d, n, e] = fileparts(f);
nm = [n e];
end
