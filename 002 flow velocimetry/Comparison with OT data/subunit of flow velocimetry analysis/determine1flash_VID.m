%% Doc
% Determine one flash of varying duration in video clips

function [t_Fstart,t_Fspan,t_Fend,...
          start_frame,t_start,varargout] = determine1flash_VID(...
                                                     img_fdpth,img_name,...
                                                     fileformatstr,fps,...
                                                     save_NoI,save_fdpth,...
                                                     show_report_fig,...
                                                     save_report_fig)
    %% Prepare the sum of the pixel values as the signal
    [~,fdname,~]    = fileparts(img_fdpth);
    img_struct      = dir([img_fdpth,img_name,'*.tif']);
    total_img_no    = length(img_struct);
    
    % Make folder for saving
    if save_NoI ~= 0            % save cut image sequence 
        if ~exist(save_fdpth,'dir')
            mkdir(save_fdpth)   % if save folder path doesn't exist, create
        end
    end

    % Make time series of img brightness
    illumi_sum = zeros(total_img_no,1);           % sum of the grayscale of an img
    img_type   = 0;                               % 0 (default), 8bit depth
                                                  % 1, RGB  
    for i_img=1:total_img_no   
        full_img_path     = fullfile(img_fdpth,img_struct(i_img).name);
        current_img       = im2double(imread(full_img_path,'tif'));
        if length(size(current_img))==3           % RGB image?
            current_img = current_img(:,:,1);     % if so, only use the 1st layer 
            img_type    = 1; 
        end
        illumi_sum(i_img) = sum(current_img(:));
    end
    illumi_sum_norm = normalize_MaxtoMin(illumi_sum);
    t               = (0:total_img_no-1)/fps*1000;% [ms], the first frame is 
    interp_Fs       = 50.0;                       % unit: kHz
    t_interp        = t(1):1/interp_Fs:t(end);    % interpolation freq:50kHz
    illumi_interp   = interp1(t,illumi_sum,t_interp,'spline');
    
      
    %% Find rising and falling edge by differentiation
    MinProminence   = 0.4;
    search_F        = zeros(length(illumi_interp),1);
    search_F(2:end) = diff(illumi_interp);              % maintain the same length
    search_F(1)     = search_F(2);
    search_F        = abs(search_F);
    search_F        = normalize_MaxtoMin(search_F);
    
    [~,idx_FDiffPeak]= findpeaks(search_F,'MinPeakProminence',MinProminence);
    idx_interp_Frise = idx_FDiffPeak(1);
    idx_interp_Ffall = idx_FDiffPeak(2);
    t_interp_Frise   = t_interp(idx_interp_Frise);  % [ms]
    t_interp_Ffall   = t_interp(idx_interp_Ffall);  % [ms]

    t_Fstart         = t_interp_Frise ; % [ms]
    t_Fend           = t_interp_Ffall ;
    t_Fspan          = t_Fend - t_Fstart;

    idx             = find(t-t_Fend>0);
    start_frame     = idx(1);
    t_start         = t(start_frame)-t_Fend;
    % t_start = t_1stFrame after the falling edge of theflash. t_start
    % is kept as a variable for compatibility
        
    %% Create a figure recording the flash profile
    if show_report_fig
        figure();
    else
        figure('visible','off')
    end
    
    set(gcf,'DefaultAxesFontSize',14,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'unit','normalized',...
        'position',[0.1,0.1,0.8,0.8],'PaperPositionMode','auto')
    
    subplot(2,1,1)
    ax1     = plot(t, illumi_sum, 'o-','MarkerSize',4,'LineWidth',1); hold on 
    legend([ax1],{'Total img intensity'},'FontSize',10);
    xlabel('Time (ms)');            
    ylabel('Img. intensity(-)');
    
    subplot(2,1,2)   
    ax2  = plot(t_interp,search_F,'color',[0,0,1,0.5],'Linewidth',2.5); 
    hold on;
    ax3  = plot(t,illumi_sum_norm,'o-','markersize',5,'linewidth',1);
    ax4  = plot([t_Fend,t_Fend],[-1,10],'r--','linewidth',1);
    ax5  = plot(t(start_frame),illumi_sum_norm(start_frame),...
                'o','markersize',8,'linewidth',2);
    text(t_Fend,0.7,sprintf(['start frame = %d\nstart time = %.3f ms\n',...
                             'flash duration %.3f ms'],...
                             start_frame,t_start,t_Fspan),...
         'FontSize',10);
    xlim([t_interp_Frise-40,t_interp_Frise+100]);
    ylim([-0.1,1.5]);
    xlabel('Time (ms)');
    ylabel('Img. intensity(-) / Match score(-)');
    legend([ax2,ax3],{'Abs of differential signal,interp: spline',...
           'raw signal'},'FontSize',10);
    
       
    save ([img_fdpth,'log.mat'],'t_Fstart','t_Fspan','t_Fend',...
          't_start','search_F','interp_Fs','fps');

    if save_report_fig ==1 && ~isempty(save_fdpth) 
        print([save_fdpth,fdname,' Cut Log.png'],'-dpng','-r0');
    end 
        
    %% Save the image sequence after the flash and rename them
    if save_NoI > 0 % save certain number of frames
        last_frame = min(total_img_no,start_frame+save_NoI-1);
    end
    if save_NoI < 0 % save all possible frames.
        last_frame = total_img_no;
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
    
    %% Optional output
    NoArgOutExtra = nargout - 5;
    switch NoArgOutExtra
        case 1
            varargout{1} = illumi_sum;
        otherwise
    end
    
    %% Embedded functions
    function full_file_name = construct_file_name(file_name,index,format_string)
        full_file_name = [file_name,'_',num2str(index,format_string),'.tif'];
    end


    
end