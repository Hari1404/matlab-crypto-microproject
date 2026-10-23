function test_cipher()
% TEST_CIPHER Checks for the key inverse, encryption, decryption and the cipher as a function.
S = define_sets();
c = cell(0, 2);

% --- key_inverse ---
c(end+1, :) = {'the inverse of 1 is 1', key_inverse(1, S) == 1};
c(end+1, :) = {'the inverse of 5 is 39 (5 * 39 = 195 = 2 * 97 + 1)', key_inverse(5, S) == 39};
c(end+1, :) = {'the inverse of 85 is 8', key_inverse(85, S) == 8};
c(end+1, :) = {'the inverse of 96 is 96 (96 is -1)', key_inverse(96, S) == 96};
ok = true;
for k = S.keys
    j = key_inverse(k, S);
    ok = ok && isscalar(j) && ismember(j, S.keys) && mod(k * j, S.prime) == 1;
end
c(end+1, :) = {'every key k has an inverse j in K with k*j = 1 (mod 97)', ok};
c(end+1, :) = {'key_inverse works without the sets argument', key_inverse(5) == 39};
c(end+1, :) = {'key 0 is rejected by key_inverse', raises_error(@() key_inverse(0, S))};
c(end+1, :) = {'key 97 is rejected by key_inverse', raises_error(@() key_inverse(97, S))};
c(end+1, :) = {'key 2.5 is rejected by key_inverse', raises_error(@() key_inverse(2.5, S))};

% --- encrypt_symbols ---
c(end+1, :) = {'E_85 of the symbols 1 2 3 is 85 73 61', isequal(encrypt_symbols([1 2 3], 85, S), [85 73 61])};
c(end+1, :) = {'E_85 of Hello Bob gives the right values', isequal(encrypt_symbols(text_to_symbols('Hello Bob'), 85, S), [90 33 46 46 10 85 65 10 69])};
c(end+1, :) = {'key 1 leaves every symbol unchanged', isequal(encrypt_symbols(S.plain, 1, S), S.plain)};
c(end+1, :) = {'key 96 turns m into 97 - m', isequal(encrypt_symbols(S.plain, 96, S), 97 - S.plain)};
ok = true;
for k = S.keys
    v = encrypt_symbols(S.plain, k, S);
    ok = ok && all(ismember(v, S.cipher)) && isequal(size(v), [1 95]);
end
c(end+1, :) = {'for every key, E_k gives 95 values and all of them are in C', ok};
c(end+1, :) = {'the encrypted values come as a row', size(encrypt_symbols([1; 2; 3], 85, S), 1) == 1};
c(end+1, :) = {'an empty list of symbols gives no values', isempty(encrypt_symbols([], 85, S))};
c(end+1, :) = {'encrypt_symbols works without the sets argument', isequal(encrypt_symbols([1 2 3], 85), [85 73 61])};
c(end+1, :) = {'symbol 0 is rejected by encrypt_symbols', raises_error(@() encrypt_symbols(0, 85, S))};
c(end+1, :) = {'symbol 96 is rejected by encrypt_symbols', raises_error(@() encrypt_symbols(96, 85, S))};
c(end+1, :) = {'symbol 2.5 is rejected by encrypt_symbols', raises_error(@() encrypt_symbols(2.5, 85, S))};
c(end+1, :) = {'key 0 is rejected by encrypt_symbols', raises_error(@() encrypt_symbols(1, 0, S))};
c(end+1, :) = {'key 97 is rejected by encrypt_symbols', raises_error(@() encrypt_symbols(1, 97, S))};
c(end+1, :) = {'two keys at once are rejected by encrypt_symbols', raises_error(@() encrypt_symbols(1, [3 4], S))};

% --- decrypt_symbols ---
c(end+1, :) = {'D_85 of 85 73 61 is 1 2 3', isequal(decrypt_symbols([85 73 61], 85, S), [1 2 3])};
ok = true;
for k = S.keys
    ok = ok && isequal(decrypt_symbols(encrypt_symbols(S.plain, k, S), k, S), S.plain);
