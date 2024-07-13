%% Doc
% This function is my first 'software', designed and established from the
% scratch. A whole weekend devoted in.
% 
% 20170607:
% I replaced 'filter()' and 'iirnotch()', which are the two filtering
% process to the one that introduces no delay, that is, filtfilt();
% The latter one has been tested and it's working
%
% 20170904:
% I simplified the code, incorporated different combination of signal
% filtering. Fixed the mistaken y label of the v vs. t diagram and solved
% the problem that the treated signal sometimes is saved in wrong format.
%

 

%% Create panel
h_fig                 =  figure();
set(h_fig,'PaperUnits','centimeters','PaperSize',[40,26],...
          'defaulttextinterpreter','LaTex',...
          'Unit','Normalized','Position',[0.05,0.05,0.9,0.85]);
%% text boxes and inputs
%% input paths
ui_textbox('Load from',[0.03,0.05,0.05,0.05]);
h_source      =  uicontrol('Style','Edit','String','',...
                          'Units','normalized','Position',[0.09,0.05,0.25,0.08],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Save to',  [0.38,0.05,0.05,0.05]);
h_destination        =  uicontrol('Style','Edit','String','',...
                          'Units','normalized','Position',[0.45,0.05,0.3,0.08],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
%% display paths                  
ui_textbox('Source path',[0.03,0.93,0.05,0.06]);
h_showsource               =  uicontrol('Style','text','String','',...
                          'Units','normalized','Position',[0.10,0.93,0.25,0.06],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
    
ui_textbox('Save path',[0.37,0.93,0.05,0.06]);
h_showdestination          =  uicontrol('Style','text','String','',...
                          'Units','normalized','Position',[0.44,0.93,0.3,0.06],...
                          'Fontsize',12,'FontWeight','normal','BackgroundColor','w');

%% Filter properties input
%% LPF setting
h_LPF_checkbox = uicontrol('Style','Checkbox','Units','normalized',...
                           'Position',[0.77,0.85,0.03,0.03],'value',1);         
ui_textbox('Low-Pass Filter cutoff',[0.79,0.87,0.07,0.07]);
h_LPF_freq  =  uicontrol('Style','Edit','String','300',...
                       'Units','normalized','Position',[0.8,0.85,0.05,0.03],...
                       'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.85,0.02,0.03]);

%% HPF setting
h_HPF_checkbox = uicontrol('Style','Checkbox','Units','normalized',...
                             'Position',[0.77,0.72,0.03,0.03]);     
ui_textbox('High-Pass Filter cutoff',[0.79,0.74,0.07,0.07]);
h_HPF_freq  =  uicontrol('Style','Edit','String','30',...
                       'Units','normalized','Position',[0.8,0.72,0.05,0.03],...
                       'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.72,0.02,0.03]);

%% Order setting
ui_textbox('L(H)PF/half-BPF Order',[0.88,0.80,0.095,0.07]);
h_order       =  uicontrol('Style','Edit','String','5',...
                               'Units','normalized','Position',[0.9,0.79,0.05,0.03],...
                               'Fontsize',12,'FontWeight','normal','BackgroundColor','w');

%% Notch setting
h_notch_checkbox = uicontrol('Style','Checkbox','Units','normalized',...
                             'Position',[0.77,0.58,0.03,0.03]);                   
ui_textbox('Notch Filter cutoff',[0.79,0.60,0.07,0.07]);
h_notch_freq  =  uicontrol('Style','Edit','String','124.0',...
                           'Units','normalized','Position',[0.8,0.58,0.05,0.03],...
                           'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.58,0.02,0.03]);

ui_textbox('1/# width',[0.89,0.60,0.07,0.07]);
h_notch_order      =  uicontrol('Style','Edit','String','20',...
                                'Units','normalized','Position',[0.9,0.58,0.05,0.03],...
                                'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
       
ui_textbox('Data sampling rate',[0.79,0.45,0.07,0.07]); %Sample rate
h_SR       =  uicontrol('Style','Edit','String','5000.0',...
                        'Units','normalized','Position',[0.8,0.43,0.05,0.03],...
                        'Fontsize',12,'FontWeight','normal','BackgroundColor','w');
ui_textbox('Hz',[0.851,0.43,0.02,0.03]);
                         
%% Plot position setup
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
                           'Callback',{@plot_filter_result,...
                           h_source,h_showsource,h_showdestination,h_SR,...
                           h_LPF_checkbox,h_HPF_checkbox,...
                           h_LPF_freq,h_HPF_freq,h_order,...
                           h_notch_checkbox,h_notch_freq,h_notch_order,...
                           h_holdaxis1,h_holdaxis2,h_holdaxis3});

setappdata(load_button,'t',[]);
setappdata(load_button,'x',[]);           setappdata(load_button,'y',[]);
% setappdata(load_button,'x_LP',[]);        setappdata(load_button,'y_LP',[]);
% setappdata(load_button,'x_LP_notch',[]);  setappdata(load_button,'y_LP_notch',[]);
% 
setappdata(load_button,'x_treated',[]);   setappdata(load_button,'y_treated',[]);
setappdata(load_button,'treatment',[]);

save_button   =  uicontrol('Style','PushButton','String','Save to file',...
                           'Units','normalized','Position',[0.8,0.17,0.18,0.1],...
                           'Fontsize',14,'FontWeight','bold',...
                           'Callback',{@save_result,h_source,h_destination,...
                           h_showdestination, load_button,h_SR,...
                           h_LPF_checkbox,h_HPF_checkbox,h_LPF_freq,h_HPF_freq,h_order,h_notch_checkbox,h_notch_freq,...
                           h_notch_order});

savefig_button=  uicontrol('Style','PushButton','String','Save fig',...
                           'Units','normalized','Position',[0.8,0.29,0.18,0.1],...
                           'Fontsize',14,'FontWeight','bold',...
                           'Callback',{@save_fig,h_source,h_destination,...
                           h_showdestination,h_LPF_checkbox,h_HPF_checkbox,...
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

%% Embeded function: Determine filter type
function [treatment]=determine_filter_type(LPF_checkbox,HPF_checkbox,notch_checkbox)
    % based on the combination of the selection of the checkboxes,
    % determine the final filter type used.
    LHn = [num2str(LPF_checkbox),num2str(HPF_checkbox),...
           num2str(notch_checkbox)];
    % LHn, 3 element tuple represent the combination of filter setting
    switch LHn
        case '000'; treatment = 'LPF'; % default
        case '001'; treatment = 'notch';
        case '010'; treatment = 'HPF';
        case '011'; treatment = 'HPF+notch';
        case '100'; treatment = 'LPF';
        case '101'; treatment = 'LPF+notch';
        case '110'; treatment = 'BPF';
        case '111'; treatment = 'BPF+notch';
    end
end

%% Embeded function: Plot and calculate
function plot_filter_result(h_loadbutton,~,h_frompathbox,h_showsource,...
                            h_showdestination,h_SR,...
                            h_LPF_checkbox,h_HPF_checkbox,...
                            h_LPF_freq,h_HPF_freq,h_order,...
                            h_notch_checkbox,h_notch_freq,h_notch_order,...
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
    freq_resolution = 1000/t(end); % Hz
   
    LPF_checkbox   = h_LPF_checkbox.Value;
    HPF_checkbox   = h_HPF_checkbox.Value;
    notch_checkbox = h_notch_checkbox.Value;
    treatment      = determine_filter_type(LPF_checkbox,HPF_checkbox,...
                                           notch_checkbox);
    if ~strcmp(h_LPF_freq.String,'NaN') 
        LPF_freq  = str2double(h_LPF_freq.String);
    else
        LPF_freq  = 300;
    end
    if ~strcmp(h_HPF_freq.String,'NaN')
        HPF_freq  = str2double(h_HPF_freq.String);
    else
        HPF_freq = 30;
    end
    if ~strcmp(h_order.String,'NaN')
        order     = str2double(h_order.String);
    else 
        order     = 5;
    end
    if ~strcmp(h_notch_freq.String,'NaN')
        notch_freq= str2double(h_notch_freq.String);
    else
        notch_freq= 124;
    end
    if ~strcmp(h_notch_order.String,'NaN')
        notch_order= str2double(h_notch_order.String);
    else
        notch_order = 20;
    end
    
    %% Configure filter set
    use_notch = ~isempty(strfind(treatment,'notch'));
    % use_notch = 1: treatment contains 'notch'
    if use_notch
        wo = notch_freq/Fs*2; % normalized freq (with Nyquist freq)
        bw = wo/notch_order;  % normalized notch width
        [bsb,asb]  = iirnotch(wo,bw);
        LHB_treatment = treatment(1:end-5);
        if ~isempty(LHB_treatment)
            LHB_treatment = LHB_treatment(1:3);
        else
            LHB_treatment = '';
        end
        h_notch_order.String = notch_order;
        h_notch_freq.String  = notch_freq;
    else % if notch filter not used, set values to 'NaN'
        LHB_treatment = treatment;
        h_notch_order.String = 'NaN';
        h_notch_freq.String  = 'NaN';
    end
    
    switch LHB_treatment
        case ''
            h_LPF_freq.String = 'NaN';
            h_HPF_freq.String = 'NaN';
        case 'HPF'
            [bp_freq,ap_freq] = butter(order,HPF_freq/Fs*2,'high');
            h_HPF_freq.String = HPF_freq;
            h_LPF_freq.String = 'NaN';
        case 'LPF'
            [bp_freq,ap_freq] = butter(order,LPF_freq/Fs*2,'low');
            h_HPF_freq.String = 'NaN';
            h_LPF_freq.String = LPF_freq;
            h_LPF_checkbox.Value = 1;
        case 'BPF'
            [bp_freq,ap_freq] = butter(order,[HPF_freq,LPF_freq]/Fs*2,'bandpass');
            h_HPF_freq.String = HPF_freq;
            h_LPF_freq.String = LPF_freq;
    end
    
    %% Treatment with Low/High/Band-Pass Filter
    if ~strcmp(LHB_treatment,'')
        x_LHBP = filtfilt(bp_freq,ap_freq,x);
        y_LHBP = filtfilt(bp_freq,ap_freq,y);
    else
        x_LHBP = x;
        y_LHBP = y;
    end
    
    %% Treatment with Notch filter
    if use_notch
        x_treated = filtfilt(bsb,asb,x_LHBP);
        y_treated = filtfilt(bsb,asb,y_LHBP);
    else
        x_treated = x_LHBP;
        y_treated = y_LHBP;
    end
   
    %% Pass data out       
    setappdata(h_loadbutton,'t',t);
    setappdata(h_loadbutton,'x',x);           
    setappdata(h_loadbutton,'y',y);
    setappdata(h_loadbutton,'x_treated',x_treated);
    setappdata(h_loadbutton,'y_treated',y_treated);
    setappdata(h_loadbutton,'treatment',treatment);

    %% Plot
    % setup
    xlim_range        = [0,300];
%     color_scheme      = [0,0.9,0.4];
    freq_smooth_range = 5; %Hz
    NoP_smooth        = round(freq_smooth_range/freq_resolution);
    % subplot x in time
    
    ax_x           = subplot('Position',[0.06,0.55,0.35,0.33]);
    if ~h_holdaxis1.Value
        cla(ax_x)
    end
    hold on
    ax_x.XTickLabel= [];
    plt_x          = plot(ax_x,t,x,'o','LineWidth',0.5,'color','r','markersize',2);
    plt_x_treated  = plot(ax_x,t,x_treated,'-','linewidth',2,'color','b');
    title('Signal before and after filtering')
    legend([plt_x,plt_x_treated],{'Raw (1st column)',treatment});
    legend('boxoff');
    if (max(x)-min(x))<5
        ylabel('PSD output (V)', 'FontSize', 14, 'FontWeight', 'bold');
    else
        ylabel('Displacement (nm)', 'FontSize', 14, 'FontWeight', 'bold');
    end
    xlim(xlim_range)
    
    % subplot y in time
    ax_y           = subplot('Position',[0.06,0.20,0.35,0.33]);
    if ~h_holdaxis2.Value
        cla(ax_y)
    end
    hold on
    plt_y          = plot(ax_y,t,y,'o','LineWidth',0.5,'color','r','markersize',2);
    plt_y_treated  = plot(ax_y,t,y_treated,'-','linewidth',2,'color','b');
    legend([plt_y,plt_y_treated],{'Raw (2nd column)',treatment});
    legend('boxoff')
    xlabel('Time (ms)',         'FontSize', 14, 'FontWeight', 'bold')
    if (max(y)-min(y))<5
        ylabel('PSD output (V)', 'FontSize', 14, 'FontWeight', 'bold');
    else
        ylabel('Displacement (nm)', 'FontSize', 14, 'FontWeight', 'bold');
    end
    xlim(xlim_range);

    % subplot fft x
    ax_fftx         = subplot('Position',[0.46,0.58,0.27,0.28]);
    if ~h_holdaxis3.Value
        cla(ax_fftx)
    end
    title('Frequency domain characteristics')
    set(ax_fftx,'Yscale','log','Xscale','log')
    hold on 
    [f0,pow0]     =  fft_mag(x,Fs);
    pow0_smooth   =  smooth(pow0,NoP_smooth);
    plt_fftx0     =  plot(f0,pow0_smooth,'r');
    
    [f1,pow1]     =  fft_mag(x_treated,Fs);
    pow1_smooth   =  smooth(pow1,NoP_smooth);
    plt_fftx1     =  plot(f1,pow1_smooth,'b'); 
    
    xlim([10,Fs/2])
    ylim([0.5e-4,max(pow0(f0>10))*3])
    ylabel('Magnitude (-)', 'FontSize', 14, 'FontWeight', 'bold')
    legend([plt_fftx0,plt_fftx1],{'Raw data (x)',treatment});
    legend('boxoff')
    
    % subplot fft y
    ax_ffty         = subplot('Position',[0.46,0.24,0.27,0.28]);
    if ~h_holdaxis3.Value
        cla(ax_ffty)
    end
    set(ax_ffty,'Yscale','log','Xscale','log')
    hold on 
    [f0,pow0]     =  fft_mag(y,Fs);
    pow0_smooth   =  smooth(pow0,NoP_smooth);
    plt_fftx0     =  plot(f0,pow0_smooth,'r');
    
    [f1,pow1]     =  fft_mag(y_treated,Fs);
    pow1_smooth   =  smooth(pow1,NoP_smooth);
    plt_fftx1     =  plot(f1,pow1_smooth,'b'); 
    
    xlim([10,Fs/2])
    ylim([0.5e-4,max(pow0(f0>10))*3])
    xlabel('Freqency (Hz)', 'FontSize', 14, 'FontWeight', 'bold')
    ylabel('Magnitude (-)', 'FontSize', 14, 'FontWeight', 'bold')
    legend([plt_fftx0,plt_fftx1],{'Raw data (y)',treatment});
    legend('boxoff')
end

%% Embeded function: Save current panel as fig
function save_fig(~,~,h_source,h_destination,h_showdestination,...
                     h_LPF_checkbox,h_HPF_checkbox,h_notch_checkbox)    
    to_folderpath = [h_destination.String,'\'];
    from_filepath = h_source.String; 
    cell_temp     = strsplit(from_filepath,'\');
    from_filename = char(cell_temp(end));
    
    LPF_checkbox   = h_LPF_checkbox.Value;
    HPF_checkbox   = h_HPF_checkbox.Value;
    notch_checkbox = h_notch_checkbox.Value;
    treatment      = determine_filter_type(LPF_checkbox,HPF_checkbox,...
                                           notch_checkbox);
                                       
    figname = [from_filename(1:end-4),'_',treatment,'.png'];
    fig_path = fullfile(to_folderpath,figname);
    print(fig_path,'-dpng','-r300');
    h_showdestination.String = fig_path;
end

%% Embeded function: Save results to file
function save_result(~,~,h_source,h_destination,h_showdestination,load_button,...
                     h_SR,h_LPF_checkbox,h_HPF_checkbox,h_LPF_freq,h_HPF_freq,h_order,...
                     h_notch_checkbox,h_notch_freq,h_notch_order)                    
                     
        %% Load from all boxes
        to_folderpath = [h_destination.String,'\'];
        from_filepath = h_source.String; 
        cell_temp     = strsplit(from_filepath,'\');
        from_filename = char(cell_temp(end));
        Fs        = h_SR.String;
        LPF_freq  = h_LPF_freq.String; %cutoff of the Low Pass Filter
        HPF_freq  = h_HPF_freq.String;
        order     = h_order.String;
        
        LPF_checkbox   = h_LPF_checkbox.Value;
        HPF_checkbox   = h_HPF_checkbox.Value;
        notch_checkbox = h_notch_checkbox.Value;
        treatment      = determine_filter_type(LPF_checkbox,HPF_checkbox,...
                                           notch_checkbox);
        
        notch_or_not   = h_notch_checkbox.Value;
        if notch_or_not
            LHB_treatment = treatment(1:end-5);
            if ~isempty(LHB_treatment)
                LHB_treatment = LHB_treatment(1:3);
            else
                LHB_treatment = 'NaN';
            end
            notch_freq    = h_notch_freq.String; 
            notch_order   = h_notch_order.String;
        else % if notch filter not used, set values to 'NaN'
            LHB_treatment = treatment;
            notch_freq    = 'NaN'; 
            notch_order   = 'NaN';
        end

        
        %% Save data
        to_filename = [from_filename(1:end-4),'_',treatment,'.dat'];
        to_filepath = fullfile(to_folderpath,to_filename);
        x_treated   = getappdata(load_button,'x_treated');
        y_treated   = getappdata(load_button,'y_treated');
        
        savefile_ID = fopen(to_filepath,'wt');
        fprintf(savefile_ID,'%.5e\t%.5e\n',[x_treated;y_treated]);
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
            %% LHB-PF info
        fprintf(log_ID,['\nLow/High/Band-pass filter used: %s\n',...
                        'cutoff frequencies:\n\tHighpass: %s Hz',...
                        '\n\tLowpass: %s Hz',...
                        '\n\tOrder: %s'],...
                        LHB_treatment,HPF_freq,LPF_freq,order);
        fprintf(log_ID,'\n\nNotch used?: %d \nNotch filter frequency: %s Hz\nNotch filter width: 1/%s*freq\n',...
                       notch_or_not,notch_freq,notch_order);         
        fclose (log_ID);
        
        h_showdestination.String = {to_filepath,log_filepath};
    end