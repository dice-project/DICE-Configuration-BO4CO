function setting=domain2option(option,index)
% this converts the domain index into a configuration setting
% e.g., setting = [10 12 1], p1=10, p2=12, p3=1
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

if length(option)~=length(index)
    error('index size is not equal to the number of parameters');
end
setting=[];
for i=1:length(option)
    optionarr=str2num(option{2,i});
    setting=[setting;optionarr(1,index(i))];
end

end