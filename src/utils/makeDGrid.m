function [xTest, xTestDiff, nTest, nTestPerDim] = makeDGrid(xRange)
% Construct a d-dimensional grid with equal number of test points per dimension.
% This is commonly used to generate the grid for test points.
%
% Input
%   xRange: (d x 2) rectangular region. Each row is an interval [min, max]
%
% Output
%   xTest: (nTest x d) set of points that forms the grid
%   xTestDiff: (d x 1) spacing for each dimension
%   nTest: number of points on the grid (may be larger than nMinGridPoints)
%   nTestPerDim: number of points per dimension

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

d = size(xRange, 1); % dimension
%xtr = cell(d, 1);
nTest=1;
nTestPerDim=[];
xTestDiff=1;

for kD=1:d
    nTestDim=xRange(kD, 2)-xRange(kD, 1)+1;
    nTestPerDim=[nTestPerDim;nTestDim];
    nTest=nTest*nTestDim;
end

xTest = zeros(nTest, d);

switch d
    case 2
        [X1,X2] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2));
        xTest=[X1(:) X2(:)];
    case 3
        [X1,X2,X3] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2));
        xTest=[X1(:) X2(:) X3(:)];
    case 4
        [X1,X2,X3,X4] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:)];
    case 5
        [X1,X2,X3,X4,X5] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:)];
    case 6
        [X1,X2,X3,X4,X5,X6] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:)];

end


end
