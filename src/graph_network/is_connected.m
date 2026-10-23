function flag = is_connected(A)
% IS_CONNECTED True when every vertex can reach every other vertex (one group only).
%   A graph with no vertices is not connected.
[comp, k] = connected_components(A);
flag = (k == 1);
end
