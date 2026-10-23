function h = draw_network(ax, G, xy, opts)
% DRAW_NETWORK Draw the communication network (circles for the users, lines for the channels) in the axes ax.
%   G is the graph struct (G.n, G.m, G.vertices and G.edges are used) and xy has the places from graph_layout.
%   opts is an optional struct. Every field is optional:
%     vertex_color  n by 3 colors of the circles (default light blue)
%     edge_color    m by 3 colors of the lines (default gray)
%     edge_width    m numbers, the width of each line (default 1.5)
%     edge_style    cell array of m texts, '-' or ':' for each line (default '-')
%     title         the title text, in one line
%   The result h keeps the handles in cell arrays: h.edge{e}, h.edge_label{e}, h.vertex{v}, h.vertex_label{v}.
%   h.title is the title handle, h.xlim and h.ylim are the limits used. The lines come first, so the circles cover their ends.
if nargin < 4
    opts = struct();
end
n = G.n;
m = G.m;
if ~isequal(size(xy), [n, 2])
    error('draw_network:size', 'xy must have one row [x y] for each vertex.');
end
if isfield(opts, 'vertex_color')
    vcol = opts.vertex_color;
    if ~isequal(size(vcol), [n, 3])
        error('draw_network:option', 'vertex_color must have one row of 3 numbers for each vertex.');
    end
else
    vcol = repmat([0.80 0.88 0.98], n, 1);
end
if isfield(opts, 'edge_color')
    ecol = opts.edge_color;
    if ~isequal(size(ecol), [m, 3])
        error('draw_network:option', 'edge_color must have one row of 3 numbers for each edge.');
    end
else
    ecol = repmat([0.35 0.35 0.35], m, 1);
end
if isfield(opts, 'edge_width')
    ewid = opts.edge_width;
    if numel(ewid) ~= m
        error('draw_network:option', 'edge_width must have one number for each edge.');
    end
else
    ewid = 1.5 * ones(1, m);
end
if isfield(opts, 'edge_style')
    esty = opts.edge_style;
    if ~iscell(esty) || numel(esty) ~= m
        error('draw_network:option', 'edge_style must be a cell array with one text for each edge.');
    end
else
    esty = repmat({'-'}, 1, m);
end

set(ax, 'NextPlot', 'add');
radius = 0.6;
h.edge = cell(1, m);
h.edge_label = cell(1, m);
h.vertex = cell(1, n);
h.vertex_label = cell(1, n);

for e = 1:m
    i = G.edges(e, 1);
    j = G.edges(e, 2);
    h.edge{e} = line('Parent', ax, 'XData', [xy(i, 1) xy(j, 1)], 'YData', [xy(i, 2) xy(j, 2)], 'Color', ecol(e, :), 'LineWidth', ewid(e), 'LineStyle', esty{e});
end
t = linspace(0, 2 * pi, 61);
for v = 1:n
    h.vertex{v} = fill(xy(v, 1) + radius * cos(t), xy(v, 2) + radius * sin(t), vcol(v, :), 'Parent', ax, 'EdgeColor', [0.1 0.2 0.45], 'LineWidth', 0.8);
    h.vertex_label{v} = text(xy(v, 1), xy(v, 2), G.vertices{v}, 'Parent', ax, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 11, 'FontWeight', 'bold');
end
for e = 1:m
    i = G.edges(e, 1);
    j = G.edges(e, 2);
    d = xy(j, :) - xy(i, :);
    nrm = [-d(2), d(1)] / norm(d);
    if nrm(2) < 0 || (nrm(2) == 0 && nrm(1) < 0)
        nrm = -nrm;
    end
    pos = (xy(i, :) + xy(j, :)) / 2 + 0.3 * nrm;
    h.edge_label{e} = text(pos(1), pos(2), sprintf('e%d', e), 'Parent', ax, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 9, 'Color', [0.25 0.25 0.25]);
end

if n > 0
    h.xlim = [min(xy(:, 1)) - 1.1, max(xy(:, 1)) + 1.1];
    h.ylim = [min(xy(:, 2)) - 1.1, max(xy(:, 2)) + 1.1];
else
    h.xlim = [-1 1];
    h.ylim = [-1 1];
end
set(ax, 'XLim', h.xlim, 'YLim', h.ylim);
axis(ax, 'equal');
axis(ax, 'off');
if isfield(opts, 'title')
    h.title = title(ax, opts.title, 'FontSize', 13, 'FontWeight', 'bold');
else
    h.title = [];
end
end
