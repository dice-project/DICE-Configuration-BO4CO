function [polling_interval,status]=get_polling_interval()
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global mon_service
if isdeployed
    ip = getmcruserdata('mon_service');
else ip=mon_service;
end
api='/dmon/v1/overlord/aux/interval';
url=[ip api];
options = weboptions('RequestMethod','get');
data = webread(url,options);
if ~isempty(data)
    polling_interval=data;
    status=200; % OK
else
    polling_interval=[];
    status=400; % Not OK
end
end