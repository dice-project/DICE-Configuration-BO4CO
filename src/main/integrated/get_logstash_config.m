function [mon_ls_config]=get_logstash_config()
% gets logstash config file

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global mon_service
if isdeployed
    ip = getmcruserdata('mon_service');
else ip=mon_service;
end

api='/dmon/v1/overlord/core/ls';
url=[ip api];
options = weboptions('RequestMethod','get');
mon_ls_config = webread(url,options);


end