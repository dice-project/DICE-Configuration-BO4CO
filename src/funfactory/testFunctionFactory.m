function [f, domain, trueMinLoc] = testFunctionFactory(name)
% Returns an oracle (without noise and some with noise)
% This is not a unit test of another function, but rather a factory for
% "test functions".
%
% Output
%   f: @(x) oracle function handle
%   domain: (d x 2) range of optimization (min and max for each dimension)
%   trueMinLoc: (d x n) n true known global minima
%		(could be analytical or numerically optained)
%
% Reference: Cox & John
% Reference: http://www-optima.amp.i.kyoto-u.ac.jp/member/student/hedar/Hedar_files/TestGO_files/Page364.htm
% Reference: http://coco.gforge.inria.fr/doku.php?id=start

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

%% creating BBOB function handles
benchfunc = benchmarks('handles');
noisybenchfunc = benchmarksnoisy('handles');

%%
switch lower(name)
    case {'e1', 'sin-sqrt'} % 1 local minima
        f = @(x) sin(x * 2 * pi * 2.5) .* sqrt(x);
        domain = [0 1];
        trueMinLoc = 0.702878196278343;
    case {'e2', 'sin'}
        f = @(x) sin(x * 2 * pi * 2.5);
        domain = [0 1];
        trueMinLoc = [0.3, 0.7];
    case {'e3'} % 1 local minima
        f = @(x) -(x.^2 + 1) .* cos(3*pi*x);
        domain = [-1 1];
        % wolframalpha query "minimize -(x^2 + 1) * cos(3*pi*x)"
        trueMinLoc = 0.677086 * [-1 1];
    case {'e4'} % 4 local minima
        f = @(x) (-exp(-x.^2) + 1) .* cos(3*pi*x);
        domain = [-1.5 1.5];
        % wolframalpha query
        %	"minimize (-exp(-x^2) + 1) * cos(3*pi*x) from x=-1.5 to 1.5"
        trueMinLoc = 1.01269 * [-1 1];
    case {'f1', 'simulated annealing i'}
        % Cox & John f1
        f = @(x,y)(2*x.^2 + 2*y.^2 - 0.3*cos(3*pi*x) - 0.4*cos(4*pi*y) + 0.7);
        domain = [-1 1; -1 1];
        trueMinLoc = [0, 0];
    case {'f2', 'simulated annealing ii'}
        % Cox & John f2
        f = @(x,y)(2*x.^2 + 2*y.^2 - 0.3*cos(3*pi*x).*cos(4*pi*y) + 0.3);
        domain = [-1 1; -1 1];
        trueMinLoc = [0, 0];
    case {'f3', 'simulated annealing iii'}
        % Cox & John f3
        f = @(x,y)(2*x.^2 + 2*y.^2 - 0.3*cos(3*pi*x + 4*pi*y) + 0.3);
        domain = [-1 1; -1 1];
        trueMinLoc = [0, 0];
    case {'f4', 'sine function'}
        % Cox & John f4
        f = @(x,y)(sin(x).^2 + sin(y).^2 - 0.1 * exp(-x.^2 - y.^2));
        domain = [-10 10; -10 10];
        trueMinLoc = [0, 0];
    case {'f5', 'tree hump camel-back'}
        f = @(x,y)(2*x.^2 - 1.05 * x.^4 + x.^6 / 6 - x.*y + y.^2);
        domain = [-3 3;-1.5 1.5];
        trueMinLoc = [0, 0];
    case {'f6', 'hosaki'}
        fx = @(x)(1 - 8*x + 7*x.^2 - (7/3)*(x.^3) + (x.^4)/4);
        fy = @(y)((y.^2) .* exp(-y));
        f = @(x,y) fx(x) .* fy(y);
        domain = [0 5;0 6];
        trueMinLoc = [4, 2];
        localMinLoc = [1, 2]; % I should provide local minimum of other functions as well
    case {'f7', 'goldstein and price'}
        %    f = @(x,y)((1+(x+y+1).^2 ...
        %	    * (19 - 14*x + 3*x.^2 - 14*y + 6*x.*y + 3*y.^2)) ...
        %	* (30 + (2*x - 3*y).^2 ...
        %	    .* (18 - 32*x + 12*x.^2 + 48*y - 36*x.*y + 27*y.^2)));
        % Lizotte Ph.D. dissertation p. 82
        a = @(x,y) 1+((x+y+1).^2).*(19-14*x+3*x.^2-14*y+6*x.*y+3*y.^2);
        b = @(x,y) 30+((2*x-3*y).^2).*(18-32*x+12*x.^2+48*y-36*x.*y+27*y.^2);
        f = @(x,y) a(x,y).*b(x,y);
        % Schonlau Ph.D. dissertation p. 51
        domain = [-2 2;-2 2];
        trueMinLoc = [0, -1];
    case {'f8', 'branin'}
        %f = @(x,y)((y - (5/4)*(pi^2)*x.^2 + (5/pi)*x - 6).^2 + 10 * (1 - 1/(8*pi)) * cos(x) + 10);
        % Ref: Torn and Zilinskas 1989
        f = @(x,y)(y-(5.1/(4*pi^2))*x.^2+5*x/pi-6).^2+10*(1-1/(8*pi))*cos(x)+10;
        domain = [-5 10; 0 15];
        trueMinLoc = [-pi, pi, 9.4248; 12.275, 2.275, 2.475]';
    case {'f9', 'dixon-szego'}
        % Ref: http://www2.maths.ox.ac.uk/chebfun/examples/opt/html/DixonSzego.shtml
        % L.C.W. Dixon and G.P. Szegő, The global optimization problem: an introduction, in L.C.W. Dixon and G.P. Szegő (eds.), Towards Global Optimisation 2, North-Holland, Amsterdam 1978, pp. 1-15.
        f = @(x,y) (4-2.1*x.^2+ x.^4/3).*x.^2 + x.*y + 4*(y.^2-1).*y.^2;
        domain = [-2 2; -1.25 1.25];
        trueMinLoc = [0.0898, -0.0898; -0.7127, 0.7127]'; % numerical result
    case {'f10', 'rosenbrock'}
        % H. H. Rosenbrock, "An automatic method for finding the greatest or least value of a function", Computer Journal 3 (1960), 175-184.
        f = @(x,y) (1-x).^2 + 100*(y-x.^2).^2;
        domain = [-1.5 1.5; -1 3]';
        trueMinLoc = [1, 1];
    case {'f11', 'peaks'}
        % MATLAB Peaks function
        f = @(x,y) peaks(x,y);
        domain = [-3 3; -3 3];
        trueMinLoc = [0.25, -1.625];
    case {'g1', 'hartmann3'}
        % Hartmann 3D
        f=@(x,y,z) hart3([x y z]);
        domain=[0 1;0 1;0 1];
        trueMinLoc = [0.114614, 0.555649, 0.852547];
        
    case {'shekel4'}
        % shekel 4D
        f=@(x1,x2,x3,x4) shekel([x1 x2 x3 x4]);
        domain=[0 10;0 10;0 10;0 10];
        trueMinLoc = [4,4,4,4];
        
    case {'rosenbrock5'}
        % BBOB functions, see folder eval
        f = @(x) benchfunc{1,8}(x);
        domain=([-25; 25]*ones(1,5))';
        [dummy, trueMinLoc] = benchfunc{1,8}('xOpt',5);
        trueMinLoc=trueMinLoc'; % just for compatibility with the rest
    case {'rosenbrock10'}
        % BBOB functions, see folder eval
        f = @(x) benchfunc{1,8}(x);
        domain=([-5; 5]*ones(1,10))';
        [dummy, trueMinLoc] = benchfunc{1,8}('xOpt',10);
        trueMinLoc=trueMinLoc'; % just for compatibility with the rest
    case {'rosenbrock10noisy'}
        % BBOB functions, see folder eval
        f = @(x) noisybenchfunc{1,8}(x);
        domain=([-5; 5]*ones(1,10))';
        [dummy, trueMinLoc] = noisybenchfunc{1,8}('xOpt',10);
        trueMinLoc=trueMinLoc'; % just for compatibility with the rest
    case {'sphere10'}
        % BBOB functions, see folder eval
        f = @(x) benchfunc{1,1}(x);
        domain=([-5; 5]*ones(1,10))';
        [dummy, trueMinLoc] = benchfunc{1,1}('xOpt',10);
        trueMinLoc=trueMinLoc'; % just for compatibility with the rest
    case {'rastrigin10'}
        % BBOB functions, see folder eval
        f = @(x) benchfunc{1,15}(x);
        domain=([-5; 5]*ones(1,10))';
        [dummy, trueMinLoc] = benchfunc{1,15}('xOpt',10);
        trueMinLoc=trueMinLoc'; % just for compatibility with the rest
    otherwise
        error('Unknown test function name [%s]', name);
end

%%
d = size(domain, 1);
if d == 1
    f = @(x)(f(x(:,1)));
elseif d == 2
    f = @(x)(f(x(:,1), x(:,2)));
elseif d==3
    f = @(x)(f(x(:,1),x(:,2),x(:,3)));
elseif d==4
    f = @(x)(f(x(:,1),x(:,2),x(:,3),x(:,4)));
elseif d>4 && d <=40
    f=@(x)(f(x'));
else
    error('Super high dimension?');
end
