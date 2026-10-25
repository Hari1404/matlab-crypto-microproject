function M = send_message(txt, i, j, D, S)
% SEND_MESSAGE One message from user i to user j, encrypted with their Diffie-Hellman shared key.
%   M = send_message(txt, i, j) uses define_sets and define_secrets.
%   M = send_message(txt, i, j, D, S) uses the secret numbers D (from define_secrets) and the sets S.
%   i is the sender and j is the receiver (user numbers, different). txt is a text of the 95 printable characters, at least one.
%   The sender computes the key from the own secret number and the public value of the receiver.
%   The receiver computes the key from the own secret number and the public value of the sender.
%   M has
%   M.from, M.to       the names of the sender and the receiver
%   M.i, M.j           their user numbers
%   M.text             the text that was sent
%   M.public_from      the public value of the sender (it crosses the channel)
%   M.public_to        the public value of the receiver (it crosses the channel)
%   M.key_sender       the key that the sender computes
%   M.key_receiver     the key that the receiver computes
%   M.agree            true when both keys are the same
%   M.cipher           the encrypted text, a row of numbers from C (this crosses the channel)
%   M.received         the text that the receiver gets (empty when the decryption stops with an error)
%   M.ok               true when the receiver gets the same text that was sent
if nargin < 5
    S = define_sets();
end
if nargin < 4
    D = define_secrets(S);
end
n = numel(S.users);
if ~is_whole_number(i) || i < 1 || i > n
    error('send_message:sender', 'The sender must be one user number from 1 to %d.', n);
end
if ~is_whole_number(j) || j < 1 || j > n
    error('send_message:receiver', 'The receiver must be one user number from 1 to %d.', n);
end
if i == j
    error('send_message:same', 'The sender and the receiver must be different users.');
end
if ~ischar(txt) || size(txt, 1) ~= 1 || size(txt, 2) < 1
    error('send_message:text', 'The message must be a text with at least one character (text in single quotes).');
end
if ~isstruct(D) || ~isfield(D, 'private') || ~isfield(D, 'public') || numel(D.private) ~= n || numel(D.public) ~= n
    error('send_message:secrets', 'D must come from define_secrets and have one secret number and one public value for each user.');
end
p = S.prime;
M.from = S.users{i};
M.to = S.users{j};
M.i = i;
M.j = j;
M.text = txt;
M.public_from = D.public(i);
M.public_to = D.public(j);
M.key_sender = dh_shared_key(D.private(i), D.public(j), p);
M.key_receiver = dh_shared_key(D.private(j), D.public(i), p);
M.agree = (M.key_sender == M.key_receiver);
M.cipher = encrypt_text(txt, M.key_sender, S);
try
    M.received = decrypt_text(M.cipher, M.key_receiver, S);
catch
    M.received = '';
end
M.ok = strcmp(M.received, txt);
end
