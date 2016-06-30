addpath('PUT_PATH_TO_BBOB/matlab');  % should point to fgeneric.m etc.
datapath = 'PUT_MY_BBOB_DATA_PATH';  % different folder for each experiment
% opt.inputFormat = 'row';
opt.algName = 'PUT ALGORITHM NAME';
opt.comments = 'PUT MORE DETAILED INFORMATION, PARAMETER SETTINGS ETC';
maxfunevals = '10 * dim'; % 10*dim is a short test-experiment taking a few minutes
% INCREMENT maxfunevals successively to larger value(s)
minfunevals = 'dim + 2';  % PUT MINIMAL SENSIBLE NUMBER OF EVALUATIONS for a restart
maxrestarts = 1e4;        % SET to zero for an entirely deterministic algorithm

dimensions = [2, 3, 5, 10, 20, 40];  % small dimensions first, for CPU reasons
functions = benchmarks('FunctionIndices');  % or benchmarksnoisy(...)
instances = [1:5, 41:50];  % 15 function instances


dim = dimensions(1);
ifun = functions(8);
iinstance = instances(1);

fgeneric('initialize', ifun, iinstance, datapath, opt);
xbest=MY_OPTIMIZER('fgeneric', dim, fgeneric('ftarget'), 1000000);

[res, res2] = benchmarks('handles', 8, 2)
[res] = benchmarks('fopt', 8, 2)
[Fval, Ftrue] = res{1,8}('best')
[Fval, Ftrue] = res{1,8}('xOpt')
