%% Doc
% Select the scenario folder, like ..\170703\c2b3\
% This will be the mama_folder_path. A folder called c2b3_AF will be
% created in the same layer with \c2b3
% Then NoI images are going to be renamed and copied to the target folder
% ..\c2b3_AF. If there are not enough imgs after the flash, will put all
% that are left there. If process_all_img is set as one, NoI will be a
% dummy. All the imgs after the flash will be sent to the target.
% NOTE: will consume unnecessary harddisk space.
% Meanwhile, user will put the cut_log into the AfterFlash_PSD folder.

%% Method of finding the flash.
% see in the code.
close all
clear all 
% clearvars -except iiii experiments experiment mama_folder_path

%% Add paths
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))

%% Manually update settings
experiment      = '190104c37lc'
AA05_experiment_based_parameter_setting;
NoI             = 600;         % How many frames after the flash 
                               % do you want.
process_all_img = 0;
img_type        = 0;           % 0 for grayscale, 1 for RGB;
mama_folder_path = uigetdir('D:\001 RAW MOVIES\',...
                             'SELECT VIDEO FILE FOLDER');
%                                Folder containing subflds of img sequences
%% Folder Setting
cd (mama_folder_path);
[~,MFN,~] = fileparts(mama_folder_path);
SFL     = dir(mama_folder_path);         % Sub Folder List
SFL(1:2)= [];                            % delelte '..' and '.'
SFL     = leave_only_folders_with_sth_in(SFL,mama_folder_path);          
NoFd    = length(SFL);                   % No. of Folder     


[file_name_list, file_format_list,...
 image_number_list,  FFFN_list   ,...    % FFFN: First File Full Name
                    img_size_list]  = get_image_sequence_info_from_SFL(SFL);
%%
cd ..
if exist('uni_name','var');   MFN = uni_name;       end
if ~exist([MFN,'_AF'],'dir'); mkdir([MFN,'_AF']);   end
AF_MF_path = [MFN,'_AF/'];
%AF: after flash

for i_Fd = 1:NoFd
    
    SFN               = SFL(i_Fd).name;     % Name (of this folder),
                                            % Sub Folder Name
    SF_adjusted_path  = [fullfile(mama_folder_path,SFN),'/'];
    if exist(fullfile(SF_adjusted_path,'shift'),'dir')
        SF_adjusted_path = [fullfile(SF_adjusted_path,'shift'),'/'];
    end
    
    AF_SF_path = fullfile(AF_MF_path,[SFN,'_AF']);
    mkdir(AF_SF_path);
    AF_SF_path    = [AF_SF_path,'/'];                   %#ok<AGROW> 
                                                        % subfolder path 
    file_name     = char(file_name_list(i_Fd));         % Filename
    format_string = char(file_format_list(i_Fd));       % Format string 
    img_size_1    = img_size_list(i_Fd,1);              % Img size
    img_size_2    = img_size_list(i_Fd,2);
    first_img_path= fullfile(SF_adjusted_path,char(FFFN_list(i_Fd)));
    total_img_no  = image_number_list(i_Fd);
    if process_all_img
        NoI       = total_img_no;                       
    end
    
    illumi_sum = zeros(total_img_no,1);                 % sum of the grayscale of an img
    t          = ((1:total_img_no)-1)/fps*1000;          % unit: ms
   
    for i_img=1:total_img_no                                     
        full_file_name    = construct_file_name(...
                            file_name,i_img,format_string);
        current_img       = im2double(imread(...
                            [SF_adjusted_path,full_file_name],'tif'));
        if length(size(current_img))==3
            current_img = current_img(:,:,1);
            img_type    = 1; 
        end
        illumi_sum(i_img) = sum(current_img(:));
    end
   
    
    interp_Fs = 50.0;                              % unit: kHz
    t_interp = t(1):1/interp_Fs:t(end);            % interpol. freq.: 50kHz
    illumi_interp = interp1(t,illumi_sum,t_interp);
    
    F_dura       = 10.326;                         % unit: ms, calib 20170510
    F_winspan    = 2*round((F_dura*interp_Fs)/2);  % must be even number
                                                   % F_ for flash.

    % The method is to sweep a window through the signal, assign to each
    % position the sum of the illumination in the adjacent figures during
    % 10.326 ms. The flash center is supposed to have the highest light
    % intensity.
    search_flash    = zeros(length(illumi_interp),1);
    for i_search    = (1+F_winspan/2):(length(illumi_interp)-F_winspan/2)
        search_flash(i_search) = sum(illumi_interp(...
                                    (i_search-F_winspan/2):...
                                    (i_search+F_winspan/2-1)));
    end
    search_flash    = search_flash/max(search_flash);
    
    [~,arg_F_center]= max(search_flash);
    t_flash_center  = t_interp(arg_F_center);       % unit: ms
    t_0             = t_flash_center + F_dura/2 ;   % unit: ms
    idx             = find(t-t_0>0);
    start_frame     = idx(1); left_frame = NoI - start_frame+1;
    t_start         = t(idx(1))-t_0;
        
    %% Create a figure recording the flash profile
    figure(i_Fd);
    set(gcf,'DefaultAxesFontSize',16,'DefaultAxesFontWeight','bold',...
            'DefaultAxesLineWidth',1.5,'unit','normalized',...
            'position',[0.1,0.1,0.8,0.8])
    subplot(1,2,1)
    ax1  = plot(t, illumi_sum, 'o-','MarkerSize',4,'LineWidth',1.5);
    legend(ax1,'Total illumination');
    xlabel('Time (ms)');            ylabel('Sum of grayscale (-)');
    subplot(1,2,2)
    ax2  = plot(t_interp,search_flash);hold on;
    ax3  = plot(t,illumi_sum/max(illumi_sum),'o-',...
               'markersize',5,'linewidth',2);
    ax4  = plot([t_0,t_0],[-1,10],'r--','linewidth',2);
    note = text(t_0+10,0.7,sprintf(...
                'start frame = %d\nstart time = %.3f ms',...
                start_frame,t_start));
    set(note,'fontsize',12);
    xlim([t_flash_center-30,t_flash_center+50]);   ylim([0.1,1.3]);
    xlabel('Time (ms)');
    legend([ax2,ax3],{sprintf('sum of %.3f ms window',F_dura),...
           'raw signal'});
    set(gcf,'PaperPositionMode','auto')
    print(fullfile(AF_SF_path,[MFN,'_',SFN,'_log.png']),'-dpng','-r0');
    save (fullfile(AFpsd_fdpth,[MFN,'_',SFN,'_log.mat']));
        
    if mod(i_Fd,4)==0
        close all 
    end
    
    for i_img=start_frame:min(image_number_list(i_Fd),start_frame+NoI-1)                          
        full_file_name    = construct_file_name(...
                            file_name,i_img,format_string);
        if img_type == 1
            img_temp      =  imread(fullfile(SF_adjusted_path,...
                             full_file_name),'tif');
            current_img   =  img_temp(:,:,1);
        else
            current_img   =  imread(fullfile(SF_adjusted_path,...
                             full_file_name),'tif');
        end
        AF_file_name      = construct_file_name(file_name,...
                            i_img-start_frame+1,format_string);
        imwrite(current_img,fullfile(AF_SF_path,AF_file_name));
    end
    fprintf('%s DONE,\n %d/%d\n',SFN,i_Fd,NoFd);
end
    
