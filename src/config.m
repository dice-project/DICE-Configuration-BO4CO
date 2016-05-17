% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global nMinGridPoints istestfun visualize maxIter maxExp exp_name domain;

if ~isdeployed
    nMinGridPoints=1e5;
    istestfun=1;
    visualize=0;
    
    maxIter = 110; % number of search iterations
    maxExp = 1; % maximum number of experiment replication
    exp_name= '';
    
    domain=[];
    
    mode='running';
else
    setmcruserdata('nMinGridPoints',1e5);
    setmcruserdata('istestfun',1);
    setmcruserdata('visualize',0);
    setmcruserdata('maxIter',110);
    setmcruserdata('maxExp',1);
    setmcruserdata('domain',[]);
    setmcruserdata('mode','running');
    
end