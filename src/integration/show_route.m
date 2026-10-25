function show_route(R, Y)
% SHOW_ROUTE Print the result R of route_message for the system Y: the route, the keys, who can read the text and what arrives.
%   Y is needed for the names and for the groups of the network in use (Y.A).
names = Y.users;
answer = {'NO', 'yes'};
fprintf('  %s sends to %s: %s\n', R.from, R.to, R.text);
if ~R.reachable
    [comp, k] = connected_components(Y.A);
    fprintf('  There is no route from %s to %s in the network now, so the message cannot be sent.\n', R.from, R.to);
    fprintf('  The network has %d group%s: %s\n', k, plural_s(k), format_groups(names, comp));
    fprintf('  Only %s knows the text.\n', R.from);
    return;
end
fprintf('  The shortest route is %s (%d channel%s).\n', format_names(names, R.path, ' - '), R.hops, plural_s(R.hops));
fprintf('  Hop   From      To        Key   The numbers that cross the channel\n');
for h = 1:numel(R.ciphers)
    c = R.ciphers{h};
    if numel(c) <= 8
        shown = strtrim(sprintf('%d ', c));
    else
        shown = [strtrim(sprintf('%d ', c(1:6))) ' ...'];
    end
    fprintf('  %-6d%-10s%-10s%-6d%s\n', h, names{R.path(h)}, names{R.path(h + 1)}, R.keys(h), shown);
end
fprintf('  The users who can read the message: %s.\n', format_names(names, R.readers));
if isempty(R.relays)
    fprintf('  Nobody is in the middle, so only %s and %s can read it.\n', R.from, R.to);
else
    fprintf('  The users in the middle (%s) decrypt and encrypt it again, so they see the text.\n', format_names(names, R.relays));
end
if R.delivered
    fprintf('  %s gets: %s\n', R.to, R.received);
else
    fprintf('  The message did not arrive: a hop gave a wrong text.\n');
end
fprintf('  It is the same as the message: %s\n', answer{double(R.delivered) + 1});
end
