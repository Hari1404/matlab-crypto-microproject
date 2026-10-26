function show_rsa_verification(S)
% SHOW_RSA_VERIFICATION Print the checks of verify_rsa as three tables, then the same checks for other RSA keys.
%   show_rsa_verification()   uses define_sets.
%   show_rsa_verification(S)  uses the sets S (6 users).
%   The other keys have other primes and exponents (Alice 53*59 with e = 3, Bob 67*43 with e = 5, Carol 31*97 with e = 7,
%   Dave 41*89 with e = 13, Frank 47*73 with e = 11 and Grace 37*61 with e = 19).
if nargin < 1
    S = define_sets();
end
R = define_rsa_users(S);
V = verify_rsa(R, S);
answer = {'NO', 'yes'};
titles = {'The RSA keys', 'Encryption and decryption with RSA', 'Key transport and the eavesdropper'};
w = max(cellfun(@numel, V(:, 2)));
fprintf('\n=== VERIFICATION OF RSA: THE KEYS, THE ENCRYPTION AND THE EAVESDROPPER ===\n');
fprintf('Every check is made a second way with trial division and repeated multiplication, and the two answers must be the same.\n');
nyes = 0;
for gi = 1:3
    fprintf('\n%d. %s\n', gi, titles{gi});
    fprintf(['  %-' num2str(w) 's  %7s  %s\n'], 'What is checked', 'Cases', 'Agree');
    for r = 1:size(V, 1)
        if V{r, 1} == gi
            fprintf(['  %-' num2str(w) 's  %7d  %s\n'], V{r, 2}, V{r, 3}, answer{double(V{r, 4}) + 1});
            nyes = nyes + double(V{r, 4});
        end
    end
end
fprintf('\nIn all: %d of %d checks agree.\n', nyes, size(V, 1));
p2 = [53 67 31 41 47 37];
q2 = [59 43 97 89 73 61];
e2 = [3 5 7 13 11 19];
R2.users = R.users;
R2.p = zeros(1, numel(R.users));
R2.q = R2.p;
R2.n = R2.p;
R2.phi = R2.p;
R2.e = R2.p;
R2.d = R2.p;
for i = 1:numel(R.users)
    K = rsa_make_keys(p2(i), q2(i), e2(i));
    R2.p(i) = K.p;
    R2.q(i) = K.q;
    R2.n(i) = K.n;
    R2.phi(i) = K.phi;
    R2.e(i) = K.e;
    R2.d(i) = K.d;
end
check_rsa_users(R2, S);
V2 = verify_rsa(R2, S);
ok2 = sum(cell2mat(V2(:, 4)));
fprintf('\nThe same checks for other keys (n = %s, e = %s):\n', strtrim(sprintf('%d ', R2.n)), strtrim(sprintf('%d ', R2.e)));
fprintf('  %d of %d checks agree.\n', ok2, size(V2, 1));
end
