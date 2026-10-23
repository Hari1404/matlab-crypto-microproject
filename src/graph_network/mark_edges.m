function opts = mark_edges(opts, ids, color, width)
% MARK_EDGES Give the edges with the numbers ids one color and one line width in the drawing options opts.
%   opts is the struct used by draw_network (it needs opts.edge_color and opts.edge_width).
for t = 1:numel(ids)
    opts.edge_color(ids(t), :) = color;
    opts.edge_width(ids(t)) = width;
end
end
