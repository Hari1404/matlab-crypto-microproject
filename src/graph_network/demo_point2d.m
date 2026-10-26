function demo_point2d(outdir, visible)
% DEMO_POINT2D Demonstration of packet 2D: the communication network as a directed graph.
%   It prints the digraph (arcs, adjacency matrix, degrees, directed distances, paths, strongly connected groups, checks)
%   and then draws 3 pictures with arrows and saves them as PNG files.
%   demo_point2d()                 shows the 3 pictures on the screen and saves them in the outputs folder of the project.
%   demo_point2d(outdir, visible)  saves them in the folder outdir. visible is 'on' (show the figures) or 'off' (only save them).
if nargin < 1
    outdir = '';
end
if nargin < 2
    visible = 'on';
end
fprintf('\n##### POINT 2D DEMO: THE DIRECTED GRAPH #####\n');
S = define_sets();
G = define_graph(S);
D = define_digraph(S, G);
show_digraph(D);

fprintf('\n=== PICTURES OF THE DIRECTED NETWORK ===\n');
[files, titles] = save_digraph_pictures(D, outdir, visible);
if strcmp(visible, 'on')
    fprintf('The 3 pictures are open in figure windows and are saved as PNG files in this folder:\n');
else
    fprintf('The 3 pictures are saved as PNG files in this folder (the figure windows are closed):\n');
end
folder = fileparts(files{1});
fprintf('  %s\n', folder);
for k = 1:3
    [d, nm, ext] = fileparts(files{k});
    fprintf('%d. %-22s %s\n', k, [nm ext], titles{k});
end
[ok_exist, ok_png, ok_diff] = check_picture_files(files);
fprintf('\nPicture checks:\n');
checks = {
    'All 3 picture files were written and none of them is empty', ok_exist;
    'All 3 files are PNG pictures (they start with the PNG signature)', ok_png;
    'The 3 pictures are all different from each other', ok_diff};
for q = 1:size(checks, 1)
    if checks{q, 2}
        word = 'yes';
    else
        word = 'NO';
    end
    fprintf('  %-80s: %s\n', checks{q, 1}, word);
end
end
