function G = define_graph(S, R)
% DEFINE_GRAPH Build the communication network as a graph and return it in a struct.
%   The graph is the relation R1 (can talk with) drawn as a graph: the users are the
%   vertices and each channel is one undirected edge. Vertex i is user i.
%   G.vertices   the names of the users
%   G.n          the number of vertices
%   G.edges      one row [i j] for each edge, with i < j, in increasing order (edge number e is row e)
%   G.m          the number of edges
%   G.adj        the adjacency matrix (n by n, true where an edge joins two users)
%   G.adj_list   the adjacency list (cell array, G.adj_list{i} holds the neighbors of vertex i)
%   G.degree     the degree of each vertex (row vector)
%   define_graph()      uses define_sets and define_relations.
%   define_graph(S, R)  uses the structs S and R.
if nargin < 1
    S = define_sets();
end
if nargin < 2
    R = define_relations(S);
end
n = numel(S.users);
pairs = R.talk_pairs;
E = sortrows(pairs(pairs(:, 1) < pairs(:, 2), :));

G.vertices = S.users;
G.n = n;
G.edges = E;
G.m = size(E, 1);
G.adj = edges_to_adjacency(E, n);
if ~isequal(G.adj, R.talk)
    error('define_graph:relation', 'The relation R1 must be symmetric and must have no pair (u, u), so that it describes a graph.');
end
G.adj_list = adjacency_to_list(G.adj);
G.degree = sum(G.adj, 2)';
end
