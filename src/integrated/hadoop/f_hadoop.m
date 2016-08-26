function [job_completion_time]=f_hadoop(setting)
% this deploy the hadoop applications with specific settings, waits until 
% the job is finished and data are retrived then send back performance data 
% associated with the application under specific setting, in other words 
% this is the response function

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global application exp_name
if ~isdeployed
    exp_name_=exp_name;
    application_=application;
else
    exp_name_=getmcruserdata('exp_name');
    application_=getmcruserdata('application');
end

try
    % deploy the job under a specific setting
    deploy_hadoop_mapreduce_job(setting);
catch ME
    warning(ME.message);
end
expdata_csv_name=strcat(application_.name,'_metrics_',num2str(datenum(datetime('now')),'%bu'),'.csv');

if ~isempty(expdata_csv_name)
    is_summarized=summarize_expdata_hadoop(expdata_csv_name,setting); % this also update a csv file
else
    is_summarized=0;
end
if is_summarized
    [job_completion_time]=retrieve_data_hadoop(exp_name_);
    fprintf('the average job completion time of %s is: %d \n', application_.name,job_completion_time);
else
    job_completion_time=-1;
end

end