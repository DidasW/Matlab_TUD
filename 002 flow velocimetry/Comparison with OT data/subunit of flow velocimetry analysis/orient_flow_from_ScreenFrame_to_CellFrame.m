%% Doc
% This function orient the input flow speed (v_x, v_y) from the conversion 
% of PSD voltage (V1,V2) to the cell-based frame. output (v_ax,v_lat) 
% are flow speed in the axial and lateral direction.
% NOTE1 : v_x and v_y are always the chosen based on the screen's
%         horizontal and veritical axis

%%
function [v_ax,v_lat] = orient_flow_from_ScreenFrame_to_CellFrame(...
                        v_x,v_y,experiment)
        %% Determine experiment date (EXP_date)
    switch length(experiment)
        case 6
            EXP_date = str2double(experiment);
        case 8
            warning(['experiment date is an 8-digit string,',...
                     'read with format YYYYMMDD']);
            EXP_date = str2double(experiment(3:end));
        case {9,10,11,12,13,14,15}
            % strings like YYMMDD+uni_name
            EXP_date = str2double(experiment(1:6));
        otherwise
            warning('Experiment date not ecognized, use default 999999')
            EXP_date = 999999;
    end
    
%% output 
    if     EXP_date >= 100000 &&  EXP_date <= 199999
        % orientation after 20170401 but before 20180901
        % orientation with which the pipettePointTo = 'down'
        v_ax        =  -v_y;
        v_lat       =  -v_x;
    elseif EXP_date >= 200000 &&  EXP_date <= 299999
        % orientation before 20170401
        % orientation with which the pipettePointTo = 'right'
        v_ax        =  -v_x;
        v_lat       =  -v_y;
    else % pipettePointTo = 'down'
        v_ax        =  -v_y;
        v_lat       =  -v_x;
    end
    
end