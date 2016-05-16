function [config_file]=get_config()
% updates and get the configuration YAML file 
% (only includes the parameters testers specifies and other parameters are default)

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

options=getmcruserdata('options');
save_folder=getmcruserdata('save_folder');
exp_name=getmcruserdata('exp_name');

[obsX,obsY]=retrieve_all_data(exp_name);
[mv, mloc] = min(obsY);
optimum_options=obsX(mloc, :);

optimum_configuration=[];
for i=1:length(optimum_options)
    optimum_configuration{i,1}=options{1,i};
    optimum_configuration{i,2}=optimum_options(1,i);
end

if ~isdir(save_folder)
    mkdir(save_folder);
end

config_file=strcat(save_folder,exp_name,'_config.yaml');

WriteYaml(config_file,optimum_configuration);

end