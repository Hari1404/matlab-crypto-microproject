function [u, k] = pick_user(Y, prompt, answers, k, other)
% PICK_USER Ask for one user, by number or by name, and ask again until the answer is right.
%   [u, k] = pick_user(Y, prompt, answers, k, other)
%   Y is the system (define_system). The answer is a user number from 1 to Y.n or a name from Y.users
%   (small or capital letters). other is a user number that is not allowed (the first user already chosen), or 0.
%   answers and k are as in read_answer.
u = 0;
while u == 0
    [s, k] = read_answer(prompt, answers, k);
    s = strtrim(s);
    v = 0;
    if ~isempty(s) && all(s >= '0' & s <= '9') && numel(s) <= 6
        v = str2double(s);
        if v < 1 || v > Y.n
            v = 0;
        end
    else
        v = find(strcmpi(Y.users, s), 1);
        if isempty(v)
            v = 0;
        end
    end
    if v == 0
        fprintf('  Please type a user number from 1 to %d or a name (%s).\n', Y.n, format_names(Y.users, 1:Y.n));
    elseif v == other
        fprintf('  Please choose a different user than %s.\n', Y.users{other});
    else
        u = v;
    end
end
end
