      
function [sig_ScreenX,sig_ScreenY] = AODxyToCamera(sig_AOD1,...
                                        sig_AOD2,EXP_date)
        %% output 
        if     EXP_date >= 100000 &&  EXP_date <= 199999
        % orientation after 20170401 but before 20180901
        % orientation with which the pipettePointTo = 'down'
            sig_ScreenX       =  sig_AOD1;
            sig_ScreenY       =  sig_AOD2;
        elseif EXP_date >= 200000 &&  EXP_date <= 299999
        % orientation before 20170401
        % orientation with which the pipettePointTo = 'right'
            sig_ScreenX       =  sig_AOD2;
            sig_ScreenY       =  sig_AOD1;
        else
            sig_ScreenX       =  sig_AOD2;
            sig_ScreenY       =  sig_AOD1;
        end
    end