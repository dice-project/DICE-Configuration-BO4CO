function [latency,throughput]=f(x)
% this deploy the application with specific settings, waits until the data
% are retrived then send back performance data associated with the
% application under specific setting, in other words this is the response
% function

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London
exp_name=getmcruserdata('exp_name');
system_name=getmcruserdata('topology');

options_=getmcruserdata('options');
exp_time=getmcruserdata('exp_time');
sleep_time=getmcruserdata('sleep_time');

setting=domain2option(options_,x);

% deploy the application under a specific setting
[updated_config_name]=update_config(setting);
deploy(updated_config_name);

pause(exp_time/60); % convert to seconds and wait for the experiment to finish and retireve the performance data
undeploy(system_name);
pause(sleep_time/60); % convert to seconds and wait for the experiment to finish and retireve the performance data

summarize_expdata(exp_name,setting);
[latency,throughput]=retrieve_data(exp_name);

end