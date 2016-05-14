function [nextX, gps, xTest, m, s, z, ef, h, et] = boLCB(xRange, observedX, observedY, gps)
% LCB acquisition function (selection criteria).
% this method selects a point in the configuration space (nextX) to be
% experimented with
% Input:
%   xRange: (d x 2), rectangular Euclidean region
%   observedX: (d x N) N observed x
%   observedY: (N x 1) corresponding y
%   gps: GP structure from previous step (used as initial state for the update)
%	gps.hyp: hyper parameter structure
%	gps.meanfunc: mean function
%	gps.covfunc: covariance function
%	gps.likfunc: likelihood function
%
% Output:
%   nextX: (d x 1) next X to sample from
%   gps: GP structure
%   xTest: set of points where predictive distributions are computed
%   m: mean of predictive distribution
%   s: std of predictive distribution
%   z: current estimate of minimum (usually underestimates)
%   ef: probability density of estimated posterior of Pmin
%   h: entropy of last Pmin
%   et: elapsed time (for measuring the runtime overhead of computing LCB)
%
% Example parameters: (see GPML documentation by Rasmussen et al.)
% gps.meanfunc = {@meanSum, {@meanLinear, @meanConst}}; gps.hyp.mean = [0; 0];
% gps.covfunc = {@covMaterniso, 3}; ell = 1/4; sf = 1;
% gps.hyp.cov = log([ell; sf]);
% gps.likfunc = @likGauss; sn = 0.1; gps.hyp.lik = log(sn);
%
% Algorithm: < Selection of x_{n+1} >
% 1. From GP, estimate z = min(f) via minimizer of mean posterior
%
% Requires: GPML
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global istestfun nMinGridPoints;

if ~isdeployed
    istestfun_=istestfun;
    nMinGridPoints_=nMinGridPoints;
else
    istestfun_=getmcruserdata('istestfun');
    nMinGridPoints_=getmcruserdata('nMinGridPoints');
end
%% kappa function
kappaf=@(s,r,e,t) sqrt(2*log(s*zeta(r)*t.^2/e));

%% process input
d = size(xRange, 1); % input space dimension
N = size(observedX, 1);
assert(d == size(observedX, 2));
assert(N == numel(observedY)); observedY = observedY(:);

%% Parameters of the algorithm
%nMinGridPoints = 1e2;
isSmoothGrid = true;
kappa=1; %default value
%% Make the grid for Pmin sampling
if istestfun_
    [xTest, xTestDiff, nTest, nTestPerDim] = makeGrid(xRange, nMinGridPoints_);
else
    [xTest, xTestDiff, nTest, nTestPerDim] = makeDGrid(xRange);
end

nCandidateSample = nTest; % candidate x_{n+1} to be drawn at every step

x = observedX; y = observedY;

tic;
% Bayesian model selection to find hyperparameter
gps = optimizeHyp(gps, x, y);

%% Perform GP on the test grid (calculate posterior)
[ym, ys2, m, s2] = gp(gps.hyp, @infExact, gps.meanfunc, gps.covfunc, ...
    gps.likfunc, x, y, xTest);
s = sqrt(s2);

% compute the entropy of the minimizer distribution, since entropy takes
% significant time you can disable it in order to execute it quickly
h=compute_entropy(m,s);
%h=0;
%% Estimate the current min f
[z, zi] = min(m);

%% Estimate LCB (UCB)
%ef = m+kappa*s; % for UCB

% adapt kappa
kappa=kappaf(length(xTest),2,0.001,length(observedY));

ef = m-kappa*s;
%idxs = arrayfun(@(x)find(xTest==x,1),observedX);
[sharedVals,idxsIntoA] = intersect(xTest,observedX,'rows');
[dummy, mefi] = min(ef(setdiff(1:end,idxsIntoA)));
idxNext = mefi;

xTestnotObserved=xTest(setdiff(1:end,idxsIntoA),:);
nextX = xTestnotObserved(idxNext, :);

et=toc;

end