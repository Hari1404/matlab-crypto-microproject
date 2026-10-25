function k = channel_key(Y, i, j)
% CHANNEL_KEY The key of the channel between user i and user j.
%   Y comes from define_system. The channel must be in the network that is in use (Y.A), so a removed channel has no key.
check_system(Y);
n = Y.n;
if ~is_whole_number(i) || i < 1 || i > n
    error('channel_key:user', 'The first user must be one user number from 1 to %d.', n);
end
if ~is_whole_number(j) || j < 1 || j > n
    error('channel_key:user', 'The second user must be one user number from 1 to %d.', n);
end
if i == j
    error('channel_key:same', 'The two users must be different.');
end
if ~Y.A(i, j)
    error('channel_key:missing', 'There is no channel between %s and %s.', Y.users{i}, Y.users{j});
end
e = find(Y.G.edges(:, 1) == min(i, j) & Y.G.edges(:, 2) == max(i, j), 1);
k = Y.edge_keys(e);
end
