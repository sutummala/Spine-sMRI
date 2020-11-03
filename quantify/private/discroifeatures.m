function [roiBW, d1, roid1, stats] = discroifeatures(BW, spine, lenfrac, widfrac, map)

%center = regionprops(BW, spine, 'WeightedCentroid');
stats = regionprops(BW, 'all');

% Compute parametric coordinates for ROI (ellipse)
cosphi = cosd(stats.Orientation);
sinphi = sind(360 - stats.Orientation);
a = 0.5*stats.MajorAxisLength;
b = 0.5*stats.MinorAxisLength;
n = 1;

for i = 0:0.1:2*pi
x(n) = stats.Centroid(1)+ lenfrac*a*cos(i)*cosphi - widfrac*b*sin(i)*sinphi;
y(n) = stats.Centroid(2)+ lenfrac*a*cos(i)*sinphi + widfrac*b*sin(i)*cosphi;
n = n+1;
end

%Binary ROI
roiBW = roipoly(BW, x, y);
[d1, roid1] = getmasks(spine, BW, roiBW);

if map
    figure, imshow(spine), imcontrast, hold on, plot(x,y,'r');
end