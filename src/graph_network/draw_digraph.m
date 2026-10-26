function h = draw_digraph(ax, D, xy, opts)
% DRAW_DIGRAPH Draw the directed network (circles for the users, arrows for the arcs) in the axes ax.
%   D is the digraph struct (D.n, D.m, D.vertices, D.arcs and D.adj are used) and xy has the places from graph_layout.
%   Every arc is an arrow with a filled arrowhead just before the circle of the receiver. The two arrows of a
%   two-way channel are drawn side by side, each shifted 0.12 to the left of its own direction. The arrow of a
%   one-way channel is drawn in the middle. The arcs are labeled a1, a2, ... (arc number = row of D.arcs).
%   opts is an optional struct. Every field is optional:
%     vertex_color  n by 3 colors of the circles (default light blue)
%     arc_color     m by 3 colors of the arrows (default gray)
%     arc_width     m numbers, the width of each arrow line (default 1.5)
%     title         the title text, in one line
%   The result h keeps the handles in cell arrays: h.arc{a}, h.head{a}, h.arc_label{a}, h.vertex{v}, h.vertex_label{v}.
%   h.title is the title handle, h.xlim and h.ylim are the limits used. The arrows come first, so the circles cover their ends.
if nargin < 4
    opts = struct();
end
n = D.n;
m = D.m;
if ~isequal(size(xy), [n, 2])
    error('draw_digraph:size', 'xy must have one row [x y] for each vertex.');
end
if isfield(opts, 'vertex_color')
    vcol = opts.vertex_color;
    if ~isequal(size(vcol), [n, 3])
        error('draw_digraph:option', 'vertex_color must have one row of 3 numbers for each vertex.');
    end
else
    vcol = repmat([0.80 0.88 0.98], n, 1);
end
if isfield(opts, 'arc_color')
    acol = opts.arc_color;
    if ~isequal(size(acol), [m, 3])
        error('draw_digraph:option', 'arc_color must have one row of 3 numbers for each arc.');
    end
else
    acol = repmat([0.35 0.35 0.35], m, 1);
end
if isfield(opts, 'arc_width')
    awid = opts.arc_width;
    if numel(awid) ~= m
        error('draw_digraph:option', 'arc_width must have one number for each arc.');
    end
else
    awid = 1.5 * ones(1, m);
end

set(ax, 'NextPlot', 'add');
radius = 0.6;
side = 0.12;
h.arc = cell(1, m);
h.head = cell(1, m);
h.arc_label = cell(1, m);
h.vertex = cell(1, n);
h.vertex_label = cell(1, n);

P = cell(1, m);
for a = 1:m
    i = D.arcs(a, 1);
    j = D.arcs(a, 2);
    P{a} = arrow_points(xy(i, :), xy(j, :), radius, side * double(D.adj(j, i)));
    h.arc{a} = line('Parent', ax, 'XData', [P{a}.start(1) P{a}.line_end(1)], 'YData', [P{a}.start(2) P{a}.line_end(2)], 'Color', acol(a, :), 'LineWidth', awid(a));
    h.head{a} = fill(P{a}.head(:, 1), P{a}.head(:, 2), acol(a, :), 'Parent', ax, 'EdgeColor', acol(a, :), 'LineWidth', 0.5);
end
t = linspace(0, 2 * pi, 61);
for v = 1:n
    h.vertex{v} = fill(xy(v, 1) + radius * cos(t), xy(v, 2) + radius * sin(t), vcol(v, :), 'Parent', ax, 'EdgeColor', [0.1 0.2 0.45], 'LineWidth', 0.8);
    h.vertex_label{v} = text(xy(v, 1), xy(v, 2), D.vertices{v}, 'Parent', ax, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 11, 'FontWeight', 'bold');
end
for a = 1:m
    d = P{a}.tip - P{a}.start;
    nrm = [-d(2), d(1)] / norm(d);
    pos = (P{a}.start + P{a}.tip) / 2 + 0.28 * nrm;
    h.arc_label{a} = text(pos(1), pos(2), sprintf('a%d', a), 'Parent', ax, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 9, 'Color', [0.25 0.25 0.25]);
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
