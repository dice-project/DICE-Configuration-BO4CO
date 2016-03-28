function plotGP(x, m, s, obsX, obsY)
% plot the estimated function with 95% confidence interval for estimates.
%
% x  - inputs
% m  - mean predictions
% s - standard deviation of estimates (prediction errors)
% xt - optional: training inputs
% yt - optional: training outputs

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

fu = [m+2*s; flip(m-2*s,1)];

for kk=2:10
    fu1(:,kk)=[m+2*s/(10-kk+1); flip(m+2*s/(10-kk+2),1)];
    fu1(:,kk+10)=[m-2*s/(10-kk+2); flip(m-2*s/(10-kk+1),1)];
end
fu1(:,1)=[m+2*s/10; flip(m,1)];
fu1(:,11)=[m; flip(m-2*s/10,1)];

for kk=1:10
    fu2(:,kk)=[m+2*kk*s/10; flip(m+2*(kk-1)*s/10,1)];
    fu2(:,kk+10)=[m-2*(kk-1)*s/10; flip(m-2*kk*s/10,1)];
end

for kk=1:10
    hold on; h2=fill([x; flip(x,1)], fu2(:,kk), [7 7 7]/8,'FaceColor','r','FaceAlpha',10/(10*kk)); 
    h3=fill([x; flip(x,1)], fu2(:,kk+10), [7 7 7]/8,'FaceColor','r','FaceAlpha',10/(10*kk));
    set(h2,'Linestyle','none')
    set(h3,'Linestyle','none')
end

hold on; plot(x,m); plot(obsX,obsY,'*');