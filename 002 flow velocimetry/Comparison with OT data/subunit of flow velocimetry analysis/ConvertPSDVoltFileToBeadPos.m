function [nmx,nmy] = ConvertPSDVoltFileToBeadPos(data_path,coef_path,subs_path,...
                                                 experiment,subtract_subs)
    if isempty(experiment)
        EXP_date = 999999;
    else
        EXP_date = str2double(experiment(1:6));
    end

    %% CONVERSION
    calib_file_size = length(dlmread(coef_path));
    switch calib_file_size
        case 21     % 5th Order polynomial conversion, 21 coefficients
            conversion_method  = 0;
        case 3      % Linear Conversion, 3 coefficients
            conversion_method  = 2;
    end

    %% SIGNAL
    rawdata_V  = dlmread(data_path);
    V1         = rawdata_V(:,1); % 1st column of the PSD output, usually PSDx
    V2         = rawdata_V(:,2); % 2nd column of the PSD output, usually PSDy

    substrate_V= dlmread(subs_path);
    subx_V  = substrate_V(:,1);
    suby_V  = substrate_V(:,2);
    
    switch conversion_method
        case 0
            rawdata_nm = ConvertVtoNM(V1,V2,coef_path);
            subs_nm    = ConvertVtoNM(subx_V,suby_V,coef_path); 
        case 2
            rawdata_nm = ConvertVtoNM_linear(V1,V2,coef_path);
            subs_nm    = ConvertVtoNM_linear(subx_V,suby_V,coef_path); 
    end

    [nmx,nmy] = AODxyToCamera(rawdata_nm(:,1),rawdata_nm(:,2),EXP_date);
    [subx_nm,suby_nm] = AODxyToCamera(subs_nm(:,1),subs_nm(:,2),EXP_date);
    subx = mean(subx_nm);
    suby = mean(suby_nm);
    %% SUBSTRATE

    if subtract_subs == 1
        nmx = nmx - subx;
        nmy = nmy - suby;       
    end

%     function [sig_ScreenX,sig_ScreenY] = AODxyToCamera(sig_AOD1,sig_AOD2,EXP_date)
%         %% output 
%         if EXP_date < 170400
%         % orientation before 20170400
%             sig_ScreenX       =  sig_AOD2;
%             sig_ScreenY       =  sig_AOD1;
%         elseif EXP_date < 180900
%         % orientation after 20170400 but before 2018-September-01
%             sig_ScreenX       =  sig_AOD1;
%             sig_ScreenY       =  sig_AOD2;
%         else
%             sig_ScreenX       =  sig_AOD2;
%             sig_ScreenY       =  sig_AOD1;
%         end
%     end
end