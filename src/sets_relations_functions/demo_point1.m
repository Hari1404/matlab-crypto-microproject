function demo_point1()
% DEMO_POINT1 Demonstration of Point 1: sets, relations and functions.
%   Packet 1A shows the sets and the conversion between text and symbols.
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
end

function s = yes_or_no(flag)
if flag
    s = 'yes';
else
    s = 'NO';
end
end
