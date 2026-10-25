function R = route_message(txt, i, j, Y)
% ROUTE_MESSAGE Send a message from user i to user j along the shortest path of the network Y.A.
%   Every hop is one send_message with the key of that channel. Every relay decrypts and encrypts again (hop by hop).
%   The relays can read the text. This is not end-to-end encryption.
%   R.from, R.to, R.i, R.j   the names and the numbers of the sender and the receiver
%   R.text                   the text that was sent
%   R.reachable              true when there is a path from i to j
%   R.path                   the users on the route (empty when there is none)
%   R.hops                   the number of channels on the route (Inf when there is none)
%   R.relays                 the users in the middle of the route
%   R.readers                the users who can read the text (the route, or just the sender when there is no route)
%   R.keys                   the key of each channel on the route
%   R.ciphers                cell array, the numbers that cross each channel
%   R.texts                  cell array, the text that each hop gives to the next user
%   R.received               the text that the receiver gets (empty when it does not arrive)
%   R.delivered              true when the receiver gets the same text that was sent
%   An unreachable receiver or a hop that fails is not an error: delivered is false.
check_system(Y);
n = Y.n;
if ~is_whole_number(i) || i < 1 || i > n
    error('route_message:sender', 'The sender must be one user number from 1 to %d.', n);
end
if ~is_whole_number(j) || j < 1 || j > n
    error('route_message:receiver', 'The receiver must be one user number from 1 to %d.', n);
end
if i == j
    error('route_message:same', 'The sender and the receiver must be different users.');
end
if ~ischar(txt) || size(txt, 1) ~= 1 || size(txt, 2) < 1
    error('route_message:text', 'The message must be a text with at least one character (text in single quotes).');
end
codes = double(txt);
if any(codes < 32) || any(codes > 126)
    error('route_message:text', 'The text has a character outside the 95 printable characters (space to ~).');
end
R.from = Y.users{i};
R.to = Y.users{j};
R.i = i;
R.j = j;
R.text = txt;
[path, len] = shortest_path(Y.A, i, j);
R.reachable = ~isinf(len);
R.path = path;
R.hops = len;
R.relays = zeros(1, 0);
R.readers = i;
R.keys = zeros(1, 0);
R.ciphers = cell(1, 0);
R.texts = cell(1, 0);
R.received = '';
R.delivered = false;
if ~R.reachable
    return;
end
R.relays = path(2:end - 1);
R.readers = path;
cur = txt;
good = true;
for h = 1:len
    a = path(h);
    b = path(h + 1);
    R.keys(h) = channel_key(Y, a, b);
    M = send_message(cur, a, b, Y.D, Y.S);
    R.ciphers{h} = M.cipher;
    if ~M.ok
        good = false;
        break;
    end
    cur = M.received;
    R.texts{h} = cur;
end
if good && strcmp(cur, txt)
    R.received = cur;
    R.delivered = true;
end
end
