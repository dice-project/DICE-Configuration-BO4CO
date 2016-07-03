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
    case 7
        [X1,X2,X3,X4,X5,X6,X7] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:)];
    case 8
        [X1,X2,X3,X4,X5,X6,X7,X8] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:)];
    case 9
        [X1,X2,X3,X4,X5,X6,X7,X8,X9] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:)];
    case 10
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:)];
    case 11
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:)];
    case 12
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:)];
    case 13
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:)];
    case 14
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:)];
    case 15
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2),xRange(15, 1):1:xRange(15, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:) X15(:)];
    case 16
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2),xRange(15, 1):1:xRange(15, 2),xRange(16, 1):1:xRange(16, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:) X15(:) X16(:)];
    case 17
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16 ,X17] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2),xRange(15, 1):1:xRange(15, 2),xRange(16, 1):1:xRange(16, 2),xRange(17, 1):1:xRange(17, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:) X15(:) X16(:) X17(:)];
    case 18
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2),xRange(15, 1):1:xRange(15, 2),xRange(16, 1):1:xRange(16, 2),xRange(17, 1):1:xRange(17, 2),xRange(18, 1):1:xRange(18, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:) X15(:) X16(:) X17(:) X18(:)];
    case 19
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2),xRange(15, 1):1:xRange(15, 2),xRange(16, 1):1:xRange(16, 2),xRange(17, 1):1:xRange(17, 2),xRange(18, 1):1:xRange(18, 2),xRange(19, 1):1:xRange(19, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:) X15(:) X16(:) X17(:) X18(:) X19(:)];
    case 20
        [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20] = ndgrid(xRange(1, 1):1:xRange(1, 2),xRange(2, 1):1:xRange(2, 2),xRange(3, 1):1:xRange(3, 2),xRange(4, 1):1:xRange(4, 2),xRange(5, 1):1:xRange(5, 2),xRange(6, 1):1:xRange(6, 2),xRange(7, 1):1:xRange(7, 2),xRange(8, 1):1:xRange(8, 2),xRange(9, 1):1:xRange(9, 2),xRange(10, 1):1:xRange(10, 2),xRange(11, 1):1:xRange(11, 2),xRange(12, 1):1:xRange(12, 2),xRange(13, 1):1:xRange(13, 2),xRange(14, 1):1:xRange(14, 2),xRange(15, 1):1:xRange(15, 2),xRange(16, 1):1:xRange(16, 2),xRange(17, 1):1:xRange(17, 2),xRange(18, 1):1:xRange(18, 2),xRange(19, 1):1:xRange(19, 2),xRange(20, 1):1:xRange(20, 2));
        xTest=[X1(:) X2(:) X3(:) X4(:) X5(:) X6(:) X7(:) X8(:) X9(:) X10(:) X11(:) X12(:) X13(:) X14(:) X15(:) X16(:) X17(:) X18(:) X19(:) X20(:)];        

end
end
