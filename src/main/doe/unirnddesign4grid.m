function X=unirnddesign4grid(n,p,domain,varargin)
% this function rescale uniform random design to the desired range
% and also it provide the option to sample on a regular grid

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% see alo lhsdesign4grid.m

%import bo4co.*

global nMinGridPoints istestfun;

if ~isdeployed
    istestfun_=istestfun;
    nMinGridPoints_=nMinGridPoints;
else
    istestfun_=getmcruserdata('istestfun');
    nMinGridPoints_=getmcruserdata('nMinGridPoints');
end

%% Parameters of the algorithm
%nMinGridPoints = 1e3;

%% Make the grid for Pmin sampling
if istestfun_
    [xTest, xTestDiff, nTest, nTestPerDim] = makeGrid(xRange, nMinGridPoints_);
else
    [xTest, xTestDiff, nTest, nTestPerDim] = makeDGrid(xRange);
end

%%

lb=zeros(1,size(domain,1));
ub=zeros(1,size(domain,1));

for i=1:size(domain,1)
    lb(i)=domain(i,1);
    ub(i)=domain(i,2);
end

xn = rand(n,p)';
X = bsxfun(@plus,lb,bsxfun(@times,xn,(ub-lb)));

%% making the initial points into the grid
for i=1:size(X,1)
    [M,I]=min(pdist2(X(i,:),xTest));
    X(i,:)=xTest(I,:);
    xTest(I,:)=[]; % clear the selected point in order not to select this point again in the initial design
end

if ~isempty(varargin) && isequal(varargin,'round')
    X=round(X);
end
end