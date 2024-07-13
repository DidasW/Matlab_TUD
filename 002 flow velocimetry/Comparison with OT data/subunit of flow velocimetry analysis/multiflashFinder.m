%% Doc
% Multiflash finder. 
% MUST CONTAIN N FULLY RECORDED FLASHES

function [NoFlash,...
    start_frame_list,...
    t_start_list,...
    t_Fstart_list,...
    t_Fspan_list,...
    t_Fend_list,...
    illumi_sum]   = multiflashFinder(img_fdpth,fps)

    
    img_struct     = dir(fullfile(img_fdpth,'*.tif'));
    N_totImg       = length(img_struct);

    illumi_sum = zeros(N_totImg,1);           % illumi_: sum of pixel value
    for i_img=1:N_totImg
        full_img_path     = fullfile(img_fdpth,img_struct(i_img).name);
        current_img       = im2double(imread(full_img_path,'tif'));
        if length(size(current_img))==3       % RGB image? if so, use the 
            current_img = current_img(:,:,1); % the 1st layer of it
        end
        illumi_sum(i_img) = sum(current_img(:));
    end

    t               = (0:N_totImg-1)/fps*1000;% [ms], the first frame is
    
    interp_Fs       = 50.0;                   % unit: kHz
    t_interp        = t(1):1/interp_Fs:t(end);% interpolation freq:50kHz
    illumi_interp   = interp1(t,illumi_sum,t_interp,'spline');

    
    %% Find rising and falling edge by differentiation
    MinProminence   = 0.3;
    search_F        = zeros(length(illumi_interp),1);
    search_F(2:end) = diff(illumi_interp); % maintain the same length
    search_F(1)     = search_F(2);
    
    search_F_rise   = search_F;
    search_F_rise(search_F_rise<0) = 0;
    search_F_rise   = abs(search_F_rise); % each peak is a rising edge
    search_F_rise   = normalize_MaxToMin(search_F_rise);
    
    search_F_fall   = search_F;
    search_F_fall(search_F_fall>0) = 0;
    search_F_fall   = abs(search_F_fall); % each peak is a falling edge
    search_F_fall   = normalize_MaxToMin(search_F_fall);
    
    [~,idx_F_rise]= findpeaks(search_F_rise,'MinPeakProminence',...
                    MinProminence);
    [~,idx_F_fall]= findpeaks(search_F_fall,'MinPeakProminence',...
                    MinProminence);
    
    % number of falling edge is used to determine the number of useful
    % flashes
    
    NoFlash = length(idx_F_fall);
    start_frame_list= zeros(NoFlash,1);
    t_start_list    = zeros(NoFlash,1);
    t_Fstart_list   = zeros(NoFlash,1);
    t_Fspan_list    = zeros(NoFlash,1);
    t_Fend_list     = zeros(NoFlash,1);
    for i_F = 1:NoFlash
        idx_interp_Ffall = idx_F_fall(i_F);
        t_interp_Ffall   = t_interp(idx_interp_Ffall);  % [ms]
        
        if i_F<= numel(idx_F_rise)
            idx_interp_Frise = idx_F_rise(i_F);
            t_interp_Frise   = t_interp(idx_interp_Frise);  % [ms]
        else
            t_interp_Frise   = t_interp(idx_interp_Ffall)-10.32; %[ms]  
        end
        
        t_Fstart_list(i_F)= t_interp_Frise ; % [ms]
        t_Fend_list(i_F)  = t_interp_Ffall ;
        t_Fspan_list(i_F) = t_interp_Ffall - t_interp_Frise;

        idx             = find(t-t_interp_Ffall>0);
        start_frame     = idx(1);
        start_frame_list(i_F)=  start_frame;
        t_start         = t(start_frame)-t_interp_Ffall;
        t_start_list(i_F)   = t_start;
    end  
        
    
    function signal_norm = normalize_MaxToMin(signal)
        signal_norm = (signal-min(signal))/(max(signal)-min(signal));
    end
end