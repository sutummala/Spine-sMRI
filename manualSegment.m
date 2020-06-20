function manualsegment

% Created on 21-11-2012 by Sudhakar Tummala
% First it will request the user interactively for the DICOM file.
% Then It requests the directory that has dicomfiles.
% Each Disc segmented separately.

% The disc severity graded by a radiologist.
[discgrades, ids] = xlsread('D:\Sudhakar\spinecode\matlab\discgradingcube.xls', 2);

% Savepath
savepath = 'D:\Sudhakar\spinecode\save\discgroundtruthT2_followup_090113_cube';
if ~exist(savepath, 'dir')
    mkdir(savepath);
end

qc = quantify;

files = dir(savepath); count = length(files)-2;
fprintf('Found %d files in the savepath\n\n', count);

for i = count+1:length(ids)-1
    
    % User Interface to get dicom slices
    fprintf('For %s \n\n', ids{i+1});
    filename = uigetfile;
    datapath = uigetdir;
    info = dicominfo([datapath, '\', filename]);
    spine = single(dicomread(info));
    disc = struct(); % Initialize an empty structure

    % Segment the discs
    [BW1, disc1] = segmentdisc2d(qc, spine, 'L1-L2');
    [BW2, disc2] = segmentdisc2d(qc, spine, 'L2-L3');
    [BW3, disc3] = segmentdisc2d(qc, spine, 'L3-L4');
    [BW4, disc4] = segmentdisc2d(qc, spine, 'L4-L5');
    [BW5, disc5] = segmentdisc2d(qc, spine, 'L5-S1');
    close(gcf);

    % Get the disc masks and the corresponding texture features into the
    % structure
    disc.BW1 = BW1; disc.BW2 = BW2; disc.BW3 = BW3; disc.BW4 = BW4; disc.BW5 = BW5; % Get binary masks of the discs into the struture
    disc.disc1 = disc1; disc.disc2 = disc2; disc.disc3 = disc3; disc.disc4 = disc4; disc.disc5 = disc5; % Get the masks of the discs into the structure
    
    save([savepath, '\' ids{i+1}], 'disc', 'spine'); % Save the data to the filename corresponding to the patient ids/number
    clear disc spine; clc;
end






