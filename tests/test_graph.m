function test_graph()
% TEST_GRAPH Checks for the graph of the communication network, the adjacency matrix and the adjacency list.
S = define_sets();
R = define_relations(S);
G = define_graph(S, R);
c = cell(0, 2);

% --- vertices and edges ---
c(end+1, :) = {'the graph has 6 vertices', G.n == 6 && numel(G.vertices) == 6};
c(end+1, :) = {'the vertices are the 6 users of U', isequal(G.vertices, S.users)};
c(end+1, :) = {'the graph has 6 edges', G.m == 6};
c(end+1, :) = {'the edge list has 6 rows and 2 columns', isequal(size(G.edges), [6 2])};
c(end+1, :) = {'in every edge the first vertex is smaller than the second', all(G.edges(:, 1) < G.edges(:, 2))};
c(end+1, :) = {'all 6 edges are different', size(unique(G.edges, 'rows'), 1) == 6};
c(end+1, :) = {'the edges are Alice-Bob, Alice-Carol, Bob-Dave, Carol-Dave, Dave-Frank, Frank-Grace', isequal(G.edges, [1 2; 1 3; 2 4; 3 4; 4 5; 5 6])};
ok = true;
for e = 1:G.m
    names = sort({G.vertices{G.edges(e, 1)}, G.vertices{G.edges(e, 2)}});
    found = any(strcmp(R.channels(:, 1), names{1}) & strcmp(R.channels(:, 2), names{2})) || any(strcmp(R.channels(:, 1), names{2}) & strcmp(R.channels(:, 2), names{1}));
    ok = ok && found;
end
c(end+1, :) = {'every edge is one of the channels of define_relations', ok};

% --- adjacency matrix ---
A = G.adj;
c(end+1, :) = {'the adjacency matrix is 6 by 6', isequal(size(A), [6 6])};
c(end+1, :) = {'the adjacency matrix holds true and false', islogical(A)};
c(end+1, :) = {'the adjacency matrix is symmetric', isequal(A, A')};
c(end+1, :) = {'the diagonal is all zero (no loops)', ~any(diag(A))};
c(end+1, :) = {'the adjacency matrix has 12 ones (2 for each edge)', sum(A(:)) == 12};
c(end+1, :) = {'the adjacency matrix is the same as the R1 matrix', isequal(A, R.talk)};
c(end+1, :) = {'Alice and Bob are joined', A(1, 2) && A(2, 1)};
c(end+1, :) = {'Dave and Frank are joined', A(4, 5) && A(5, 4)};
c(end+1, :) = {'Frank and Grace are joined', A(5, 6) && A(6, 5)};
c(end+1, :) = {'Alice and Dave are not joined', ~A(1, 4) && ~A(4, 1)};
c(end+1, :) = {'Grace and Alice are not joined', ~A(6, 1) && ~A(1, 6)};
c(end+1, :) = {'the matrix built again from the edges is the same', isequal(edges_to_adjacency(G.edges, 6), A)};

% --- adjacency list ---
L = G.adj_list;
c(end+1, :) = {'the adjacency list has one cell for each vertex', iscell(L) && numel(L) == 6};
c(end+1, :) = {'the neighbors of Alice are Bob and Carol', isequal(L{1}, [2 3])};
c(end+1, :) = {'the neighbors of Bob are Alice and Dave', isequal(L{2}, [1 4])};
c(end+1, :) = {'the neighbors of Carol are Alice and Dave', isequal(L{3}, [1 4])};
c(end+1, :) = {'the neighbors of Dave are Bob, Carol and Frank', isequal(L{4}, [2 3 5])};
c(end+1, :) = {'the neighbors of Frank are Dave and Grace', isequal(L{5}, [4 6])};
c(end+1, :) = {'the neighbors of Grace are only Frank', isequal(L{6}, 5)};
ok = true;
for i = 1:6
    ok = ok && issorted(L{i}) && all(A(i, L{i}));
end
c(end+1, :) = {'every list is in increasing order and every listed neighbor is joined', ok};
c(end+1, :) = {'the list gives the matrix back', isequal(list_to_adjacency(L), A)};
c(end+1, :) = {'the matrix gives the list back', isequal(adjacency_to_list(A), L)};

% --- degrees ---
c(end+1, :) = {'the degrees are 2 2 2 3 2 1', isequal(G.degree, [2 2 2 3 2 1])};
c(end+1, :) = {'Dave has the largest degree (3)', G.degree(4) == max(G.degree) && sum(G.degree == max(G.degree)) == 1};
c(end+1, :) = {'Grace has the smallest degree (1)', G.degree(6) == min(G.degree)};
c(end+1, :) = {'the sum of the degrees is twice the number of edges (12)', sum(G.degree) == 2 * G.m && sum(G.degree) == 12};
c(end+1, :) = {'the degree of each vertex is the length of its list', isequal(G.degree, cellfun(@numel, L))};

% --- the helper functions on small graphs ---
Ap = edges_to_adjacency([1 2; 2 3], 3);
c(end+1, :) = {'a path of 3 vertices gives the right matrix', isequal(Ap, logical([0 1 0; 1 0 1; 0 1 0]))};
Lp = adjacency_to_list(Ap);
c(end+1, :) = {'a path of 3 vertices gives the right list', isequal(Lp, {2, [1 3], 2})};
At = edges_to_adjacency([1 2; 2 3; 1 3], 3);
c(end+1, :) = {'a triangle has all off-diagonal entries true', isequal(At, ~logical(eye(3)))};
c(end+1, :) = {'an empty edge list gives an empty 4 by 4 matrix', isequal(edges_to_adjacency([], 4), false(4, 4))};
Le = adjacency_to_list(false(3, 3));
c(end+1, :) = {'a graph with no edges gives empty lists', numel(Le) == 3 && all(cellfun(@isempty, Le))};
c(end+1, :) = {'an edge written twice is counted once', isequal(edges_to_adjacency([1 2; 2 1], 2), logical([0 1; 1 0]))};
c(end+1, :) = {'a loop edge is rejected', raises_error(@() edges_to_adjacency([2 2], 3))};
c(end+1, :) = {'an edge with a vertex outside 1 to n is rejected', raises_error(@() edges_to_adjacency([1 7], 3))};
c(end+1, :) = {'an edge with vertex 0 is rejected', raises_error(@() edges_to_adjacency([0 1], 3))};
c(end+1, :) = {'an edge with a fractional vertex is rejected', raises_error(@() edges_to_adjacency([1 2.5], 3))};
c(end+1, :) = {'an edge list with three columns is rejected', raises_error(@() edges_to_adjacency([1 2 3], 3))};
c(end+1, :) = {'a matrix that is not square is rejected by adjacency_to_list', raises_error(@() adjacency_to_list(false(2, 3)))};
c(end+1, :) = {'a neighbor outside 1 to n is rejected by list_to_adjacency', raises_error(@() list_to_adjacency({2, 5}))};
c(end+1, :) = {'a fractional neighbor is rejected by list_to_adjacency', raises_error(@() list_to_adjacency({1.5, 1}))};

% --- define_graph ---
c(end+1, :) = {'define_graph works without arguments', isequal(define_graph(), G)};
R2 = R;
R2.talk_pairs = R.talk_pairs(1:6, :);
R2.talk = pairs_to_matrix(R2.talk_pairs, 6, 6);
c(end+1, :) = {'a one-way relation R1 is rejected by define_graph', raises_error(@() define_graph(S, R2))};

summarize_checks('test_graph', c);
end

function flag = raises_error(f)
flag = false;
try
    f();
catch
    flag = true;
end
end
