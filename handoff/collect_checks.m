% collect_checks  Run every test that needs no figure window, one by one,
% and print how many checks passed in each (and any FAIL lines).
% Use this where no graphics work (for example a headless Octave).
% Run from the project folder:  octave --no-gui --eval "run('handoff/collect_checks.m')"
root = fileparts(fileparts(mfilename('fullpath')));
cd(root); setup_project;
names = {'test_sets','test_relations','test_cipher','test_graph','test_digraph','test_modular', ...
    'test_group','test_dh','test_encryption','test_system','test_verification', ...
    'test_rsa','test_rsa_users','test_rsa_verification','test_main_demo'};
tot = 0; totp = 0;
for k = 1:numel(names)
    try
        out = evalc(names{k});
        nfail = numel(strfind(out, 'FAIL'));
        tok = regexp(out, '(\d+) of (\d+) checks passed', 'tokens');
        if isempty(tok)
            s = 'no summary line';
        else
            p = str2double(tok{end}{1}); n = str2double(tok{end}{2});
            s = sprintf('%d of %d', p, n); tot = tot + n; totp = totp + p;
        end
        printf('%-24s %-16s FAIL lines: %d\n', names{k}, s, nfail);
    catch err
        printf('%-24s ERROR %s\n', names{k}, strtok(err.message, sprintf('\n')));
    end
end
printf('TOTAL: %d of %d\n', totp, tot);
% Not run here (they draw figures): test_graph_analysis, test_graph_pictures, test_digraph_pictures, test_route_picture
