function Y = define_system(S)
% DEFINE_SYSTEM The whole secure network in one struct: the users, the graph, the secret numbers and the Diffie-Hellman key of every pair of users.
%   Y = define_system() uses define_sets. Y = define_system(S) uses the sets in the struct S.
%   Y.S           the sets
%   Y.users       the names of the users
%   Y.n           the number of users
%   Y.G           the graph of the channels (define_graph)
%   Y.D           the secret numbers and the public values (define_secrets)
%   Y.K           the table of the keys of all pairs of users (dh_key_table)
%   Y.A           the adjacency matrix of the network that is in use. It starts equal to Y.G.adj.
%                 A network with a broken channel is made with Y.A = remove_channel(Y.A, i, j).
%   Y.edge_keys   the key of each channel: element e is the key of the channel in row e of Y.G.edges
if nargin < 1
    S = define_sets();
end
check_dh_setup(S.prime, S.generator);
Y.S = S;
Y.users = S.users;
Y.n = numel(S.users);
Y.G = define_graph(S, define_relations(S));
Y.D = define_secrets(S);
Y.K = dh_key_table(Y.D, S.prime);
Y.A = Y.G.adj;
Y.edge_keys = zeros(1, Y.G.m);
for e = 1:Y.G.m
    Y.edge_keys(e) = Y.K(Y.G.edges(e, 1), Y.G.edges(e, 2));
end
end
