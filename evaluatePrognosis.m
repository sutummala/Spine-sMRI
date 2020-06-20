function evaluatePrognosis

% Computer aided prognosis of DDD
% First created on 04-12-12 by Sudhakar Tummala

% The disc severity was graded by a radiologist.
[discgradesB, ids] = xlsread('D:\Sudhakar\spinecode\matlab\discgradingcube.xls', 1);
[discgradesF, ids] = xlsread('D:\Sudhakar\spinecode\matlab\discgradingcube.xls', 2);

fprintf('Please select the folder that contains the data to validate\n\n');
datapath = uigetdir;
fprintf('Loading all images, please wait......\n');

discs = dir(datapath);

% Initialize
npage = []; page = []; pmsi = []; npmsi = []; pent = []; npent = []; pcon = []; npcon = [];
pcor = []; npcor = []; pene = []; npene = []; phom = []; nphom = [];
qc = quantify;

for i = 3:length(discs)
    load([datapath, '\', ids{i-1,1}]);
    fprintf('%d of %d images loaded\n', i-2, length(discs)-2);
    % Features in a selected ROI
    disc = roifeatures(qc, disc, spine, 0.7, 0.8, 0);
    % Prognosis analysis
    progindex = discgradesF(i-2, 1:5) - discgradesB(i-2, 1:5);
    age = discgradesB(i-2, 7);
    [msi, ent, con, cor, ene, hom]= classifyprog(qc, disc);
    if ~isempty(find(progindex, 1))
        % Progressors
        pag = repmat(age, 1, length(find(progindex)));% Age
        pms = msi(find(progindex)); % Variance of signal intensity
        pen = ent(find(progindex)); % Entropy
        pco = con(find(progindex)); % Contrast
        pco1 = cor(find(progindex)); % Correlation
        pen1 = ene(find(progindex)); % Energy
        pho = hom(find(progindex)); % Homogeneity
        pmsi = horzcat(pmsi, pms);
        page = horzcat(page, pag);
        pent = horzcat(pent, pen);
        pcon = horzcat(pcon, pco);
        pcor = horzcat(pcor, pco1);
        pene = horzcat(pene, pen1);
        phom = horzcat(phom, pho);
        
        % Non Progressors
        npag = repmat(age, 1, length(find(~progindex)));
        npms = msi(find(~progindex));
        npen = ent(find(~progindex));
        npco = con(find(~progindex));
        npco1 = cor(find(~progindex));
        npen1 = ene(find(~progindex));
        npho = hom(find(~progindex));
        npage = horzcat(npage, npag);
        npmsi = horzcat(npmsi, npms);
        npent = horzcat(npent, npen);
        npcon = horzcat(npcon, npco);
        npcor = horzcat(npcor, npco1);
        npene = horzcat(npene, npen1);
        nphom = horzcat(nphom, npho);
    end
end

progressors(:,1) = page;
progressors(:,2) = pmsi;
progressors(:,3) = pent;
progressors(:,4) = pcor;
progressors(:,5) = pcon;
progressors(:,6) = pene;
progressors(:,7) = phom;

nonprogressors(:,1) = npage;
nonprogressors(:,2) = npmsi;
nonprogressors(:,3) = npent;
nonprogressors(:,4) = npcor;
nonprogressors(:,5) = npcon;
nonprogressors(:,6) = npene;
nonprogressors(:,7) = nphom;

% Combination marker for Prognosis
aggregatemarkerPrognosis(qc, progressors, nonprogressors); 














    




    
