function [array,group]  = groupTagging(arraysInACell,tagsInACell)
    As  =  arraysInACell;
    Tags=  tagsInACell;
    if numel(As) ~= numel(Tags)
        error('Inputs are cells with different sizes')
    else 
        group  = {};
        array  = [];
        for i_group = 1:numel(As)
            eachArray = As{i_group};
            eachArray = reshape(eachArray,[numel(eachArray),1]);
            groupTag  = Tags{i_group};
            for i = 1:numel(eachArray)
                group{numel(group)+1} = groupTag;
            end
            array = [array;eachArray];
        end
    end
end