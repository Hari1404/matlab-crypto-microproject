function show_digraph(D)
% SHOW_DIGRAPH Print the communication network as a directed graph in the Command Window.
%   show_digraph()   uses define_digraph.
%   show_digraph(D)  prints the digraph in the struct D.
if nargin < 1
    D = define_digraph();
end
n = D.n;
A = D.adj;
names = D.vertices;
w = max(cellfun(@numel, names)) + 2;
fmt_name = sprintf('%%-%ds', w);

fprintf('\n=== THE COMMUNICATION NETWORK AS A DIRECTED GRAPH ===\n');
fprintf('The digraph D = (V, A) has the %d users as vertices and %d arcs. An arc u -> v means that user u can send to user v.\n', n, D.m);
fprintf('It has the same channels as the graph G, but a channel may work in one direction only (one arc) or in both directions (two arcs).\n');

fprintf('\nArcs (%d):\n', D.m);
for a = 1:D.m
    fprintf('  a%d  %s -> %s\n', a, names{D.arcs(a, 1)}, names{D.arcs(a, 2)});
end

fprintf('\nAdjacency matrix (row user can send to column user when the entry is 1):\n');
fprintf('%s', repmat(' ', 1, w));
for j = 1:n
    fprintf(fmt_name, names{j});
end
fprintf('\n');
for i = 1:n
    fprintf(fmt_name, names{i});
    for j = 1:n
        fprintf(fmt_name, sprintf('%d', double(A(i, j))));
    end
    fprintf('\n');
