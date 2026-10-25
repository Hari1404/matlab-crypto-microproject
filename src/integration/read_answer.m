function [s, k] = read_answer(prompt, answers, k)
% READ_ANSWER One typed answer, or the next answer of a scripted run.
%   [s, k] = read_answer(prompt, answers, k)
%   If answers is empty, the answer is typed on the keyboard with input(prompt, 's').
%   If answers is a cell array of texts, the answer is answers{k}; the prompt and the answer are printed
%   so that a scripted run looks as if it was typed. k is the number of the next answer and grows by 1.
%   When the scripted answers have run out, this stops with an error.
if ~ischar(prompt)
    error('read_answer:prompt', 'The prompt must be a text.');
end
if isempty(answers)
    s = input(prompt, 's');
    if ~ischar(s)
        s = '';
    end
    return;
end
if ~iscell(answers) || ~all(cellfun(@ischar, answers(:)))
    error('read_answer:answers', 'The answers must be a cell array of texts.');
end
if k > numel(answers)
    error('read_answer:answers', 'The scripted answers have run out (answer number %d is missing).', k);
end
s = answers{k};
k = k + 1;
fprintf('%s\n', [prompt s]);
end
