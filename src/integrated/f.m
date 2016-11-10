function [response_1,response_2]=f(x)
% this is a function factory for technology specific experiments
% based on the type of application, it will call specific functions

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global application options

% this make the code mcr compatible for global vars
if ~isdeployed
    application_=application;
    options_=options;
else
    application_=getmcruserdata('application');
    options_=getmcruserdata('options');
end

setting=domain2option(options_,x);

switch application_.type
    case 'storm'
        [latency,throughput]=f_storm(setting);
        response_1=latency;
        response_2=throughput;
    case 'hadoop'
        [job_completion_time]=f_hadoop(setting);
        response_1=job_completion_time;
        response_2=-1; % throughput is not applicable for batch applications
end