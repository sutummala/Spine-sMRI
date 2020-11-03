function [msi, ent, con, cor, ene, hom] = classifyprog(qc, disc)


% Texture Features
msi = [mean(disc.roid1(:)) mean(disc.roid2(:)) mean(disc.roid3(:)) mean(disc.roid4(:)) mean(disc.roid5(:))];
ent = [entropy(disc.roid1) entropy(disc.roid2) entropy(disc.roid3) entropy(disc.roid4) entropy(disc.roid5)];
con = [localtextures(disc.roid1, 1) localtextures(disc.roid2, 1) localtextures(disc.roid3, 1) localtextures(disc.roid4, 1) localtextures(disc.roid5, 1)];
cor = [localtextures(disc.roid1, 2) localtextures(disc.roid2, 2) localtextures(disc.roid3, 2) localtextures(disc.roid4, 2) localtextures(disc.roid5, 2)];
ene = [localtextures(disc.roid1, 3) localtextures(disc.roid2, 3) localtextures(disc.roid3, 3) localtextures(disc.roid4, 3) localtextures(disc.roid5, 3)];
hom = [localtextures(disc.roid1, 4) localtextures(disc.roid2, 4) localtextures(disc.roid3, 4) localtextures(disc.roid4, 4) localtextures(disc.roid5, 4)];
