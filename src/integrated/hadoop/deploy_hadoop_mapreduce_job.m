function deploy_hadoop_mapreduce_job(setting)
% Submit a mapreduce job with a specific configuration setting.

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global hadoop application options replication

% this make the code mcr compatible for global vars
if ~isdeployed
    hadoop_=hadoop;
    application_=application;
    options_=options;
    replication_=replication;
else
    hadoop_=getmcruserdata('hadoop');
    application_=getmcruserdata('application');
    options_=getmcruserdata('options');
    replication_=getmcruserdata('replication');
end
extrastr = ' ';

% clean hdfs for the job
% if strcmp(status,'deployed')
%     undeploy_storm_topology(deployment_id);
% end

% prepare the connection
ssh2_conn = ssh2_config(hadoop_.ip,hadoop_.username,hadoop_.password);
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
    config_str=[config_str options_{1,i} '=' num2str(setting(i)) ';'];
end
config_str=config_str(1:end-1); % taking out the last ;

cli=['java -jar' extrastr application_.cli_file];
cmd=[cli extrastr '-jar' extrastr application_.jar_file extrastr '-params' extrastr '"' config_str '"' extrastr '-class' extrastr application_.class extrastr '-args' extrastr application_.args extrastr '-applicationReplication' extrastr int2str(replication_)];
[ssh2_conn, response] = ssh2_command(ssh2_conn,cmd);

ssh2_conn = ssh2_close(ssh2_conn); %will call ssh2.m and run command and then close connection

end

function [filethere] = check_remote_file(ssh2_conn, fn)
[ssh2_conn, response] = ssh2_command(ssh2_conn,['[ -f ' fn ' ] && echo 1 || echo 0']);
if response{1} == '1'
    filethere = 1;
else
    filethere = 0;
end
end
