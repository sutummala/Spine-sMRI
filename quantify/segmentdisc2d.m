function [BW, disc] = segmentdisc2d(qc, spine, tag)

fprintf('Segmenting %s disc\n', tag);

BW = roipoly(spine); %It starts an interactive manual segmentation and returns a binary mask for the segmented disc region
disc = zeros(size(spine));

for i = 1:size(spine,1)
    for j = 1:size(spine,2)
        if BW(i,j)
            disc(i,j) = spine(i,j);
        end
    end
end
