function tex = classifygrade(qc, disc, disclevel)


switch disclevel
    case 1 % L1-L2 disc
        msi = mean(disc.roid1(:)); % Signal Mean
        ent = entropy(disc.roid1); % Entropy
        con = localtextures(disc.roid1, 1); % Contrast
        cor = localtextures(disc.roid1, 2); % Correlation
        ene = localtextures(disc.roid1, 3); % Energy
        hom = localtextures(disc.roid1, 4); % Homogeneity
    case 2 % L2-L3 disc
        msi = mean(disc.roid2(:)); % Signal Mean
        ent = entropy(disc.roid2); % Entropy
        con = localtextures(disc.roid2, 1); % Contrast
        cor = localtextures(disc.roid2, 2); % Correlation
        ene = localtextures(disc.roid2, 3); % Energy
        hom = localtextures(disc.roid2, 4); % Homogeneity
    case 3 % L3-L4 disc
        msi = mean(disc.roid3(:)); % Signal Mean
        ent = entropy(disc.roid3); % Entropy
        con = localtextures(disc.roid3, 1); % Contrast
        cor = localtextures(disc.roid3, 2); % Correlation
        ene = localtextures(disc.roid3, 3); % Energy
        hom = localtextures(disc.roid3, 4); % Homogeneity
    case 4 % L4-L5 disc
        msi = mean(disc.roid4(:)); % Signal Mean
        ent = entropy(disc.roid4); % Entropy
        con = localtextures(disc.roid4, 1); % Contrast
        cor = localtextures(disc.roid4, 2); % Correlation
        ene = localtextures(disc.roid4, 3); % Energy
        hom = localtextures(disc.roid4, 4); % Homogeneity
    case 5 % L5-S1 disc
        msi = mean(disc.roid5(:)); % Signal Mean
        ent = entropy(disc.roid5); % Entropy
        con = localtextures(disc.roid5, 1); % Contrast
        cor = localtextures(disc.roid5, 2); % Correlation
        ene = localtextures(disc.roid5, 3); % Energy
        hom = localtextures(disc.roid5, 4); % Homogeneity
    otherwise
        error('wrong disc level');
end

tex.msi = msi; tex.con = con; tex.cor = cor; tex.ene = ene; tex.hom = hom; tex.ent = ent;
