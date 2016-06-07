function total_number_of_message_pushed=execute_workload(type,time_period,number_of_parallel_execution)
% this generates load by parallelizing execution of generate_load() 
% type,time_period are the inputs for generate_load()
% number_of_parallel_execution is the parallelism level
% the main reason for this parallelism is that each execution of
% generate_load() is able to generate limited amount of messages and for
% executing a workload plan we need to be able to generate enough messages
% per seconds for a time_period

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

p=gcp(); % get the current parallel pool
for i=1:number_of_parallel_execution
    f(i)=parfeval(p,@generate_load,1,type, time_period);
end
value=fetchOutputs(f);
total_number_of_message_pushed=sum(value);


end