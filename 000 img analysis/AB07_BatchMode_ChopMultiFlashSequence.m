%% path
AB00_importExperimentPathList_oda1
experiment_path_list = keepExperimentListByDate(experiment_path_list,...
                       '190728');

chopFdnameList = {'01XY','02MinXY','03Axial'}; 
% under each fdname, multiple subfolders each contains an multiple-flash 
% recording

%%
for i_exp = 1:numel(experiment_path_list)
    experiment_path = experiment_path_list{i_exp};
    [experiment,rootFdpth,cellNo] = parseExperimentPath(experiment_path);

    AB00_experimentalConditions;
    clearvars -except experiment_path_list chopFdnameList ...
              experiment_path rootFdpth experiment cellNo fps 
    
    for i_fd = 1:numel(chopFdnameList)
        chopFdName = chopFdnameList{i_fd};
        if ~exist(fullfile(experiment_path,chopFdName),'dir')
            fprintf('"%s" does not have "%s"\n',experiment, chopFdName);
            continue
        else 
            fprintf('Processing "%s-%s"\n',experiment, chopFdName);
            
        end
        
        % MF_ : multi-flash
        MF_fdList = dir(fullfile(experiment_path,chopFdName)); 
        MF_fdList = MF_fdList([MF_fdList.isdir]);
        MF_fdList(1:2) = [] ;
        MF_fdNameList  = {MF_fdList.name};
        
        flashAlreadyDetected = 0 ;
        for i_MF_fd = 1:numel(MF_fdNameList)
            MF_fdName = MF_fdNameList{i_MF_fd};         
            img_fdpth    =[   fullfile(experiment_path,...
                              chopFdName,...
                              MF_fdName),    '/'];     
            to_rootFdpth =[   fullfile(rootFdpth,...
                              [cellNo,'_Chopped'],...
                              chopFdName),   '/'];
            cutLogFdpth  =[   fullfile(rootFdpth,...
                              '999 CutLog',...
                              chopFdName),   '/'];   
            
            if ~exist(cutLogFdpth,'dir') ; mkdir(cutLogFdpth); end
            if ~exist(to_rootFdpth,'dir'); mkdir(to_rootFdpth); end

            %% determine flash lights
            tic
            [NoF,start_frame_list,t_start_list,...
                t_Fstart_list,t_Fspan_list,...
                t_Fend_list,illumi_sum]  = multiflashFinder_beta(img_fdpth,fps);
            toc
            NoImg = length(illumi_sum);
            save(fullfile(cutLogFdpth,...
                 ['CutLog_',MF_fdName,'.mat']),...
                 'fps','NoF','start_frame_list',...
                't_start_list','t_Fstart_list',...
                't_Fspan_list','t_Fend_list','illumi_sum',...
                'img_fdpth','to_rootFdpth');
            toc
            
            %% Also split and save shift vs time.mat file
            load(fullfile(img_fdpth,'shift vs time.mat'),'u','v');
            u_raw  = expand_uv_from_cell(u);
            v_raw  = expand_uv_from_cell(v);
            
            %% Chop and save
            for i_F = 1:NoF
                tic
                %% images
                start_frame = start_frame_list(i_F);
                t_start     = t_start_list(i_F);
                t_Fstart    = t_Fstart_list(i_F);
                t_Fspan     = t_Fspan_list(i_F);
                t_Fend      = t_Fend_list(i_F);

                to_flashFdpth = fullfile(to_rootFdpth,...
                                num2str(flashAlreadyDetected+i_F,'%02d'));
                if ~exist(to_flashFdpth,'dir'); mkdir(to_flashFdpth); end

                if i_F < NoF
                    end_frame = start_frame_list(i_F+1)-...
                                floor(t_Fspan_list(i_F+1)*fps/1000)-1;
                else 
                    end_frame = NoImg;
                end
                saveImgSequenceByFrame(fullfile(img_fdpth,'adjust'),...
                                       fullfile(to_flashFdpth,'adjust'),...
                                       '1','%05d',start_frame,...
                                       end_frame)   

                h_fig = plot_createFlashCheckPlots(illumi_sum,fps,...
                        start_frame,t_start,t_Fstart,t_Fspan,t_Fend);
                print(h_fig,fullfile(cutLogFdpth,['Cut Log_Fd',...
                      num2str(flashAlreadyDetected+i_F,'%02d'),'.png']),...
                      '-dpng','-r300');

                if mod(i_F,4)==0; close all;end
                
                %% pipette oscillation 
                u = u_raw(start_frame:end_frame);
                v = v_raw(start_frame:end_frame);
                save(fullfile(to_flashFdpth,'shift vs time.mat'),'u','v');               
                toc
            end
            
            flashAlreadyDetected = flashAlreadyDetected + NoF  ;
            disp([MF_fdName,' done'])
        end
    end
end