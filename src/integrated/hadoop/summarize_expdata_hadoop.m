function [status]=summarize_expdata_hadoop(expdata_csv_name,setting)
% this calculates the mean throughput and latency for the experiment run with a specific
% configuration. status==1 successful, 0 unsuccessful

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global  exp_name save_folder summary_folder hadoop
if ~isdeployed
    exp_name_=exp_name;
    save_folder_=save_folder;
    summary_folder_=summary_folder;
    hadoop_=hadoop;
else
    exp_name_ = getmcruserdata('exp_name');
    save_folder_=getmcruserdata('save_folder');
    summary_folder_=getmcruserdata('summary_folder');
    hadoop_=getmcruserdata('hadoop');
end

ssh2_conn = scp_simple_get(hadoop_.ip,hadoop_.username,hadoop_.password,'data.csv',save_folder_);
ssh2_conn = ssh2_close(ssh2_conn); %will call ssh2.m and run command and then close connection
movefile([save_folder_ 'data.csv'],[save_folder_ expdata_csv_name]);

summary=[];
filename=[save_folder_ expdata_csv_name];
firstrow = 1;
firstcol = number_of_cols(filename)-1;
thiscsv=csvread(filename,firstrow,firstcol);

% if instead of mean percentile required replace it with prctile(X,p)
if ~isempty(thiscsv)
    job_completion_time=mean(thiscsv(:,end));
    summary=[setting job_completion_time];
end

% writing data to the performance data repository
if ~isdir(summary_folder_)
    mkdir(summary_folder_);
end

if ~isempty(summary)
    % we use dlmwrite in order to use -append feature
    dlmwrite(strcat(summary_folder_,exp_name_,'.csv'),summary,'-append');
    status=1;
else
    status=0;
end
end