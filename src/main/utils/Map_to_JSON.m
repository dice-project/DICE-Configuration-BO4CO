function JSONstr=Map_to_JSON(map)
% Convert to JSON:
JSONstr = '{'; % Initialization
map_keys = keys(map);
map_vals = values(map);
for ind1 = 1:map.Count
    JSONstr = [JSONstr '"' map_keys{ind1} '":"' map_vals{ind1} '",'];
end
JSONstr =[JSONstr(1:end-1) '}']; % Finalization (get rid of the last ',' and close)

end