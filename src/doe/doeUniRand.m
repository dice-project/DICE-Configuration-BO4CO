function x = doeUniRand(xRange, n, minDist, maxSampleTries)
% Random design of experiment. Selects n random points uniformly distributed between lower
% bound lb and upper bound ub. 

% n: number of samples
% minDist: min distance in dataset

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

generate = @(n,d,lb,ub) lb+bsxfun(@times,(ub - lb),rand(n, d)); 

% transform to the range

lb=xRange(:,1)';
ub=xRange(:,2)';
d = size(xRange, 1); % input space dimension

x = generate(n,d,lb,ub);

nWrong = 1;


i = 0;
while (nWrong > 0 && i < maxSampleTries)
  dists = sqrt(sq_dist(x') + eye(length(x)));

  whereTolXErrorMatrix = triu(dists < minDist, 1);
  whereTolXErrorBool = sum(whereTolXErrorMatrix,1) > 0;
  nWrong = sum(whereTolXErrorBool);

  xNew = generate(nWrong,d,lb,ub);
  x(whereTolXErrorBool,:) = xNew;
  
  i = i + 1;
end


if (i >= maxSampleTries)
  error('doeRandom:SampleTriesRanOut', ...
    ['Maximal number of tries to sample data was not enough for data '...
     'to be spread for at least options.minTolX = ' num2str(minDist)]);
end