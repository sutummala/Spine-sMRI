function w = multiLDA(d1, d2, d3, d4, d5)

% Number of elements of each classes
n1 = numel(d1);
n2 = numel(d2);
n3 = numel(d3);
n4 = numel(d4);
n5 = numel(d5);

% Mean of each classes
mu1 = mean(d1);
mu2 = mean(d2);
mu3 = mean(d3);
mu4 = mean(d4);
mu5 = mean(d5);

% Average of the mean of all classes
mu = (mu1 + mu2 + mu3+ mu4 + mu5)/5;

% Center the data (data-mean)
d1 = d1 - repmat(mu1,size(d1,1),1);
d2 = d2 - repmat(mu2,size(d2,1),1);
d3 = d3 - repmat(mu3,size(d3,1),1);
d4 = d4 - repmat(mu4,size(d4,1),1);
d5 = d5 - repmat(mu5,size(d5,1),1);

% Calculate the within class variance (SW)
s1 = d1'*d1;
s2 = d2'*d2;
s3 = d3'*d3;
s4 = d4'*d4;
s5 = d5'*d5;
sw = s1 + s2 + s3+ s4 + s5;

% in case of two classes only use v
% v1 = (mu1-mu2)/sw;

% if more than 2 classes calculate between class variance (SB)
sb1 = n1*(mu1 - mu)'*(mu1 - mu);
sb2 = n2*(mu2 - mu)'*(mu2 - mu);
sb3 = n3*(mu3 - mu)'*(mu3 - mu);
sb4 = n4*(mu4 - mu)'*(mu4 - mu);
sb5 = n5*(mu5 - mu)'*(mu5 - mu);
SB = sb1 + sb2 + sb3 + sb4 + sb5;
v = SB/sw;

% find eigne values and eigen vectors of the (v)
[evec, eval] = eigs(v);

w = evec(:,1); % Weight of importance for each marker/feature.

% Sort eigen vectors according to eigen values (descending order) and
% neglect eigen vectors according to small eigen values
% v=evec(greater eigen value)
% or use all the eigen vectors

% project the data of the first and second class respectively
% hel = hel * w(1);
% ddd = ddd * w(2);