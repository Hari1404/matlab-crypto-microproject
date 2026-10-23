function summarize_checks(test_name, checks)
% SUMMARIZE_CHECKS Print PASS or FAIL for each check and stop with an error if any failed.
%   checks is a cell array with one row per check: {label, true or false}.
n = size(checks, 1);
nfail = 0;
fprintf('\n--- %s ---\n', test_name);
for i = 1:n
    if isequal(checks{i, 2}, true)
        fprintf('PASS  %s\n', checks{i, 1});
    else
        fprintf('FAIL  %s\n', checks{i, 1});
        nfail = nfail + 1;
    end
end
fprintf('%s: %d of %d checks passed\n', test_name, n - nfail, n);
if nfail > 0
    error('%s: %d check(s) failed.', test_name, nfail);
end
end
