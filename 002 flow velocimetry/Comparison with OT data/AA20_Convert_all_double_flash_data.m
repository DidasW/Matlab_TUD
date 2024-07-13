
experiment = '171029c16l1';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
camera_orientation = 'after 201704';
conversion_method  = 2;                  % 0: use 5th order polinomial
                                         % 1: correct 5th order polynomial
                                         %    with linear conversion
                                         % 2: use linear plane conversion
rawdata_fdpth = 'D:\000 RAW DATA FILES\171029 c13-c16\c16l1\000 raw files\';                                         
NoPt = length(pt_list);
v_ax_raw_list  = cell(NoPt,1);
v_lat_raw_list = cell(NoPt,1);

for i = 1:length(pt_list)
    pt= pt_list(i);


    data_path= [rawdata_fdpth,'Flow_Lateral_Pos',num2str(pt,'%02d'),'_Meas01.dat'];
    coef_path= [rawdata_fdpth,'coef_Lateral_Pos',num2str(pt,'%02d'),'_Meas01.txt'];
    subs_path= [rawdata_fdpth,'volt_Lateral_Pos',num2str(pt,'%02d'),'_Meas01.dat'];
                                                      
    substrate_V= dlmread(subs_path);
    subx_V  = substrate_V(:,1);
    suby_V  = substrate_V(:,2);
    subs_nm = ConvertVtoNM(subx_V,suby_V,coef_path);
    switch camera_orientation
        case 'before 201704'
            suby_nm = subs_nm(:,1); suby = mean(suby_nm);
            subx_nm = subs_nm(:,2); subx = mean(subx_nm);
        case 'after 201704' % after 201704, AOD-X is Screen-X
            subx_nm = subs_nm(:,1); subx = mean(subx_nm);
            suby_nm = subs_nm(:,2); suby = mean(suby_nm);
    end


    rawdata_V = dlmread(data_path);
    sig_probe = rawdata_V(:,2);
    [~,idx_F1_start,idx_F1_cent,idx_F1_end,...
       idx_F2_start,idx_F2_cent,idx_F2_end] = determine2flashes_PSD(sig_probe,Fs,'differential');

    Vx = rawdata_V(idx_F1_end:idx_F2_start,1);
    Vy = rawdata_V(idx_F1_end:idx_F2_start,2); 

    rawdata_nm     = ConvertVtoNM(Vx,Vy,coef_path);

    if conversion_method >=1
        coef_path_lin  = 'D:\000 RAW DATA FILES\171029 c13-c16\c16l1\000 raw files\calib\coef_linear.txt';
        if exist(coef_path_lin,'file')
            rawdata_nm_lin = ConvertVtoNM_linear(Vx,Vy,coef_path_lin);
        else 
            warning('linear conversion not available, make the file first')
            warning('use 5th order polinomial to convert')
            rawdata_nm_lin = rawdata_nm;

        end
    end
    %% From here the x&y are defined according to the screen.

    % NOTE that the y axis of AOD coordinate aligns with the x direction of the
    % screen. With possibly ~6 degrees of rotation. Here the rotation has not
    % been taken into consideration
    switch camera_orientation
        case 'before 201704'
            nmy = rawdata_nm(:,1);
            nmx = rawdata_nm(:,2);
            if conversion_method >=1
                nmy_lin = rawdata_nm_lin(:,1);
                nmx_lin = rawdata_nm_lin(:,2);
            end
        case 'after 201704' % after 201704, AOD-X is Screen-X
            nmx = rawdata_nm(:,1);
            nmy = rawdata_nm(:,2);
            if conversion_method >=1
                nmx_lin = rawdata_nm_lin(:,1);
                nmy_lin = rawdata_nm_lin(:,2);
            end
    end

    % % CORRECTION OF THE EXCURSION OF THE CALIBRATED AREA % %
    switch conversion_method
        case 1                  % correct output with linear conversion
            % nmx
            dif_nmx = abs(nmx-nmx_lin);
            dif_nmy = abs(nmy-nmy_lin);
            idx_exceed = find(abs(nmx_lin)>80);
                                % ~80 nm is the valid range for 8 steps with
                                % 0.008 MHz stepsize.
            idx_differ = find(dif_nmx>5);
                                % when one axis trespass the valid range,
                                % the other one will share abnormality in
                                % the signal. While the linear conversion
                                % is more insensitive
            idx_combi  = cat(1,idx_exceed,idx_differ);
            idx_combi  = unique(idx_combi);
            nmx(idx_combi) = nmx_lin(idx_combi);

            % nmy
            idx_exceed = find(abs(nmy_lin)>80);
            idx_differ = find(dif_nmy>5);
            idx_combi  = cat(1,idx_exceed,idx_differ);
            idx_combi  = unique(idx_combi);
            nmy(idx_combi) = nmy_lin(idx_combi);
        case 2                  % use linear conversion
            nmx = nmx_lin;
            nmy = nmy_lin;
        otherwise
            error('wrong conversion mode, set again.')
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nmy_AS = nmy - suby;       %nmy_AS : after subtraction of the substrate
    nmx_AS = nmx - subx;

    if exist('beadsize','var')    
        v_y = nmy_AS * stiff_y / 0.8995 / beadsize * 100;   % micron/s, 
        v_x = nmx_AS * stiff_x / 0.8995 / beadsize * 100;   % 22 degrees Celcius
    else
        beadsize = 2.0;
        v_y = nmy_AS * stiff_y / 0.8995 / beadsize * 100;   % micron/s, 
        v_x = nmx_AS * stiff_x / 0.8995 / beadsize * 100;   % 22 degrees Celcius
        warning('Using default bead diameter %.2f micron',beadsize)
    end 


    [vx_raw,vy_raw]=orient_flow_from_ScreenFrame_to_CellFrame(v_x,v_y,experiment); 
    v_ax_raw_list{i}  = vx_raw;
    v_lat_raw_list{i} = vy_raw;
end

save([material_fdpth,'v_raw_list.mat'],'v_ax_raw_list','v_lat_raw_list')