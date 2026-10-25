function [file, title_text, fig] = show_route_picture(Y, R, visible, outdir)
% SHOW_ROUTE_PICTURE Draw the picture of the network Y with the route R marked and save it as the PNG file point5_route.png.
%   [file, title_text, fig] = show_route_picture(Y, R, visible, outdir)
%   R        the result of route_message, or [] for no route (see route_picture_options)
%   visible  'on' keeps the figure window open (default), 'off' saves the picture and closes the figure
%   outdir   the folder for the file (default: the outputs folder of the project; it is made if missing)
%   file     the full file name, title_text the title written in the picture,
%   fig      the handle of the figure window ([] when the figure was closed).
%   An older point5_route.png in the folder is replaced.
if nargin < 3
    visible = 'on';
end
if nargin < 4 || isempty(outdir)
    outdir = fullfile(fileparts(which('setup_project')), 'outputs');
end
if ~ischar(visible) || ~(strcmp(visible, 'on') || strcmp(visible, 'off'))
    error('show_route_picture:visible', 'visible must be the text on or the text off.');
end
if ~ischar(outdir) || isempty(outdir)
    error('show_route_picture:outdir', 'outdir must be a text (the name of a folder).');
end
opts = route_picture_options(Y, R);
title_text = opts.title;
if ~exist(outdir, 'dir')
    mkdir(outdir);
end
file = fullfile(outdir, 'point5_route.png');
fig = figure('Visible', visible, 'Position', [60 300 900 420], 'Color', [1 1 1], 'PaperPositionMode', 'auto', 'NumberTitle', 'off', 'Name', 'Point 5 - the network and the route');
try
    ax = axes('Parent', fig, 'Position', [0.02 0.02 0.96 0.86]);
    h = draw_route_picture(ax, Y, R);
    shape = (h.ylim(2) - h.ylim(1)) / (h.xlim(2) - h.xlim(1));
    height = min(900, max(300, round(864 * shape / 0.86) + 10));
    set(fig, 'Position', [60 300 900 height]);
    drawnow;
    print(fig, file, '-dpng', '-r150');
catch err
    close(fig);
    rethrow(err);
end
if strcmp(visible, 'off')
    close(fig);
    fig = [];
end
end
