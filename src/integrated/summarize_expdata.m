function summarize_expdata(exp_name,setting)
% this calculates the mean throughput and latency for the experiment run with a specific
% configuration.
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% this is to cut the unstable monitoring data in the first 2-3 minutes
firstrow=120;
dirpath='./reports/';
% throughput and latency measurements are located in col 11,12
throughput_col_index=11;%11
latency_column_index=12;%12

% retreive the latest csv file in the folder
list=dir(fullfile(dirpath,'*.csv'));
list=list(~[list.isdir]);
name={list.name};
[dummy, index] = sort(name);
name = name(index); % sorted numerically now
summary=[];

filename=strcat(dirpath, name{1});
lastrow=number_of_rows(filename);
thiscsv=csvread(filename,firstrow,throughput_col_index,[firstrow,throughput_col_index,lastrow-1,latency_column_index]);

% if instead of mean percentile required replace it with prctile(X,p)
if ~isempty(thiscsv)
    throughput=mean(nonzeros(thiscsv(:,1)));
    latency=mean(nonzeros(thiscsv(:,2)));
    summary=[summary; setting throughput latency];
end

% writing data to the performance data repository
if ~isdir('summary')
    mkdir('summary');
end
% we use dlmwrite in order to use -append feature
dlmwrite(strcat('summary/',exp_name,'.csv'),summary,'-append');
end