function [xTest, xTestDiff, nTest, nTestPerDim] = makeGrid(xRange, nMinGridPoints, nMinPerDim)
% Construct a d-dimensional grid with equal number of test points per dimension.
% This is commonly used to generate the grid for test points.
%
% Input
%   xRange: (d x 2) rectangular region. Each row is an interval [min, max]
%   nMinGridPoints: (opt) minimum number of grid points (default: 200)
%   nMinPerDim: (opt) minimum number of grid points per dimension (default: 10)
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

if nargin < 2
    nMinGridPoints = 100;
end

if nargin < 3
    nMinPerDim = 2;
end

nTestPerDim = max(ceil(nMinGridPoints^(1/d)), nMinPerDim);
nTest = nTestPerDim^d;
xTestDiff = zeros(d, 1);
if d == 1 % Grid to evaluate things (1D)
    xTest = linspace(xRange(:,1), xRange(:,2), nTest)';
    xTestDiff = xTest(2) - xTest(1); % grid interval
else
    xtr = cell(d, 1);
    for kD = 1:d
        xtr{kD} = linspace(xRange(kD, 1), xRange(kD, 2), nTestPerDim)';
    end
    xTest = zeros(nTest, d);
    for kD = 1:d
        xr = xtr{kD};
        xTestDiff(kD) = xr(2) - xr(1);
        xr = xr(:, ones(1, nTest/nTestPerDim));
        xr = reshape(xr, nTestPerDim * ones(1, d));
        xr = permute(xr, [2:kD 1 kD+1:d]);
        xTest(:, kD) = xr(:);
    end
end
