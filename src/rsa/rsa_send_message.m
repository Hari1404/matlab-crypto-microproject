function M = rsa_send_message(txt, i, j, R, S)
% RSA_SEND_MESSAGE One message from user i to user j, encrypted with the public key of j.
%   M = rsa_send_message(txt, i, j) uses define_sets and define_rsa_users.
%   M = rsa_send_message(txt, i, j, R, S) uses the RSA keys R (from define_rsa_users) and the sets S.
%   i is the sender and j is the receiver (user numbers, different). txt is a text of the 95 printable characters, at least one.
%   The sender needs only the public key (n, e) of the receiver: no secret and no key exchange.
%   The receiver decrypts with the own private key d.
%   M has
%   M.from, M.to   the names of the sender and the receiver
%   M.i, M.j       their user numbers
%   M.text         the text that was sent
%   M.n, M.e       the public key of the receiver that was used
%   M.cipher       the encrypted text, a row of numbers from 0 to n-1 (this crosses the channel)
%   M.received     the text that the receiver gets (empty when the decryption stops with an error)
%   M.ok           true when the receiver gets the same text that was sent
%   The errors are rsa_send_message:sender, :receiver, :same and :text. Bad keys R stop with the errors of check_rsa_users.
if nargin < 5
    S = define_sets();
end
if nargin < 4
    R = define_rsa_users(S);
end
nu = numel(S.users);
if ~is_whole_number(i) || i < 1 || i > nu
    error('rsa_send_message:sender', 'The sender must be one user number from 1 to %d.', nu);
end
if ~is_whole_number(j) || j < 1 || j > nu
    error('rsa_send_message:receiver', 'The receiver must be one user number from 1 to %d.', nu);
end
if i == j
    error('rsa_send_message:same', 'The sender and the receiver must be different users.');
end
if ~ischar(txt) || size(txt, 1) ~= 1 || size(txt, 2) < 1
    error('rsa_send_message:text', 'The message must be a text with at least one character (text in single quotes).');
end
check_rsa_users(R, S);
M.from = S.users{i};
M.to = S.users{j};
M.i = i;
M.j = j;
M.text = txt;
M.n = R.n(j);
M.e = R.e(j);
M.cipher = rsa_encrypt_text(txt, M.n, M.e);
try
    M.received = rsa_decrypt_text(M.cipher, R.n(j), R.d(j));
catch
    M.received = '';
end
M.ok = strcmp(M.received, txt);
end
