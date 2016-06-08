function [arrival_rate]=get_arrival_rate(time_period)
% estimates the arrival rate
% the estimation is based on calculation of the difference between offsets
% of the kafka topic per seconds
% time_period is in seconds
% for more information about Kafka APIs: http://docs.confluent.io/3.0.0/kafka-rest/docs/api.html

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

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

api='/consumers/arrival_estimation_consumer';
instance_name='arrival_estimator_instance';

consumer_url=[ip api];
instance_url_without_topic=[ip api '/instances/' instance_name];

%data = struct('name',instance_name,'format','json','auto.offset.reset','smallest');
% dot in the name of the fields so we use containers instead of
% mls.internal.toJSON
map=containers.Map({'name','format','auto.offset.reset'},{instance_name,'json','smallest'});
JSONstr= Map_to_JSON(map);

% create consumer
header = http_createHeader('Content-Type','application/vnd.kafka.json.v1+json');
[status,extras]=urlread2(consumer_url,'POST',JSONstr,header);

% estimate the arrival rates
relative_time=0;
while relative_time<time_period
    data = struct('records',{{struct('value',struct('test','test'))}});
    [status,extras]=urlread2(url,'POST',mls.internal.toJSON(data),header);
    response_struct=mls.internal.fromJSON(status);
    current_offset=response_struct.offsets(1).offset;
    pause(1); % pause for 1 second
    relative_time=relative_time+1;
    [status,extras]=urlread2(url,'POST',mls.internal.toJSON(data),header);
    response_struct=mls.internal.fromJSON(status);
    diff=response_struct.offsets(1).offset-current_offset;
    arrival_rate(relative_time)=diff;
    fprintf('current arrival rate (tuples/sec) is: %d \n', diff);
end

% delete consumer
[status,extras]=urlread2(instance_url_without_topic,'DELETE');

end