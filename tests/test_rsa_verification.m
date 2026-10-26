function test_rsa_verification()
% TEST_RSA_VERIFICATION Checks for verify_rsa, show_rsa_verification and the changes of demo_point7 and run_all_tests.
S = define_sets();
R = define_rsa_users(S);
c = cell(0, 2);
has = @(t, s) ~isempty(strfind(t, s));
allyes = @(V) all(cellfun(@(x) isequal(x, true), V(:, 4)));
failed = @(V) find(~cellfun(@(x) isequal(x, true), V(:, 4)))';
root = fileparts(fileparts(fileparts(which('verify_rsa'))));
before = dir(fullfile(root, 'outputs'));

% --- verify_rsa with the keys of define_rsa_users ---
V = verify_rsa(R, S);
c(end+1, :) = {'verify_rsa: 15 rows with 4 columns, in 3 groups of 4, 7 and 4 checks', isequal(size(V), [15 4]) && isequal(cell2mat(V(:, 1))', [1 1 1 1 2 2 2 2 2 2 2 3 3 3 3])};
c(end+1, :) = {'verify_rsa: all 15 checks agree for the 6 users', allyes(V)};
c(end+1, :) = {'verify_rsa: the numbers of cases are 6 6 6 16294 570 570 16956 16300 6 30 30 2880 30 6 6', isequal(cell2mat(V(:, 3))', [6 6 6 16294 570 570 16956 16300 6 30 30 2880 30 6 6])};
c(end+1, :) = {'verify_rsa: the cases follow the keys (sum of phi minus 6, sum of n, sum of phi)', V{4, 3} == sum(R.phi) - 6 && V{7, 3} == sum(R.n) && V{8, 3} == sum(R.phi)};
c(end+1, :) = {'verify_rsa: every label is a text and every answer is true or false', all(cellfun(@ischar, V(:, 2))) && all(cellfun(@islogical, V(:, 4)))};
V0 = verify_rsa();
c(end+1, :) = {'verify_rsa without arguments gives the same result', isequal(V0, V)};

% --- verify_rsa with other keys ---
p2 = [53 67 31 41 47 37];
q2 = [59 43 97 89 73 61];
e2 = [3 5 7 13 11 19];
R2 = R;
for i = 1:6
    K = rsa_make_keys(p2(i), q2(i), e2(i));
    R2.p(i) = K.p;
    R2.q(i) = K.q;
    R2.n(i) = K.n;
    R2.phi(i) = K.phi;
    R2.e(i) = K.e;
    R2.d(i) = K.d;
end
V2 = verify_rsa(R2, S);
c(end+1, :) = {'verify_rsa: all 15 checks agree for other keys (n = 3127 2881 3007 3649 3431 2257, one prime above 95)', isequal(R2.n, [3127 2881 3007 3649 3431 2257]) && allyes(V2) && V2{7, 3} == sum(R2.n) && V2{8, 3} == sum(R2.phi)};

% --- verify_rsa finds wrong keys ---
Rw = R;
Rw.d(1) = R.d(1) + 1;
c(end+1, :) = {'a wrong d (Alice) fails exactly the rows 2, 4, 6, 7, 9, 10, 12, 13 and 14', isequal(failed(verify_rsa(Rw, S)), [2 4 6 7 9 10 12 13 14])};
Rp = R;
Rp.phi(4) = R.phi(4) - 1;
c(end+1, :) = {'a wrong phi (Dave) fails exactly the rows 1, 2, 3, 8, 10, 13 and 14', isequal(failed(verify_rsa(Rp, S)), [1 2 3 8 10 13 14])};
Rq = R;
Rq.p(1) = 63;
Rq.n(1) = 63 * 53;
Rq.phi(1) = 62 * 52;
Rq.d(1) = mod_inverse(17, 62 * 52);
c(end+1, :) = {'a number that is not a prime (63 for Alice) fails the rows 1, 3, 4, 6, 7, 8, 9, 10, 12, 13 and 14', isequal(failed(verify_rsa(Rq, S)), [1 3 4 6 7 8 9 10 12 13 14])};
Re = R;
Re.e(3) = 7;
c(end+1, :) = {'a wrong e (Carol) fails the rows 2, 4, 6, 7, 9, 10, 12, 13, 14 and 15', isequal(failed(verify_rsa(Re, S)), [2 4 6 7 9 10 12 13 14 15])};
Rs = R;
Rs.n(2) = R.n(1);
c(end+1, :) = {'two users with the same n fail the first check (row 1)', ismember(1, failed(verify_rsa(Rs, S)))};

% --- verify_rsa refuses bad input ---
c(end+1, :) = {'verify_rsa: R that is not a struct, or has no field d, is refused (verify_rsa:fields)', strcmp(error_id(@() verify_rsa(5, S)), 'verify_rsa:fields') && strcmp(error_id(@() verify_rsa(rmfield(R, 'd'), S)), 'verify_rsa:fields')};
Rf = R;
Rf.e = R.e(1:5);
c(end+1, :) = {'verify_rsa: a field with 5 numbers instead of 6 is refused (verify_rsa:fields)', strcmp(error_id(@() verify_rsa(Rf, S)), 'verify_rsa:fields')};
Rb = R;
Rb.n(6) = 20000;
Rb2 = R;
Rb2.n(6) = 96;
Rb3 = R;
Rb3.e(2) = 2.5;
c(end+1, :) = {'verify_rsa: n above 10000, n below 97 and a fractional e are refused (verify_rsa:size)', strcmp(error_id(@() verify_rsa(Rb, S)), 'verify_rsa:size') && strcmp(error_id(@() verify_rsa(Rb2, S)), 'verify_rsa:size') && strcmp(error_id(@() verify_rsa(Rb3, S)), 'verify_rsa:size')};
c(end+1, :) = {'verify_rsa: sets that are not a struct with users are refused (verify_rsa:sets)', strcmp(error_id(@() verify_rsa(R, 5)), 'verify_rsa:sets') && strcmp(error_id(@() verify_rsa(R, struct('prime', 97))), 'verify_rsa:sets')};

% --- show_rsa_verification ---
o = evalc('show_rsa_verification()');
c(end+1, :) = {'show_rsa_verification: title and the explanation', has(o, '=== VERIFICATION OF RSA: THE KEYS, THE ENCRYPTION AND THE EAVESDROPPER ===') && has(o, 'Every check is made a second way with trial division and repeated multiplication')};
c(end+1, :) = {'show_rsa_verification: the 3 tables', has(o, '1. The RSA keys') && has(o, '2. Encryption and decryption with RSA') && has(o, '3. Key transport and the eavesdropper') && numel(strfind(o, 'What is checked')) == 3};
c(end+1, :) = {'show_rsa_verification: 15 checks, all of them yes', has(o, 'In all: 15 of 15 checks agree.') && numel(strfind(o, '  yes')) == 15 && isempty(strfind(o, '  NO'))};
c(end+1, :) = {'show_rsa_verification: the case numbers 16294, 16956 and 2880 are printed', has(o, '16294  yes') && has(o, '16956  yes') && has(o, '2880  yes')};
c(end+1, :) = {'show_rsa_verification: a label of each table', has(o, 'd is the inverse of e mod phi, found by trying every number') && has(o, 'Euler: a^phi = 1 mod n') && has(o, 'Eve reads the text with a list of all small numbers')};
c(end+1, :) = {'show_rsa_verification: the other keys and their 15 of 15', has(o, 'The same checks for other keys (n = 3127 2881 3007 3649 3431 2257, e = 3 5 7 13 11 19):') && has(o, '  15 of 15 checks agree.')};
c(end+1, :) = {'show_rsa_verification does not print the words that test_rsa_users counts (Checks: and a colon before yes or NO)', isempty(strfind(o, 'Checks:')) && isempty(strfind(o, ': yes')) && isempty(strfind(o, ': NO'))};

% --- demo_point7 and run_all_tests (the files are read, not run) ---
demotxt = fileread(which('demo_point7'));
a = strfind(demotxt, 'show_rsa_eavesdropper(S);');
b = strfind(demotxt, 'show_rsa_verification(S);');
c(end+1, :) = {'demo_point7 shows the verification after the eavesdropper', ~isempty(a) && ~isempty(b) && a(1) < b(1)};
runtxt = fileread(which('run_all_tests'));
a = strfind(runtxt, 'test_rsa_users();');
b = strfind(runtxt, 'test_rsa_verification();');
c(end+1, :) = {'run_all_tests runs test_rsa_verification after test_rsa_users', ~isempty(a) && ~isempty(b) && a(1) < b(1)};

% --- project files ---
files = {'verify_rsa', 'show_rsa_verification', 'demo_point7', 'run_all_tests', 'test_rsa_verification'};
ascii_ok = true;
for k = 1:numel(files)
    fid = fopen(which(files{k}), 'r');
    bytes = fread(fid);
    fclose(fid);
    ascii_ok = ascii_ok && ~isempty(bytes) && all(bytes < 128) && ~any(bytes == 13) && ~any(bytes == 9);
end
c(end+1, :) = {'the 5 new or changed files of packet 7C are plain ASCII, with no tab and no carriage return', ascii_ok};
after = dir(fullfile(root, 'outputs'));
c(end+1, :) = {'these tests do not change the files in outputs', isequal({before.name}, {after.name})};

summarize_checks('test_rsa_verification', c);
end

function id = error_id(f)
% The identifier of the error that calling f gives (empty text when there is no error or no identifier).
id = '';
try
    f();
catch err
    id = err.identifier;
end
end
