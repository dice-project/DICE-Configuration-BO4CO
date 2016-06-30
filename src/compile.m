% compiles BO4CO for the target deployments

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% adding required folders
if ~isdir('bin/main')
    mkdir 'bin/main'
end
if ~isdir('main')
    mkdir('main')
end
copyfile('acqfun','main')
copyfile('conf','main')
copyfile('covs','main')
copyfile('doe','main')
copyfile('eval','main')
copyfile('external','main')
copyfile('funfactory','main')
copyfile('gp','main')
copyfile('integrated','main')
copyfile('stats','main')
copyfile('utils','main')

% this is weired but I had to add the ssh2 jar file path directly to the
% javapath file, the dynamic way did not work!
java_class_path=[prefdir '/javaclasspath.txt'];
ssh2_jar_file=[pwd '/external/libs/ssh2/ssh2v2/ganymed-ssh2-build250/ganymed-ssh2-build250.jar'];
if exist(java_class_path,'file')
    fid = fopen(java_class_path, 'a+');
    fprintf(fid, '\n%s', ssh2_jar_file);
    fclose(fid);
else
    fid = fopen(java_class_path, 'w+');
    fprintf(fid, '%s', ssh2_jar_file);
    fclose(fid);
end

% compile
mcc -o main -a ./main -d ./bin/main -m ./main.m

% copy the compiled files into the deploy folder
switch computer('arch')
    case 'maci64'
        copyfile('bin/main/readme.txt','../deploy/maci64/','f')
        copyfile('bin/main/requiredMCRProducts.txt','../deploy/maci64/','f')
        copyfile('bin/main/run_main.sh','../deploy/maci64/','f')
        copyfile('bin/main/main.app','../deploy/maci64/','f')
        copyfile('bin/main/mccExcludedFiles.log','../deploy/maci64/','f')
    case 'glnxa64'
        copyfile('bin/main/readme.txt','../deploy/ubuntu64/','f')
        copyfile('bin/main/requiredMCRProducts.txt','../deploy/ubuntu64/','f')
        copyfile('bin/main/run_main.sh','../deploy/ubuntu64/','f')
        copyfile('bin/main/main','../deploy/ubuntu64/','f')
        copyfile('bin/main/mccExcludedFiles.log','../deploy/ubuntu64/','f')
end