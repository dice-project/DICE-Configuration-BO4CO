function [status]=summarize_expdata(expdata_csv_name,setting)
% this calculates the mean throughput and latency for the experiment run with a specific
% configuration. status==0 successful, 1 unsuccessful
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London


global  exp_name save_folder summary_folder
if ~isdeployed
    exp_name_=exp_name;
    save_folder_=save_folder;
    summary_folder_=summary_folder;
    
else
    exp_name_ = getmcruserdata('exp_name');
    save_folder_=getmcruserdata('save_folder');
    summary_folder_=getmcruserdata('summary_folder');
end

% this is to cut the unstable monitoring data in the first 2-3 minutes
firstrow=120;
% throughput and latency measurements are located in col 11,12
throughput_col_index=2;%11
latency_column_index=1;%12

summary=[];

filename=[save_folder_ expdata_csv_name];
lastrow=number_of_rows(filename);
thiscsv=csvread(filename,firstrow,latency_column_index,[firstrow,latency_column_index,lastrow-1,throughput_col_index]);

% if instead of mean percentile required replace it with prctile(X,p)
if ~isempty(thiscsv)
    latency=mean(nonzeros(thiscsv(:,1)));
    throughput=mean(nonzeros(thiscsv(:,2)));
    summary=[summary; setting throughput latency];
end

% writing data to the performance data repository
if ~isdir(summary_folder_)
    mkdir(summary_folder_);
end

if ~isempty(summary)
    % we use dlmwrite in order to use -append feature
    dlmwrite(strcat(summary_folder_,exp_name_,'.csv'),summary,'-append');
    status=0;
else
    status=1;
end
end