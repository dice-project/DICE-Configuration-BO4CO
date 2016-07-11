function [output_file]=get_optimum_performance()

global  exp_name summary_folder
if ~isdeployed
    exp_name_=exp_name;
    summary_folder_=summary_folder;
else
    exp_name_ = getmcruserdata('exp_name');
    summary_folder_=getmcruserdata('summary_folder');
end

data=csvread(strcat(summary_folder_,exp_name_,'.csv'));

if ~isempty(data)
    [latency,I]=min(data(:,end));
    throughput=data(I,end-1);
    output_file=[summary_folder_ exp_name_ '.json'];
    setting_struct=struct('latency',{num2cell(latency)},'throughput',{num2cell(throughput)});
    fileID = fopen(output_file,'w');
    fprintf(fileID,mls.internal.toJSON(setting_struct));
    fclose(fileID);
else
    output_file='';
end

end