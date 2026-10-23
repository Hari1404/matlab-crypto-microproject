function cyc = find_cycle(A)
% FIND_CYCLE A shortest cycle of an undirected graph, or an empty row if the graph has no cycle.
%   cyc lists the vertices of the cycle once each, and the last one is joined to the first one.
%   The cycle starts at its smallest vertex and goes first to the smaller of its two neighbors there.
%   Method: an edge u-v lies on a cycle exactly when u and v are still joined after the edge is removed.
E = adjacency_to_edges(A);
cyc = zeros(1, 0);
for r = 1:size(E, 1)
    B = remove_channel(A, E(r, 1), E(r, 2));
    p = shortest_path(B, E(r, 1), E(r, 2));
    if ~isempty(p) && (isempty(cyc) || numel(p) < numel(cyc))
        cyc = p;
    end
end
if ~isempty(cyc)
    [m, pos] = min(cyc);
    cyc = cyc([pos:numel(cyc), 1:(pos - 1)]);
    if cyc(2) > cyc(end)
        cyc = [cyc(1), fliplr(cyc(2:end))];
    end
end
end
