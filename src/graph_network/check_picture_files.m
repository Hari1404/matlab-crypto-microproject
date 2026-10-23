function [exists_all, png_all, different_all] = check_picture_files(files)
% CHECK_PICTURE_FILES Check the picture files written by save_network_pictures (files is a cell array of file names).
%   exists_all     true when every file exists and is not empty
%   png_all        true when every file starts with the 8 bytes that every PNG file starts with
%   different_all  true when no two files hold exactly the same bytes (so no two pictures are the same)
sig = uint8([137 80 78 71 13 10 26 10]);
n = numel(files);
exists_all = true;
png_all = true;
different_all = true;
data = cell(n, 1);
for i = 1:n
    data{i} = uint8([]);
    fid = fopen(files{i}, 'r');
    if fid < 0
        exists_all = false;
        png_all = false;
    else
        data{i} = fread(fid, Inf, 'uint8=>uint8')';
        fclose(fid);
        if isempty(data{i})
            exists_all = false;
        end
        if numel(data{i}) < 8 || ~isequal(data{i}(1:8), sig)
            png_all = false;
        end
    end
end
for i = 1:n
    for j = (i + 1):n
        if isequal(data{i}, data{j})
            different_all = false;
        end
    end
end
end
