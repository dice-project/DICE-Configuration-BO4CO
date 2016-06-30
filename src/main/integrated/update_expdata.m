function [expdata_csv_name]=update_expdata(deployment_id)
% this update the csv files and dump monitoring data

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global storm polling_time exp_time topology save_folder
if ~isdeployed
    ip=storm;
    polling_interval=polling_time;
    total_time=exp_time;
    system_name=topology;
    csv_folder=save_folder;
else
    ip = getmcruserdata('storm');
    polling_interval = getmcruserdata('polling_time');
    total_time = getmcruserdata('exp_time');
    system_name=getmcruserdata('topology');
    csv_folder=getmcruserdata('save_folder');
end

%nimbus_api='/api/v1/nimbus/summary';
api='/api/v1/topology/';
url=[ip api deployment_id];
%url_nimbus=[ip nimbus_api];
options = weboptions('RequestMethod','get');

i=0;
tic;
end_time=total_time/1000;
data=[];
while true
    pause(polling_interval/1000);
    i=i+1;
    now_=toc;
    if now_>end_time
        break;
    end
    % do query to get stats
    try
        top_stats = webread(url,options);
    catch ME
        warning(ME.message);
        continue
    end
    %nimbus_stats=webread(url_nimbus,options);
    %nimbus_status=nimbus_stats.status;
    % update internal array index 2,3 for topology stats, 4,5 for spout
    % stats and rest for bolt stats
    if length(top_stats.topologyStats)==4
        headerRow={'time (s)','top_completeLatency (ms)','top_transferred (messages)'};
        data(i,1)=round(now_); % column 1 is dedicated for current timestamp
        data(i,2)=str2double(top_stats.topologyStats(4).completeLatency);
        data(i,3)=top_stats.topologyStats(4).transferred;
        for j=1:size(top_stats.spouts,1)
            data(i,3+2*j-1)=str2double(top_stats.spouts(j).completeLatency);
            data(i,3+2*j)=top_stats.spouts(j).transferred;
            headerRow(3+2*j-1:3+2*j)={'spout_completeLatency (ms)','spout_transferred (messages)'};
        end
        for k=1:size(top_stats.bolts,1)
            data(i,3+2*size(top_stats.spouts,1)+4*k-3)=str2double(top_stats.bolts(k).executeLatency);
            data(i,3+2*size(top_stats.spouts,1)+4*k-2)=top_stats.bolts(k).executed;
            data(i,3+2*size(top_stats.spouts,1)+4*k-1)=str2double(top_stats.bolts(k).capacity);
            data(i,3+2*size(top_stats.spouts,1)+4*k)=str2double(top_stats.bolts(k).processLatency);
            headerRow(3+2*size(top_stats.spouts,1)+4*k-3:3+2*size(top_stats.spouts,1)+4*k)={'bolt_executeLatency (ms)','bolt_executed (messages)','capacity','bolt_processLatency (ms)'};
        end
    end
end

expdata_csv_name=strcat(system_name,'_metrics_',num2str(datenum(datetime('now')),'%bu'),'.csv');
if ~isdir(csv_folder)
    mkdir(csv_folder);
end
%csvwrite([csv_folder expdata_csv_name],headerRow);
%csvwrite([csv_folder expdata_csv_name],data);
if ~isempty(data)
    csvwrite_with_headers([csv_folder expdata_csv_name],data,headerRow);
else expdata_csv_name='';
end
end