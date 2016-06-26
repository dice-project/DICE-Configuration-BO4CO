mcc -m main.m -N -p ../
switch computer('arch')
    case 'maci64'
        movefile('readme.txt','../deploy/maci64/')
        movefile('requiredMCRProducts.txt','../deploy/maci64/')
        movefile('run_main.sh','../deploy/maci64/')
        movefile('main.app','../deploy/maci64/')
        movefile('mccExcludedFiles.log','../deploy/maci64/')
    case 'glnxa64'
        movefile('readme.txt','../deploy/ubuntu64/')
        movefile('requiredMCRProducts.txt','../deploy/ubuntu64/')
        movefile('run_main.sh','../deploy/ubuntu64/')
        movefile('main','../deploy/ubuntu64/')
        movefile('mccExcludedFiles.log','../deploy/ubuntu64/')
end