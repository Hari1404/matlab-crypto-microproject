function [files, titles] = save_digraph_pictures(D, outdir, visible)
% SAVE_DIGRAPH_PICTURES Draw the 3 pictures of the directed network and save each one as a PNG file.
%   [files, titles] = save_digraph_pictures(D, outdir, visible)
%   D        the digraph struct from define_digraph
%   outdir   the folder for the files (default: the outputs folder of the project; it is made if missing)
%   visible  'on' keeps the 3 figures open on the screen, 'off' (default) saves them and closes them
%   files    the full file names, titles the title written in each picture (3 by 1 cell arrays).
%   The pictures: 1 the directed network, 2 the shortest directed path from the first to the last user,
%   3 the strongly connected groups. All pictures use the places of graph_layout for the network of the channels,
%   so the users are at the same places as in the 5 pictures of Point 2.
if nargin < 2 || isempty(outdir)
    outdir = fullfile(fileparts(which('setup_project')), 'outputs');
end
if nargin < 3
    visible = 'off';
end
if ~strcmp(visible, 'on') && ~strcmp(visible, 'off')
    error('save_digraph_pictures:visible', 'visible must be the text on or the text off.');
end
if D.n < 1
    error('save_digraph_pictures:empty', 'The digraph must have at least one user.');
end
if ~exist(outdir, 'dir')
    mkdir(outdir);
end
names = {'point2d_digraph.png'; 'point2d_path.png'; 'point2d_strong.png'};
files = cell(3, 1);
titles = cell(3, 1);
xy = graph_layout(D.adj | D.adj');
for k = 1:3
    opts = digraph_options(D, k);
    titles{k} = opts.title;
    files{k} = fullfile(outdir, names{k});
    left = 40 + 30 * (k - 1);
    bottom = 380 - 30 * (k - 1);
    fig = figure('Visible', visible, 'Position', [left bottom 900 420], 'Color', [1 1 1], 'PaperPositionMode', 'auto', 'NumberTitle', 'off', 'Name', sprintf('Point 2D - picture %d', k));
    ax = axes('Parent', fig, 'Position', [0.02 0.02 0.96 0.86]);
    h = draw_digraph(ax, D, xy, opts);
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
