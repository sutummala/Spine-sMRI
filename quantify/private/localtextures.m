function tex = localtextures(data, n)

glcm = graycomatrix(data, 'Offset', [0 1; -1 1; -1 0; -1 -1], 'Symmetric', true); % Offset added to avoid rotational invariance

stats = graycoprops(glcm);
switch n
    case 1
        tex = mean(stats.Contrast(:));
    case 2
        tex = mean(stats.Correlation(:));
    case 3
        tex = mean(stats.Energy(:));
    case 4
        tex = mean(stats.Homogeneity(:));
    otherwise
        error('Wrong number selection');
end