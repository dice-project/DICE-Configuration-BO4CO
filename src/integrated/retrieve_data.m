function [latency,throughput]=retrieve_data(exp_name)
% this retrieves the latest end-to-end data from the performance repository
% (csv file)
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global summary_folder
if ~isdeployed
    dirpath=summary_folder;
else
    dirpath=getmcruserdata('summary_folder');
end
%dirpath='./summary/';
filename=strcat(dirpath,exp_name,'.csv');

if exist(filename, 'file')
    lastrow=number_of_rows(filename);    
    thiscsv=csvread(filename,lastrow-1,0);
    
    % I assume the end column is latency and the end-1 is throughput, see summarize_expdata(expdata_csv_name,setting)
    throughput=thiscsv(end-1);
    latency=thiscsv(end);
else
    % File does not exist.
    warningMessage = sprintf('Warning: file does not exist:\n%s', filename);
    warning(warningMessage);
end

end