function [obsX,obsY]=retrieve_all_data(exp_name)
% this retrieves all end-to-end data from the performance repository
% (csv file)
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

dirpath='./summary/';
filename=strcat(dirpath,exp_name,'.csv');

if exist(filename, 'file')
    
    thiscsv=csvread(filename);
    
    % I assume the end column is latency and the end-1 is throughput
    obsX=thiscsv(:,1:end-2);
    obsY=thiscsv(:,end);
    throughput=thiscsv(:,end-1);
    
else
    % File does not exist.
    warningMessage = sprintf('Warning: file does not exist:\n%s', filename);
    warning(warningMessage);
end

end