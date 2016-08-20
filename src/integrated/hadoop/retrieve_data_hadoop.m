function [job_completion_time]=retrieve_data_hadoop(exp_name)
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
filename=strcat(dirpath,exp_name,'.csv');

if exist(filename, 'file')
    lastrow=number_of_rows(filename);    
    thiscsv=csvread(filename,lastrow-1,0);
    % I assume the end column is job_completion_time
    job_completion_time=thiscsv(end);
else
    % File does not exist.
    warningMessage = sprintf('Warning: file does not exist:\n%s', filename);
    warning(warningMessage);
end

end