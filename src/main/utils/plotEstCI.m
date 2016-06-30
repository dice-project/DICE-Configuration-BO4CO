function plotEstCI(x, m, s, xt, yt)
% plot the estimated function with 95% confidence interval for estimates.
%
% x  - inputs
% m  - mean predictions
% s - standard deviation of estimates (prediction errors)
% xt - optional: training inputs
% yt - optional: training outputs

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

f = [m + 2*s; flip(m - 2 * s, 1)];

fill([x; flip(x, 1)], f, [7 7 7] / 8)
hold on;
plot(x, m);

if nargin == 4
    error('the number of inputs is not correct');
end

if nargin == 5
    plot(xt, yt, '+')
end