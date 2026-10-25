function test_main_demo()
% TEST_MAIN_DEMO Checks for read_answer, pick_user, show_route and main_demo (scripted answers, no keyboard).
Y = define_system();
c = cell(0, 2);
nl = char(10);
has = @(t, s) ~isempty(strfind(t, s));
root = fileparts(fileparts(fileparts(which('main_demo'))));
before = dir(fullfile(root, 'outputs'));

% --- read_answer ---
o = evalc('[s, k] = read_answer(''Q: '', {''a'', ''b''}, 1);');
c(end+1, :) = {'read_answer takes answer 1 and gives k = 2', strcmp(s, 'a') && k == 2};
o = evalc('[s2, k2] = read_answer(''Q: '', {''a'', ''b''}, 2);');
c(end+1, :) = {'read_answer takes answer 2 and prints the prompt and the answer', strcmp(s2, 'b') && k2 == 3 && strcmp(o, ['Q: b' nl])};
c(end+1, :) = {'read_answer stops when the answers have run out', raises_error(@() read_answer('Q: ', {'a', 'b'}, 3))};
c(end+1, :) = {'read_answer refuses answers that are not a cell array of texts', raises_error(@() read_answer('Q: ', 5, 1)) && raises_error(@() read_answer('Q: ', {1}, 1)) && raises_error(@() read_answer('Q: ', 'abc', 1))};
c(end+1, :) = {'read_answer refuses a prompt that is not a text', raises_error(@() read_answer(5, {'a'}, 1))};
c(end+1, :) = {'read_answer takes an empty text as an answer', isequal(evalc('[s3, k3] = read_answer(''Q: '', {''''}, 1);'), ['Q: ' nl]) && isempty(s3) && k3 == 2};

% --- pick_user ---
o = evalc('[u, k] = pick_user(Y, ''User: '', {''frank''}, 1, 0);');
c(end+1, :) = {'pick_user: a name in small letters works', u == 5 && k == 2 && strcmp(o, ['User: frank' nl])};
o = evalc('[u, k] = pick_user(Y, ''User: '', {''3''}, 1, 0);');
c(end+1, :) = {'pick_user: a number works', u == 3 && k == 2};
o = evalc('[u, k] = pick_user(Y, ''User: '', {''  BOB ''}, 1, 0);');
c(end+1, :) = {'pick_user: capital letters and spaces around the name work', u == 2 && k == 2};
o = evalc('[u, k] = pick_user(Y, ''User: '', {'''', ''0'', ''7'', ''10'', ''abc'', ''1.5'', ''-1'', ''Alice''}, 1, 0);');
c(end+1, :) = {'pick_user: empty, 0, 7, 10, abc, 1.5 and -1 are refused, then Alice', u == 1 && k == 9 && numel(strfind(o, 'Please type a user number from 1 to 6 or a name (Alice, Bob, Carol, Dave, Frank, Grace).')) == 7};
o = evalc('[u, k] = pick_user(Y, ''User: '', {''Alice'', ''alice'', ''1'', ''Bob''}, 1, 1);');
c(end+1, :) = {'pick_user: the user that is not allowed is refused by name and by number', u == 2 && k == 5 && numel(strfind(o, 'Please choose a different user than Alice.')) == 3};
c(end+1, :) = {'pick_user stops when the answers have run out', raises_error(@() evalc('pick_user(Y, ''User: '', {''zzz''}, 1, 0);'))};
o = evalc('[u, k] = pick_user(Y, ''User: '', {''6''}, 1, 5);');
c(end+1, :) = {'pick_user: the last user (6) works', u == 6 && k == 2};

% --- show_route ---
R = route_message('Hi', 1, 6, Y);
o = evalc('show_route(R, Y)');
c(end+1, :) = {'show_route: route, 4 hops with keys, readers and the text received', has(o, 'The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).') && has(o, 'Hop   From      To        Key') && has(o, 'Grace gets: Hi') && has(o, 'It is the same as the message: yes')};
c(end+1, :) = {'show_route: the keys of the hops are 85 42 32 72', has(o, 'Alice     Bob       85') && has(o, 'Bob       Dave      42') && has(o, 'Dave      Frank     32') && has(o, 'Frank     Grace     72')};
c(end+1, :) = {'show_route: readers and relays are named', has(o, 'The users who can read the message: Alice, Bob, Dave, Frank, Grace.') && has(o, 'The users in the middle (Bob, Dave, Frank) decrypt and encrypt it again, so they see the text.')};
c(end+1, :) = {'show_route: a short text shows all its numbers and no dots', ~has(o, '...')};
R = route_message('Hello Grace, the meeting is at 5 pm.', 1, 6, Y);
o = evalc('show_route(R, Y)');
c(end+1, :) = {'show_route: a long text shows 6 numbers and dots', has(o, ' ...')};
R = route_message('Hi', 1, 2, Y);
o = evalc('show_route(R, Y)');
c(end+1, :) = {'show_route: neighbours, 1 channel and nobody in the middle', has(o, '(1 channel).') && has(o, 'Nobody is in the middle, so only Alice and Bob can read it.')};
Yb = Y;
Yb.A = remove_channel(Y.A, 4, 5);
R = route_message('Hi', 1, 6, Yb);
o = evalc('show_route(R, Yb)');
c(end+1, :) = {'show_route: no route, names the 2 groups and says who knows the text', has(o, 'There is no route from Alice to Grace in the network now, so the message cannot be sent.') && has(o, 'The network has 2 groups: {Alice, Bob, Carol, Dave}  {Frank, Grace}') && has(o, 'Only Alice knows the text.') && ~has(o, 'Hop   From')};

% --- main_demo: quit and the menu ---
o = evalc('main_demo({''0''})');
c(end+1, :) = {'main_demo: title, users, p and g, the menu with 7 lines', has(o, '##### MAIN DEMO: THE SECURE NETWORK #####') && has(o, 'Users: Alice, Bob, Carol, Dave, Frank, Grace') && has(o, 'p = 97 and g = 5.') && has(o, '  6  The whole report (show_system)') && has(o, '  0  Quit')};
c(end+1, :) = {'main_demo: quit at once, 0 sent and 0 arrived, goodbye', has(o, 'Messages sent: 0. Messages that arrived: 0.') && has(o, 'Goodbye.')};
o = evalc('main_demo({'' 0 ''})');
c(end+1, :) = {'main_demo: spaces around the 0 still quit', has(o, 'Goodbye.')};
o = evalc('main_demo({'''', ''9'', ''x'', ''01'', ''-1'', ''7'', ''0''})');
c(end+1, :) = {'main_demo: a bad menu answer asks again (empty, 9, x, 01, -1, 7)', numel(strfind(o, 'Please type a number from 0 to 6.')) == 6 && has(o, 'Goodbye.')};
o1 = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''0''})');
o2 = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hi'', ''0''})');
c(end+1, :) = {'main_demo: the same answers give the same text twice', strcmp(o1, o2)};

% --- main_demo: send a message ---
o = evalc('main_demo({''1'', ''Alice'', ''Grace'', ''Hello Grace, the meeting is at 5 pm.'', ''0''})');
c(end+1, :) = {'main_demo: Alice to Grace along Alice - Bob - Dave - Frank - Grace', has(o, 'The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).') && has(o, 'Grace gets: Hello Grace, the meeting is at 5 pm.')};
c(end+1, :) = {'main_demo: 1 sent and 1 arrived', has(o, 'Messages sent: 1. Messages that arrived: 1.')};
o = evalc('main_demo({''1'', ''1'', ''6'', ''Hi'', ''0''})');
c(end+1, :) = {'main_demo: user numbers work', has(o, 'The shortest route is Alice - Bob - Dave - Frank - Grace (4 channels).') && has(o, 'Grace gets: Hi')};
o = evalc('main_demo({''1'', ''ALICE'', ''gRaCe'', ''Hi'', ''0''})');
c(end+1, :) = {'main_demo: any mix of small and capital letters works', has(o, 'Grace gets: Hi')};
o = evalc('main_demo({''1'', ''Grace'', ''Alice'', ''Hi'', ''0''})');
c(end+1, :) = {'main_demo: the other direction, Grace to Alice, along the reverse route', has(o, 'The shortest route is Grace - Frank - Dave - Bob - Alice (4 channels).') && has(o, 'Alice gets: Hi')};
o = evalc('main_demo({''1'', ''Alice'', ''Bob'', ''Hi'', ''0''})');
c(end+1, :) = {'main_demo: neighbours, nobody in the middle', has(o, 'Nobody is in the middle, so only Alice and Bob can read it.')};
alltext = char(32:126);
o = evalc('main_demo({''1'', ''Carol'', ''Frank'', alltext, ''0''})');
c(end+1, :) = {'main_demo: a message with all 95 printable characters arrives', has(o, 'It is the same as the message: yes') && has(o, ['Frank gets: ' alltext nl]) && has(o, 'Messages sent: 1. Messages that arrived: 1.')};
o = evalc('main_demo({''9'', ''1'', ''Zed'', ''Alice'', ''7'', ''Alice'', ''Bob'', '''', [''a'' char(9)], ''Hi'', ''0''})');
c(end+1, :) = {'main_demo: bad sender, bad receiver, same user, empty text and a tab ask again', has(o, 'Please type a number from 0 to 6.') && numel(strfind(o, 'Please type a user number from 1 to 6')) == 2 && has(o, 'Please choose a different user than Alice.') && has(o, 'Please type at least one character.') && has(o, 'Please use only the 95 printable characters (space to ~).') && has(o, 'Bob gets: Hi') && has(o, 'Messages sent: 1. Messages that arrived: 1.')};

% --- main_demo: key exchange ---
o = evalc('main_demo({''2'', ''Alice'', ''Bob'', ''0''})');
c(end+1, :) = {'main_demo option 2: Alice and Bob get the key 85 of their channel', has(o, 'Both keys are the same: yes. The key is 85.') && has(o, 'This is the key of the channel Alice - Bob.') && has(o, 'Alice has the secret number 6 and Bob has the secret number 15.')};
c(end+1, :) = {'main_demo option 2: the public values and both computations are shown', has(o, 'Alice sends 5^6 mod 97 = 8 and Bob sends 5^15 mod 97 = 46.') && has(o, 'Alice computes 46^6 mod 97 = 85.') && has(o, 'Bob computes 8^15 mod 97 = 85.')};
o = evalc('main_demo({''2'', ''Alice'', ''Grace'', ''0''})');
c(end+1, :) = {'main_demo option 2: two users without a channel say so', has(o, 'Both keys are the same: yes.') && has(o, 'Alice and Grace have no channel, so they do not use this key to talk.') && ~has(o, 'This is the key of the channel')};
o = evalc('main_demo({''2'', ''Bob'', ''Bob'', ''Carol'', ''0''})');
c(end+1, :) = {'main_demo option 2: the same user twice is refused', has(o, 'Please choose a different user than Bob.') && has(o, 'Bob has the secret number')};

% --- main_demo: channels ---
o = evalc('main_demo({''3'', ''0''})');
c(end+1, :) = {'main_demo option 3: 6 channels with the keys 85 12 42 90 32 72, all work', has(o, 'e1       Alice - Bob      85    works') && has(o, 'e2       Alice - Carol    12    works') && has(o, 'e3       Bob - Dave       42    works') && has(o, 'e4       Carol - Dave     90    works') && has(o, 'e5       Dave - Frank     32    works') && has(o, 'e6       Frank - Grace    72    works') && ~has(o, 'broken')};
c(end+1, :) = {'main_demo option 3: one group with all 6 users', has(o, 'The network has 1 group: {Alice, Bob, Carol, Dave, Frank, Grace}')};

% --- main_demo: break and repair ---
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''3'', ''0''})');
c(end+1, :) = {'main_demo option 4: Dave - Frank is broken and the network has 2 groups', has(o, 'The channel Dave - Frank is broken.') && has(o, 'The network has 2 groups: {Alice, Bob, Carol, Dave}  {Frank, Grace}')};
c(end+1, :) = {'main_demo option 3 after the break: e5 is broken, the others work', has(o, 'e5       Dave - Frank     32    broken') && numel(strfind(o, 'works')) == 5};
o = evalc('main_demo({''4'', ''Frank'', ''Dave'', ''0''})');
c(end+1, :) = {'main_demo option 4: the order of the two users does not matter', has(o, 'The channel Frank - Dave is broken.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Alice'', ''Grace'', ''Are you there?'', ''0''})');
c(end+1, :) = {'main_demo: after the break there is no route from Alice to Grace', has(o, 'There is no route from Alice to Grace in the network now, so the message cannot be sent.') && has(o, 'Only Alice knows the text.') && ~has(o, 'Grace gets:')};
c(end+1, :) = {'main_demo: after the break 1 sent and 0 arrived', has(o, 'Messages sent: 1. Messages that arrived: 0.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Bob'', ''Carol'', ''See you at 5 pm.'', ''0''})');
c(end+1, :) = {'main_demo: after the break a message inside a group still arrives', has(o, 'Carol gets: See you at 5 pm.') && has(o, 'Messages sent: 1. Messages that arrived: 1.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''1'', ''Alice'', ''Grace'', ''x'', ''1'', ''Bob'', ''Carol'', ''y'', ''0''})');
c(end+1, :) = {'main_demo: 2 sent and 1 arrived when one of two is cut off', has(o, 'Messages sent: 2. Messages that arrived: 1.')};
o = evalc('main_demo({''4'', ''Alice'', ''Grace'', ''0''})');
c(end+1, :) = {'main_demo option 4: a pair without a channel says so and goes back to the menu', has(o, 'There is no working channel between Alice and Grace, so nothing is broken.') && has(o, 'Goodbye.') && ~has(o, 'The channel Alice - Grace is broken.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''4'', ''Dave'', ''Frank'', ''0''})');
c(end+1, :) = {'main_demo option 4: breaking the same channel twice says there is no working channel', has(o, 'The channel Dave - Frank is broken.') && has(o, 'There is no working channel between Dave and Frank, so nothing is broken.')};
o = evalc('main_demo({''4'', ''Alice'', ''Alice'', ''Bob'', ''0''})');
c(end+1, :) = {'main_demo option 4: the same user twice is refused', has(o, 'Please choose a different user than Alice.') && has(o, 'The channel Alice - Bob is broken.')};
o = evalc('main_demo({''4'', ''Alice'', ''Bob'', ''4'', ''Alice'', ''Carol'', ''0''})');
c(end+1, :) = {'main_demo option 4: after e1 and e2 Alice is alone, 2 groups', has(o, 'The network has 2 groups: {Alice}  {Bob, Carol, Dave, Frank, Grace}')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''5'', ''1'', ''Alice'', ''Grace'', ''Back'', ''0''})');
c(end+1, :) = {'main_demo option 5: 1 channel repaired and the message to Grace arrives again', has(o, '1 channel repaired. The network is whole again.') && has(o, 'Grace gets: Back') && has(o, 'Messages sent: 1. Messages that arrived: 1.')};
o = evalc('main_demo({''4'', ''Alice'', ''Bob'', ''4'', ''Dave'', ''Frank'', ''5'', ''3'', ''0''})');
c(end+1, :) = {'main_demo option 5: 2 channels repaired and all work in the list', has(o, '2 channels repaired. The network is whole again.') && ~has(o, 'e1       Alice - Bob      85    broken') && has(o, 'e5       Dave - Frank     32    works')};
o = evalc('main_demo({''5'', ''0''})');
c(end+1, :) = {'main_demo option 5: nothing broken says so', has(o, 'No channel was broken.')};

% --- main_demo: the whole report ---
rep = evalc('show_system(define_system())');
o = evalc('main_demo({''6'', ''0''})');
c(end+1, :) = {'main_demo option 6: the text of show_system, all 7 checks yes', has(o, rep) && ~has(o, 'The report is about the whole network') && has(o, 'Goodbye.')};
o = evalc('main_demo({''4'', ''Dave'', ''Frank'', ''6'', ''0''})');
c(end+1, :) = {'main_demo option 6 after a break: a note, and the report of the untouched network', has(o, '(The report is about the whole network, not about the broken channels.)') && has(o, rep)};

% --- main_demo: wrong use ---
c(end+1, :) = {'main_demo stops when the scripted answers run out', raises_error(@() evalc('main_demo({''1'', ''Alice''})')) && raises_error(@() evalc('main_demo({''3''})'))};
c(end+1, :) = {'main_demo refuses answers that are not a cell array of texts', raises_error(@() evalc('main_demo(5)')) && raises_error(@() evalc('main_demo({1})'))};
try
    evalc('main_demo({''1''})');
    errid = '';
catch err
    errid = err.identifier;
end
c(end+1, :) = {'main_demo: the error for missing answers is read_answer:answers', strcmp(errid, 'read_answer:answers')};

% --- the files in outputs do not change ---
after = dir(fullfile(root, 'outputs'));
c(end+1, :) = {'main_demo and its parts do not change the files in outputs', isequal({before.name}, {after.name}) && isequal([before.bytes], [after.bytes]) && isequal([before.datenum], [after.datenum])};

summarize_checks('test_main_demo', c);
end
