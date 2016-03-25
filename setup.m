function setup
% Setup script to set paths right so the BO4CO works
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

disp('Starting BO4CO, setting path...');

myDir = fileparts(mfilename('fullpath'));
paths = genpath(myDir);
paths = strread(paths,'%s','delimiter',':');
pathsToAdd = [];

for i=1:length(paths)
    thisPath = paths{i};
    thisPathSplit = strread(thisPath,'%s','delimiter','/');
    addThisPath = 1;
    
    % Do not add any directories or files starting with a . or a ~
    for j=1:length(thisPathSplit)
        thisStr = thisPathSplit{j};
        if (~isempty(thisStr)) && ((thisStr(1) == '.') || (thisStr(1) == '~'))
            addThisPath = 0;
        end
    end
    if addThisPath ==1
        if ~isempty(pathsToAdd)
            thisPath = [':' thisPath];
        end
        pathsToAdd = [pathsToAdd thisPath];
    end
end

addpath(pathsToAdd);

% setup the GPML package, GPML is a dependency for BO4CO
run([strcat(myDir,filesep), 'libs/', 'gpml-matlab-v3.6-2015-07-07/', 'startup'])

% if you want to not run this when you exit matlab uncomment this, use
% this: which pathdef.m -all
%savepath;
