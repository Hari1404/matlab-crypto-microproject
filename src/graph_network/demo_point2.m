function demo_point2()
% DEMO_POINT2 Demonstration of Point 2: the graph network.
%   Packet 2A shows the network as a graph: the edges, the adjacency matrix, the adjacency list and the degrees.
fprintf('\n##### POINT 2 DEMO: THE GRAPH NETWORK #####\n');
S = define_sets();
R = define_relations(S);
G = define_graph(S, R);
show_graph(G);
end
