function evaluateDiagnosis

% Computer aided diagnosis of DDD
% First created on 04-12-12 by Sudhakar Tummala

% The disc severity was graded by a radiologist.
[discgrades, ids] = xlsread('D:\Sudhakar\spinecode\matlab\discgradingcube.xls', 2);

fprintf('Please select the folder that contains the data to validate\n\n');
datapath = uigetdir;
fprintf('Loading all images, please wait......\n');

discs = dir(datapath);
qc = quantify;

% Initializations
Age = struct([]);
Tex = Age;
age1 = []; age2 = []; age3 = []; age4 = []; age5 = [];
msi1 = []; msi2 = []; msi3 = []; msi4 = []; msi5 = [];
con1 = []; con2 = []; con3 = []; con4 = []; con5 = [];
cor1 = []; cor2 = []; cor3 = []; cor4 = []; cor5 = [];
ene1 = []; ene2 = []; ene3 = []; ene4 = []; ene5 = [];
hom1 = []; hom2 = []; hom3 = []; hom4 = []; hom5 = [];
ent1 = []; ent2 = []; ent3 = []; ent4 = []; ent5 = [];

for i = 3:length(discs)
    load([datapath, '\', ids{i-1,1}]);
    fprintf('%d of %d images loaded\n', i-2, length(discs)-2);
    % Features in a selected ROI
    disc = roifeatures(qc, disc, spine, 0.7, 0.8, 0); % Involves pre smoothing/reqularization    
    grades = discgrades(i-2,1:5);
    age = discgrades(i-2, 7);
    sex = discgrades(i-2, 8);
    for j = 1:length(grades)
        grade = grades(j);
        switch grade % DDD Grade (1 being healthy and 5 being worse)
            case 1 
                age1(end+1) = age;
                tex = classifygrade(qc, disc, j);
                msi1(end+1) = tex.msi;
                ent1(end+1) = tex.ent;
                con1(end+1) = tex.con;
                cor1(end+1) = tex.cor;
                ene1(end+1) = tex.ene;
                hom1(end+1) = tex.hom;               
            case 2 
                age2(end+1) = age;
                tex = classifygrade(qc, disc, j);
                msi2(end+1) = tex.msi;
                ent2(end+1) = tex.ent;
                con2(end+1) = tex.con;
                cor2(end+1) = tex.cor;
                ene2(end+1) = tex.ene;
                hom2(end+1) = tex.hom;
            case 3 
                age3(end+1) = age;
                tex = classifygrade(qc, disc, j);
                msi3(end+1) = tex.msi;
                ent3(end+1) = tex.ent;
                con3(end+1) = tex.con;
                cor3(end+1) = tex.cor;
                ene3(end+1) = tex.ene;
                hom3(end+1) = tex.hom;
            case 4 
                age4(end+1) = age;
                tex = classifygrade(qc, disc, j);
                msi4(end+1) = tex.msi;
                ent4(end+1) = tex.ent;
                con4(end+1) = tex.con;
                cor4(end+1) = tex.cor;
                ene4(end+1) = tex.ene;
                hom4(end+1) = tex.hom;
            case 5 
                age5(end+1) = age;
                tex = classifygrade(qc, disc, j);
                msi5(end+1) = tex.msi;
                ent5(end+1) = tex.ent;
                con5(end+1) = tex.con;
                cor5(end+1) = tex.cor;
                ene5(end+1) = tex.ene;
                hom5(end+1) = tex.hom;
            otherwise
                error('Wrong Grade');
        end
    end
end

Age(1).age1 = age1; Age(1).age2 = age2; Age(1).age3 = age3; Age(1).age4 = age4; Age(1).age5 = age5;
Tex(1).msi1 = msi1; Tex(1).msi2 = msi2; Tex(1).msi3 = msi3; Tex(1).msi4 = msi4; Tex(1).msi5 = msi5;
Tex(1).ent1 = ent1; Tex(1).ent2 = ent2; Tex(1).ent3 = ent3; Tex(1).ent4 = ent4; Tex(1).ent5 = ent5;
Tex(1).con1 = con1; Tex(1).con2 = con2; Tex(1).con3 = con3; Tex(1).con4 = con4; Tex(1).con5 = con5;
Tex(1).cor1 = cor1; Tex(1).cor2 = cor2; Tex(1).cor3 = cor3; Tex(1).cor4 = cor4; Tex(1).cor5 = cor5;
Tex(1).ene1 = ene1; Tex(1).ene2 = ene2; Tex(1).ene3 = ene3; Tex(1).ene4 = ene4; Tex(1).ene5 = ene5;
Tex(1).hom1 = hom1; Tex(1).hom2 = hom2; Tex(1).hom3 = hom3; Tex(1).hom4 = hom4; Tex(1).hom5 = hom5;


% Cross-Validation of Combination marker for Diagnosis
aggregatemarkerDiagnosis(qc, Age, Tex, 1, 0, 0);
msgbox('Validation Done');

%http://www.cse.oulu.fi/CMV/Downloads/LBPMatlab





























    




    
