function [status]=set_polling_interval()
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global mon_service polling_time
if isdeployed
    ip = getmcruserdata('mon_service');
    polling_interval=getmcruserdata('polling_time')/1000; % convert to second
else
    ip=mon_service;
    polling_interval=polling_time/1000;
end
api='/dmon/v1/overlord/aux/interval';
url=[ip api];
options = weboptions('RequestMethod','post','MediaType','application/json');

data = struct('Spark',num2str(polling_interval),'Storm',num2str(polling_interval),'System',num2str(polling_interval),'YARN',num2str(polling_interval));

%status = webwrite(url,data,options); % I realized webwrite and webread
%does not support PUT and DELETE so I used undocumented urlread2
header = http_createHeader('Content-Type','application/json');
[status,extras]=urlread2(url,'PUT',mls.internal.toJSON(data),header);
status=extras.status.value;

end