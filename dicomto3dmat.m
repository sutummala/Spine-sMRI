function dicomto3dmat

% Created on 20-01-2013 by Tummala

% Savepath
clear all
savepath = 'D:\Sudhakar\spinecode\save\3Ddatasingle';
if ~exist(savepath, 'dir')
    mkdir(savepath);
end

files = dir(savepath); count = length(files)-2;
fprintf('Found %d files in the savepath %s\n\n', count, savepath);

% Datapath
filepath = 'D:\Sudhakar\spinecode\save\MRSpineimages';
images = dir(filepath);
fprintf('%d images found in datapath %s\n\n', length(images)-2, filepath);

for i = count+1:length(images)-2
    folderpath = [filepath, '\', images(i+2).name];
    fprintf('%d/%d, for %s visit \n\n', i, length(images)-2, images(i+2).name);
    slices = dir(folderpath);
    
    vol = zeros(length(slices)-2, 512, 512, 'single'); lspine = struct;
    for j = 1:length(slices)-2
        info = dicominfo([folderpath, '\', slices(j+2).name]);
        fprintf('%d/%d, %s slice\n\n', j, length(slices)-2, slices(j+2).name);
        slice = single(dicomread(info));
        vol(j, 1:size(slice, 1), 1:size(slice, 2)) = slice;
        clear slice
    end
    
    lspine.vol = vol; lspine.info = info;
    save([savepath, '\', images(i+2).name], 'lspine');
    clear lspine vol info
end
