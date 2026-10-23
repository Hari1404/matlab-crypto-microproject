function setup_project()
% SETUP_PROJECT Add all project code folders to the MATLAB path.
root = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(root, 'src')));
addpath(fullfile(root, 'tests'));
fprintf('Project paths added. Project folder: %s\n', root);
end
