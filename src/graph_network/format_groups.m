function s = format_groups(names, comp)
% FORMAT_GROUPS Write the groups of users as one text, for example {Alice, Bob}  {Carol}.
%   comp(v) is the group number of the user v (as given by connected_components).
k = max([comp, 0]);
s = '';
for g = 1:k
    if g > 1
        s = [s '  '];
    end
    s = [s '{' format_names(names, find(comp == g)) '}'];
end
if k == 0
    s = '(none)';
end
end
