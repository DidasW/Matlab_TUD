%% AB01_multiflashImageSeqDicer
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m');


%% path
cd('D:\001 RAW MOVIES\180619 wvfm calib for cell 1-2\wvfm calib\')
img_fdpth = 'XY flow calib\';
to_rootFdpth = 'XYFlowCalib_Chopped\';
if ~exist(to_rootFdpth,'dir'); mkdir(to_rootFdpth); end
Fs = 990.85;

%% determine flash lights
[NoF,start_frame_list,t_start_list,...
 t_Fstart_list,t_Fspan_list,...
 t_Fend_list,illumi_sum]         = multiflashFinder(img_fdpth,Fs);
NoImg = length(illumi_sum);

%% Dice and save
for i_F = 1:NoF
    start_frame = start_frame_list(i_F);
    t_start     = t_start_list(i_F);
    t_Fstart    = t_Fstart_list(i_F);
    t_Fspan     = t_Fspan_list(i_F);
    t_Fend      = t_Fend_list(i_F);
    
    to_flashFdpth = fullfile(to_rootFdpth,num2str(i_F,'%02d'));
    if ~exist(to_flashFdpth,'dir'); mkdir(to_flashFdpth); end
        
    if i_F < NoF
        end_frame = start_frame_list(i_F+1)-...
                    floor(t_Fspan_list(i_F+1)*Fs/1000)-1;
    else 
        end_frame = NoImg;
    end
    saveImgSequenceByFrame(img_fdpth,to_flashFdpth,'1','%06d',start_frame,...
         end_frame)   
     
    h_fig = plot_createFlashCheckPlots(illumi_sum,Fs,start_frame,t_start,...
                                    t_Fstart,t_Fspan,t_Fend);
    print(h_fig,fullfile(to_flashFdpth,'Cut Log.png'),'-dpng','-r300');
    if mod(i_F,4)==0; close all;end
end

