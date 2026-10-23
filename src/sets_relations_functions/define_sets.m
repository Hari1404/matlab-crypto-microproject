function S = define_sets()
% DEFINE_SETS Build the sets of the system and return them in a struct.
%   S.users      U, the users
%   S.plain      P, the plaintext symbols (numbers 1 to 95)
%   S.cipher     C, the ciphertext values (numbers 1 to 96)
%   S.keys       K, the keys (numbers 1 to 96, the group Z_97 star)
%   S.alphabet   the 95 printable characters; character number i is symbol i
%   S.prime      the prime p used by Diffie-Hellman and by the cipher
%   S.generator  the generator g of the group
S.prime = 97;
S.generator = 5;
S.users = {'Alice', 'Bob', 'Carol', 'Dave', 'Frank', 'Grace'};
S.alphabet = char(32:126);
S.plain = 1:numel(S.alphabet);
S.cipher = 1:(S.prime - 1);
S.keys = 1:(S.prime - 1);
end
