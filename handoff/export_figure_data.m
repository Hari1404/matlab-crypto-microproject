% export_figure_data  Write the drawing data of the 6 report figures to a JSON file.
% It runs the REAL code (graph_layout, picture_options, route_picture_options) and writes
% what draw_network would draw: places, colors, line widths, line styles and titles.
% No figure is opened, so it works in a headless Octave. handoff/make_figures.py draws the
% stand-in pictures from this file.
% Run from the project folder:
%   octave --no-gui --eval "export_figure_data('/tmp/figure_data.json')"
function export_figure_data(jsonfile)
if nargin < 1
    jsonfile = fullfile(tempdir(), 'figure_data.json');
end
root = fileparts(fileparts(mfilename('fullpath')));
old = pwd(); cd(root); setup_project; cd(old);
S = define_sets();
Y = define_system(S);
G = Y.G;
xy = graph_layout(G.adj);
names = {'point2_network', 'point2_shortest_path', 'point2_cycle', 'point2_weak_points', 'point2_split'};
pics = cell(1, 6);
for k = 1:5
    pics{k} = pack_picture(names{k}, picture_options(G, k));
end
R = route_message('Hello Grace, the meeting is at 5 pm.', 1, 6, Y);
pics{6} = pack_picture('point5_route', route_picture_options(Y, R));
D.users = G.vertices(:)';
D.edges = G.edges;
D.xy = xy;
D.radius = 0.6;
D.pictures = pics;
txt = jsonencode(D);
fid = fopen(jsonfile, 'w');
fprintf(fid, '%s\n', txt);
fclose(fid);
printf('Wrote %s (%d pictures)\n', jsonfile, numel(pics));
for k = 1:numel(pics)
    printf('  %-22s %s\n', pics{k}.name, pics{k}.title);
end
end

function P = pack_picture(name, o)
P.name = name;
P.title = o.title;
P.vertex_color = o.vertex_color;
P.edge_color = o.edge_color;
P.edge_width = o.edge_width(:)';
P.edge_style = o.edge_style(:)';
end
