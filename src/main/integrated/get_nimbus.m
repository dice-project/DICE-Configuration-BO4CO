function [nimbus_ip,nimbus_port]=get_nimbus()
% get nimbus ip and port for running storm CLI.

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global storm
if isdeployed
    ip = getmcruserdata('storm');
else ip=storm;
end
nimbus_ip=[];
nimbus_port=[];

api='/api/v1/nimbus/summary';
url=[ip api];
options = weboptions('RequestMethod','get');
nimbus_stats = webread(url,options);


for i=1:size(nimbus_stats.nimbuses,1)
    if strcmp(nimbus_stats.nimbuses{i}.status,'Leader')
        nimbus_ip=nimbus_stats.nimbuses{i}.host;
        nimbus_port=nimbus_stats.nimbuses{i}.port;
        return
    end 
end


end