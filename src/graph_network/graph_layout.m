function xy = graph_layout(A)
% GRAPH_LAYOUT Fixed places for drawing a graph: one row [x y] for each vertex.
%   Each connected group is drawn in layers. The layer of a vertex is its distance from the smallest
%   vertex of its group (found with breadth-first search), and x = 2.4 * layer.
%   The vertices of one layer are placed one under the other, 1.6 apart, in increasing order from the top.
%   Several groups are stacked from the top, the group with the smallest vertex first.
%   The whole drawing is centered on y = 0. The result is always the same for the same matrix.
n = size(A, 1);
if size(A, 2) ~= n
    error('graph_layout:size', 'The adjacency matrix must be square.');
end
xstep = 2.4;
ystep = 1.6;
gap = 1.8;
xy = zeros(n, 2);
[comp, k] = connected_components(A);
top = 0;
for g = 1:k
    members = find(comp == g);
    dist = bfs_search(A, members(1));
    last = max(dist(members));
    tallest = 1;
    for L = 0:last
        tallest = max(tallest, sum(dist(members) == L));
    end
    height = (tallest - 1) * ystep;
    middle = top - height / 2;
    for L = 0:last
        layer = members(dist(members) == L);
        cnt = numel(layer);
        for t = 1:cnt
            xy(layer(t), :) = [xstep * L, middle + ((cnt - 1) / 2 - (t - 1)) * ystep];
        end
    end
    top = top - height - gap;
end
if n > 0
    xy(:, 2) = xy(:, 2) - (max(xy(:, 2)) + min(xy(:, 2))) / 2;
end
end
