function opts = route_picture_options(Y, R)
% ROUTE_PICTURE_OPTIONS The colors, line widths, line styles and title of the picture of the network Y with the route R marked, for draw_network.
%   Y is the system (define_system). Y.A is the network in use: a channel of Y.G that is missing in Y.A is broken.
%   R is the result of route_message for the network in use, or [] when there is no route to show.
%   Broken channels are dotted and gray in every picture.
%   R = []: one color for each group of users, and the title counts the working and the broken channels.
%   R with a route: the channels of the route are thick and green, the sender and the receiver are dark green,
%   the users in the middle are light green and the other users are blue.
%   R without a route: one color for each group of users, and the title says that there is no route.
%   An error is raised when a channel of the route is broken in Y.A (the route is out of date).
check_system(Y);
n = Y.n;
m = Y.G.m;
E = Y.G.edges;
names = Y.users;
if ~isempty(R)
    need = {'from', 'to', 'i', 'j', 'reachable', 'path', 'hops'};
    if ~isstruct(R) || ~all(isfield(R, need))
        error('route_picture_options:route', 'R must be [] or the result of route_message.');
    end
    if ~is_whole_number(R.i) || ~is_whole_number(R.j) || R.i < 1 || R.i > n || R.j < 1 || R.j > n
        error('route_picture_options:route', 'R.i and R.j must be user numbers from 1 to %d.', n);
    end
    if R.reachable && (isempty(R.path) || R.path(1) ~= R.i || R.path(end) ~= R.j)
        error('route_picture_options:route', 'R.path must go from the sender to the receiver.');
    end
end
opts.vertex_color = repmat([0.80 0.88 0.98], n, 1);
opts.edge_color = repmat([0.35 0.35 0.35], m, 1);
opts.edge_width = 1.5 * ones(1, m);
opts.edge_style = repmat({'-'}, 1, m);
broken = false(1, m);
for e = 1:m
    if ~Y.A(E(e, 1), E(e, 2))
        broken(e) = true;
        opts.edge_color(e, :) = [0.55 0.55 0.55];
        opts.edge_style{e} = ':';
    end
end
nb = sum(broken);
[comp, k] = connected_components(Y.A);
has_route = ~isempty(R) && R.reachable;
if ~has_route
    shades = [0.80 0.88 0.98; 0.80 0.92 0.80; 1.00 0.92 0.70; 0.95 0.80 0.90; 0.88 0.84 0.96; 0.85 0.85 0.85];
    for v = 1:n
        opts.vertex_color(v, :) = shades(mod(comp(v) - 1, 6) + 1, :);
    end
end
if isempty(R)
    opts.title = sprintf('The network now: %d working channel%s, %d broken, %d group%s of users', m - nb, plural_s(m - nb), nb, k, plural_s(k));
elseif ~R.reachable
    opts.title = sprintf('No route from %s to %s: they are in different groups of users', R.from, R.to);
else
    ids = path_to_edges(E, R.path);
    if any(broken(ids))
        error('route_picture_options:stale', 'A channel of the route is broken in the network in use, so the route is out of date.');
    end
    opts = mark_edges(opts, ids, [0.10 0.55 0.20], 3);
    opts.vertex_color(R.path, :) = repmat([0.60 0.85 0.60], numel(R.path), 1);
    opts.vertex_color([R.i R.j], :) = repmat([0.35 0.72 0.40], 2, 1);
    opts.title = sprintf('%s to %s: %s (%d channel%s)', R.from, R.to, format_names(names, R.path, ' - '), R.hops, plural_s(R.hops));
end
end
