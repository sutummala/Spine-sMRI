% This function gets corresponding masks from the image using the extracted
% binary masks 
function [d1, roid1] = getmasks(spine, BW, roiBW)

d1 = zeros(size(spine)); roid1 = d1;

for i = 1:size(spine,1)
    for j = 1:size(spine,2)
        if BW(i,j)
            d1(i,j) = spine(i,j);
        end
        if roiBW(i,j)
            roid1(i,j) = spine(i,j);
        end
    end
end