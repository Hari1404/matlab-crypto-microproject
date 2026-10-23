function show_analysis(G, s, t)
% SHOW_ANALYSIS Print the analysis of the communication network in the Command Window.
%   show_analysis()         uses define_graph, starts the search at user 1 and asks for the path from user 1 to the last user.
%   show_analysis(G)        analyses the graph in the struct G (it only needs G.n, G.vertices and G.adj).
%   show_analysis(G, s, t)  does the search from user s and the shortest path from user s to user t.
if nargin < 1
    G = define_graph();
end
if nargin < 2
    s = 1;
end
if nargin < 3
    t = G.n;
end
n = G.n;
A = G.adj;
names = G.vertices;
m = sum(A(:)) / 2;
w = max(cellfun(@numel, names)) + 2;
fmt_name = sprintf('%%-%ds', w);

fprintf('\n=== ANALYSIS OF THE COMMUNICATION NETWORK ===\n');

% 1. connectivity
[comp, k] = connected_components(A);
fprintf('\n1. Connectivity\n');
fprintf('The network has %d connected group(s) of users (users in the same group can reach each other):\n', k);
fprintf('  %s\n', format_groups(names, comp));
fprintf('Is the network connected? %s\n', yes_no(is_connected(A)));

% 2. breadth-first search
[dist, parent, order] = bfs_search(A, s);
fprintf('\n2. Breadth-first search from %s\n', names{s});
fprintf('Visit order: %s\n', format_names(names, order));
fprintf(fmt_name, 'User');
fprintf('%-10s%s\n', 'Distance', 'Reached from');
for v = 1:n
    fprintf(fmt_name, names{v});
    if isinf(dist(v))
        dtxt = '-';
        from = '(not reached)';
    elseif v == s
        dtxt = '0';
        from = '(start)';
    else
        dtxt = sprintf('%d', dist(v));
        from = names{parent(v)};
    end
    fprintf('%-10s%s\n', dtxt, from);
end
reach = reachable_from(A, s);
fprintf('Users reachable from %s: %s (%d of %d)\n', names{s}, format_names(names, reach), numel(reach), n);

% 3. distances between every two users
D = distance_matrix(A);
fprintf('\n3. Distances between every two users (the number of channels on a shortest path, - means no path)\n');
fprintf('%s', repmat(' ', 1, w));
for j = 1:n
    fprintf(fmt_name, names{j});
end
fprintf('\n');
for i = 1:n
    fprintf(fmt_name, names{i});
    for j = 1:n
        if isinf(D(i, j))
            fprintf(fmt_name, '-');
        else
            fprintf(fmt_name, sprintf('%d', D(i, j)));
        end
    end
    fprintf('\n');
end

% 4. shortest path
fprintf('\n4. Shortest path from %s to %s\n', names{s}, names{t});
[path, len] = shortest_path(A, s, t);
if isempty(path)
    fprintf('There is no path: %s cannot reach %s.\n', names{s}, names{t});
else
    fprintf('%s (length %d)\n', format_names(names, path, ' - '), len);
    fprintf('If several shortest paths exist, this is the one the search finds first.\n');
end

% 5. cycles
fprintf('\n5. Cycles\n');
fprintf('Independent cycles = channels - users + groups = %d - %d + %d = %d\n', m, n, k, cycle_rank(A));
cyc = find_cycle(A);
if isempty(cyc)
    fprintf('The network has no cycle (it is a tree or a forest).\n');
else
    fprintf('A shortest cycle: %s (length %d)\n', format_names(names, [cyc, cyc(1)], ' - '), numel(cyc));
end

% 6. removing one channel
E = adjacency_to_edges(A);
fprintf('\n6. What happens when one channel is removed\n');
for e = 1:size(E, 1)
    B = remove_channel(A, E(e, 1), E(e, 2));
    [comp2, k2] = connected_components(B);
    label = sprintf('e%d  %s - %s', e, names{E(e, 1)}, names{E(e, 2)});
    fprintf('  %-26s connected: %-4s groups: %s\n', label, yes_no(k2 == 1), format_groups(names, comp2));
end
Br = bridge_channels(A);
txt = '';
for r = 1:size(Br, 1)
    if r > 1
        txt = [txt ', '];
    end
    txt = [txt names{Br(r, 1)} ' - ' names{Br(r, 2)}];
end
if isempty(txt)
    txt = '(none)';
end
fprintf('Bridge channels (removing one splits the network): %s\n', txt);

% 7. removing one user
fprintf('\n7. What happens when one user is removed (the other users must still reach each other)\n');
for v = 1:n
    [B, keep] = remove_user(A, v);
    [comp2, k2] = connected_components(B);
    fprintf('  ');
    fprintf(fmt_name, names{v});
    fprintf('connected: %-4s groups: %s\n', yes_no(k2 == 1), format_groups(names(keep), comp2));
end
fprintf('Cut users (removing one splits the network): %s\n', format_names(names, cut_users(A)));

% checks
fprintf('\nChecks:\n');
ok_cycle = true;
for i = 1:numel(cyc)
    j = mod(i, numel(cyc)) + 1;
    ok_cycle = ok_cycle && logical(A(cyc(i), cyc(j)));
end
if isempty(path)
    ok_path = isinf(D(s, t));
else
    ok_path = (numel(path) - 1 == D(s, t));
end
checks = {
    'The distances are symmetric (the distance from u to v is the one from v to u)', isequal(D, D');
    'The shortest path has as many channels as the distance says', ok_path;
    'Every two neighbors on the shortest cycle are joined by a channel', ok_cycle;
    'The groups agree with the reachability (users in a group reach each other)', size(unique(double(isfinite(D)), 'rows'), 1) == k};
for q = 1:size(checks, 1)
    if checks{q, 2}
        word = 'yes';
    else
        word = 'NO';
    end
    fprintf('  %-80s: %s\n', checks{q, 1}, word);
end
end
