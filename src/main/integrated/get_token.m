function [token]=get_token()
% gets the token from deployment service to authenticate the runs of other 
% deployment service operations

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global deployment_service
if isdeployed
    ds_service=getmcruserdata('deployment_service');
    ip = ds_service.URL;
    ds_username=ds_service.username;
    ds_password=ds_service.password;
else
    ip=deployment_service.URL;
    ds_username=deployment_service.username;
    ds_password=deployment_service.password;
end

api='/auth/get-token';
url=[ip api];

options = weboptions('RequestMethod','post','MediaType','application/x-www-form-urlencoded');
data = ['username=',ds_username,'&password=',ds_password];
status = webwrite(url,data,options);
token=status.token;

end