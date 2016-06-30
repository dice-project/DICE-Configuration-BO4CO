function [gps, desc] = covarianceKernelFactory(setting, d)
% Set of commonly used covariance kernels and their hyperparameter grids
%
% Input
%   setting: numerical selection of options
%   d: input dimension

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% import bo4co.*

maxOption = 7;
if nargin < 1
    gps = maxOption;
    return
end

% here we set the mean function, you can chose whether to use a constant or
% a composite affine function

gps.meanfunc = @meanConst; 
%gps.meanfunc = {@meanSum, {@meanLinear, @meanConst}}; %hyp.mean = [0.5; 1];
%gps.meanfunc = {@meanPoly,2};

gps.hyp.mean = 0;
gps.hypgridRange.mean = -1:1:1;

switch setting
    case 1
        innerCovFunc = {@covSEiso};
        desc = 'Gaussian (iso)';
    case 2
        innerCovFunc = {@covMaterniso, 1};
        desc = 'Matern (iso) 1';
    case 3
        innerCovFunc = {@covMaterniso, 3};
        desc = 'Matern (iso) 3';
    case 4
        innerCovFunc = {@covMaterniso, 5};
        desc = 'Matern (iso) 5';
    case 5
        innerCovFunc = {@covPPiso, 0};
        desc = 'Piecewise polynomial compact 0 diff';
    case 6
        innerCovFunc = {@covPPiso, 1};
        desc = 'Piecewise polynomial compact 2 diff';
    case 7
        innerCovFunc = {@covPPiso, 2};
        desc = 'Piecewise polynomial compact 4 diff';
    case 8
        innerCovFunc = {@covSEard};
        desc = 'Squared Exponential covariance function with Automatic Relevance Detemination';
    case 9
        innerCovFunc = {@covRQiso};
        desc = 'isotropic rational quadratic covariance function';
    case 10
        innerCovFunc = {@covRQard};
        desc = 'rational quadratic covariance function with ARD';
    case 11
        innerCovFunc = {@covMaternard,5};
        desc = 'Matern class d=5';
    case 12
        innerCovFunc = {@covCategorical};
        desc = 'Categorical kernel';
end
% innerCovFunc = {@covRQiso}; % 3 params
% innerCovFunc = {@covSEard}; % requires d+1 hyperparams

covfunc = {@covCaching, innerCovFunc};
covCaching('clear');
covCaching('noverbose');

gps.covfunc = covfunc;
ell = 1; sf = 1; % ell=1;sf=1
if (strcmpi(char(innerCovFunc{1,1}), 'covSEard')||strcmpi(char(innerCovFunc{1,1}), 'covMaternard'))
    gps.hyp.cov = log([ell*ones(d,1); sf]);
elseif (strcmpi(char(innerCovFunc{1,1}), 'covRQard'))
    al=1; gps.hyp.cov = log([ell*ones(d,1); sf; al]);
elseif (strcmpi(char(innerCovFunc{1,1}), 'covRQiso'))
    al=1; gps.hyp.cov = log([ell;sf;al]);
else
    gps.hyp.cov = log([ell;sf]);
end
gps.hypgridRange.cov = [(-2:1:0); (-1:1:1)];

gps.likfunc = @likGauss;
sn = 0.1; % noise
gps.hyp.lik = log(sn);
gps.hypgridRange.lik = -3:0;

%% Make the hyper-parameter grid (fixed case for 1 mean, 1 lik, 2 cov)
k = 1;
hyp = gps.hyp;
for k1 = 1:size(gps.hypgridRange.mean, 2)
    hyp.mean = gps.hypgridRange.mean(k1); %[ones(d,1)*gps.hypgridRange.mean(k1);ones(d,1)*gps.hypgridRange.mean(k1)];%gps.hypgridRange.mean(k1);
    for k4 = 1:size(gps.hypgridRange.lik, 2)
        hyp.lik = gps.hypgridRange.lik(k4);
        p = perms(1:size(gps.hypgridRange.cov, 2));
        for k2 = 1:size(p,1)
            for k3 = 1:size(gps.hypgridRange.cov, 1)
                hyp.cov(k3) = gps.hypgridRange.cov(k3, p(k2, 1));
            end
            gps.hypgrid(k) = hyp;
            k = k + 1;
        end
    end
end
