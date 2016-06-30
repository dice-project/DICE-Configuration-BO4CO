function domain=options2domain(option)
% this converts the parameters options into domain of [1,di] for each
% parameter pi, e.g., [1 4 16 20]->[1,2,3,4]
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

domain=[];
for i=1:length(option)
    domain=[domain;1,length(str2num(option{2,i}))];
end

end