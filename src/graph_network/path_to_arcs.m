function ids = path_to_arcs(arcs, path)
% PATH_TO_ARCS The arc numbers along a directed path (or along a directed cycle, if its first vertex is repeated at the end).
%   arcs is the arc list (one row [i j] for each arc, as in D.arcs); path is a row of vertices.
%   ids(r) is the number of the arc that goes from path(r) to path(r + 1). A path with one vertex gives an empty row.
%   Error path_to_arcs:missing when there is no arc from one vertex of the path to the next one (the direction counts).
ids = zeros(1, 0);
for r = 1:(numel(path) - 1)
    a = find(arcs(:, 1) == path(r) & arcs(:, 2) == path(r + 1));
    if isempty(a)
        error('path_to_arcs:missing', 'There is no arc from vertex %d to vertex %d.', path(r), path(r + 1));
    end
    ids(end + 1) = a(1);
end
end
