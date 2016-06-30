function [number_of_message_pushed]=generate_load(type, time_period)
% pushes generated messages for the period of time_period to a kafka topic
% type is "text" or "random_number"
% time_period is in milliseconds

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London
init();

global kafka topic
if ~isdeployed
    ip=kafka;
    topic_=topic;
else
    ip = getmcruserdata('kafka');
    topic_ = getmcruserdata('topic');
end

api='/topics/';
url=[ip api topic_];

switch type
    case 'text'
        fid=fopen('test.txt','r');
        number_of_message_pushed=0;
        tStart=tic;
        while toc(tStart)*1000<=time_period
            tline=fgetl(fid);
            if feof(fid)
                fseek(fid,0,'bof');
            end
            data = struct('records',{{struct('value',struct('sentence',tline))}});
            header = http_createHeader('Content-Type','application/vnd.kafka.json.v1+json');
            [status,extras]=urlread2(url,'POST',mls.internal.toJSON(data),header);
            number_of_message_pushed=number_of_message_pushed+1;
        end
        fclose(fid);
        
    case 'random_number'
        tStart=tic;
        size=6;
        number_of_message_pushed=0;
        while toc(tStart)*1000<=time_period
            rand_number=randi([int64(10^(size-1)),int64(10^size)]);
            data = struct('records',{{struct('value',struct('number',rand_number))}});
            header = http_createHeader('Content-Type','application/vnd.kafka.json.v1+json');
            [status,extras]=urlread2(url,'POST',mls.internal.toJSON(data),header);
            number_of_message_pushed=number_of_message_pushed+1;
        end
        
end
end