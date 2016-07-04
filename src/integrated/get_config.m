function [config_file]=get_config()
% prepares the optimum configuration file in YAML
% only includes the parameters testers specifies and other parameters are assumes as default

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global options summary_folder exp_name

if ~isdeployed
    options_=options;
    summary_folder_=summary_folder;
    exp_name_=exp_name;
else
    options_=getmcruserdata('options');
    summary_folder_=getmcruserdata('summary_folder');
    exp_name_=getmcruserdata('exp_name');
end

[obsX,obsY]=retrieve_all_data(exp_name_);
[mv, mloc] = min(obsY);
optimum_options=obsX(mloc, :);

optimum_configuration=[];
for i=1:length(optimum_options)
    optimum_configuration{i,1}=options_{1,i};
    optimum_configuration{i,2}=optimum_options(1,i);
end

if ~isdir(summary_folder_)
    mkdir(summary_folder_);
end

config_file=strcat(summary_folder_,exp_name_,'_optimum.yaml');
if ~isempty(optimum_configuration)
    WriteYaml(config_file,optimum_configuration);
end
end