%% Doc
% This function will take all the image in the given folder path, use a
% moving window of a flash's duration to mark the two flashes contained in
% the image sequence. Optionally, it can simply be used to give the index
% of the flash, or it can store only NoI frames after the first flash. It
% is written to be compatible with previous usage in AA02_...
%
% img_fdpth    : full folder path ended with '\' that contains the image
%                sequence  
% img_name     : name of the image. Da usually put it as '1'
% fileformatstr: index space of the image sequence. If total No. < 10000,
%                it is %04d; more than 10000, it is %06d
% fps          : sampling frequency of the camera, [Hz]
% save_NoI     : Save only NoI frames to the save path. 
%                < 0 : save all
%                = 0 : don't save
%                > 0 : save the given number
% save_fdpth   : Save folder path, only effective when save_NoI ~=0. 
% save_report_fig: whether to save the a reporting figure, showing the two
%                flashes. 1 = save
% Date 2017-11-11, Da

function [t_start,t_2Fspan,idx_F1_cent,idx_F2_cent] = determine2flashes_VID(...
                                                     img_fdpth,img_name,...
                                                     fileformatstr,fps,...
                                                     save_NoI,save_fdpth,...
                                                     show_report_fig,...
                                                     save_report_fig)
    first_img_idx   = 1;
    first_img_path  = [img_fdpth,img_name,'_',num2str(first_img_idx,fileformatstr),'.tif'];
    temp            = strsplit(img_fdpth,'\');
    SFN             = temp{end-1};
    clear temp
    img_struct      = dir([img_fdpth,img_name,'*.tif']);
    total_img_no    = length(img_struct);
    
    %% Prepare the folder
    if save_NoI ~= 0            % save cut image sequence 
        if ~exist(save_fdpth,'dir')
            mkdir(save_fdpth)   % if save folder path doesn't exist, create
        end
    end

    illumi_sum = zeros(total_img_no,1);           % sum of the grayscale of an img
    t          = (0:total_img_no-1)/fps*1000;     % [ms], the first frame is 
    img_type   = 0;                               % 0 (default), 8bit depth
                                                  % 1, RGB
   
    for i_img=1:total_img_no 
        
        full_img_path     = [img_fdpth,img_struct(i_img).name];
        current_img       = im2double(imread(full_img_path,'tif'));
        if length(size(current_img))==3           % RGB image?
            current_img = current_img(:,:,1);     % if so, only use the 1st layer 
            img_type    = 1; 
        end
        illumi_sum(i_img) = sum(current_img(:));
    end
   
    
    interp_Fs = 50.0;                                   % unit: kHz
    t_interp = t(1):1/interp_Fs:t(end);                 % interpolation frequency: 50kHz
    illumi_interp = interp1(t,illumi_sum,t_interp);
    
    F_dura       = 10.326;                              % unit: ms, calib 20170510
    F_winspan    = 2*round((F_dura*interp_Fs)/2);       % must be even number
                                                        % F_ for flash.

    % The method is to sweep a window through the signal, assign to each
    % position the sum of the illumination in the adjacent figures during
    % 10.326 ms. The flash center is supposed to have the highest light
    % intensity.
    
    search_F    = ones(length(illumi_interp),1)*(prctile(illumi_sum,50)*F_winspan);
    for i_search    = (1+F_winspan/2):(length(illumi_interp)-F_winspan/2)
        search_F(i_search) = sum(illumi_interp((i_search-F_winspan/2):(i_search+F_winspan/2-1)));
    end
    
    % Normalization, given its nature being illumination intensity, a flash
    % is a very high PEAK.
    search_F    = (search_F - min(search_F))/(max(search_F) - min(search_F));
    
    [~,idx_F_cents] = findpeaks(search_F,'MinPeakProminence',0.8);
    idx_interp_F1_cent = idx_F_cents(1);
    idx_interp_F2_cent = idx_F_cents(2);
    t_interp_F1_cent   = t_interp(idx_interp_F1_cent);  % [ms]
    t_interp_F2_cent   = t_interp(idx_interp_F2_cent);  % [ms]
    
    % These two outputs will be like 345.34 frame, meaning that the center
    % is between frame 345 and 346 but closer to 345th frame
    idx_F1_cent        = t_interp_F1_cent*fps + 1 ;    
    idx_F2_cent        = t_interp_F2_cent*fps + 1 ;
        
    
    t_0                = t_interp_F1_cent + F_dura/2 ; % [ms]
    t_1                = t_interp_F2_cent - F_dura/2 ;
    t_2Fspan           = t_1 - t_0;
    % t_0 is the start time of the cut image sequence in its original
    % time frame.
    idx_0           = find(t-t_0>0);
    start_frame     = idx_0(1);
    t_start         = t(start_frame)-t_0;
    
    idx_1           = find(t_1-t>0);
    end_frame       = idx_1(end);
    t_end           = t(end_frame)-t_0;
    % t_start = t_1stFrame after the falling edge of the 1st flash. t_start
    % is kept as variable for compatibility
        
    %% Create a figure recording the flash profile
    if show_report_fig
        figure();
    else
        figure('visible','off')
    end
    
    set(gcf,'DefaultAxesFontSize',14,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'unit','normalized',...
        'position',[0.1,0.1,0.8,0.8])
    
    subplot(2,2,[1:2])
    ax1     = plot(t, illumi_sum, 'o-','MarkerSize',4,'LineWidth',1); hold on 
    ax1_cut = plot(t(start_frame:end_frame), illumi_sum(start_frame:end_frame),...
                    'o-','MarkerSize',4,'LineWidth',1);
    legend([ax1,ax1_cut],{'Total img intensity','Cut sequence'},'FontSize',10);
    xlabel('Time (ms)');            
    ylabel('Img. intensity(-)');
    
    subplot(2,2,3)
    illumi_sum_norm = (illumi_sum-min(illumi_sum))/(max(illumi_sum)-min(illumi_sum));
    
    ax2  = plot(t_interp,search_F,'color',[0,0,1,0.5],'Linewidth',2.5); 
    hold on;
    ax3  = plot(t,illumi_sum_norm,...
               'o-','markersize',5,'linewidth',1);
    ax4  = plot([t_0,t_0],[-1,10],'r--','linewidth',1);
    ax5  = plot(t(start_frame),illumi_sum_norm(start_frame),...
                'o','markersize',8,'linewidth',2);
    text(t_0,0.7,sprintf('start frame = %d\nstart time = %.3f ms',...
                start_frame,t_start),'FontSize',10);
    xlim([t_interp_F1_cent-30,t_interp_F1_cent+30]);
    ylim([-0.1,1.5]);
    xlabel('Time (ms)');
    ylabel('Img. intensity(-) / Match score(-)');
    legend([ax2,ax3],{sprintf('sum of %.3f ms window',F_dura),...
           'raw signal'},'FontSize',10);
    
    subplot(2,2,4) 
    ax6  = plot(t_interp,search_F,'color',[0,0,1,0.5],'Linewidth',2.5); 
    hold on;
    ax7  = plot(t,illumi_sum_norm,...
               'o-','markersize',5,'linewidth',1);
    ax8  = plot([t_1,t_1],[-1,10],'r--','linewidth',1);
    ax9  = plot(t(end_frame),illumi_sum_norm(end_frame),...
                'o','markersize',8,'linewidth',2);
    text(t_1+10,0.7,sprintf('end frame = %d\ntime span = %.3f ms',...
                end_frame,t_2Fspan),'FontSize',10);
    xlim([t_interp_F2_cent-30,t_interp_F2_cent+30]);
    ylim([-0.1,1.5]);
    xlabel('Time (ms)');
    legend([ax6,ax7],{sprintf('sum of %.3f ms window',F_dura),...
           'raw signal'},'FontSize',10); 
    set(gcf,'PaperPositionMode','auto')
    
    save ([img_fdpth,'log.mat'],'t','t_0','t_1','start_frame','end_frame',...
          'img_fdpth','img_struct','illumi_sum','illumi_interp','search_F',...
          'idx_interp_F1_cent','idx_interp_F2_cent','idx_F1_cent','idx_F2_cent',...
          't_interp_F1_cent','t_interp_F2_cent','interp_Fs','fps');

    if save_report_fig ==1 && ~isempty(save_fdpth) 
        print([save_fdpth,'Cut Log.png'],'-dpng','-r0');
    end 
        
    %% Save the image sequence between flashes and rename them
    if save_NoI > 0 % save certain number of frames
        last_frame = min(end_frame,start_frame+NoI-1);
    end
    if save_NoI < 0 % save all possible frames.
        last_frame = end_frame;
    end
    
    if save_NoI ~=0
        for i_img=start_frame:last_frame
            full_img_path     = [img_fdpth,img_struct(i_img).name];
            if img_type == 1
                img_temp      =  imread(full_img_path,'tif');
                current_img   =  img_temp(:,:,1);
                clear img_temp
            else
                current_img   =  imread(full_img_path,'tif');
            end
            AF_file_name      = construct_file_name(img_name,i_img-start_frame+1,fileformatstr);
            imwrite(current_img,[save_fdpth,AF_file_name]);
        end
    end
    %% Embedded functions
    function full_file_name = construct_file_name(file_name,index,format_string)
        full_file_name = [file_name,'_',num2str(index,format_string),'.tif'];
    end
    
end