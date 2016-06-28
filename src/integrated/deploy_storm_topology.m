function [deployment_id,status]=deploy_storm_topology(setting)
% Submit a topology with a specific configuration file.

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global storm_ui config_folder application options

% this make the code mcr compatible for global vars
if ~isdeployed
    storm_ui_=storm_ui;
    dirpath=config_folder;
    application_=application;
    options_=options;
else
    storm_ui_=getmcruserdata('storm_ui');
    dirpath=getmcruserdata('config_folder');
    application_=getmcruserdata('application');
    options_=getmcruserdata('options');
end
extrastr = ' ';
%config_file=strcat(dirpath, topology_config_name);

% check whether an existing topology exists and udenploys it in case
[deployment_id, status]=get_deployment_info(application_.name);
if strcmp(status,'deployed')
    undeploy_storm_topology(deployment_id);
end

% prepare the connection
ssh2_conn = ssh2_config(storm_ui_.ip,storm_ui_.username,storm_ui_.password);
%ssh2_conn.remote_file_mode = 0777; % change to a more readable permission
%ssh2_conn = ssh2_command(ssh2_conn,['sudo chmod 777 ' storm_ui_.storm_client 'conf']);

% copy the updated config file to the storm UI VM
%ssh2_conn = scp_simple_put(storm_ui_.ip,storm_ui_.username,storm_ui_.password,topology_config_name,[storm_ui_.storm_client 'conf'],dirpath);
% check whether the current version of the application is in the remote
% server, note new versions should be reflected via input configuration
% file via application_.jar_file
[filethere] = check_remote_file(ssh2_conn, application_.jar_file);
if ~filethere
    ssh2_conn = ssh2_command(ssh2_conn,['wget ' application_.jar_path]);
end

% prepare the command to be executed, we assume storm cli is installed and
% added to the path
config_str='';
for i=1:length(options_)
    config_str=[config_str extrastr '-c' extrastr options_{1,i} '=' num2str(setting(i))];
end

% make the topology reliable
config_str=[config_str extrastr '-c topology.acker.executors=1'];

cli='storm';
cmd=[cli extrastr 'jar' extrastr application_.jar_file extrastr application_.class extrastr application_.name config_str];
[ssh2_conn, response] = ssh2_command(ssh2_conn,cmd);

ssh2_conn = ssh2_close(ssh2_conn); %will call ssh2.m and run command and then close connection

[deployment_id, status]=get_deployment_info(application_.name);

end

function [filethere] = check_remote_file(ssh2_conn, fn)
[ssh2_conn, response] = ssh2_command(ssh2_conn,['[ -f ' fn ' ] && echo 1 || echo 0']);
if response{1} == '1'
    filethere = 1;
else
    filethere = 0;
end
end
