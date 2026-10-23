function test_relations()
% TEST_RELATIONS Checks for the relations, their properties and the function check.
S = define_sets();
R = define_relations(S);
c = cell(0, 2);

% --- the channels and relation R1 (can talk with) ---
c(end+1, :) = {'there are 6 channels', size(R.channels, 1) == 6};
c(end+1, :) = {'every channel joins two different users', all(~strcmp(R.channels(:, 1), R.channels(:, 2)))};
c(end+1, :) = {'R1 has 12 ordered pairs (6 channels, both directions)', isequal(size(R.talk_pairs), [12 2])};
c(end+1, :) = {'the R1 matrix is 6 by 6', isequal(size(R.talk), [6 6])};
c(end+1, :) = {'the R1 matrix has 12 ones', sum(R.talk(:)) == 12};
c(end+1, :) = {'Alice can talk to Bob', R.talk(1, 2) == true};
c(end+1, :) = {'Bob can talk to Alice', R.talk(2, 1) == true};
c(end+1, :) = {'Alice cannot talk to Dave', R.talk(1, 4) == false};
c(end+1, :) = {'Grace can talk only to Frank', isequal(find(R.talk(6, :)), 5)};

P = relation_properties(R.talk);
c(end+1, :) = {'R1 is not reflexive', ~P.reflexive};
c(end+1, :) = {'R1 is irreflexive', P.irreflexive};
c(end+1, :) = {'R1 is symmetric', P.symmetric};
c(end+1, :) = {'R1 is not antisymmetric', ~P.antisymmetric};
c(end+1, :) = {'R1 is not transitive', ~P.transitive};
c(end+1, :) = {'R1 is not an equivalence relation', ~P.equivalence};
c(end+1, :) = {'R1 is not a partial order', ~P.partial_order};
t = P.transitive_witness;
c(end+1, :) = {'the example that breaks transitivity is right', numel(t) == 3 && R.talk(t(1), t(2)) && R.talk(t(2), t(3)) && ~R.talk(t(1), t(3))};

% --- relation R2 (owns) ---
c(end+1, :) = {'R2 has 6 pairs, one for each user', isequal(size(R.owns_pairs), [6 2]) && isequal(R.owns_pairs(:, 1)', 1:6)};
c(end+1, :) = {'the R2 matrix is 6 by 96', isequal(size(R.owns), [6 96])};
c(end+1, :) = {'the private keys are all different', numel(unique(R.private_keys)) == 6};
c(end+1, :) = {'the private keys are all in K', all(ismember(R.private_keys, S.keys))};
c(end+1, :) = {'the R2 matrix agrees with the private keys', all(R.owns(sub2ind(size(R.owns), 1:6, R.private_keys)))};
F = function_properties(R.owns);
c(end+1, :) = {'R2 is a function from U to K', F.is_function};
c(end+1, :) = {'R2 is one-to-one', F.one_to_one};
c(end+1, :) = {'R2 is not onto (only 6 of the 96 keys are owned)', ~F.onto};
c(end+1, :) = {'R2 is not a bijection', ~F.bijective};

% --- relation_properties on small known relations ---
Pi = relation_properties(eye(4));
c(end+1, :) = {'identity relation: equivalence and partial order', Pi.equivalence && Pi.partial_order};
Pl = relation_properties(triu(ones(4)));
c(end+1, :) = {'a <= b on 4 elements: partial order, not symmetric', Pl.partial_order && ~Pl.symmetric};
c(end+1, :) = {'a <= b on 4 elements: not an equivalence relation', ~Pl.equivalence};
Pa = relation_properties(ones(3));
c(end+1, :) = {'all pairs related: equivalence, not antisymmetric', Pa.equivalence && ~Pa.antisymmetric};
Pz = relation_properties(zeros(3));
c(end+1, :) = {'empty relation: irreflexive, symmetric, antisymmetric, transitive', Pz.irreflexive && Pz.symmetric && Pz.antisymmetric && Pz.transitive};
c(end+1, :) = {'empty relation: not reflexive, no transitivity example', ~Pz.reflexive && isempty(Pz.transitive_witness)};
Pc = relation_properties([0 1 0; 0 0 1; 0 0 0]);
c(end+1, :) = {'chain 1->2->3: not transitive, example is [1 2 3]', ~Pc.transitive && isequal(Pc.transitive_witness, [1 2 3])};
c(end+1, :) = {'a matrix that is not square is rejected', raises_error(@() relation_properties(ones(2, 3)))};
c(end+1, :) = {'a matrix with the value 2 is rejected', raises_error(@() relation_properties([0 2; 1 0]))};

% --- function_properties on small known relations ---
Fi = function_properties(eye(3));
c(end+1, :) = {'identity 3x3: bijection', Fi.bijective};
Fo = function_properties([1 0; 1 0; 0 1]);
c(end+1, :) = {'two inputs share an output: function, onto, not one-to-one', Fo.is_function && Fo.onto && ~Fo.one_to_one};
Fj = function_properties([1 0 0; 0 1 0]);
c(end+1, :) = {'2 inputs to 3 outputs: one-to-one, not onto', Fj.one_to_one && ~Fj.onto};
Fn = function_properties([1 1; 0 1]);
c(end+1, :) = {'an input with two outputs: not a function', ~Fn.is_function && ~Fn.one_to_one && ~Fn.onto};
Fm = function_properties(zeros(2, 3));
c(end+1, :) = {'an input with no output: not a function', ~Fm.is_function};
c(end+1, :) = {'a matrix with the value 2 is rejected (function check)', raises_error(@() function_properties([1 2; 0 1]))};

% --- pairs_to_matrix ---
Mp = pairs_to_matrix([1 2; 2 3], 3, 3);
c(end+1, :) = {'pairs [1 2; 2 3] give ones at (1,2) and (2,3) only', sum(Mp(:)) == 2 && Mp(1, 2) && Mp(2, 3)};
c(end+1, :) = {'no pairs give a matrix of false', isequal(pairs_to_matrix([], 3, 3), false(3, 3))};
c(end+1, :) = {'a repeated pair is counted once', sum(sum(pairs_to_matrix([1 2; 1 2], 3, 3))) == 1};
c(end+1, :) = {'a pair outside the matrix is rejected', raises_error(@() pairs_to_matrix([4 1], 3, 3))};
c(end+1, :) = {'a pair with 0 is rejected', raises_error(@() pairs_to_matrix([1 0], 3, 3))};
c(end+1, :) = {'a pair with 1.5 is rejected', raises_error(@() pairs_to_matrix([1.5 2], 3, 3))};
c(end+1, :) = {'a list with three columns is rejected', raises_error(@() pairs_to_matrix([1 2 3], 3, 3))};

% --- define_relations and show_relations ---
S2 = S;
S2.users{1} = 'Zed';
c(end+1, :) = {'a channel with a user that is not in U is rejected', raises_error(@() define_relations(S2))};
S3 = S;
S3.keys = 1:10;
c(end+1, :) = {'a private key that is not in K is rejected', raises_error(@() define_relations(S3))};
out = evalc('show_relations(S, R);');
c(end+1, :) = {'show_relations prints both relations', ~isempty(strfind(out, 'RELATION 1')) && ~isempty(strfind(out, 'RELATION 2')) && ~isempty(strfind(out, 'Alice - Bob'))};

summarize_checks('test_relations', c);
end

function flag = raises_error(f)
flag = false;
try
    f();
catch
    flag = true;
end
end
