function numberOfCols=number_of_cols(filename)
fid = fopen(filename);
allText = textscan(fid,'%s','delimiter','\n');
v=cell2mat(allText{1,1}(1));
numberOfCols=length(find(v==','))+1;
fclose(fid);
end