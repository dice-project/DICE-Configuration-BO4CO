function numberOfRows=number_of_rows(filename)
fid = fopen(filename);
allText = textscan(fid,'%s','delimiter','\n');
numberOfRows = length(allText{1});
fclose(fid);
end