end
if isequal(A, A')
    fprintf('The matrix is symmetric: every channel works in both directions, so D is the same as the undirected graph G.\n');
else
    fprintf('The matrix is NOT symmetric: a 1 at (i, j) with a 0 at (j, i) is a channel that works in one direction only.\n');
end

fprintf('\nWho each user can send to (out-neighbors) and who can send to each user (in-neighbors):\n');
for i = 1:n
    fprintf(fmt_name, names{i});
    fprintf(': sends to %s; receives from %s\n', join_names(names, D.out_list{i}), join_names(names, D.in_list{i}));
end

fprintf('\nOut-degree (arcs leaving the user) and in-degree (arcs entering the user):\n');
fprintf('%s%-6s%-6s\n', repmat(' ', 1, w), 'out', 'in');
for i = 1:n
    fprintf(fmt_name, names{i});
    fprintf('%-6d%-6d\n', D.out_degree(i), D.in_degree(i));
end
fprintf('Sum of the out-degrees = %d, sum of the in-degrees = %d, number of arcs = %d (every arc leaves one user and enters one user)\n', sum(D.out_degree), sum(D.in_degree), D.m);

fprintf('\nChannels:\n');
fprintf('  two-way (%d): %s\n', size(D.two_way, 1), join_pairs(names, D.two_way, ' - '));
fprintf('  one-way (%d): %s\n', size(D.one_way, 1), join_pairs(names, D.one_way, ' -> '));

dist = distance_matrix(A);
fprintf('\nDirected distances (the number of arcs on a shortest directed path from the row user to the column user; - means no path):\n');
fprintf('%s', repmat(' ', 1, w));
for j = 1:n
    fprintf(fmt_name, names{j});
end
fprintf('\n');
for i = 1:n
    fprintf(fmt_name, names{i});
    for j = 1:n
        if isinf(dist(i, j))
            fprintf(fmt_name, '-');
        else
            fprintf(fmt_name, sprintf('%d', dist(i, j)));
        end
    end
    fprintf('\n');
end
if isequal(dist, dist')
    fprintf('The table is symmetric: every distance is the same in both directions.\n');
else
    fprintf('The table is NOT symmetric: the way from u to v can be longer than the way back, or there may be no way back at all.\n');
end

fprintf('\nShortest directed paths (found by breadth-first search along the arcs):\n');
pairs = [1 min(3, n); min(3, n) 1; 1 n; n 1];
for r = 1:size(pairs, 1)
    s = pairs(r, 1);
    t = pairs(r, 2);
    [path, len] = shortest_path(A, s, t);
    if isempty(path)
        fprintf('  %s to %s: no path\n', names{s}, names{t});
    else
        fprintf('  %s to %s: %s (%d arc%s)\n', names{s}, names{t}, join_names(names, path, ' -> '), len, plural_s(len));
    end
end

fprintf('\nWho each user can reach along arcs (the user itself included):\n');
for i = 1:n
    fprintf(fmt_name, names{i});
    r = reachable_from(A, i);
    fprintf(': %s (%d user%s)\n', join_names(names, r), numel(r), plural_s(numel(r)));
end
for i = 1:n
    if D.out_degree(i) == 0 && D.in_degree(i) > 0
        fprintf('%s can receive but cannot send: no arc leaves this user.\n', names{i});
    elseif D.in_degree(i) == 0 && D.out_degree(i) > 0
        fprintf('%s can send but cannot receive: no arc enters this user.\n', names{i});
    end
end

[scomp, sk] = strong_components(A);
[wcomp, wk] = connected_components(A | A');
fprintf('\nStrongly connected groups (every user in a group can reach every other user in it): %d\n', sk);
for g = 1:sk
    fprintf('  group %d: %s\n', g, join_names(names, find(scomp == g)));
end
fprintf('Weakly connected groups (directions ignored, the same as the groups of the graph G): %d\n', wk);
for g = 1:wk
    fprintf('  group %d: %s\n', g, join_names(names, find(wcomp == g)));
end
if sk == 1
    fprintf('The digraph is strongly connected: every user can send a message to every other user.\n');
elseif wk == 1
    fprintf('The digraph is connected only when the directions are ignored: some users cannot send to some other users.\n');
else
    fprintf('The digraph is not connected, even when the directions are ignored.\n');
end

fprintf('\nChecks:\n');
check_line('The diagonal is all zero (no user has an arc to themself)', ~any(diag(A)));
check_line('The sum of the out-degrees and the sum of the in-degrees are both the number of arcs', sum(D.out_degree) == D.m && sum(D.in_degree) == D.m);
check_line('The arc list and the adjacency matrix describe the same digraph', isequal(arcs_to_adjacency(D.arcs, n), A));
check_line('The out-lists and the in-lists describe the same arcs', isequal(list_to_adjacency(D.out_list), A) && isequal(list_to_adjacency(D.in_list), A'));
check_line('Two-way channels count 2 arcs and one-way channels count 1 arc, together all the arcs', 2 * size(D.two_way, 1) + size(D.one_way, 1) == D.m);
W = warshall_reach(A);
check_line('Warshall''s algorithm finds the same reachable users as the breadth-first search', isequal(W, isfinite(dist)));
check_line('The strongly connected groups are the same when found with the Warshall matrix', isequal(groups_from_reach(W), scomp));
check_line('Every user is in exactly one strongly connected group', all(scomp >= 1) && all(scomp <= sk) && numel(scomp) == n);
end

function W = warshall_reach(A)
% Warshall's algorithm: W(i, j) is true when j can be reached from i (every user reaches itself).
n = size(A, 1);
W = logical(A) | logical(eye(n));
for k = 1:n
    for i = 1:n
        if W(i, k)
            W(i, :) = W(i, :) | W(k, :);
        end
    end
end
end

function comp = groups_from_reach(W)
% The strongly connected groups from a reach matrix, numbered by their smallest vertex.
n = size(W, 1);
comp = zeros(1, n);
k = 0;
for v = 1:n
    if comp(v) == 0
        k = k + 1;
        comp(W(v, :) & W(:, v)') = k;
    end
end
end

function s = join_names(names, idx, sep)
if nargin < 3
    sep = ', ';
end
s = '';
for t = 1:numel(idx)
    if t > 1
        s = [s sep];
    end
    s = [s names{idx(t)}];
end
if isempty(idx)
    s = '(none)';
end
end

function s = join_pairs(names, pairs, sep)
s = '';
for r = 1:size(pairs, 1)
    if r > 1
        s = [s ', '];
    end
    s = [s names{pairs(r, 1)} sep names{pairs(r, 2)}];
end
if isempty(pairs)
    s = '(none)';
end
end

function check_line(label, flag)
if flag
    word = 'yes';
else
    word = 'NO';
end
fprintf('  %-84s: %s\n', label, word);
end
