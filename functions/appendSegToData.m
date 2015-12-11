function [colHdr, newData] = appendSegToData(colHdr, data, segFile)
    % Function assumes data has 'iCh', 'iCond', 'iTrial'
    
    load(segFile);
    idxCond = find(strcmp(colHdr, 'iCond'));
    idxTrial = find(strcmp(colHdr, 'iTrial'));
    
    % Make sure indices are numbers
    assert(size(idxCond, 1) == 1 && size(idxCond, 2) == 1);
    assert(size(idxTrial, 1) == 1 && size(idxTrial, 2) == 1);
    
    % Make sure data has more than one line
    assert(size(data, 1) > 1);
    
    % Expand colHdrs and data to accomodate for 3 new variables
    colHdr{end+1} = 'segTimeSec';
    colHdr{end+1} = 'respNum';
    colHdr{end+1} = 'respTimeSec';
    newData = zeros(size(data,1), size(data,2)+3);
    
    % Get the data's condition
    currDataCond = data(1, idxCond);
    lengthData = size(data, 1);
    for i = 1:lengthData
        currTrial = data(i, idxTrial);
        % Fill in other parts of the data
        for j = 1:size(data,2)
            newData(i, j) = data(i, j);
        end
        [currSegTimeSec, currRespNum, currRespTimeSec] = getData(TimeLine, currDataCond, currTrial);
        newData(i, end-2) = currSegTimeSec; %#ok<*AGROW>
        newData(i, end-1) = currRespNum;
        newData(i, end) = currRespTimeSec;
    end
end

function [segTimeSec, respNum, respTimeSec] = getData(TimeLineStruct, cond, trial)
    total = size(TimeLineStruct, 1);
    for i = 1:total
        if (TimeLineStruct(i).cndNmb == cond) && (TimeLineStruct(i).trlNmb == trial)
            segTimeSec = TimeLineStruct(i).segTimeSec;
            respNum = str2double(TimeLineStruct(i).respString);
            respTimeSec = TimeLineStruct(i).respTimeSec;
            break;
        % If can't find condition, trial in TimeLineStruct, just return -1
        else
            segTimeSec = -1;
            respNum = -1;
            respTimeSec = -1;
        end
    end
end