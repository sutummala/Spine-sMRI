function w = LDA(hel, ddd)

% Number of elements of each classes
n1 = numel(hel);
n2 = numel(ddd);

% Mean of each classes
mu1 = mean(hel);
mu2 = mean(ddd);

% Average of the mean of all classes
mu = (mu1 + mu2)/2;

% Center the data (data-mean)
d1 = hel - repmat(mu1,size(hel,1),1);
d2 = ddd - repmat(mu2,size(ddd,1),1);

% Calculate the within class variance (SW)
s1 = d1'*d1;
s2 = d2'*d2;
sw = s1 + s2;

% in case of two classes only use v
% v1 = (mu1-mu2)/sw;

% if more than 2 classes calculate between class variance (SB)
sb1 = n1*(mu1 - mu)'*(mu1 - mu);
sb2 = n2*(mu2 - mu)'*(mu2 - mu);
SB = sb1 + sb2;
v = SB/sw;

% find eigne values and eigen vectors of the (v)
[evec, eval] = eigs(v);

w = evec(:,1); % Weight of importance for each marker.

% Sort eigen vectors according to eigen values (descending order) and
% neglect eigen vectors according to small eigen values
% v=evec(greater eigen value)
% or use all the eigen vectors

% project the data of the first and second class respectively
hel = hel * w(1);
ddd = ddd * w(2);