function V = cut_users(A)
% CUT_USERS The vertices whose removal (with their edges) splits a group of the graph into more groups.
%   V is a row of vertex numbers in increasing order (empty if there is none).
V = zeros(1, 0);
[comp, k] = connected_components(A);
for v = 1:size(A, 1)
    B = remove_user(A, v);
    [comp2, k2] = connected_components(B);
    if k2 > k
        V(end + 1) = v;
    end
end
end
