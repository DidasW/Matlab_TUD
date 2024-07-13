%% path
AB00_importExperimentPathList_oda1
experiment_path_list = keepExperimentListByDate(experiment_path_list,...
                       '190728');
% experiment_path_list = keepFolderPathListByKeyWords(experiment_path_list,...
%                        {'c02'});

fromFdname_list = {'00NoFlow','99Deflag'}; 
% each fromFd serves as a mama_folder, 

%%
for i_exp = 1:numel(experiment_path_list)
    experiment_path = experiment_path_list{i_exp};
    % in AB00_import..., if there exists c<i>_Chopped
    %   experiment_path = ..\YYDDMM c<i>\c<i>_Chopped/
    % otherwise
    %   experiment_path = ..\YYDDMM c<i>\c<i>/
    if ~contains(experiment_path,'_Chopped')
        fprintf('No chopped image squence, skip\n')
        continue;
    end 
    
    [experiment,rootFdpth,cellNo] = parseExperimentPath(experiment_path);
    AB00_experimentalConditions;
    clearvars -except experiment_path_list fromFdname_list ...
              experiment_path rootFdpth experiment cellNo fps 
    
    for i_fd = 1:numel(fromFdname_list)
        fromFdname = fromFdname_list{i_fd};
        fromFdpath = fullfile(rootFdpth,cellNo,fromFdname);
        %% check existence of the source
        if ~exist(fromFdpath,'dir')
            fprintf('"%s" does not have "%s"\n',experiment, fromFdname);
            continue
        else 
            fprintf('Moving "%s --- %s"\n',experiment, fromFdname); 
        end
        
        %% create destination
        toFdpath = fullfile(rootFdpth,[cellNo,'_Chopped'],fromFdname);
        if ~exist(toFdpath,'dir'); mkdir(toFdpath); end
        
        %% move .mat files directly under FromFdname
        matfiles = dir(fullfile(fromFdpath,'*.mat'));
        for i_file  = 1:numel(matfiles)
            copyfile(fullfile(fromFdpath,matfiles(i_file).name),...
                     fullfile(toFdpath  ,matfiles(i_file).name),'f')
        end
        
        %% move subfolders
        % list the subfolders
        % SF[L/N] : subfolder [list/name]
        SFL = dir(fromFdpath); 
        SFL = SFL([SFL.isdir]);
        SFL(1:2) = [] ;
        
        %% move
        for i_SF = 1:numel(SFL)
            SFN          = SFL(i_SF).name;         
            fromSF_fdpth = fullfile(SFL(i_SF).folder,SFN);     
            
            %% create destination
            toSF_fdpth     = fullfile(toFdpath,SFN);     
            toSF_adj_fdpth = fullfile(toSF_fdpth,'adjust');
            if ~exist(toSF_fdpth,'dir')    ; mkdir(toSF_fdpth); end
            if ~exist(toSF_adj_fdpth,'dir'); mkdir(toSF_adj_fdpth); end
            
            %% copy .mat file (usually only a shift.mat)
            matfiles_SF = dir(fullfile(fromSF_fdpth,'*.mat'));
            for i_file  = 1:numel(matfiles_SF)
                filename = matfiles_SF(i_file).name;
                copyfile(fullfile(fromSF_fdpth,filename),...
                         fullfile(toSF_fdpth  ,filename),'f')
            end

            %% move the adjusted images
            fromSF_adj_fdpth = fullfile(fromSF_fdpth,'adjust');
            img_list  = dir(fullfile(fromSF_adj_fdpth,'*.tif'));
            NoI       = numel(img_list);
            
            fprintf('Moving subfolder "%s"\n',SFN);
            tic
            for i_img = 1:NoI
                imgName = img_list(i_img).name;
                copyfile(fullfile(fromSF_adj_fdpth,imgName),...
                         fullfile(toSF_adj_fdpth  ,imgName),'f')
                
                if i_img == NoI || mod(i_img,5000)==0
                    t = toc;
                    fprintf('%d/%d finished, %.2f s\n',i_img,NoI,t); 
                end
            end
            toc       
        end
    end
end
