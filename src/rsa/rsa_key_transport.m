function T = rsa_key_transport(txt, k, i, j, R, S)
% RSA_KEY_TRANSPORT Send a key of the cipher of Point 1 with RSA, then send a text with that key.
%   T = rsa_key_transport(txt, k, i, j) uses define_sets and define_rsa_users.
%   T = rsa_key_transport(txt, k, i, j, R, S) uses the RSA keys R (from define_rsa_users) and the sets S.
%   i is the sender and j is the receiver (user numbers, different). k is the key: a whole number from 1 to p-1 (p is S.prime).
%   The sender encrypts the key k with the public key (n, e) of the receiver: key_cipher = k^e mod n.
%   The receiver decrypts it with the own private key d: key_received = key_cipher^d mod n.
%   The text is then encrypted with encrypt_text and the key k, and decrypted with decrypt_text and the key that the receiver got.
%   T has
%   T.from, T.to          the names of the sender and the receiver
%   T.i, T.j              their user numbers
%   T.text                the text that was sent
%   T.key                 the key k that the sender chose
%   T.n, T.e              the public key of the receiver that was used
%   T.key_cipher          the encrypted key (this crosses the channel)
%   T.key_received        the key that the receiver gets
%   T.agree               true when the receiver gets the key k
%   T.cipher              the encrypted text, a row of numbers from C (this crosses the channel)
%   T.received            the text that the receiver gets (empty when the decryption stops with an error)
%   T.ok                  true when the receiver gets the same text that was sent
%   The errors are rsa_key_transport:sender, :receiver, :same, :text and :key. Bad keys R stop with the errors of check_rsa_users.
if nargin < 6
    S = define_sets();
end
if nargin < 5
    R = define_rsa_users(S);
end
nu = numel(S.users);
if ~is_whole_number(i) || i < 1 || i > nu
    error('rsa_key_transport:sender', 'The sender must be one user number from 1 to %d.', nu);
end
if ~is_whole_number(j) || j < 1 || j > nu
    error('rsa_key_transport:receiver', 'The receiver must be one user number from 1 to %d.', nu);
end
if i == j
    error('rsa_key_transport:same', 'The sender and the receiver must be different users.');
end
if ~ischar(txt) || size(txt, 1) ~= 1 || size(txt, 2) < 1
    error('rsa_key_transport:text', 'The message must be a text with at least one character (text in single quotes).');
end
if ~is_whole_number(k) || k < 1 || k > S.prime - 1
    error('rsa_key_transport:key', 'The key must be one whole number from 1 to %d.', S.prime - 1);
end
check_rsa_users(R, S);
T.from = S.users{i};
T.to = S.users{j};
T.i = i;
T.j = j;
T.text = txt;
T.key = k;
T.n = R.n(j);
T.e = R.e(j);
T.key_cipher = rsa_encrypt_number(k, T.n, T.e);
T.key_received = rsa_decrypt_number(T.key_cipher, R.n(j), R.d(j));
T.agree = (T.key_received == k);
T.cipher = encrypt_text(txt, k, S);
try
    T.received = decrypt_text(T.cipher, T.key_received, S);
catch
    T.received = '';
end
T.ok = strcmp(T.received, txt);
end
