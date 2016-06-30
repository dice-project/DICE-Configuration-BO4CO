% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global nMinGridPoints istestfun visualize maxExp exp_name domain mode maxIter nInit;

if ~isdeployed
    nMinGridPoints=1e4;
    istestfun=1;
    visualize=0;
    maxExp = 1; % maximum number of experiment replications
    maxIter = 100; % total number of iterations (experimental budget), set maxIter as you wish
    nInit=20;% set nInit as you wish, this is the number of initial samples
    
    exp_name= '';
    domain=[];
    mode='running';
else
    setmcruserdata('nMinGridPoints',1e4);
    setmcruserdata('istestfun',0);
    setmcruserdata('visualize',0);
    setmcruserdata('maxExp',1);
    setmcruserdata('domain',[]);
    setmcruserdata('mode','running');
end