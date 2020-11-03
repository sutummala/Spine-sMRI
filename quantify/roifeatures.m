function disc = roifeatures(qc, disc, spine, lf, wf, map)

% Intensity Normalization
spine = normalize(spine);

%g = gaussfir(0.8); % Gaussian filtering
%spine = filter2(g, spine);
 
% spinevar = cont(spinefil, 4, 16);

[roiBW1, d1, roid1, stats1] = discroifeatures(disc.BW1, spine, lf, wf, map);
[roiBW2, d2, roid2, stats2] = discroifeatures(disc.BW2, spine, lf, wf, map);
[roiBW3, d3, roid3, stats3] = discroifeatures(disc.BW3, spine, lf, wf, map);
[roiBW4, d4, roid4, stats4] = discroifeatures(disc.BW4, spine, lf, wf, map);
[roiBW5, d5, roid5, stats5] = discroifeatures(disc.BW5, spine, lf, wf, map);

disc.d1 = d1; disc.roiBW1 = roiBW1; disc.roid1 = roid1; disc.stats1 = stats1;
disc.d2 = d2; disc.roiBW2 = roiBW2; disc.roid2 = roid2; disc.stats2 = stats2;
disc.d3 = d3; disc.roiBW3 = roiBW3; disc.roid3 = roid3; disc.stats3 = stats3;
disc.d4 = d4; disc.roiBW4 = roiBW4; disc.roid4 = roid4; disc.stats4 = stats4;
disc.d5 = d5; disc.roiBW5 = roiBW5; disc.roid5 = roid5; disc.stats5 = stats5;