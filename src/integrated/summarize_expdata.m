function [status]=summarize_expdata(expdata_csv_name,setting)
% this calculates the mean throughput and latency for the experiment run with a specific
% configuration. status==1 successful, 0 unsuccessful

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London


global  exp_name save_folder summary_folder polling_time
if ~isdeployed
    exp_name_=exp_name;
    save_folder_=save_folder;
    summary_folder_=summary_folder;
    polling_interval=polling_time;
else
    exp_name_ = getmcruserdata('exp_name');
    save_folder_=getmcruserdata('save_folder');
    summary_folder_=getmcruserdata('summary_folder');
    polling_interval=getmcruserdata('polling_time');
end

% this is to cut the unstable monitoring data in the first 2 minutes
firstrow=120000/polling_interval;
% throughput and latency measurements are located in col 11,12
latency_column_index=2;%12
throughput_col_index=3;%11

summary=[];

filename=[save_folder_ expdata_csv_name];
lastrow=number_of_rows(filename);
if lastrow>firstrow
    thiscsv=csvread(filename,firstrow,0);
else
    thiscsv=[];
end
% if instead of mean percentile required replace it with prctile(X,p)
if ~isempty(thiscsv)
    latency=mean(thiscsv(:,latency_column_index));
    throughput=mean(thiscsv(:,throughput_col_index));
    
    if latency==0 % means the topology is not reliable and we need to estimate end to end latency by summing process latency of the bolts
        no_column=size(thiscsv,2);
        current_index=5+4; % column 1 is index, 2 columns for topology and 2 columns forspout stats, see the csv files, 4 for each bolt and the last one is for process latency
        process_latency=0;
        while current_index<=no_column
            process_latency=process_latency+mean(thiscsv(:,current_index));
            current_index=current_index+4;
        end
        latency = process_latency; % we use process latency to estimate the end to end latency then
    end
    summary=[setting throughput latency];
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