function workload = extract_workload(log_file,spout_name)
% extracts the messages pushed into the topology via the spout named as spout_name
% this is used for replaying previous workloads
% example: data=extract_data_in_timestamps('worker-6703.log','word-reader')

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

match_string=['b.s.d.task [INFO] Emitting: ' spout_name ' default'];
regular_exp='\[(.*?)\]';

fid=fopen(log_file,'r');
workload=struct([]);
current_line=fgetl(fid);
counter=0;
while ischar(current_line)
    if ~isempty(current_line) % if the line is empty ignore it
        match = strfind(current_line, match_string);
        if match
            counter=counter+1;
            time_stamp=textscan(current_line(1:20),'%{yyyy-MM-dd}D%{hh:mm:ss}D');
            workload(counter).('date')=time_stamp{1,1};
            workload(counter).('time')=time_stamp{1,2}; 
            index = regexp(current_line,regular_exp);
            workload(counter).('message')=current_line(index(2)+1:end-1);
        end
    end
    current_line=fgetl(fid);
end
fclose(fid);

end