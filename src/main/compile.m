if ~isdir('bin/main')
    mkdir 'bin/main'
end
if ~isdir('main')
mkdir('main')
end
copyfile('.','main')
mcc -o main -a ./main -d ./bin/main -m ./main.m

% switch computer('arch')
%     case 'maci64'
%         movefile('readme.txt','../deploy/maci64/','f')
%         movefile('requiredMCRProducts.txt','../deploy/maci64/','f')
%         movefile('run_main.sh','../deploy/maci64/','f')
%         movefile('main.app','../deploy/maci64/','f')
%         movefile('mccExcludedFiles.log','../deploy/maci64/','f')
%     case 'glnxa64'
%         movefile('readme.txt','../deploy/ubuntu64/','f')
%         movefile('requiredMCRProducts.txt','../deploy/ubuntu64/','f')
%         movefile('run_main.sh','../deploy/ubuntu64/','f')
%         movefile('main','../deploy/ubuntu64/','f')
%         movefile('mccExcludedFiles.log','../deploy/ubuntu64/','f')
% end