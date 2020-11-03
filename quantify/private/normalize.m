% Linear gray scale normalization
function spine = normalize(spine)

Mini = min(spine(:));
Maxi = max(spine(:));
newMini = 0; newMaxi = 255;

spine = (spine-Mini)*((newMaxi - newMini)/(Maxi-Mini)) + newMini;