end
c(end+1, :) = {'D_k(E_k(m)) = m for all 95 symbols and all 96 keys', ok};
c(end+1, :) = {'decrypt_symbols works without the sets argument', isequal(decrypt_symbols([85 73 61], 85), [1 2 3])};
c(end+1, :) = {'an empty list of values gives no symbols', isempty(decrypt_symbols([], 85, S))};
c(end+1, :) = {'with key 1 the value 96 is rejected (96 is not a symbol)', raises_error(@() decrypt_symbols(96, 1, S))};
c(end+1, :) = {'value 0 is rejected by decrypt_symbols', raises_error(@() decrypt_symbols(0, 85, S))};
c(end+1, :) = {'value 97 is rejected by decrypt_symbols', raises_error(@() decrypt_symbols(97, 85, S))};
c(end+1, :) = {'key 0 is rejected by decrypt_symbols', raises_error(@() decrypt_symbols(1, 0, S))};
c(end+1, :) = {'a wrong key that gives 96 is rejected', raises_error(@() decrypt_symbols(encrypt_symbols(text_to_symbols('Hello Bob'), 85, S), 12, S))};

% --- encrypt_text and decrypt_text ---
cv = encrypt_text('Hello Bob', 85, S);
c(end+1, :) = {'encrypt_text gives the same values as encrypt_symbols', isequal(cv, [90 33 46 46 10 85 65 10 69])};
c(end+1, :) = {'decrypt_text gives back Hello Bob', isequal(decrypt_text(cv, 85, S), 'Hello Bob')};
ok = true;
for k = S.keys
    ok = ok && isequal(decrypt_text(encrypt_text(S.alphabet, k, S), k, S), S.alphabet);
end
c(end+1, :) = {'text -> encrypt -> decrypt works for all 95 characters and all 96 keys', ok};
c(end+1, :) = {'decrypting Hello Bob with the wrong key 2 gives other text', ~isequal(decrypt_text(cv, 2, S), 'Hello Bob') && isequal(decrypt_text(cv, 2, S), 'L`66$zp$r')};
c(end+1, :) = {'an empty text gives no values', isempty(encrypt_text('', 85, S))};
c(end+1, :) = {'encrypt_text and decrypt_text work without the sets argument', isequal(decrypt_text(encrypt_text('Hi', 85), 85), 'Hi')};
c(end+1, :) = {'a number instead of text is rejected by encrypt_text', raises_error(@() encrypt_text(65, 85, S))};

% --- E_k as a relation and a function ---
[pairs, M] = cipher_relation(85, S);
c(end+1, :) = {'the relation of E_85 has 95 pairs', isequal(size(pairs), [95 2])};
c(end+1, :) = {'the relation matrix of E_85 is 95 by 96', isequal(size(M), [95 96])};
c(end+1, :) = {'the relation matrix of E_85 has 95 ones', sum(M(:)) == 95};
c(end+1, :) = {'the pairs of E_85 agree with encrypt_symbols', isequal(pairs(:, 1)', S.plain) && isequal(pairs(:, 2)', encrypt_symbols(S.plain, 85, S))};
F = function_properties(M);
c(end+1, :) = {'E_85 is a function from P to C', F.is_function};
c(end+1, :) = {'E_85 is one-to-one', F.one_to_one};
c(end+1, :) = {'E_85 is not onto (the value 12 is never used)', ~F.onto && isequal(find(~any(M, 1)), 12)};
c(end+1, :) = {'E_85 is not a bijection from P to C', ~F.bijective};
ok = true;
for k = S.keys
    [pk, Mk] = cipher_relation(k, S);
    Fk = function_properties(Mk);
    ok = ok && Fk.is_function && Fk.one_to_one && ~Fk.onto && isequal(find(~any(Mk, 1)), S.prime - k);
end
c(end+1, :) = {'for every key, E_k is a one-to-one function that is not onto and misses only 97 - k', ok};
c(end+1, :) = {'different keys give different functions (E_85 and E_12)', ~isequal(encrypt_symbols(S.plain, 85, S), encrypt_symbols(S.plain, 12, S))};
c(end+1, :) = {'cipher_relation works without the sets argument', isequal(size(cipher_relation(85)), [95 2])};

summarize_checks('test_cipher', c);
end

function flag = raises_error(f)
flag = false;
try
    f();
catch
    flag = true;
end
end
