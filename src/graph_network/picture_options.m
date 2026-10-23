function opts = picture_options(G, k)
% PICTURE_OPTIONS The colors, line widths and title of picture k (1 to 5) of the network, for draw_network.
%   1 the network, 2 the shortest path from the first to the last user, 3 a shortest cycle,
%   4 the weak points (bridge channels in red, cut users in orange),
%   5 the network after the first bridge channel is removed (one color for each group of users).
%   When a picture has nothing to show (no path, no cycle, no channel) the title says so.
A = G.adj;
n = G.n;
m = G.m;
names = G.vertices;
blue = [0.80 0.88 0.98];
opts.vertex_color = repmat(blue, n, 1);
opts.edge_color = repmat([0.35 0.35 0.35], m, 1);
opts.edge_width = 1.5 * ones(1, m);
opts.edge_style = repmat({'-'}, 1, m);
if k == 1
    opts.title = 'The communication network: users are vertices, channels are edges';
elseif k == 2
    [path, len] = shortest_path(A, 1, n);
    if isempty(path)
        opts.vertex_color([1 n], :) = repmat([0.60 0.85 0.60], 2, 1);
        opts.title = sprintf('No path from %s to %s: they are in different groups of users', names{1}, names{n});
    else
        opts = mark_edges(opts, path_to_edges(G.edges, path), [0.10 0.55 0.20], 3);
        opts.vertex_color(path, :) = repmat([0.60 0.85 0.60], numel(path), 1);
        opts.title = sprintf('Shortest path: %s (length %d)', format_names(names, path, ' - '), len);
    end
elseif k == 3
    cyc = find_cycle(A);
    if isempty(cyc)
        opts.title = 'The network has no cycle (it is a tree or a forest)';
    else
        loop = [cyc, cyc(1)];
        opts = mark_edges(opts, path_to_edges(G.edges, loop), [0.45 0.20 0.70], 3);
        opts.vertex_color(cyc, :) = repmat([0.82 0.72 0.95], numel(cyc), 1);
        opts.title = sprintf('A shortest cycle: %s (length %d)', format_names(names, loop, ' - '), numel(cyc));
    end
elseif k == 4
    Br = bridge_channels(A);
    cu = cut_users(A);
    for r = 1:size(Br, 1)
        opts = mark_edges(opts, path_to_edges(G.edges, Br(r, :)), [0.80 0.10 0.10], 3);
    end
    opts.vertex_color(cu, :) = repmat([1.00 0.62 0.15], numel(cu), 1);
    opts.title = sprintf('Weak points: %d bridge channel%s (red), %d cut user%s (orange)', size(Br, 1), plural_s(size(Br, 1)), numel(cu), plural_s(numel(cu)));
elseif k == 5
    Br = bridge_channels(A);
    if ~isempty(Br)
        r = Br(1, :);
    elseif m > 0
        r = G.edges(1, :);
    else
        r = [];
    end
    if isempty(r)
        opts.title = 'No channel to remove: the network has no channels';
    else
        B = remove_channel(A, r(1), r(2));
        [comp, kk] = connected_components(B);
        shades = [0.80 0.88 0.98; 0.80 0.92 0.80; 1.00 0.92 0.70; 0.95 0.80 0.90; 0.88 0.84 0.96; 0.85 0.85 0.85];
        for v = 1:n
            opts.vertex_color(v, :) = shades(mod(comp(v) - 1, 6) + 1, :);
        end
        e = path_to_edges(G.edges, r);
        opts.edge_color(e, :) = [0.55 0.55 0.55];
        opts.edge_style{e} = ':';
        opts.title = sprintf('Channel %s - %s removed: %d group(s) of users (one color each)', names{r(1)}, names{r(2)}, kk);
    end
else
    error('picture_options:number', 'The picture number must be a whole number from 1 to 5.');
end
end
