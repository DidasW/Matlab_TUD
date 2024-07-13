%% Doc
% This function makes a time series of the totally brightness of the image 
% sequence, and determine the first flash light by differentiating.
% img_fdpth: folder path of the where the image sequence is stored
% fps      : frame per second, at which the sequence is taken
% show_report_fig: 1 to show figure displaying the flash finding process;
%                  0 to show nothing 
% save_report_fig: 1 to save it to the 
% NOTE: Saving img sequence and determining flash light are made into two
%       parts.


%%
function [t_Fstart,t_Fspan,t_Fend,...
          start_frame,t_start,varargout] = determine1flash_VID_v2(...
                                                     img_fdpth,fps,...
                                                     show_report_fig,...
                                                     save_report_fdpth)
    [~,fdname,~]    = fileparts(img_fdpth);
    if isempty(fdname)
        temp         = strsplit(img_fdpth,'\');
        idx_lastNonEmpty = find(~cellfun('isempty', temp),1,'last');
        fdname       = temp{idx_lastNonEmpty};
    end
    
    img_struct      = dir(fullfile(img_fdpth,'*.tif'));
    total_img_no    = length(img_struct);
    
    illumi_sum = zeros(total_img_no,1);           % sum of the grayscale of an img
    
    for i_img=1:total_img_no   
        full_img_path     = fullfile(img_fdpth,img_struct(i_img).name);
        current_img       = im2double(imread(full_img_path,'tif'));
        if length(size(current_img))==3           % RGB image?
            current_img = current_img(:,:,1);     % if so, only use the 1st layer 
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
    % t_start = t_1stFrame after the falling edge of the flash. 

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

    if ~isempty(save_report_fdpth) 
        print(fullfile(save_report_fdpth,[fdname,' Cut Log.png']),'-dpng','-r0');
    end  
    
    %% Optional output
    NoArgOutExtra = nargout - 5;
    switch NoArgOutExtra
        case 1
            varargout{1} = illumi_sum;
        otherwise1
    end
        
    function signal_norm = normalize_MaxtoMin(signal)
        signal_norm = (signal-min(signal))/(max(signal)-min(signal));
    end

end