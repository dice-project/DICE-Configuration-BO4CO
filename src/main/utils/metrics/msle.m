function score = msle(actual, prediction)
%MSLE   Computes the mean squared log error between actual and prediction

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London
score = mean(sle(actual, prediction));
