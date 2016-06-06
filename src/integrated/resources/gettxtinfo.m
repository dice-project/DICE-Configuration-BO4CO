fid=fopen('(1) The Hunger Games.txt','r');
arr=[];
tline=fgetl(fid);
while ischar(tline)
if ~isempty(tline) % if the line is empty ignore it
    scannedline=textscan(tline,'%s');
    numofwords=size(scannedline{1,1},1);
    arr=[arr,numofwords];
end    
tline=fgetl(fid);
end
fclose(fid);