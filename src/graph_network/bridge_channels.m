function E = bridge_channels(A)
% BRIDGE_CHANNELS The edges whose removal splits a group of the graph into more groups.
%   E has one row [i j] (with i < j) for each such edge, in increasing order. It has 0 rows if there is none.
E = zeros(0, 2);
all_edges = adjacency_to_edges(A);
[comp, k] = connected_components(A);
for r = 1:size(all_edges, 1)
    B = remove_channel(A, all_edges(r, 1), all_edges(r, 2));
    [comp2, k2] = connected_components(B);
    if k2 > k
        E(end + 1, :) = all_edges(r, :);
    end
end
end
