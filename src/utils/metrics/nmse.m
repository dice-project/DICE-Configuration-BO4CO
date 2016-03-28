function score = nmse(actual, prediction)
%NMSE   Computes the normalized mean-squared error between actual and prediction

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

score = mse(actual, prediction)/var(prediction);
