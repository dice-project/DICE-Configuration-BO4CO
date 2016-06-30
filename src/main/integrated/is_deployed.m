function [status]=is_deployed(deployment_id)
% this checks whether a specific storm topology is successfuly deployed or
% not, e.g.: is_deployed('exclamation-topology-1-1454603337'), here
% 'exclamation-topology-1-1454603337' is a specific deployment id visible
% in Storm UIunder topology summary

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London
global storm

status=0;
if isempty(deployment_id)
    return
end

if isdeployed
    ip = getmcruserdata('storm');
else ip=storm;
end

api='/api/v1/topology/summary';
url=[ip api];
options = weboptions('RequestMethod','get','Timeout',30);
data = webread(url,options);
for i=1:size(data.topologies,1)
    if strcmp(data.topologies(i).id,deployment_id) && strcmp(data.topologies(i).status,'ACTIVE')
        status=1; % the topology is active and the deployment was successful
        return
    end
end

end