function show_relations(S, R)
% SHOW_RELATIONS Print the relations of the system and their properties in the Command Window.
%   show_relations()      uses define_sets and define_relations.
%   show_relations(S, R)  prints the relations in the structs S and R.
if nargin < 1
    S = define_sets();
end
if nargin < 2
    R = define_relations(S);
end
nu = numel(S.users);

fprintf('\n=== RELATION 1: CAN TALK WITH (a relation on U) ===\n');
fprintf('R1 is the set of ordered pairs (u, v) where user u can talk to user v.\n');
fprintf('Channels (each one works in both directions):\n');
for r = 1:size(R.channels, 1)
    fprintf('  %s - %s\n', R.channels{r, 1}, R.channels{r, 2});
end
fprintf('Number of ordered pairs in R1: %d\n', size(R.talk_pairs, 1));

w = max(cellfun(@numel, S.users)) + 2;
fmt_name = sprintf('%%-%ds', w);
fprintf('\nRelation matrix (1 means the user in the row can talk to the user in the column):\n');
fprintf('%s', repmat(' ', 1, w));
for j = 1:nu
    fprintf(fmt_name, S.users{j});
end
fprintf('\n');
for i = 1:nu
    fprintf(fmt_name, S.users{i});
    for j = 1:nu
        fprintf(fmt_name, sprintf('%d', double(R.talk(i, j))));
    end
    fprintf('\n');
end

P = relation_properties(R.talk);
fprintf('\nProperties of R1:\n');
prop_line('Reflexive (every user can talk to themself)', P.reflexive);
prop_line('Symmetric (if u can talk to v, then v can talk to u)', P.symmetric);
prop_line('Antisymmetric (u and v talk to each other only if u = v)', P.antisymmetric);
prop_line('Transitive (u talks to v and v talks to w, so u talks to w)', P.transitive);
if ~P.transitive
    t = P.transitive_witness;
    fprintf('    Example: %s can talk to %s and %s can talk to %s, but %s cannot talk to %s.\n', ...
        S.users{t(1)}, S.users{t(2)}, S.users{t(2)}, S.users{t(3)}, S.users{t(1)}, S.users{t(3)});
end
prop_line('Equivalence relation (reflexive, symmetric and transitive)', P.equivalence);

fprintf('\n=== RELATION 2: OWNS (a relation from U to K) ===\n');
fprintf('R2 is the set of pairs (u, k) where user u owns the private key k.\n');
for r = 1:size(R.owns_pairs, 1)
    fprintf('  (%s, %d)\n', S.users{R.owns_pairs(r, 1)}, R.owns_pairs(r, 2));
end

F = function_properties(R.owns);
nused = sum(any(R.owns, 1));
fprintf('\nIs R2 a function from U to K?\n');
prop_line('Function (every user owns exactly one key)', F.is_function);
prop_line('One-to-one (no two users own the same key)', F.one_to_one);
fprintf('  %-62s: %s (%d of %d keys are owned)\n', 'Onto (every key of K is owned by someone)', yes_no(F.onto), nused, numel(S.keys));
end

function prop_line(label, flag)
fprintf('  %-62s: %s\n', label, yes_no(flag));
end

function s = yes_no(flag)
if flag
    s = 'yes';
else
    s = 'no';
end
end
