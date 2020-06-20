function segmentDisc3D

file = uigetfile;
datapath = 'D:\Sudhakar\spinecode\save\3Dcubedata';
savepath = 'D:\Sudhakar\spinecode\save\L4L5segmentations';

if ~exist(savepath, 'dir')
    mkdir(savepath);
end

load([datapath, '\', file]);
numSlices= size(lspine.vol, 1);
binaryIm = false(numSlices, 512, 512);

fprintf('Number of Slices in the image: %d\n\n', numSlices);
prompt = {'Enter start slice:','Enter end slice:'};
dlg_title = 'Input for 3D slice range';
num_lines = 1;
def = {'1','200'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
start = str2double(answer{1}); last = str2double(answer{2});

for i = start:last
    fprintf('Slice %d/%d\n\n', i, numSlices);
    slice = reshape(lspine.vol(i, :, :), 512, 512);
    binaryIm(i, :, :) = roipoly(slice);
    close(gcf);
end

save([savepath, '\', file], 'lspine', 'binaryIm');
    
