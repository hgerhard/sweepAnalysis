function [defaultKeys, defaultValues] = getDefaultMap(dataDir, dataType)
% [keys, values] = getDefaultMap(dataDir, dataType)
% dataDir    : Directory of data files
% [dataType] : 'RLS' or 'DFT' (Default 'RLS', if not provided)
%
% This function returns the default mapping returned by the channel mapping
% from getSweepDataFlex.m.  By returning this map (its keys and values),
% the user will know how to create their new channel map to use in
% getChanNames.m (this function should be used in conjunction with
% getChanNames.m).

    if nargin < 2
        dataType = 'RLS';
    end
    
    % Get any data file because it doesn't matter which one is used
    fileList = dir(sprintf('%s/%s*.txt', dataDir, dataType));
    filename = [dataDir, '/', fileList(1).name];
    
    % Read file and return default mapping
    % There is probably a better way to read in the file and get the map
    % more efficiently, but this is the most straight forward way.
    [~,~,~,~,defaultMap] = getSweepDataFlex(filename);
    defaultKeys = keys(defaultMap);
    defaultValues = values(defaultMap);
end