function [status]=undeploy(system_name)
% undeploys a topology (system) that is already deployed on the testing cluster

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% runs the deployment service to deploy the system with the current config

service_url = [deployment_service 'undeploy'];
options = weboptions('RequestMethod','post');

% call the restfull api and return the status
status = webread(service_url,'sys_name',system_name,optwions);

end