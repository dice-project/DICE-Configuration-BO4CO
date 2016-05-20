function [latency,throughput]=f(x)
% this deploy the application with specific settings, waits until the data
% are retrived then send back performance data associated with the
% application under specific setting, in other words this is the response
% function

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

exp_name=getmcruserdata('exp_name');
options_=getmcruserdata('options');
sleep_time=getmcruserdata('sleep_time');

setting=domain2option(options_,x);

% deploy the application under a specific setting
[updated_config_name]=update_config(setting);
deployment_id=deploy(updated_config_name);

if is_deployed(deployment_id)
    [expdata_csv_name]=update_expdata(deployment_id);
    undeploy(deployment_id);
    pause(sleep_time/60); % convert to seconds and wait for the experiment to finish and retireve the performance data
    summarize_expdata(expdata_csv_name,setting); % this also update a csv file
    [latency,throughput]=retrieve_data(exp_name);
else % -1 means there was some problem...
    latency=-1;
    throughput=-1;
end

end