function D = define_digraph(S, G, arcs)
% DEFINE_DIGRAPH Build the communication network as a directed graph and return it in a struct.
%   The users are the vertices. An arc [i j] means that user i can send to user j. Every channel of the graph G
%   gets one arc (it works in one direction only) or two arcs (it works in both directions).
%   D.vertices   the names of the users            D.n  the number of vertices
%   D.arcs       one row [i j] for each arc, sorted by i and then by j (arc number a is row a)
%   D.m          the number of arcs
%   D.adj        the adjacency matrix (true at (i, j) when the arc i -> j exists; not symmetric in general)
%   D.out_list   out_list{i} holds the users that i can send to      D.in_list   in_list{i} holds the users that can send to i
%   D.out_degree, D.in_degree   row vectors
%   D.two_way    rows [i j] with i < j, the channels with both arcs  D.one_way   rows [i j], the arc goes from i to j
%   define_digraph()           uses define_sets, define_graph and the default arcs.
%   define_digraph(S, G)       uses the structs S and G.
%   define_digraph(S, G, arcs) uses the given arc list instead of the default one.
%   Errors: define_digraph:channel (an arc joins two users who have no channel in G),
%   define_digraph:missing (a channel of G has no arc).
if nargin < 1
    S = define_sets();
end
if nargin < 2
    G = define_graph(S);
end
if nargin < 3
    arcs = [1 2; 2 1; 2 4; 3 1; 4 3; 4 5; 5 4; 5 6];
end
n = G.n;
A = arcs_to_adjacency(arcs, n);
arcs = adjacency_to_arcs(A);
U = A | A';
if ~isequal(U, G.adj)
    if any(any(U & ~G.adj))
        error('define_digraph:channel', 'An arc joins two users who have no channel in the graph G.');
    else
        error('define_digraph:missing', 'A channel of the graph G has no arc.');
    end
end
D.vertices = S.users;
D.n = n;
D.arcs = arcs;
D.m = size(arcs, 1);
D.adj = A;
D.out_list = adjacency_to_list(A);
D.in_list = adjacency_to_list(A');
D.out_degree = sum(A, 2)';
D.in_degree = sum(A, 1);
both = A & A';
[bi, bj] = find(triu(both));
D.two_way = [bi bj];
[oi, oj] = find(A & ~A');
D.one_way = [oi oj];
end
