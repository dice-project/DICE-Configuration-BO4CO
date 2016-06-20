function [latency,throughput]=f(x)
% this deploy the application with specific settings, waits until the data
% are retrived then send back performance data associated with the
% application under specific setting, in other words this is the response
% function

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global exp_name options sleep_time
if ~isdeployed
    exp_name_=exp_name;
    options_=options;
    sleep_time_=sleep_time;
else
exp_name_=getmcruserdata('exp_name');
options_=getmcruserdata('options');
sleep_time_=getmcruserdata('sleep_time');
end

setting=domain2option(options_,x);

% deploy the application under a specific setting
%[updated_config_name]=update_config(setting);
updated_blueprint_name=update_blueprint(setting);
[deployment_id,blueprint_id,status]=deploy(updated_blueprint_name);

% uncomment this when deployment service supports deploying monitoring agents
%start_monitoring_topology(deployment_id); 

if is_deployed(deployment_id) && strcmp(status,'deployed') % verifying deployment though storm API and deployment service status
    [expdata_csv_name]=update_expdata(deployment_id);
    undeploy(blueprint_id);
    pause(sleep_time_/60); % convert to seconds and wait for the experiment to finish and retireve the performance data
    summarize_expdata(expdata_csv_name,setting); % this also update a csv file
    [latency,throughput]=retrieve_data(exp_name_);
else % -1 means there was some problem...
    latency=-1;
    throughput=-1;
end

end