function opts = digraph_options(D, k)
% DIGRAPH_OPTIONS The colors, line widths and title of picture k (1 to 3) of the directed network, for draw_digraph.
%   1 the directed network (one-way channels in blue, the two arrows of a two-way channel in gray),
%   2 the shortest directed path from the first to the last user (green), with a word about the way back,
%   3 the strongly connected groups (one color for each group, the arcs between two groups in red).
%   When a picture has nothing to show (no path) the title says so.
%   opts.vertex_color (n by 3), opts.arc_color (m by 3), opts.arc_width (1 by m) and opts.title.
A = D.adj;
n = D.n;
m = D.m;
names = D.vertices;
blue = [0.80 0.88 0.98];
opts.vertex_color = repmat(blue, n, 1);
opts.arc_color = repmat([0.35 0.35 0.35], m, 1);
opts.arc_width = 1.5 * ones(1, m);
if k == 1
    nt = size(D.two_way, 1);
    no = size(D.one_way, 1);
    for a = 1:m
        if ~A(D.arcs(a, 2), D.arcs(a, 1))
            opts.arc_color(a, :) = [0.15 0.35 0.75];
            opts.arc_width(a) = 2;
        end
    end
    opts.title = sprintf('The directed network: %d arc%s, %d two-way and %d one-way channel%s', m, plural_s(m), nt, no, plural_s(no));
elseif k == 2
    [path, len] = shortest_path(A, 1, n);
    if isempty(path)
        opts.vertex_color([1 n], :) = repmat([0.60 0.85 0.60], 2, 1);
        opts.title = sprintf('No path from %s to %s along the arcs', names{1}, names{n});
    else
        ids = path_to_arcs(D.arcs, path);
        for t = 1:numel(ids)
            opts.arc_color(ids(t), :) = [0.10 0.55 0.20];
            opts.arc_width(ids(t)) = 3;
        end
        opts.vertex_color(path, :) = repmat([0.60 0.85 0.60], numel(path), 1);
        [back, blen] = shortest_path(A, n, 1);
        if isempty(back)
            word = sprintf('no path back from %s to %s', names{n}, names{1});
        else
            word = sprintf('back: %d arc%s', blen, plural_s(blen));
        end
        opts.title = sprintf('%s to %s: %d arc%s (green); %s', names{1}, names{n}, len, plural_s(len), word);
    end
elseif k == 3
    [comp, kk] = strong_components(A);
    shades = [0.80 0.88 0.98; 0.80 0.92 0.80; 1.00 0.92 0.70; 0.95 0.80 0.90; 0.88 0.84 0.96; 0.85 0.85 0.85];
    for v = 1:n
        opts.vertex_color(v, :) = shades(mod(comp(v) - 1, 6) + 1, :);
    end
    cross = find(comp(D.arcs(:, 1)) ~= comp(D.arcs(:, 2)));
    for t = 1:numel(cross)
        opts.arc_color(cross(t), :) = [0.80 0.10 0.10];
        opts.arc_width(cross(t)) = 3;
    end
    opts.title = sprintf('Strongly connected groups: %d (one color each), %d arc%s between groups (red)', kk, numel(cross), plural_s(numel(cross)));
else
    error('digraph_options:number', 'The picture number must be a whole number from 1 to 3.');
end
end
