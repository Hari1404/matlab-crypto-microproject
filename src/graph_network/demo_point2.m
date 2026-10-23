function demo_point2(outdir, visible)
% DEMO_POINT2 Demonstration of Point 2: the graph network.
%   Packet 2A shows the network as a graph: the edges, the adjacency matrix, the adjacency list and the degrees.
%   Packet 2B shows the analysis: connectivity, breadth-first search, distances, the shortest path, cycles and what happens when a channel or a user is removed.
%   Packet 2C draws the network with plot commands: 5 pictures, saved as PNG files.
%   demo_point2()                 shows the 5 pictures on the screen and saves them in the outputs folder of the project.
%   demo_point2(outdir, visible)  saves them in the folder outdir. visible is 'on' (show the figures) or 'off' (only save them).
if nargin < 1
    outdir = '';
end
if nargin < 2
    visible = 'on';
end
fprintf('\n##### POINT 2 DEMO: THE GRAPH NETWORK #####\n');
S = define_sets();
R = define_relations(S);
G = define_graph(S, R);
show_graph(G);
show_analysis(G);

fprintf('\n=== PICTURES OF THE COMMUNICATION NETWORK ===\n');
[files, titles] = save_network_pictures(G, outdir, visible);
if strcmp(visible, 'on')
    fprintf('The 5 pictures are open in figure windows and are saved as PNG files in this folder:\n');
else
    fprintf('The 5 pictures are saved as PNG files in this folder (the figure windows are closed):\n');
end
folder = fileparts(files{1});
fprintf('  %s\n', folder);
for k = 1:5
    [d, nm, ext] = fileparts(files{k});
    fprintf('%d. %-26s %s\n', k, [nm ext], titles{k});
end
[ok_exist, ok_png, ok_diff] = check_picture_files(files);
fprintf('\nChecks:\n');
checks = {
    'All 5 picture files were written and none of them is empty', ok_exist;
    'All 5 files are PNG pictures (they start with the PNG signature)', ok_png;
    'The 5 pictures are all different from each other', ok_diff};
for q = 1:size(checks, 1)
    if checks{q, 2}
        word = 'yes';
    else
        word = 'NO';
    end
    fprintf('  %-80s: %s\n', checks{q, 1}, word);
end
end
