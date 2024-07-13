%% Doc
% This function is my first 'software', designed and established from the
% scratch. A whole weekend devoted in.
% 
% 20170607:
% I replaced 'filter()' and 'iirnotch()', which are the two filtering
% process to the one that introduces no delay, that is, filtfilt();
% The latter one has been tested and it's working



function h_fig = ui_interactive_adjust_filter
 

%% Create panel
h_fig                 =  figure();
set(h_fig,'PaperUnits','centimeters','PaperSize',[40,26],...
          'defaulttextinterpreter','LaTex',...
          'Unit','Normalized','Position',[0.05,0.05,0.9,0.85]);

%% text boxes and inputs
    %% input
ui_textbox('Load from',[0.03,0.05,0.05,0.05]);
h_source      =  uicontrol('Style','Edit','String','',...
                          'Units','normalized','Position',[0.09,0.05,0.25,0.08],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Save to',  [0.38,0.05,0.05,0.05]);
h_destination        =  uicontrol('Style','Edit','String','',...
                          'Units','normalized','Position',[0.45,0.05,0.3,0.08],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
    %% show                  
ui_textbox('Source path',[0.03,0.93,0.05,0.05]);
h_showsource               =  uicontrol('Style','text','String','',...
                          'Units','normalized','Position',[0.10,0.93,0.25,0.05],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
    
ui_textbox('Save path',[0.37,0.93,0.05,0.05]);
h_showdestination          =  uicontrol('Style','text','String','',...
                          'Units','normalized','Position',[0.44,0.93,0.3,0.05],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');

%% Filter properties input
ui_textbox('Low-Pass Filter cutoff',[0.79,0.85,0.07,0.07]);
h_LPF_freq  =  uicontrol('Style','Edit','String','300',...
                       'Units','normalized','Position',[0.8,0.83,0.05,0.03],...
                       'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.83,0.02,0.03]);

ui_textbox('Order',[0.89,0.85,0.07,0.07]);
h_LPF_order       =  uicontrol('Style','Edit','String','5',...
                               'Units','normalized','Position',[0.9,0.83,0.05,0.03],...
                               'Fontsize',12,'FontWeight','normal','BackgroundColor','w');


h_notch_checkbox = uicontrol('Style','Checkbox','Units','normalized',...
                             'Position',[0.77,0.63,0.03,0.03]);                   
ui_textbox('Notch Filter cutoff',[0.79,0.65,0.07,0.07]);
h_notch_freq  =  uicontrol('Style','Edit','String','124.0',...
                           'Units','normalized','Position',[0.8,0.63,0.05,0.03],...
                           'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.63,0.02,0.03]);

ui_textbox('1/# width',[0.89,0.65,0.07,0.07]);
h_notch_order      =  uicontrol('Style','Edit','String','20',...
                                'Units','normalized','Position',[0.9,0.63,0.05,0.03],...
                                'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
       
ui_textbox('Data sampling rate',[0.79,0.45,0.07,0.07]); %Sample rate
h_SR       =  uicontrol('Style','Edit','String','5000.0',...
                        'Units','normalized','Position',[0.8,0.43,0.05,0.03],...
                        'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.43,0.02,0.03]);
                         
%% Plot setup
ui_textbox('Hold plot',[0.89,0.45,0.07,0.07]); %Sample rate
h_holdaxis1 = uicontrol('Style','Checkbox','Units','normalized',...
                        'Position',[0.91,0.46,0.03,0.03]);  
h_holdaxis2 = uicontrol('Style','Checkbox','Units','normalized',...
                        'Position',[0.91,0.42,0.03,0.03]);                             
h_holdaxis3 = uicontrol('Style','Checkbox','Units','normalized',...
                        'Position',[0.93,0.44,0.03,0.03]);    


%% Buttons
load_button   =  uicontrol('Style','PushButton','String','Load and plot',...
                           'Units','normalized','Position',[0.8,0.05,0.18,0.1],...
                           'Fontsize',14,'FontWeight','bold',...
                           'Callback',{@plot_filter_result,h_source,h_showsource,h_showdestination...
                           h_SR,h_LPF_freq,h_LPF_order,...
                           h_notch_checkbox,h_notch_freq,...
                           h_notch_order,...
                           h_holdaxis1,h_holdaxis2,h_holdaxis3});

setappdata(load_button,'t',[]);
setappdata(load_button,'x',[]);           setappdata(load_button,'y',[]);
setappdata(load_button,'x_LP',[]);        setappdata(load_button,'y_LP',[]);
setappdata(load_button,'x_LP_notch',[]);  setappdata(load_button,'y_LP_notch',[]);


save_button   =  uicontrol('Style','PushButton','String','Save to file',...
                           'Units','normalized','Position',[0.8,0.17,0.18,0.1],...
                           'Fontsize',14,'FontWeight','bold',...
                           'Callback',{@save_result,h_source,h_destination,h_showdestination,...
                           load_button,...
                           h_SR,h_LPF_freq,h_LPF_order,h_notch_checkbox,h_notch_freq,...
                           h_notch_order});

savefig_button=  uicontrol('Style','PushButton','String','Save fig',...
                           'Units','normalized','Position',[0.8,0.29,0.18,0.1],...
                           'Fontsize',14,'FontWeight','bold',...
                           'Callback',{@save_fig,h_source,h_destination,h_showdestination,...
                           h_notch_checkbox});


                       
%% Embeded function: Show text
    function h_text = ui_textbox(string,position)
       h_text =  uicontrol('Style','text','String',string,...
                           'Units','normalized','Position',position,...
                           'Fontsize',12,'FontWeight','normal');
    end

%% Embeded function: Simple FFT tool
    function [freq_sequence,magitude]=fft_mag(signal,fs)
        %fs is sampling frequency
        %signal is a 1D array
        L=length(signal);
        nfft = 2^nextpow2(2*L); % Next power of 2 from length of 2*y 
        %2*L is used for the zeropadding
        Y = fft(signal,nfft)/L;
        magitude=2*abs(Y(1:nfft/2+1)); % Magnitude of FFT
        % take only the positive frequency
        freq_sequence = fs/2*linspace(0,1,nfft/2+1);
    end

%% Embeded function: Plot and calculate
    function plot_filter_result(h_loadbutton,~,h_frompathbox,h_showsource,...
                                h_showdestination,h_SR,h_LPF_freq,...
                                h_LPF_order,h_notch_checkbox,h_notch_freq,...
                                h_notch_order,...
                                h_holdaxis1,h_holdaxis2,h_holdaxis3)
            %% Load and refresh data
            pth = h_frompathbox.String;
            h_showsource.String = pth;
            h_showdestination.String= '';
            rawdata = dlmread(pth);
            Fs = str2double(h_SR.String);
            x  = rawdata(:,1); 
            y  = rawdata(:,2);
            t = (1:length(x))/Fs*1000; % ms
            
            %% Low Pass Filter
            LPF_freq  = str2double(h_LPF_freq.String); %cutoff of the Low Pass Filter
            LPF_order = str2double(h_LPF_order.String);
            [blp,alp ] = butter(LPF_order,LPF_freq/Fs*2,'low');
%             [blp,alp ] = butter(floors(LPF_order/2),[30/Fs*2,LPF_freq/Fs*2],'bandpass');
            x_LP = filtfilt(blp,alp,x);
            y_LP = filtfilt(blp,alp,y);
            
            %% Notch filter
            switch h_notch_checkbox.Value
                case 1 % using notch filter
                    if strcmp(h_notch_freq.String,'NaN') ||strcmp(h_notch_order.String,'NaN')
                        h_notch_freq.String = '124.0';
                        h_notch_order.String= '20';
                    end
                    notch_freq = str2double(h_notch_freq.String);
                    notch_order= str2double(h_notch_order.String);
                    wo = notch_freq/Fs*2; % normalized freq (with Nyquist freq)
                    bw = wo/notch_order;  % normalized notch width
                    [bsb,asb]  = iirnotch(wo,bw);
                    x_LP_notch = filtfilt(bsb,asb,x_LP);
                    y_LP_notch = filtfilt(bsb,asb,y_LP);
                    %% Pass data out       
                    setappdata(h_loadbutton,'t',t);
                    setappdata(h_loadbutton,'x',x);           
                    setappdata(h_loadbutton,'y',y);
                    setappdata(h_loadbutton,'x_LP',x_LP);
                    setappdata(h_loadbutton,'y_LP',y_LP);
                    setappdata(h_loadbutton,'x_LP_notch',x_LP_notch);  
                    setappdata(h_loadbutton,'y_LP_notch',y_LP_notch);


                case 0 % not using notch filter
                    %% Pass data out   
                    setappdata(h_loadbutton,'t',t);
                    setappdata(h_loadbutton,'x',x);           
                    setappdata(h_loadbutton,'y',y);
                    setappdata(h_loadbutton,'x_LP',x_LP);
                    setappdata(h_loadbutton,'y_LP',y_LP);
                    h_notch_freq.String = 'NaN';
                    h_notch_order.String= 'NaN';
            end
            
            %% Plot
            xlim_range     = [0,300];
            color_scheme   = [0,0.9,0.4];
            switch h_notch_checkbox.Value
                case 1 % using notch filter
                    
                    
                    % Plot 
                    ax_x           = subplot('Position',[0.06,0.55,0.35,0.33]);
                    if ~h_holdaxis1.Value
                        cla(ax_x)
                    end
                    hold on
                    ax_x.XTickLabel= [];
                    plt_x          = plot(ax_x,t,x,'o','LineWidth',0.5,'color','r','markersize',2);
                    plt_LP_x       = plot(ax_x,t,x_LP,'-','linewidth',2,'color',color_scheme);
                    plt_LP_notch_x = plot(ax_x,t,x_LP_notch,'-','linewidth',2,'color','b');
                    title('Signal before and after filtering')
                    legend([plt_x,plt_LP_x,plt_LP_notch_x],{'Raw (1st column)','Low Pass Filter','LPS and Notch'});
                    legend('boxoff');
                    ylabel('Displacement (nm)', 'FontSize', 14, 'FontWeight', 'bold');
                    xlim(xlim_range)

                    ax_y           = subplot('Position',[0.06,0.20,0.35,0.33]);
                    if ~h_holdaxis2.Value
                        cla(ax_y)
                    end
                    hold on
                    plt_y          = plot(ax_y,t,y,'o','LineWidth',0.5,'color','r','markersize',2);
                    plt_LP_y       = plot(ax_y,t,y_LP,'-','linewidth',2,'color',color_scheme);
                    plt_LP_notch_y = plot(ax_y,t,y_LP_notch,'-','linewidth',2,'color','b');
                    legend([plt_y,plt_LP_y,plt_LP_notch_y],{'Raw (2nd column)','Low Pass Filter','LPS and Notch'});
                    legend('boxoff')
                    xlabel('Time (ms)',         'FontSize', 14, 'FontWeight', 'bold')
                    ylabel('Displacement (nm)', 'FontSize', 14, 'FontWeight', 'bold')
                    xlim(xlim_range);


                    ax_fft         = subplot('Position',[0.46,0.25,0.27,0.6]);
                    if ~h_holdaxis3.Value
                        cla(ax_fft)
                    end
                    title('Frequency domain characteristics')
                    set(ax_fft,'Yscale','log','Xscale','log')
                    hold on 
                    [f,pow]  =fft_mag(x,Fs);
                    plt_1    = plot(f,smooth(pow,50),'r');
                    [f1,pow1]=fft_mag(x_LP,Fs);
                    plt_2    = plot(f1,smooth(pow1,15),'color',color_scheme);
                    [f2,pow2]=fft_mag(x_LP_notch,Fs);
                    plt_3    = plot(f2,smooth(pow2,15),'b'); 
                    xlim([10,Fs/2])
                    xlabel('Freqency (Hz)', 'FontSize', 14, 'FontWeight', 'bold')
                    ylabel('Magnitude (-)', 'FontSize', 14, 'FontWeight', 'bold')
                    legend([plt_1,plt_2,plt_3],{'Raw data (x)','Low Pass Filter','LPS and Notch'});
                    legend('boxoff')
                    
                   
                    
                    
                case 0 % not using notch filter
                    
                    % Plot 
                    ax_x           = subplot('Position',[0.06,0.55,0.35,0.33]);
                    if ~h_holdaxis1.Value
                        cla(ax_x)
                    end
                    hold on
                    ax_x.XTickLabel= [];
                    plt_x          = plot(ax_x,t,x,'o','LineWidth',0.5,'color','r','markersize',2);
                    plt_LP_x       = plot(ax_x,t,x_LP,'-','linewidth',2,'color',color_scheme);
                    title('Signal before and after filtering')
                    legend([plt_x,plt_LP_x],{'Raw data (x)','Low Pass Filter'});
                    legend('boxoff');
                    ylabel('Displacement (nm)', 'FontSize', 14, 'FontWeight', 'bold');
                    xlim(xlim_range)

                    ax_y           = subplot('Position',[0.06,0.20,0.35,0.33]);
                    if ~h_holdaxis2.Value
                        cla(ax_y)
                    end
                    hold on
                    plt_y          = plot(ax_y,t,y,'o','LineWidth',0.5,'color','r','markersize',2);
                    plt_LP_y       = plot(ax_y,t,y_LP,'-','linewidth',2,'color',color_scheme);
                    legend([plt_y,plt_LP_y],{'Raw data (y)','Low Pass Filter'});
                    legend('boxoff')
                    xlabel('Time (ms)',         'FontSize', 14, 'FontWeight', 'bold')
                    ylabel('Displacement (nm)', 'FontSize', 14, 'FontWeight', 'bold')
                    xlim(xlim_range);


                    ax_fft         = subplot('Position',[0.46,0.25,0.27,0.6]);
                    if ~h_holdaxis3.Value
                        cla(ax_fft)
                    end
                    title('Frequency domain characteristics')
                    set(ax_fft,'Yscale','log','Xscale','log')
                    hold on 
                    [f,pow]  =fft_mag(y,Fs);
                    plt_1    = plot(f,smooth(pow,15),'r');
                    [f1,pow1]=fft_mag(y_LP,Fs);
                    plt_2    = plot(f1,smooth(pow1,15),'color',color_scheme);
                    xlim([10,Fs/2])
                    xlabel('Freqency (Hz)', 'FontSize', 14, 'FontWeight', 'bold')
                    ylabel('Magnitude (-)', 'FontSize', 14, 'FontWeight', 'bold')
                    legend([plt_1,plt_2],{'Raw data (y)','Low Pass Filter'});
                    legend('boxoff')
                    
            end
            
             
    end

%% Embeded function: Save current panel as fig
    function save_fig(~,~,h_source,h_destination,h_showdestination,...
                         h_notch_checkbox)    
        to_folderpath = [h_destination.String,'\'];
        from_filepath = h_source.String; 
        cell_temp     = strsplit(from_filepath,'\');
        from_filename = char(cell_temp(end));
        notch_or_not  = h_notch_checkbox.Value;
        switch notch_or_not
            case 1  
                figname = [from_filename(1:end-4),'_LPFnotch.png'];
                fig_path = fullfile(to_folderpath,figname);
            case 0
                figname = [from_filename(1:end-4),'_LPF.png'];
                fig_path = fullfile(to_folderpath,figname);
        end
        print(fig_path,'-dpng','-r300');
        h_showdestination.String = fig_path;
    end

%% Embeded function: Save results to file
    function save_result(~,~,h_source,h_destination,h_showdestination,load_button,...
                         h_SR,h_LPF_freq,h_LPF_order,...
                         h_notch_checkbox,h_notch_freq,h_notch_order)                    
                     
        %% Load from all boxes
        to_folderpath = [h_destination.String,'\'];
        from_filepath = h_source.String; 
        cell_temp     = strsplit(from_filepath,'\');
        from_filename = char(cell_temp(end));
        Fs        = h_SR.String;
        LPS_freq  = h_LPF_freq.String; %cutoff of the Low Pass Filter
        LPS_order = h_LPF_order.String;
        notch_or_not  = h_notch_checkbox.Value;
        notch_freq    = h_notch_freq.String; %cutoff of the Low Pass Filter
        notch_order   = h_notch_order.String;
        
        %% Save data
        switch notch_or_not
            case 1  
                to_filename = [from_filename(1:end-4),'_LPFnotch.dat'];
                to_filepath = fullfile(to_folderpath,to_filename);
                x_final     = getappdata(load_button,'x_LP_notch');
                y_final     = getappdata(load_button,'y_LP_notch');
            case 0
                to_filename = [from_filename(1:end-4),'_LPF.dat'];
                to_filepath = fullfile(to_folderpath,to_filename);
                x_final     = getappdata(load_button,'x_LP');
                y_final     = getappdata(load_button,'y_LP');
        end
        
        savefile_ID = fopen(to_filepath,'w');
        fprintf(savefile_ID,'%.9e\t%.9e\r\n',[x_final;y_final]);
        fclose (savefile_ID);
        %dlmwrite(to_filepath,[x_final,y_final]);
        
        %% Write a data operation log
        log_filepath = [to_folderpath,from_filename(1:end-4),'_FilterLog.txt'];
        log_ID = fopen(log_filepath,'wt');
            %% Date
        current_time = clock();
        fprintf(log_ID,'Time of operation: %s, %02d:%2d\n',date(),...
                current_time(4),current_time(5));
            %% Signal sampling rate
        fprintf(log_ID,'\nSource filepath: %s\nSaved to: %s\nSampling frequency: %s Hz\n',from_filepath,to_filepath,Fs);
            %% LPF info
        fprintf(log_ID,'\nLowpass filter cutoff frequency: %s Hz\nLowpass filter order: %s Hz\n',LPS_freq,LPS_order);
        fprintf(log_ID,'\nNotch used?: %d \nNotch filter frequency: %s Hz\nNotch filter width: 1/%s*freq\n',...
                       notch_or_not,notch_freq,notch_order);         
        fclose (log_ID);
        
        h_showdestination.String = {to_filepath,log_filepath};
    end
end