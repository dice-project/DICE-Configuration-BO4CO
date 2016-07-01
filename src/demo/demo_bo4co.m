%% Demo for BO4CO (Bayesian optimization for Configuration Optimization)
% BO4CO is a Configuration Optimization Tool for Big Data Systems
% this script uses synthetic functions as response instead of experimental
% measurements, this is only for demonstration of the underlying machine learning method
% more details: https://arxiv.org/abs/1606.06543

% When referring to the dataset or code please cite the paper:
% P. Jamshidi, G. Casale, "An Uncertainty-Aware Approach to Optimal Configuration of Stream Processing Systems", MASCOTS 2016.

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

%% initilizations
close all;
clear variables;
clc;
warning off;

global istestfun maxExp visualize maxIter nInit;
init();

expData = []; % init matrix saving experimental data
expElapsed=[];
expEntropy=[];
Fmotion = @(x) alpha(max(min(x,1),0)); % for transparent fill and fun!

%% this is the analytical function we want to find it's minimum (a wrapper for the response function)
% domain represents the domain of the function
if istestfun
    [f, domain, trueMinLoc] = testFunctionFactory('e4'); %f11 e4
else
    [f, domain, trueMinLoc] = testConfigurationFactory('cass20-109'); %f11 e4
end

d = size(domain, 1); % dimension of the space
%% create the grid
%[xTest, xTestDiff, nTest, nTestPerDim] = makeGrid(xRange, nMinGridPoints);

%% initialize the prior
% choose the covariance function as you wish 11 is the MaternARD and 8 is
% SE-ARD, 1 is SE-iso and 2,3,4 are Matern-iso 1-3-5 respectively
% see some descriptions about the kernels here: http://www.cs.toronto.edu/~duvenaud/cookbook/index.html
% some more details in https://arxiv.org/abs/1606.06543
gps = covarianceKernelFactory(11, d);

%% initial samples from the Latin Hypercube design
maxIter=maxIter-nInit;

%% this loop is only for replicating optimization loop to get a mean and CI for each optimization criteria
for exp=1:maxExp
    fprintf('experiment number %d is running now!!!',exp);
    %% choose the initial design algorithm, e.g., lhd, uniform, etc
    
    %obsX = lhsdesign(d, nInit)';
    obsX = lhsdesign4grid(d, nInit, domain);
    %obsX = unirnddesign4grid(d, nInit, domain);
    obsY = zeros(size(obsX, 1), 1);
        
    for k = 1:size(obsX, 1)
        obsY(k) = f(obsX(k, :));
    end
    
    tElapsed=[];
    tEntropy=[];
    
    %% Bayesian optimization loop (for locating minimizer)
    for k = 1:maxIter
        % criterial to evaluate in order to find where to sample next, this
        % can be replaced with other selection criteria (such as MPI, EI)
        [nextX, dummy1, xTest, m, s, z, ef, h, et] = boLCB(domain, obsX, obsY, gps);
        
        % saving experimental data for generating plots
        tEntropy=[tEntropy;h];
        tElapsed=[tElapsed;et];
        ms(:,k)=m; % saving mean prediction for saving the evolution of gp models over time
        
        % evaluate at the suggested point
        nextY = f(nextX);
        
        % save the measurement pair and CIs
        obsX = [obsX; nextX];
        obsY = [obsY; nextY];
        
        %% visualize and update
        if visualize==1
            % 1D
            if d==1
                % visualize true function 1D
                y=f(xTest);
                h1=figure(1);
                plot(xTest,y,'LineWidth',2);
                hold on; plot(trueMinLoc,f(trueMinLoc),'+');
                % observations
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
                    hold on; h2=fill([xTest; flip(xTest,1)], fu2(:,kk), [7 7 7]/8,'FaceColor','r','FaceAlpha',10/(10*kk)); % [7 7 7]/8
                    h3=fill([xTest; flip(xTest,1)], fu2(:,kk+10), [7 7 7]/8,'FaceColor','r','FaceAlpha',10/(10*kk));
                    %set(gcf,'windowbuttonmotionfcn','Fmotion( ([1 0]*get(gca,''currentp'')*[0;1;0] - min(ylim)) / diff(ylim) )');
                    set(h2,'Linestyle','none')
                    set(h3,'Linestyle','none')
                end
                               
                hold on; plot(xTest, m); plot(obsX, obsY, '*');
                % current estimate
                hold on; plot(nextX, nextY,'o');
                saveas(gcf,strcat('gp-',num2str(k),'.fig'));
                
                %h3=figure(2); plot(z); % if you use boTS
                %disp('paused');
                pause(10);% pause for a while
                close(h1);
            end
            
            % 2D
            if d==2
                h1=figure(1);
                plot(obsX(:,1),obsX(:,2), 'r+');
                for idx=1:size(obsX,1)
                    text(obsX(idx,1)+0.2,obsX(idx,2)+0.2, num2str(idx),...
                        'FontWeight', 'bold',...
                        'FontSize',8,...
                        'HorizontalAlignment','center');
                end
                hold on; plot(trueMinLoc(:,1),trueMinLoc(:,2),'d');
                hold on; plot(nextX(:,1),nextX(:,2),'o');
                hold on; contour(unique(xTest(:,1)),unique(xTest(:,2)),reshape(f(xTest),size(unique(xTest(:,1)),1),size(unique(xTest(:,2)),1)));
                set(h1,'ShowText','on','TextStep',get(h,'LevelStep'))
                % true function 2D
                %h2=figure(2);surf(unique(xTest(:,1)),unique(xTest(:,2)),reshape(y,size(unique(xTest(:,1)),1),size(unique(xTest(:,2)),1)));
                h2=figure(2);surfc(unique(xTest(:,1)),unique(xTest(:,2)),reshape(m,size(unique(xTest(:,1)),1),size(unique(xTest(:,2)),1)));
                shading interp
                disp('paused');
                pause(5); % pause for a while
                close(h1);
                close(h2);
            end
        end       
    end
    
    %% saving the replication data    
    expData=[expData obsX obsY];
    expElapsed=[expElapsed tElapsed];
    expEntropy=[expEntropy tEntropy];    
end
%% report what has been found
[mv, mloc] = min(obsY);
fprintf('Minimum value: %f found at:\n', mv);
disp(obsX(mloc, :));
fprintf('True minimum value: %f at:\n', f(trueMinLoc));
disp(trueMinLoc)