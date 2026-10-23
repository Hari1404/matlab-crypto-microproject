function show_graph(G)
% SHOW_GRAPH Print the communication network as a graph in the Command Window.
%   show_graph()   uses define_graph.
%   show_graph(G)  prints the graph in the struct G.
if nargin < 1
    G = define_graph();
end
n = G.n;

fprintf('\n=== THE COMMUNICATION NETWORK AS A GRAPH ===\n');
fprintf('The graph G = (V, E) has the %d users as vertices and the %d channels as edges.\n', n, G.m);
fprintf('It is the relation R1 (can talk with) drawn as a graph: R1 is symmetric and no user talks to themself, so each channel is one undirected edge.\n');

fprintf('\nVertices (%d):\n', n);
for i = 1:n
    fprintf('  %d  %s\n', i, G.vertices{i});
end

fprintf('\nEdges (%d):\n', G.m);
for e = 1:G.m
    fprintf('  e%d  %s - %s\n', e, G.vertices{G.edges(e, 1)}, G.vertices{G.edges(e, 2)});
end

w = max(cellfun(@numel, G.vertices)) + 2;
fmt_name = sprintf('%%-%ds', w);
fprintf('\nAdjacency matrix (1 means an edge joins the two users):\n');
fprintf('%s', repmat(' ', 1, w));
for j = 1:n
    fprintf(fmt_name, G.vertices{j});
end
fprintf('\n');
for i = 1:n
    fprintf(fmt_name, G.vertices{i});
    for j = 1:n
        fprintf(fmt_name, sprintf('%d', double(G.adj(i, j))));
    end
    fprintf('\n');
end

fprintf('\nAdjacency list (the neighbors of each user):\n');
for i = 1:n
    fprintf(fmt_name, G.vertices{i});
    fprintf(': %s\n', join_names(G.vertices, G.adj_list{i}));
end

fprintf('\nDegree of each user (the number of channels at that user):\n');
for i = 1:n
    fprintf(fmt_name, G.vertices{i});
    fprintf(': %d\n', G.degree(i));
end
total = sum(G.degree);
fprintf('Sum of the degrees = %d, and 2 x %d edges = %d (every edge is counted at both of its ends)\n', total, G.m, 2 * G.m);

fprintf('\nChecks:\n');
check_line('The adjacency matrix is symmetric (a channel works in both directions)', isequal(G.adj, G.adj'));
check_line('The diagonal is all zero (no user has a channel to themself)', ~any(diag(G.adj)));
check_line('The sum of the degrees is twice the number of edges', total == 2 * G.m);
check_line('The adjacency list and the adjacency matrix describe the same graph', isequal(list_to_adjacency(G.adj_list), G.adj));
end

function s = join_names(names, idx)
s = '';
for t = 1:numel(idx)
    if t > 1
        s = [s ', '];
    end
    s = [s names{idx(t)}];
end
if isempty(idx)
    s = '(none)';
end
end

function check_line(label, flag)
if flag
    word = 'yes';
else
    word = 'NO';
end
fprintf('  %-72s: %s\n', label, word);
end
