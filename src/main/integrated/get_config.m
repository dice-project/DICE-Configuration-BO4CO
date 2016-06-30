function [config_file]=get_config()
% updates and get the configuration YAML file
% (only includes the parameters testers specifies and other parameters are default)

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global options save_folder exp_name

if ~deployed
    options_=options;
    save_folder_=save_folder;
    exp_name_=exp_name;
else
    options_=getmcruserdata('options');
    save_folder_=getmcruserdata('save_folder');
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

if ~isdir(save_folder_)
    mkdir(save_folder_);
end

config_file=strcat(save_folder_,exp_name_,'_config.yaml');

WriteYaml(config_file,optimum_configuration);

end