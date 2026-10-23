function [files, titles] = save_network_pictures(G, outdir, visible)
% SAVE_NETWORK_PICTURES Draw the 5 pictures of the communication network and save each one as a PNG file.
%   [files, titles] = save_network_pictures(G, outdir, visible)
%   G        the graph struct from define_graph
%   outdir   the folder for the files (default: the outputs folder of the project; it is made if missing)
%   visible  'on' keeps the 5 figures open on the screen, 'off' (default) saves them and closes them
%   files    the full file names, titles the title written in each picture (5 by 1 cell arrays).
%   The pictures: 1 the network, 2 the shortest path from the first to the last user, 3 a shortest cycle,
%   4 the weak points (bridge channels and cut users), 5 the network after the first bridge channel is removed.
%   All pictures use the same places for the users (graph_layout of the whole network).
if nargin < 2 || isempty(outdir)
    outdir = fullfile(fileparts(which('setup_project')), 'outputs');
end
if nargin < 3
    visible = 'off';
end
if ~strcmp(visible, 'on') && ~strcmp(visible, 'off')
    error('save_network_pictures:visible', 'visible must be the text on or the text off.');
end
if G.n < 1
    error('save_network_pictures:empty', 'The graph must have at least one user.');
end
if ~exist(outdir, 'dir')
    mkdir(outdir);
end
names = {'point2_network.png'; 'point2_shortest_path.png'; 'point2_cycle.png'; 'point2_weak_points.png'; 'point2_split.png'};
files = cell(5, 1);
titles = cell(5, 1);
xy = graph_layout(G.adj);
for k = 1:5
    opts = picture_options(G, k);
    titles{k} = opts.title;
    files{k} = fullfile(outdir, names{k});
    left = 40 + 30 * (k - 1);
    bottom = 380 - 30 * (k - 1);
    fig = figure('Visible', visible, 'Position', [left bottom 900 420], 'Color', [1 1 1], 'PaperPositionMode', 'auto', 'NumberTitle', 'off', 'Name', sprintf('Point 2 - picture %d', k));
    ax = axes('Parent', fig, 'Position', [0.02 0.02 0.96 0.86]);
    h = draw_network(ax, G, xy, opts);
    shape = (h.ylim(2) - h.ylim(1)) / (h.xlim(2) - h.xlim(1));
    height = min(900, max(300, round(864 * shape / 0.86) + 10));
    set(fig, 'Position', [left bottom 900 height]);
    drawnow;
    print(fig, files{k}, '-dpng', '-r150');
    if strcmp(visible, 'off')
        close(fig);
    end
end
end
