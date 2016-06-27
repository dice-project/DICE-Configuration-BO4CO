function [deployment_id, status]=get_deployment_info(topology_name)
% gets deployment_id from topology name

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London
global storm

status='';
deployment_id='';
if isempty(topology_name)
    return
end

if ~isdeployed
    ip=storm;
else
    ip = getmcruserdata('storm');
end

api='/api/v1/topology/summary';
url=[ip api];
options = weboptions('RequestMethod','get');
data = webread(url,options);
for i=1:size(data.topologies,1)
    if strcmp(data.topologies(i).name,topology_name) && strcmp(data.topologies(i).status,'ACTIVE')
        deployment_id=data.topologies(i).id;
        status='deployed';
        return
    end
end

end