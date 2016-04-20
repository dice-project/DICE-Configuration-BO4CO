function summarize_expdata(exp_name,setting)
% this calculates the mean throughput and latency for the experiment run with a specific
% configuration.
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

firstrow=120;
dirpath='./reports/';
throughput_col_index=11;%11
latency_column_index=12;%12
list=dir(fullfile(dirpath,'*.csv'));
list=list(~[list.isdir]);
name={list.name};
[dummy, index] = sort(name);
name = name(index); % Sorted numerically now
summary=[];

filename=strcat(dirpath, name{1});
lastrow=number_of_rows(filename);
thiscsv=csvread(filename,firstrow,throughput_col_index,[firstrow,throughput_col_index,lastrow-1,latency_column_index]);

if ~isempty(thiscsv)
    throughput=mean(nonzeros(thiscsv(:,1)));
    latency=mean(nonzeros(thiscsv(:,2)));
    summary=[summary; setting throughput latency];
end

csvwrite(strcat(dirpath,'summary/',exp_name,'.csv'),summary);
end