function [z]=mat2func(mat,xRange,x)
% Transform the matrix representation of configuration measurements to
% smooth grid function representation and return its corresponding
% interpolated value

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% import bo4co.*
d = size(xRange, 1);

[xTest, xTestDiff, nTest, nTestPerDim] = makeDGrid(xRange);

switch d
    case 3
        [x1,x2,x3] = ndgrid(unique(xTest(:,1)),unique(xTest(:,2)),unique(xTest(:,3)));
        Vq = interpn(mat,x1,x2,x3,'cubic');
        %I=find(ismember(xTest, x,'rows'));
        I=dsearchn(xTest,x); % find the nearest point
        [I1, I2, I3] = ind2sub(size(Vq),I);
        z=Vq(I1,I2,I3);
    case 6
        [x1,x2,x3,x4,x5,x6] = ndgrid(unique(xTest(:,1)),unique(xTest(:,2)),unique(xTest(:,3)),unique(xTest(:,4)),unique(xTest(:,5)),unique(xTest(:,6)));
        Vq = interpn(mat,x1,x2,x3,x4,x5,x6,'cubic');
        %I=find(ismember(xTest, x,'rows'));
        I=dsearchn(xTest,x);        
        [I1, I2, I3, I4, I5, I6] = ind2sub(size(Vq),I);
        z=Vq(I1,I2,I3,I4,I5,I6);
    case 5
        [x1,x2,x3,x4,x5] = ndgrid(unique(xTest(:,1)),unique(xTest(:,2)),unique(xTest(:,3)),unique(xTest(:,4)),unique(xTest(:,5)));
        Vq = interpn(mat,x1,x2,x3,x4,x5,'cubic');
        %I=find(ismember(xTest, x,'rows'));
        I=dsearchn(xTest,x);        
        [I1, I2, I3, I4, I5] = ind2sub(size(Vq),I);
        z=Vq(I1,I2,I3,I4,I5);
end

end