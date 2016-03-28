function score = mse(actual, prediction)
%MSE   Computes the mean-squared error between actual and prediction

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

score = mean(se(actual,prediction));
