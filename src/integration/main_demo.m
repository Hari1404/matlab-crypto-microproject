function main_demo(answers)
% MAIN_DEMO The secure network with typed prompts: choose users and texts, send messages along the route, break and repair channels.
%   main_demo()         asks for every answer on the keyboard.
%   main_demo(answers)  uses the cell array of texts answers instead of the keyboard (for the tests and for a scripted run).
%   Menu: 1 send a message, 2 key exchange of two users, 3 the channels and their keys, 4 break a channel,
%   5 repair all channels, 6 the whole report (show_system), 0 quit.
if nargin < 1
    answers = {};
end
Y0 = define_system();
Y = Y0;
p = Y0.S.prime;
g = Y0.S.generator;
names = Y0.users;
k = 1;
sent = 0;
arrived = 0;
fprintf('\n##### MAIN DEMO: THE SECURE NETWORK #####\n');
fprintf('Users: %s\n', format_names(names, 1:Y0.n));
fprintf('Every channel has its own key, made by a Diffie-Hellman exchange of its two users. p = %d and g = %d.\n', p, g);
running = true;
while running
    fprintf('\nMenu\n');
    fprintf('  1  Send a message\n');
    fprintf('  2  Key exchange of two users\n');
    fprintf('  3  Show the channels and their keys\n');
    fprintf('  4  Break a channel\n');
    fprintf('  5  Repair all channels\n');
    fprintf('  6  The whole report (show_system)\n');
    fprintf('  0  Quit\n');
    [s, k] = read_answer('Your choice: ', answers, k);
    s = strtrim(s);
    if strcmp(s, '0')
        running = false;
    elseif strcmp(s, '1')
        fprintf('\n--- Send a message ---\n');
        [i, k] = pick_user(Y, 'Sender: ', answers, k, 0);
        [j, k] = pick_user(Y, 'Receiver: ', answers, k, i);
        txt = '';
        while isempty(txt)
            [t, k] = read_answer('Message: ', answers, k);
            if isempty(t)
                fprintf('  Please type at least one character.\n');
            elseif any(double(t) < 32) || any(double(t) > 126)
                fprintf('  Please use only the 95 printable characters (space to ~).\n');
            else
                txt = t;
            end
        end
        R = route_message(txt, i, j, Y);
        show_route(R, Y);
        sent = sent + 1;
        arrived = arrived + double(R.delivered);
    elseif strcmp(s, '2')
        fprintf('\n--- Key exchange of two users ---\n');
        [i, k] = pick_user(Y, 'First user: ', answers, k, 0);
        [j, k] = pick_user(Y, 'Second user: ', answers, k, i);
        E = dh_exchange(Y.D.private(i), Y.D.private(j), p, g);
        fprintf('  %s has the secret number %d and %s has the secret number %d. They stay with their users.\n', names{i}, E.a, names{j}, E.b);
        fprintf('  The public values cross the channel: %s sends %d^%d mod %d = %d and %s sends %d^%d mod %d = %d.\n', names{i}, g, E.a, p, E.A, names{j}, g, E.b, p, E.B);
        fprintf('  %s computes %d^%d mod %d = %d.\n', names{i}, E.B, E.a, p, E.key_alice);
        fprintf('  %s computes %d^%d mod %d = %d.\n', names{j}, E.A, E.b, p, E.key_bob);
        fprintf('  Both keys are the same: %s. The key is %d.\n', yes_no(E.agree), E.key);
        if Y0.G.adj(i, j)
            fprintf('  This is the key of the channel %s - %s.\n', names{i}, names{j});
        else
            fprintf('  %s and %s have no channel, so they do not use this key to talk.\n', names{i}, names{j});
        end
    elseif strcmp(s, '3')
        fprintf('\n--- The channels and their keys ---\n');
        fprintf('  Channel  Users            Key   State\n');
        for e = 1:Y.G.m
            a = Y.G.edges(e, 1);
            b = Y.G.edges(e, 2);
            if Y.A(a, b)
                st = 'works';
            else
                st = 'broken';
            end
            fprintf('  %-9s%-17s%-6d%s\n', sprintf('e%d', e), [names{a} ' - ' names{b}], Y.edge_keys(e), st);
        end
        [comp, kk] = connected_components(Y.A);
        fprintf('  The network has %d group%s: %s\n', kk, plural_s(kk), format_groups(names, comp));
    elseif strcmp(s, '4')
        fprintf('\n--- Break a channel ---\n');
        [i, k] = pick_user(Y, 'First user of the channel: ', answers, k, 0);
        [j, k] = pick_user(Y, 'Second user of the channel: ', answers, k, i);
        if Y.A(i, j)
            Y.A = remove_channel(Y.A, i, j);
            [comp, kk] = connected_components(Y.A);
            fprintf('  The channel %s - %s is broken.\n', names{i}, names{j});
            fprintf('  The network has %d group%s: %s\n', kk, plural_s(kk), format_groups(names, comp));
        else
            fprintf('  There is no working channel between %s and %s, so nothing is broken.\n', names{i}, names{j});
        end
    elseif strcmp(s, '5')
        fprintf('\n--- Repair all channels ---\n');
        nb = nnz(Y0.G.adj) / 2 - nnz(Y.A) / 2;
        Y.A = Y0.G.adj;
        if nb == 0
            fprintf('  No channel was broken.\n');
        else
            fprintf('  %d channel%s repaired. The network is whole again.\n', nb, plural_s(nb));
        end
    elseif strcmp(s, '6')
        if ~isequal(Y.A, Y0.G.adj)
            fprintf('\n(The report is about the whole network, not about the broken channels.)\n');
        end
        show_system(Y0);
    else
        fprintf('  Please type a number from 0 to 6.\n');
    end
end
fprintf('\nMessages sent: %d. Messages that arrived: %d.\n', sent, arrived);
fprintf('Goodbye.\n');
end
