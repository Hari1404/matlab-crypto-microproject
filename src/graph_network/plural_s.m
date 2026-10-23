function s = plural_s(k)
% PLURAL_S The text s when k is not 1, and an empty text when k is 1 (for words like channel and channels).
if k == 1
    s = '';
else
    s = 's';
end
end
