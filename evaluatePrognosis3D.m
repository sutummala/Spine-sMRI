function evaluatePrognosis3D


% Created on 12-02-2013 by Tummala

clear all

segpath = 'D:\Sudhakar\spinecode\save\L4L5segmentations';

segs = dir(segpath);

num = length(segs);
fprintf('Found %d subjects\n\n\n', round((num - 2) * 0.5));

dataVol = zeros(num - 2, 1);
Contrast = dataVol;
Correlation = dataVol;
Energy = dataVol;
Interval = dataVol;
Homogeneity = dataVol;
discLength = dataVol;

ROI = 0; % Region of Interest
visualize = 0; % Visualize the disc in 3D

for i = 1:num - 2
    
    file = segs(i+2).name;
    fprintf('---------------For %s segmentation--------------\n\n', file(1:5));
    load([segpath, '\', file]);
    binaryIm = 0 * binaryIm; % Choice
    grayIm = binaryIm;
    midsliceNum = round(size(binaryIm, 1) * 0.5);
        for j = 1:size(binaryIm,1);
            slice = reshape(lspine.vol(j, :, :), 512, 512);
            po = disccontours{j}; % Disc contour points
            if isempty(po)
                continue
            else
                binaryIm(j, :, :) = roipoly(slice, po(1,:), po(2,:)); % Extracts the binary mask
                if j == midsliceNum
                    midVoxels = length(find(binaryIm(j, :, :)));
                    normFactor = regionprops(reshape(binaryIm(j, :, :), 512, 512), 'MajorAxisLength'); % Get the disc Length for normalization purpose
                    normFactor = normFactor.MajorAxisLength * lspine.info.PixelSpacing(1); % Get the value in 'mm'
                    acquiDate = str2double(lspine.info.AcquisitionDate(3:6));
                end    
                binarySlice = reshape(binaryIm(j, :, :), 512, 512);
                grayIm(j, :, :) = extractgrayMask(slice, binarySlice);
                clear slice po bninarySlice BW
            end
        end
    
    grayIm = normalize(crop(grayIm, 1));
    
    %------VISUALIZE DISC in 3D--------
    if visualize
        binaryIm = normalize(crop(binaryIm, 1));
        bin = smooth3(binaryIm, 'gaussian', 3, 0.8);
        figure
        p = patch(isosurface(bin, 0.5));
        isonormals(bin,p);
        set(p,'FaceColor',[0.8,.75,.65],'EdgeColor','none','AmbientStrength',.4);
        set(p,'SpecularExponent',20, 'SpecularStrength',0.7);
        view(3);
        axis off
        l = light;
        light('Position', -get(l,'Position'))
        lighting phong
        title('3D visualization of L4L5 Disc', 'FontSize', 20);
        clear bin
    end
    %-----------------------------------
    
    discVol = length(find(binaryIm(:))) * lspine.info.PixelSpacing(1) * lspine.info.PixelSpacing(2) * lspine.info.SliceThickness; % Volume Computation excluding slice spacing
    gapVol = (length(find(binaryIm(:))) - midVoxels) * lspine.info.PixelSpacing(1) * lspine.info.PixelSpacing(2) * lspine.info.SpacingBetweenSlices; % Volume of slice gaps
    totalVol = discVol + gapVol;
    if ROI
        grayIm = discROI(grayIm, 0.2, 0.8);
    end
    glcm = graycomatrix(grayIm(:), 'offset', [-1 0], 'Symmetric', true); % Gray Level Co-occurance Matrix
    texProps = graycoprops(glcm); % Texture features
    
    fprintf('Slice Thickness, PixelSpacing and SpacingBetweenSlices are %1.1f mm, %0.3f mm, %0.2f mm\n\n', lspine.info.SliceThickness, lspine.info.PixelSpacing(1),...
        lspine.info.SpacingBetweenSlices); 
    fprintf('Normalized Volume is %1.3f \n\n', totalVol/(normFactor^3));
    fprintf('DiscLength is %2.1f mm\n\n', normFactor);
    clear binaryIm grayIm lspine glcm
    
    % Get the data into vectors
    dataVol(i) = totalVol;
    Interval(i) = acquiDate;
    Contrast(i) = texProps.Contrast;
    Correlation(i) = texProps.Correlation;
    Energy(i) = texProps.Energy;
    Homogeneity(i) = texProps.Homogeneity;
    discLength(i) = normFactor;
end

dataVol = dataVol .*(mean(discLength)./discLength); % Normalized DiscLength
baseVol = dataVol(1:2:end); % Baseline
folVol = dataVol(2:2:end); % Follow-up
longchange = (folVol - baseVol)./baseVol * 100; % Longitudinal Change in disc volume

% ------------------GLCM texture features----------------

Validate(longchange, Contrast, 'Contrast');
Validate(longchange, Correlation, 'Correlation');
Validate(longchange, Energy, 'Energy');
Validate(longchange, Homogeneity, 'Homogeneity');

% -----------------Combination marker (LDA)----------------

ls = [zeros(length(Contrast) * 0.5,1)' ones(length(Correlation) * 0.5,1)'];
con = Contrast./std(Contrast);
cor = Correlation./std(Correlation);
ene = Energy./std(Energy);
hom = Homogeneity./std(Homogeneity);

prog = find(longchange < median(longchange));
nonprog = find(longchange >= median(longchange));

% Progressors and nonprogressors for each GLCM texture feature

progCon = con(prog);
nonprogCon = con(nonprog);

progCor = cor(prog);
nonprogCor = cor(nonprog);

progEne = ene(prog);
nonprogEne = ene(nonprog);

progHom = hom(prog);
nonprogHom = hom(nonprog);

W = LDA([progCon, progCor, progEne, progHom], [nonprogCon, nonprogCor, nonprogEne, nonprogHom]);
aggm = W(1) * con + W(2) * cor + W(3) * ene + W(4) * hom;
fprintf('Marker Importance: 1)Contrast %0.2f \n2)Correlation %0.2f \n3)Energy %0.2f \n4)Homogeneity %0.2f\n\n', W(1), W(2), W(3), W(4));

Validate(longchange, aggm, 'CombinationMarker');


function Validate(longchange, marker, tag)

% -------------------------Start Validation from here------------------------------

fprintf('--------------------------------------Validating for %s-------------------------------------------\n\n\n', tag);

baseHomo = marker(1:2:end);
folHomo = marker(2:2:end);

longchangeHomo = (folHomo - baseHomo)./baseHomo * 100; % Longitudinal Change in disc texture

[c, p] = corrcoef(longchange, longchangeHomo); % Longitudinal associations with the marker values
fprintf('Efficacy of %s (CC %0.2f, p-value %0.9f)\n\n', tag, c(2), p(2));
fprintf('Longitudinal SRM of %s is %0.2f\n\n', tag, mean(folHomo - baseHomo)/std(folHomo - baseHomo));

progressors = baseHomo(longchange <= median(longchange));
nonprogressors = baseHomo(longchange >= median(longchange));

figure, plot(progressors);
hold on
plot(nonprogressors, 'r');
xlabel('Num of Samples', 'FontSize', 20);
ylabel(tag, 'FontSize', 20);
title('Progressors vs NonProgressors', 'FontSize', 20);
legend('Progressors', 'Nonprogressors');

% ------Statistical Validation----------

[p, h] = ranksum(progressors, nonprogressors); % Non parametric
[X,Y,T,AUC, opt] = perfcurve([zeros(length(nonprogressors),1); ones(length(progressors),1)], [nonprogressors; progressors], 1, 'NBoot', 1000); % Parametric
[dA, sddA, pauc] = DeLongTest(progressors', nonprogressors', [1 -1]);

if h
    fprintf('There is significance using %s\n\n', tag);
    fprintf('P-value (T-test) to separate Progressors from Nonprogressors is %0.5f\n\n', p);
    fprintf('AUC is %0.3f, p-value %0.9f (%0.3f - %0.3f)\n\n', AUC(1), pauc(1), AUC(2), AUC(3));
else
    fprintf('No significance differences found between Progressors and Nonprogressors (p-value is %0.5f)\n\n', p);
    fprintf('AUC is %0.3f, p-value %0.9f (%0.3f - %0.3f)\n\n', AUC(1), pauc(1), AUC(2), AUC(3));
end

figure, plot(X(:,1), Y(:,1));
xlabel('1-Specificity', 'FontSize', 20);
ylabel('Sensitivity', 'FontSize', 20);
title(tag, 'FontSize', 20);

function grayMask = extractgrayMask(slice, binarySlice)

grayMask = zeros(size(slice));

for i = 1:size(slice,1)
    for j = 1:size(slice,2)
        if binarySlice(i,j)
            grayMask(i,j) = slice(i,j);
        end
    end
end

function spine = normalize(spine)

Mini = min(spine(:));
Maxi = max(spine(:));
newMini = 0; newMaxi = 255;

spine = (spine-Mini)*((newMaxi - newMini)/(Maxi-Mini)) + newMini;

function grayImROI = discROI(grayIm, minFrac, maxFrac)

% Defines a ROI as a BOX

[x, y, z] = size(grayIm);

sagMin = round(minFrac * x); sagMax = round(maxFrac * x);
fronMin = round(minFrac * y); fronMax = round(maxFrac * y);
axiMin = round(minFrac * z); axiMax = round(maxFrac * z);

grayImROI = grayIm(sagMin:sagMax, fronMin:fronMax, axiMin:axiMax);

function [dA, sddA, p] = DeLongTest(X,Y,L)
 
% X are the normals
% Y are the abnormals
% L is the contrast function 

% In case of two biomarkers
%    X(1,:) are marker 1 values
%    X(2,:) are marker 2 values
%    Y(1,:) are marker 1 values
%    Y(2,:) are marker 2 values

% testing Aroc(M1) > Aroc(M2) -> L = [1 -1];

% For 3 markers testing Aroc(M1) larger than any other
%      ->   L = [[1 -1 0]' [1 0 -1]']';

[A Cov] = DeLongCovarians(X,Y);

%A
dA = L'*A;

VardA = L' * Cov * L;
sddA=sqrt(VardA);

if (size(X,1) > 1)
  p = 1- chi2cdf(dA' * inv(VardA) * dA,rank(L));
else
  p = 2*normcdf(0.5, A, sddA);
  if (p>1)
    p = 2-p;
  end
end

function [A, Cov] = DeLongCovarians(X,Y)

% X include biomarkervalues for normals 
% Y include biomarkervalues for abnormals

[no_markers no_normals] = size(X); 
[no_markers no_abnormals] = size(Y); 

% Compute structural components

vab = zeros(no_markers,no_abnormals);

for m = 1:no_markers
    for i = 1:no_abnormals
        vab(m,i) = (sum(X(m,:) < Y(m,i)) + 0.5 * sum(X(m,:) == Y(m,i)))/no_normals;
    end;
end;


vno = zeros(no_markers,no_normals);

for m = 1:no_markers
    for i = 1:no_normals
        vno(m,i) = (sum(X(m,i) < Y(m,:)) + 0.5 * sum(X(m,i) == Y(m,:)))/no_abnormals;
    end;
end;

% Compute estimate of areas

A = zeros(no_markers,1);
for m = 1:no_markers
    A(m) = sum(vab(m,:))/no_abnormals;
end;

% compute the estimated covariance matrix of areas

for m = 1:no_markers
    for n = 1:no_markers
        s10m(m,n) = (vab(m,:)-A(m)) * (vab(n,:)-A(n))' / (no_abnormals-1);
      
    end;
end;

for m = 1:no_markers
    for n = 1:no_markers
        s01m(m,n) = (vno(m,:)-A(m)) * (vno(n,:)-A(n))' / (no_normals-1);
      
    end;
end;

Cov = s10m/no_abnormals + s01m/no_normals;



