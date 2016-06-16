function [deployment_id,status]=deploy(config_name)
% deploys a topology (system) with a blueprint provided on the testing cluster
% I got the inspiration for this from http://www.mathworks.com/matlabcentral/fileexchange/27189-urlreadpost-url-post-method-with-binary-file-uploading/content/urlreadpost.m

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global config_folder deployment_service

% this make the code mcr compatible for global vars
if ~isdeployed
    dirpath=config_folder;
    deployment_service_=deployment_service;
    
else
    dirpath=getmcruserdata('config_folder');
    deployment_service_=getmcruserdata('deployment_service');
end
% retrieve the yaml file
%yaml_file=strcat(dirpath,config_name);
%configs = ReadYaml(yaml_file);

fileID = fopen(yaml_file,'r');
content = fscanf(fileID,'%c');

% runs the deployment service to deploy the system with the current config
eol = [char(13),char(10)];
boundary='------------------------7pooyan7';
service_url = [deployment_service_.URL '/containers/' deployment_service_.container '/blueprint'];
options = weboptions('KeyName','Authorization','KeyValue',['Token ',get_token()],'MediaType',['multipart/form-data; boundary=' boundary]);
data=['--' boundary eol];
data=[data 'Content-Disposition: form-data; name="file"; filename="' config_name '"',eol];
data=[data 'Content-Type: application/octet-stream',eol];
data=[data eol content eol];
data=[data '--' boundary '--' eol];

% call the restfull api and return the status
status = webwrite(service_url,data,options);
end