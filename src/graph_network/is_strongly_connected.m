function tf = is_strongly_connected(A)
% IS_STRONGLY_CONNECTED True when every vertex can reach every other vertex along the arcs (one strong group).
[comp, k] = strong_components(A);
tf = (k == 1) || isempty(comp);
end
