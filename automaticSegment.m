function automaticSegment


% Created on 28-02-2013 by Tummala

clear all;
segpath = 'D:\Sudhakar\spinecode\save\3Dcubedata';
segs = dir(segpath);
num = length(segs);
fprintf('Found %d subjects\n\n\n', round((num - 2) * 0.5));

for i = 1
    file = segs(i+2).name;
    fprintf('---------------For %s segmentation--------------\n\n', file(1:5));
    load([segpath, '\', file]);
    midsliceNum = round(size(lspine.vol, 1) * 0.5);
    
    slice = double(reshape(lspine.vol(midsliceNum, :, :), 512, 512));
    slice(:, 1:(0.1 * size(slice, 1))) = 0;
    slice(:, size(slice, 1) - size(0.1 * size(slice, 1):size(slice, 1))) = 0;
    slice = normalize(slice);
    g = gaussfir(0.2); % Gaussian filtering
    slice = filter2(g, slice);
    %slice = anisodiff2D(slice, 15, 1/7, 30, 1); % Anistropic Diffusion
 
    [fx, fy] = gradient(slice);
    fx(fx < 0) = 0; 
    gM = sqrt(fx.^2 + fy.^2);
    figure, h = imshow(slice); set(h, 'CDataMapping', 'direct');
    binSlice = 0 * slice;
    for j = 1:size(slice, 1)
        if j < size(slice, 1) - 0.1 * size(slice, 1)
            seed = max(fx(j, :));
            th = mean(fx(j, :)) + 1.96 * std(fx(j, :));
            index = find(fx(j, :) >= seed - th);
            binSlice(j, min(index)) = 1;
        end
    end
    figure, imshow(binSlice);
    [a,b] = find(binSlice);
    data(:,1) = slice(find(binSlice)); data(:,2) = fx(find(binSlice));
    [idx, c] = kmeans(data, 2);
end

%     threshold1 = 0; % Initialize
%     threshold2 = 1;
%     while threshold1 < threshold2
%         threshold1 = threshold2;
%         [slice1, slice2] = updateSlice(slice, fx, threshold1);
%         data(:,1) = slice1(:); data(:,2) = slice2(:);
%         figure, plot(data(:,1), data(:,2),'o')
%         %[idx, c] = kmeans(data, 2);
%         [COEFF, SCORE, latent, tsquare] = princomp(data);
%         tsquare = reshape(SCORE(:,2), 512, 512);
%         figure, imshow(tsquare, []); 
%         threshold2 = mean(tsquare) + 1.96 * std(tsquare);
%     end


function [slice1, slice2] = updateSlice(slice, fx, threshold)
    
    slice1 = 0 * slice;
    slice2 = 0 * slice;
    a = fx > threshold;
    for x = 1:size(slice, 1)
        for y = 1:size(slice, 2)
            if a(x,y)
                slice1(x,y) = slice(x,y);
                slice2(x,y) = fx(x,y);
            end
        end
    end
    
function spine = normalize(spine)

Mini = min(spine(:));
Maxi = max(spine(:));
newMini = 0; newMaxi = 255;

spine = (spine-Mini)*((newMaxi - newMini)/(Maxi-Mini)) + newMini;
    
