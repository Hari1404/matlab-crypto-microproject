function check_system(Y)
% CHECK_SYSTEM Stop with an error when Y is not a proper network made by define_system.
%   It checks the fields, the sizes, that Y.A is a symmetric 0/1 matrix with no loops and no channel outside Y.G,
%   and that there is one key for each channel, equal to the key in the table of keys.
if ~isstruct(Y)
    error('check_system:type', 'Y must be a struct made by define_system.');
end
names = {'S', 'users', 'n', 'G', 'D', 'K', 'A', 'edge_keys'};
for t = 1:numel(names)
    if ~isfield(Y, names{t})
        error('check_system:field', 'Y has no field %s.', names{t});
    end
end
if ~isstruct(Y.S) || ~isfield(Y.S, 'prime') || ~isfield(Y.S, 'keys')
    error('check_system:sets', 'Y.S must be the sets (define_sets).');
end
if ~isstruct(Y.G) || ~isfield(Y.G, 'edges') || ~isfield(Y.G, 'm') || ~isfield(Y.G, 'adj')
    error('check_system:graph', 'Y.G must be a graph made by define_graph.');
end
if ~isstruct(Y.D) || ~isfield(Y.D, 'private') || ~isfield(Y.D, 'public')
    error('check_system:secrets', 'Y.D must come from define_secrets.');
end
n = Y.n;
if ~is_whole_number(n) || n < 2 || ~iscell(Y.users) || numel(Y.users) ~= n
    error('check_system:size', 'Y.n must be the number of users in Y.users (at least 2).');
end
if numel(Y.D.private) ~= n || numel(Y.D.public) ~= n
    error('check_system:size', 'Y.D must have one secret number and one public value for each user.');
end
if ~isequal(size(Y.K), [n n]) || ~isequal(size(Y.G.adj), [n n]) || ~isequal(size(Y.A), [n n])
    error('check_system:size', 'Y.K, Y.G.adj and Y.A must be n by n matrices.');
end
if ~is_whole_number(Y.G.m) || ~isequal(size(Y.G.edges), [Y.G.m 2])
    error('check_system:size', 'Y.G.edges must have one row for each of the Y.G.m channels.');
end
if ~(isnumeric(Y.A) || islogical(Y.A)) || any(Y.A(:) ~= 0 & Y.A(:) ~= 1)
    error('check_system:matrix', 'Y.A must contain only 0 and 1.');
end
A = (Y.A ~= 0);
if ~isequal(A, A')
    error('check_system:symmetric', 'Y.A must be symmetric.');
end
if any(diag(A))
    error('check_system:loop', 'Y.A must have no loop (a channel from a user to himself).');
end
if any(A(:) & ~logical(Y.G.adj(:)))
    error('check_system:channel', 'Y.A has a channel that is not in the graph Y.G.');
end
if ~isnumeric(Y.edge_keys) || numel(Y.edge_keys) ~= Y.G.m
    error('check_system:keys', 'There must be exactly one key for each channel of Y.G.');
end
for e = 1:Y.G.m
    if Y.edge_keys(e) ~= Y.K(Y.G.edges(e, 1), Y.G.edges(e, 2))
        error('check_system:keys', 'The key of channel %d is not the key in the table of keys.', e);
    end
end
end
