function status=runexp(exp_name,setting)
% this runs the experiment with specific configuration setting
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

arrstr=mat2str(setting);
command=strcat('sudo ./',exp_name,'.sh ', arrstr(2:end-1));
status=system(command);

end