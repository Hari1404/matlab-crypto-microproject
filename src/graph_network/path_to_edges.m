function ids = path_to_edges(E, path)
% PATH_TO_EDGES The edge numbers along a path (or along a cycle, if its first vertex is repeated at the end).
%   E is the edge list (one row [i j] with i < j for each edge, as in G.edges); path is a row of vertices.
%   ids(r) is the number of the edge between path(r) and path(r + 1). A path with one vertex gives an empty row.
%   An error is raised when two neighbors on the path are not joined by an edge.
ids = zeros(1, 0);
for r = 1:(numel(path) - 1)
    a = min(path(r), path(r + 1));
    b = max(path(r), path(r + 1));
    e = find(E(:, 1) == a & E(:, 2) == b);
    if isempty(e)
        error('path_to_edges:missing', 'There is no edge between vertex %d and vertex %d.', a, b);
    end
    ids(end + 1) = e(1);
end
end
