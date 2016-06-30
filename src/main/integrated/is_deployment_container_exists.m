function status = is_deployment_container_exists()
% checks whether container available to us on DICE Deployment service (UUID)

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global deployment_service

% this make the code mcr compatible for global vars
if ~isdeployed
    deployment_service_=deployment_service;
else
    deployment_service_=getmcruserdata('deployment_service');
end
service_url = [deployment_service_.URL '/containers/' deployment_service_.container];
options = weboptions('Timeout',30,'KeyName','Authorization','KeyValue',['Token ',get_token()]);
try
    response = webread(service_url,options);
    status=1; % yes the container is available
catch ME
    status=0; % no the container is NOT available
end

end