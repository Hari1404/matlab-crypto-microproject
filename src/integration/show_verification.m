function show_verification(Y)
% SHOW_VERIFICATION Print the checks of the shared key, the decryption and the graph (verify_system) as three tables.
%   show_verification()   uses define_system.
%   show_verification(Y)  uses the system Y.
%   It ends with the same checks on the network after the first bridge channel (or the first channel) is removed.
if nargin < 1
    Y = define_system();
end
V = verify_system(Y);
answer = {'NO', 'yes'};
titles = {'The shared key', 'Encryption and decryption', 'The graph'};
w = max(cellfun(@numel, V(:, 2)));
fprintf('\n=== VERIFICATION: THE KEY, THE DECRYPTION AND THE GRAPH ===\n');
fprintf('Every check is made a second way with plain arithmetic or matrix products, and the two answers must be the same.\n');
nyes = 0;
for gi = 1:3
    fprintf('\n%d. %s\n', gi, titles{gi});
    fprintf(['  %-' num2str(w) 's  %6s  %s\n'], 'What is checked', 'Cases', 'Agree');
    for r = 1:size(V, 1)
        if V{r, 1} == gi
            fprintf(['  %-' num2str(w) 's  %6d  %s\n'], V{r, 2}, V{r, 3}, answer{double(V{r, 4}) + 1});
            nyes = nyes + double(V{r, 4});
        end
    end
end
total = size(V, 1);
fprintf('\nIn all: %d of %d checks agree.\n', nyes, total);
E = adjacency_to_edges(Y.A);
if isempty(E)
    fprintf('\nThe network has no channel, so there is no broken network to check.\n');
    return;
end
B = bridge_channels(Y.A);
if isempty(B)
    r = E(1, :);
else
    r = B(1, :);
end
Y2 = Y;
Y2.A = remove_channel(Y.A, r(1), r(2));
V2 = verify_system(Y2);
ok2 = sum(cell2mat(V2(:, 4)));
[comp, k2] = connected_components(Y2.A);
fprintf('\nThe same checks after the channel %s - %s is removed (%d group%s: %s):\n', Y.users{r(1)}, Y.users{r(2)}, k2, plural_s(k2), format_groups(Y.users, comp));
fprintf('  %d of %d checks agree.\n', ok2, size(V2, 1));
end
