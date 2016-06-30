function [design]=doeFullFactorial(domain)
% Full factorial design
% e.g., domain = [1 2 ; 1 6]
% X is the full factorial combination of all items in domain,
% e.g., X= [1 1 1 1 1 1 2 2 2 2 2 2; 1 2 3 4 5 6 1 2 3 4 5 6]
% design is the transformation of X into the options,
% e.g., design = [1 1 1 1 1 1 3 3 3 3 3 3; 1 2 10 100 1000 100000 1 2 10 100 1000 100000]

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global options

if ~isdeployed
    options_=options;
else
    options_=getmcruserdata('options');   
end

X=[];
if length(domain)==1
    X=combvec(domain(1,1):domain(1,2));
else if length(domain)==2
        X=combvec(domain(1,1):domain(1,2),domain(2,1):domain(2,2));        
    else if length(domain)>2
            X=combvec(domain(1,1):domain(1,2),domain(2,1):domain(2,2));
            for i=3:length(domain)
                X=combvec(X,domain(i,1):domain(i,2));
            end           
        end
    end
end

% transform to option values
design=zeros(size(X));
for i=1:length(X)
    design(:,i)=domain2option(options_,X(:,i)');
end

end