function demo_point1()
% DEMO_POINT1 Demonstration of Point 1: sets, relations and functions.
%   Packet 1A shows the sets and the conversion between text and symbols.
%   Packet 1B shows the relations (who can talk to whom, who owns which key).
%   Packet 1C shows encryption and decryption as functions.
fprintf('\n##### POINT 1 DEMO: SETS, RELATIONS AND FUNCTIONS #####\n');
S = define_sets();
show_sets(S);
fprintf('\n=== TEXT TO SYMBOLS AND BACK ===\n');
msg = 'Hello Bob';
sym = text_to_symbols(msg);
back = symbols_to_text(sym);
fprintf('Message          : %s\n', msg);
fprintf('Symbols (from P) : %s\n', mat2str(sym));
fprintf('Back to text     : %s\n', back);
fprintf('Same as before?  : %s\n', yes_or_no(isequal(msg, back)));
R = define_relations(S);
show_relations(S, R);

k = 85;
show_cipher(S, k);
fprintf('\n=== ENCRYPTING A MESSAGE ===\n');
cvals = encrypt_text(msg, k, S);
fprintf('Message                      : %s\n', msg);
fprintf('Key k (example)              : %d\n', k);
fprintf('Ciphertext values (from C)   : %s\n', mat2str(cvals));
fprintf('Decrypted with the right key : %s\n', decrypt_text(cvals, k, S));
wrong = 2;
try
    bad = decrypt_text(cvals, wrong, S);
    fprintf('Decrypted with a wrong key %d : %s\n', wrong, bad);
catch
    fprintf('Decrypted with a wrong key %d : fails, a value falls outside P\n', wrong);
end
end

function s = yes_or_no(flag)
if flag
    s = 'yes';
else
    s = 'NO';
end
end
