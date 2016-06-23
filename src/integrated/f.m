function [latency,throughput]=f(x)
% this deploy the application with specific settings, waits until the data
% are retrived then send back performance data associated with the
% application under specific setting, in other words this is the response
% function

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global exp_name options sleep_time storm
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

% check whether a deployment exists
[nimbus_ip,deployment_id,blueprint_id,status]=get_container_details();

if ~isempty(nimbus_ip)
    if ~isdeployed % update storm ip address
        storm=nimbus_ip;
    else
        setmcruserdata('storm',nimbus_ip);
    end
    [updated_config_name]=update_config(setting);
    try
        % deploy the application under a specific setting
        [deployment_id,status]=deploy_storm_topology(updated_config_name);
    catch ME
        warning(ME.mesage);
    end
else
    % deploy the application under a specific setting
    updated_blueprint_name=update_blueprint(setting);
    status='preparing'; deployment_id='';
    try
        [deployment_id,blueprint_id,status]=deploy(updated_blueprint_name);
    catch ME
        switch ME.identifier
            case 'MATLAB:webservices:CopyContentToDataStreamError'
                warning(ME.message);
        end
    end
    
end

% uncomment this when deployment service supports deploying monitoring agents
%start_monitoring_topology(deployment_id);

if is_deployed(deployment_id) && strcmp(status,'deployed') % verifying deployment though storm API and deployment service status
    fprintf('the system id %s is deployed', deployment_id);
    [expdata_csv_name]=update_expdata(deployment_id);
    %undeploy(blueprint_id);
    undeploy_storm_topology(deployment_id);
    pause(sleep_time_/60); % convert to seconds and wait for the experiment to finish and retireve the performance data
    summarize_expdata(expdata_csv_name,setting); % this also update a csv file
    [latency,throughput]=retrieve_data(exp_name_);
else % -1 means there was some problem...
    latency=-1;
    throughput=-1;
end

end