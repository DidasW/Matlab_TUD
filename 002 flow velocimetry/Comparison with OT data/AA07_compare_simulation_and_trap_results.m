






?%% Doc
% Compare data from trapping experiment and simulation semi-manually

%% Add all the paths
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')

%% Experiment
experiment = '170223c3g2';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
cd(AFpsd_fdpth)

%% Compare simulation with fitting. Initial setting
t_delay   = 0 ;   % t_psd = t_psd+t_delay  (positive t_delay suggests that too much has been cutout of the flash)
                  % i.e. flash ends earlier than calculated
factor    = 1 ;   % psd signal is [factor] times larger than simulation value.
v_x_shift =  0;
v_y_shift =  0;
t_vid_start    = start_frame/fps_real*1000;  % unit ms

%% Filter setting
use_filter = 3;   % 0: no filtering
                  % 1: Low pass filter (LPF)
                  % 2: Notch filter
                  % 3: LPF+notch
                  % 4: N-pts sweeping window smooth
                  % 5: 1+4
                  % 6: 2+4
                  % 7: 3+4
                  
LPF_freq = 180;
LPF_order= 5;
notch_freq   = 124.7;
notch_order  = 100; 
smth_winsize=  5; % sweep window smoothing window size

%% Treatment
for pt = pt_list
    proceed  = 0;
    %% load video based results 
    case_vid_fdpth        = [scenario_fdpth,num2str(pt,'%02d'),'\'];
%     flow_simu_result_pth  = [case_vid_fdpth,'rf=0.2_FlowSpeed_',uni_name,'_',num2str(pt,'%02d'),'.mat'];
    flow_simu_result_pth  = [case_vid_fdpth,'rf=0.2_FlowSpeed_',uni_name,'_',num2str(pt,'%02d'),'_ModifyMobilityFile','.mat'];
    load(flow_simu_result_pth);
    t_vid = make_time_series(Uflowb,fps_real,'ms');   
    
    %% load psd based results
%     psd_flow_filepath  = [AFpsd_folder,'c2rear-',num2str(pt,'%02d'),'_AF_nm,ums,pN.mat'];
    psd_flow_filepath  = [AFpsd_fdpth,num2str(pt,'%02d'),'_AF_nm,ums,pN.mat'];
    load(psd_flow_filepath);
    % v_x and v_y are defined as the horizontal and vertical axis on the
    % camera's screen. See <convert_files_into_velocity.m> for details.
    t_psd = make_time_series(v_x,   Fs, 'ms');
    
    %% Treat v_x,v_y
    switch use_filter
        case 0
        case 1
            [blp,alp ] = butter(LPF_order,LPF_freq/Fs*2,'low');
            v_x = filter(blp,alp,v_x);
            v_y = filter(blp,alp,v_y);
        case 2
            wo = notch_freq/Fs*2; % normalized freq (with Nyquist freq)
            bw = wo/notch_order;  % normalized notch width
            [bsb,asb] = iirnotch(wo,bw);
            v_x       = filter(bsb,asb,v_x);
            v_y       = filter(bsb,asb,v_y);
        case 3
            [blp,alp ] = butter(LPF_order,LPF_freq/Fs*2,'low');
            v_x = filter(blp,alp,v_x);
            v_y = filter(blp,alp,v_y);
            wo = notch_freq/Fs*2; % normalized freq (with Nyquist freq)
            bw = wo/notch_order;  % normalized notch width
            [bsb,asb] = iirnotch(wo,bw);
            v_x       = filter(bsb,asb,v_x);
            v_y       = filter(bsb,asb,v_y);
        case 4
            v_x = smooth(v_x,smth_winsize);
            v_y = smooth(v_y,smth_winsize);
        case 5
            [blp,alp ] = butter(LPF_order,LPF_freq/Fs*2,'low');
            v_x = filter(blp,alp,v_x);
            v_y = filter(blp,alp,v_y);
           
            v_x       = smooth(v_x,smth_winsize);
            v_y       = smooth(v_y,smth_winsize);
        case 6
            wo = notch_freq/Fs*2; % normalized freq (with Nyquist freq)
            bw = wo/notch_order;  % normalized notch width
            [bsb,asb] = iirnotch(wo,bw);
            v_x       = filter(bsb,asb,v_x);
            v_y       = filter(bsb,asb,v_y);
            
            v_x       = smooth(v_x,smth_winsize);
            v_y       = smooth(v_y,smth_winsize);
        case 7
            [blp,alp ] = butter(LPF_order,LPF_freq/Fs*2,'low');
            v_x = filter(blp,alp,v_x);
            v_y = filter(blp,alp,v_y);
            wo = notch_freq/Fs*2; % normalized freq (with Nyquist freq)
            bw = wo/notch_order;  % normalized notch width
            [bsb,asb] = iirnotch(wo,bw);
            v_x       = filter(bsb,asb,v_x);
            v_y       = filter(bsb,asb,v_y);
            v_x       = smooth(v_x,smth_winsize);
            v_y       = smooth(v_y,smth_winsize);
            
    end
           
    
    
    color = [1,0.6,0.2];
    while proceed == 0
        close all
        %% draw
        fig = figure(2);
        set(2,'PaperUnits','centimeters','PaperSize',[20,26],...
            'defaulttextinterpreter','LaTex',...
            'Unit','Normalized','Position',[0.1,0.1,0.6,0.7])
        h = suptitle([sprintf('pos-%02d, %d frms after flash, $t_{delay}=%.1f ms$, factor=%.1f, $v_{x,y}^{shift}$= %.1f, %.1f ',...
                  pt,start_frame,t_delay,factor,v_x_shift, v_y_shift),...
                  '$\mu$m/s',...
                  sprintf('\n$k_{x,y}$ = %.4f, %.4f pN/nm,  $f_{psd}$ = %d Hz,  $f_{cam}$ = %.1f(%.1f) Hz',...
                  stiff_x,stiff_y,Fs,fps_real,fps)]);
        set(h,'FontSize',12,'FontWeight','normal')
        
        subplot(211)
        ax11 = plot(t_vid+t_vid_start,Uflowb,'-','linewidth',2,...
                    'color',color); hold on ;
        ax12 = plot(t_psd+t_delay,-1*(v_x+v_x_shift)/factor,'-',...
                    'linewidth',0.5,'color','b');
        xlim([t_vid_start-10,t_vid_start+200]);
        ylim([-200,100]);
        xlabel('Time (ms)');
        ylabel('Flow speed ($\mu$m/s)');
        legend([ax11,ax12],{'simulation-x','trap-x'});
        set(gca,'Position',[0.1,0.55,0.8,0.35])
        
        subplot(212)
        ax21 = plot(t_vid+t_vid_start,Vflowb,'-','linewidth',2,...
                    'color',color); hold on ;
        ax22 = plot(t_psd+t_delay,-1*(v_y+v_y_shift)/factor,'-',...
                    'linewidth',0.5,'color','b');
        xlim([t_vid_start-10,t_vid_start+200]);
        ylim([-200,100]);
        xlabel('Time (ms)');
        ylabel('Flow speed ($\mu$m/s)');
        legend([ax21,ax22],{'simulation-y','trap-y'});
        set(gca,'Position',[0.1, 0.1 ,0.8, 0.35])
        
        proceed_or_not   = questdlg('Proceed?',... % question message   
                           'No to change the dela, factor, and shift', ...% dialogue title
                    	   'Yes','No',...   % Button names
                           'No');           % default choice 
        switch proceed_or_not
            case 'Yes'
                proceed = 1;
                figure_path = [result_fdpth,num2str(pt,'%02d'),'-comparison.png'];
                print(figure_path,'-dpng','-r300');
            case 'No'
                str_raw   =  char(inputdlg('t_delay,factor,vx_shift,vy_shift = #,#,#,#'));
                str_split =  strsplit(str_raw,',');
                switch length(str_split)
                    case 1
                        t_delay   =  str2double(str_split(1));
                    case 2
                        t_delay   =  str2double(str_split(1));
                        factor    =  str2double(str_split(2));
                    case 3
                        t_delay   =  str2double(str_split(1));
                        factor    =  str2double(str_split(2));
                        v_x_shift =  str2double(str_split(3));
                    case 4
                        t_delay   =  str2double(str_split(1));
                        factor    =  str2double(str_split(2));
                        v_x_shift =  str2double(str_split(3));
                        v_y_shift =  str2double(str_split(4));
                    otherwise
                        break
                end
        end
    end
    
end
