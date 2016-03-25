function [h,p]=compute_entropy(m,s)
% this function computes the entropy of the minimizer distribution
% Input:
% m: mean estimations
% s: standard deviation of estimations, square root of s2 (variance)

% Output:
% h: entropy measure
% p: minimizer distibution

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% initializastion
h=0;
r=1000;
% draw function samples
t=zeros(size(m,1),r);
nTest=size(m,1);

for k=1:r
    t(:,k)=normrnd(m,s);
end
% compute the grid index of the minimizer
[f_star,x_star]=min(t);
p=zeros(1,nTest);
for k=1:r
    for l=1:nTest
        if x_star(k)==l
            p(l)=p(l)+1;
        end
    end
end
p=p./r; % normalize minimizer distribution
for i=1:nTest
    if p(i)>0
        h = h-p(i)*log2(p(i));
    end
end
