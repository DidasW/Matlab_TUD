%% Doc
% This UI register bead-cell position.
close all
%% Manual dir. settings
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))

%% For an OTV experiment case
experiment = '190104c37wvt'
AA05_experiment_based_parameter_setting
clearvars beadcoords_pth
switch experiment(1)
    case '1'
        pipettePointTo = 'down';
    case '2'
        pipettePointTo = 'right';
    otherwise
        warning(['First digit of experiment unrecognized ',...
                 'Use default pipette orientation: head down'])
        pipettePointTo = 'down';
end

%% Quick and map cell position directly
% pipettePointTo = 'down';
% uni_name = '181012c33ptvLat';
% Figure will bestore in subfolder of the current directory

%%
mama_folder_path  = uigetdir('D:\001 RAW MOVIES\',...
                             'SELECT VIDEO FILE FOLDER');
                                % has fds of different img sequences
                                % e.g. D:\004 FLOW VELOCIMETRY DATA\c21a\
                                % or D:\..\c23g1_AF\


%% Auto. dir. settings
if ~exist('PSDtop_fdpth','var')
    warning('PSDtop_fdpth not defined, use cd')
    PSDtop_fdpth = cd;
end

if ~exist('uni_name','var')
    warning('uni_name not defined, use current folder name')
    [~,uni_name,~]=fileparts(mama_folder_path);
end

if ~exist('experiment','var')
    warning('experiment not defined')
    experiment = 'UnknownExperiment';
end

if ~exist(fullfile(PSDtop_fdpth,'position'),'dir')
    mkdir(fullfile(PSDtop_fdpth,'position'))
end

rawClicks_filepath    =   fullfile(PSDtop_fdpth,'position',...
    ['Position ',uni_name,'.dat']);  
xy_beforeRot_filepath =   fullfile(PSDtop_fdpth,'position',...
    ['Position ',uni_name,'_BeforeRot_um.dat']);
xy_afterRot_filepath  =   fullfile(PSDtop_fdpth,'position',...
    ['Position ',uni_name,'_AfterRot_um.dat']);
figpath = fullfile(PSDtop_fdpth,'position',...
    ['Position ',uni_name,'.png']);
cd(mama_folder_path);
SFL             = dir(mama_folder_path); %Sub Folder List
SFL(1:2)        = [];                %delelte '..' and '.'
SFL             = leave_only_folders_with_sth_in(SFL,cd);          
NoFd            = numel(SFL);

%% Pre-allocation
cellCenter_list = zeros(NoFd,2); % (:,1) -> x [pixel]
                                 % (:,2) -> y [pixel]
cellBase_list   = zeros(NoFd,2);
beadCenter_list = zeros(NoFd,2);

%% UI settings
fig_pos    = [0.15 0.15 0.7 0.7];  
prevImgButtonPos  = [0.18, 0.08, 0.08, 0.09];
nextImgButtonPos  = [0.28, 0.08, 0.08, 0.09];
prevFdButtonPos   = [0.40, 0.08, 0.10, 0.09];
nextFdButtonPos   = [0.52, 0.08, 0.10, 0.09];
markButtonPos     = [0.65, 0.08, 0.12, 0.11];
finishButtonPos   = [0.85, 0.08, 0.06, 0.09];
fig_browse = figure('NumberTitle','off','Units','normalized',...
             'NextPlot','Replace');
set(gcf,'Name','Marking Folders','Position',fig_pos);
tell_user  = ui_show_message_in_figure('Marking Folders');

%
setappdata(gcf,'cellCenter_list',cellCenter_list);
setappdata(gcf,'cellBase_list'  ,cellBase_list);
setappdata(gcf,'beadCenter_list',beadCenter_list);
setappdata(gcf,'ref_img_idx',1);
%
i_subfd = 1; 
setappdata(gcf,'curent_subfd_idx',i_subfd);


initial_bulletin_str = cell(NoFd+1,1);
initial_bulletin_str{1} = 'Fds To mark';
for i_line = 1:NoFd
    initial_bulletin_str{i_line+1} = SFL(i_line).name;
end
bulletin  = uicontrol('Style','text','String',initial_bulletin_str,...
            'Units','normalized','Position',[0.02,0.18,0.13,0.8],...
            'Fontsize',10,'BackgroundColor',get(gcf,'color'),...
            'HorizontalAlignment','left');
        
finished = 0;

while ~finished
    i_subfd = getappdata(gcf,'curent_subfd_idx');
    SFN = SFL(i_subfd).name;

    %% Parse filename
    img_list_temp   = dir(fullfile(SFN,'*.tif')); 
    first_img_path  = fullfile(img_list_temp(1).folder,...
                               img_list_temp(1).name);
    img_name_temp   = img_list_temp(1).name; 
    clear vars img_list_temp
    img_name_temp   = strsplit(img_name_temp,'_');
    img_name        = img_name_temp{1}; 
    img_index_temp  = strsplit(img_name_temp{2},'.');
    img_index       = img_index_temp{1}; 
    clearvars img_name_temp img_index_temp
    fileformatstr   = ['%0',num2str(numel(img_index)),'d']; 
    
    %%
    
    set(gcf,'Name',sprintf('Marking Folder %s',SFN));
    tell_user.String = ['Marking Fd: "',SFN,'"'];
    I = imread(first_img_path); gcf; hold on; imshow(I);

    %% Define buttons

                
    [next_img_button,...
     prev_img_button]  =  ui_display_other_img(SFN,'1',...
                                               fileformatstr,...
                                               nextImgButtonPos,...
                                               prevImgButtonPos);   


    prevFdButton = uicontrol('Style','Pushbutton','String','Prev Folder',...
                            'Units','normalized','Position',prevFdButtonPos,...
                            'Fontsize', 12, 'FontWeight', 'bold',...
                            'BackgroundColor', 'w',   'Callback',...
                            {@prevFolder,tell_user,SFL});


    nextFdButton = uicontrol('Style','Pushbutton','String','Next Folder',...
                            'Units','normalized','Position',nextFdButtonPos,...
                            'Fontsize', 12, 'FontWeight', 'bold',...
                            'BackgroundColor', 'w',   'Callback',...
                            {@nextFolder,tell_user,SFL});

    markButton   = uicontrol('Style','Pushbutton','String','MARK',...
                            'Units','normalized','Position',markButtonPos,...
                            'Fontsize', 15, 'FontWeight', 'bold',...
                            'BackgroundColor', 'w',   'Callback',...
                            {@mark,tell_user,bulletin});
                       
    finish_button = uicontrol('Style', 'Pushbutton','String','Finish',...
                    'Units','normalized','Position',finishButtonPos,...
                    'Fontsize', 15, 'FontWeight', 'bold',...
                    'BackgroundColor', 'w', 'Callback',...
                    'finished = 1; uiresume(gcf);');

    

    uiwait(gcf);  
    
    delete( [next_img_button, prev_img_button, prevFdButton,...
            nextFdButton,markButton])
    
    cellCenter_list = getappdata(gcf,'cellCenter_list');
    cellBase_list   = getappdata(gcf,'cellBase_list');
    beadCenter_list = getappdata(gcf,'beadCenter_list');

end
close(gcf)



%% Save and treat data
% raw clicks
data        = zeros(NoFd,6);
data(:,1:2) = cellCenter_list;
data(:,3:4) = cellBase_list;
data(:,5:6) = beadCenter_list;
pos_list    = str2double(erase({SFL.name},'_AF'))';
if isnan(pos_list)
    for i_subfd = 1:numel(SFL)
        parseStr = SFL(i_subfd).name;
        parseStr = strsplit(parseStr,'_');
        pos_list(i_subfd) = str2double(parseStr(1));
        disp(['Folder name contains multiple info.',...
             ' Take the first part before "_" as pos'])
    end
end

%%% adapted from previous python code
switch pipettePointTo
    case 'right'
        rot_to_orientation = 0;
    case 'down'
        rot_to_orientation = 270;
    case 'left'
        rot_to_orientation = 180;
    case 'up'
        rot_to_orientation = 90;
    otherwise
        rot_to_orientation = 0;
end
psx             = 0.1073*2; % pixel size on x, um/px 
psy             = 0.1066*2; % pixel size on y, um/px    


x_cc = data(:,1)*psx;          %_cc for cell center, um
y_cc = data(:,2)*psy*-1;       % -1 as in the image up is where y is smaller            
x_fr = data(:,3)*psx;          %_fr for flagellar roots, um
y_fr = data(:,4)*psy*-1;
x_b  = data(:,5)*psx    -x_cc; %_b for bead, um
y_b  = data(:,6)*psy*-1 -y_cc;

a = sqrt((x_fr-x_cc).^2+(y_fr-y_cc).^2); % distance from cell center to flagellar root, um
avg_a = mean(a);
std_a = std(a);
fprintf('The half long axis of the cell:%.3f+/-%.3f um\n',avg_a,std_a)
theta          = atan2((y_fr-y_cc),(x_fr-x_cc)); % degree
avg_theta      = mean(theta);                            
std_theta      = std(theta);
fprintf('Orientation of the cell:%.2f+/-%.2f deg\n',...
        avg_theta/pi*180,std_theta/pi*180)

%%% Rotate the coords
% rotate the cell together with the bead coords counterclockwise,around (0,0),
% which is the cell center.
% rotation counterclockwise
orientation_rad = rot_to_orientation/180*pi;
rot_rad         = orientation_rad-avg_theta;
x_rot = x_b*cos(rot_rad) - y_b*sin(rot_rad);
y_rot = x_b*sin(rot_rad) + y_b*cos(rot_rad);


%% Write into .dat files
clikedTable = array2table(horzcat(pos_list,data),...
                  'VariableNames',{'pos',...
                  'cell_cent_x','cell_cent_y',...
                  'flag_root_x','flag_root_y',...
                  'bead_x','bead_y'});
writetable(clikedTable,rawClicks_filepath,'Delimiter','\t')

xy_beforeRot = [pos_list,x_b,y_b];
xy_afterRot  = [pos_list,x_rot,y_rot];
if ispc; computer = 'pc'; else; computer = 'unix'; end 
dlmwrite(xy_beforeRot_filepath,xy_beforeRot,'delimiter','\t',...
    'precision','%.2f','newline',computer);
dlmwrite(xy_afterRot_filepath,xy_afterRot,'delimiter','\t',...
    'precision','%.2f','newline',computer);


%% Plot
figure(1)
plotMeasuredPoints(x_b,y_b,x_rot,y_rot,avg_a,avg_theta,orientation_rad);
title(['Experiment: ',experiment])
print(gcf,figpath,'-dpng','-r300')


%% Embedded function
function nextFolder(~,~,~,SFL)
    NoFd = numel(SFL);
    i_subfd = getappdata(gcf,'curent_subfd_idx');
    if i_subfd >= NoFd
        setappdata(gcf,'curent_subfd_idx',NoFd);    
    elseif i_subfd<= 0
        setappdata(gcf,'curent_subfd_idx',1);    
    else
        setappdata(gcf,'curent_subfd_idx',i_subfd+1);
    end
    
    setappdata(gcf,'ref_img_idx',1);
    ax = gca;   ax.Children.delete;
    set(gcf,'Name',sprintf('Marking Folder %s',SFL(i_subfd).name))
    uiresume(gcf)
end
function prevFolder(~,~,~,SFL) 
    NoFd = numel(SFL);
    i_subfd = getappdata(gcf,'curent_subfd_idx');
    if i_subfd > NoFd
        setappdata(gcf,'curent_subfd_idx',NoFd);    
    elseif i_subfd<= 1
        setappdata(gcf,'curent_subfd_idx',1);    
    else
        setappdata(gcf,'curent_subfd_idx',i_subfd-1);
    end
    
    setappdata(gcf,'ref_img_idx',1);
    ax = gca;   ax.Children.delete;
    set(gcf,'Name',sprintf('Marking Folder %s',SFL(i_subfd).name))
    uiresume(gcf)
    
end

function mark(~,~,h_tellUser,h_bulletin)
    currentFdStr      = h_tellUser.String;
    current_fig = gcf;
    figure(current_fig);
    img_all = getimage(current_fig);
    img = img_all(:,:,end);
    [size1,size2] = size(img);
    %% Mark
    % cell center
    h_tellUser.String = 'Mark cell center';
    easterEggStr      = 'Go fuck yourself';
    
    clickIsValid = 0; NoClick = 0;
    while ~clickIsValid
        [x_temp,y_temp] = ginput(1);
        if  x_temp>=1 && x_temp<=size2 &&...
            y_temp>=1 && y_temp<=size1
            x_CCent = x_temp;
            y_CCent = y_temp;
            clickIsValid = 1;
        end
        NoClick = NoClick + 1;
        if NoClick > 20; h_tellUser.String = easterEggStr; end
    end    
    
    
    gcf; hold on
    scatter(x_CCent,y_CCent,27, 'o','MarkerEdgeColor','none',...
            'MarkerFaceColor','w');
    scatter(x_CCent,y_CCent,54,'+','MarkerEdgeColor','r','LineWidth',1);
    
    % flagellar base        
    h_tellUser.String = 'Mark flagellar base';
    
    clickIsValid = 0; NoClick = 0;
    while ~clickIsValid
        [x_temp,y_temp] = ginput(1);
        if  x_temp>=1 && x_temp<=size2 &&...
            y_temp>=1 && y_temp<=size1
            x_FBase = x_temp;
            y_FBase = y_temp;
            clickIsValid = 1;
        end
        NoClick = NoClick + 1;
        if NoClick > 20; h_tellUser.String = easterEggStr; end
    end    
    
    scatter(x_FBase,y_FBase,27, 'o','MarkerEdgeColor','none',...
            'MarkerFaceColor','b');
    scatter(x_FBase,y_FBase,54,'x','MarkerEdgeColor','y','LineWidth',1);

    % bead center
    h_tellUser.String = 'Mark bead center';
    
    clickIsValid = 0; NoClick = 0;
    while ~clickIsValid
        [x_temp,y_temp] = ginput(1);
        if  x_temp>=1 && x_temp<=size2 &&...
            y_temp>=1 && y_temp<=size1
            x_BCent = x_temp;
            y_BCent = y_temp;
            clickIsValid = 1;
        end
        NoClick = NoClick + 1;
        if NoClick > 20; h_tellUser.String = easterEggStr; end
    end    
    
    h_tellUser.String = currentFdStr;
    scatter(x_BCent,y_BCent,90, 'o','MarkerEdgeColor','none',...
            'MarkerFaceColor',[0.3569,0.6824,0.1373],'MarkerFaceAlpha',0.4);
    scatter(x_BCent,y_BCent,54,'+','MarkerEdgeColor','k','LineWidth',1);
    
    pause(0.5)
    %% Update value
    i_subfd         = getappdata(gcf,'curent_subfd_idx');
    cellCenter_list = getappdata(gcf,'cellCenter_list');
    cellBase_list   = getappdata(gcf,'cellBase_list');
    beadCenter_list = getappdata(gcf,'beadCenter_list');
    
    cellCenter_list(i_subfd,:) = [x_CCent,y_CCent];
    cellBase_list(i_subfd,:)   = [x_FBase,y_FBase];
    beadCenter_list(i_subfd,:) = [x_BCent,y_BCent];
    
    setappdata(gcf,'cellCenter_list',cellCenter_list);
    setappdata(gcf,'cellBase_list'  ,cellBase_list);
    setappdata(gcf,'beadCenter_list',beadCenter_list);
    setappdata(gcf,'curent_subfd_idx',i_subfd);
    
    %% Update string
    bulletinStr = h_bulletin.String;
    currentLine = bulletinStr{i_subfd+1};
    currentLine = [currentLine,'--(^_^)'];
    bulletinStr{i_subfd+1} = currentLine;
    h_bulletin.String = bulletinStr ;
    %%
    uiresume(gcf)
end

% This function creates two button on the left and right side of the image
%  the current image index is stored in the button handle and can be
%  extracted by guidata(next_button)

function [next_img_button,...
          prev_img_button] = ui_display_other_img(...
                               img_fdpth,file_name,...
                               format_str,NextButtonPos,...
                               PrevButtonPos)

next_img_button   =  uicontrol('Style','Pushbutton','String','Next Img',...
                     'Units','normalized','Position',NextButtonPos,...
                     'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                     'Callback',{@next_img,img_fdpth,file_name,format_str});

prev_img_button   =  uicontrol('Style','Pushbutton','String','Prev Img',...
                     'Units','normalized','Position',PrevButtonPos,...
                     'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                     'Callback',{@prev_img,img_fdpth,file_name,format_str});
                 
    function next_img(~,~,img_fdpth,file_name,format_str)
        %% update current_img_idx
        current_img_idx = getappdata(gcf,'ref_img_idx');
        next_img_path   = fullfile(img_fdpth,...
                          [file_name,'_',...
                          num2str(current_img_idx+1,format_str),...
                          '.tif']);
        next_img_exist = exist(next_img_path,'file');
        if next_img_exist
            next_img      = imread(next_img_path);
        else
            next_img_path = fullfile(img_fdpth,...
                            [file_name,'_',...
                             num2str(current_img_idx,format_str),...
                            '.tif']);
            next_img      = imread(next_img_path);
        end
        %% show current img
        set(gcf,'Nextplot','add');
        imshow(next_img); % this current img should be the just-loaded "next image"
        fig_name = get(gcf,'Name');
        temp     = strsplit(fig_name,'|');
        fig_name = char(temp(1)); clear temp;    

        if next_img_exist
            fig_name = [fig_name,'| No.',num2str(current_img_idx+1)];
            setappdata(gcf,'ref_img_idx',current_img_idx+1);        
        else
            fig_name = [fig_name,'| No.',num2str(current_img_idx)];
        end
        set(gcf,'Name',fig_name);
    end
    function prev_img(~,~,img_fdpth,file_name,format_str)
    %% update current_img_idx
    current_img_idx = getappdata(gcf,'ref_img_idx');  
    if current_img_idx > 1 
        previous_img_path = fullfile(img_fdpth,...
                            [file_name,'_',...
                            num2str(current_img_idx-1,format_str),...
                            '.tif']);
        previous_img      = imread(previous_img_path);
    else 
        previous_img_path = fullfile(img_fdpth,[file_name,'_',...
                            num2str(1,format_str),'.tif']);
        previous_img      = imread(previous_img_path);
    end
    
    %% show current img
    set(gcf,'Nextplot','add');
    fig_name = get(gcf,'Name');
    temp     = strsplit(fig_name,'|');
    fig_name = char(temp(1)); clear temp;
    
    if current_img_idx > 1
        setappdata(gcf,'ref_img_idx',current_img_idx-1);
        imshow(previous_img);
        fig_name = [fig_name,'| No.',num2str(current_img_idx-1)];
        set(gcf,'Name',fig_name);
    else
        setappdata(gcf,'ref_img_idx',1);
        fig_name = [fig_name,'| No.1'];
        set(gcf,'Name',fig_name);
    end
end                  


end

function plotMeasuredPoints(x_b,y_b,x_rot,y_rot,...
                            cellsize,tilt,orientaion)
    gcf;
    set(gca,'Units','Normalized', 'fontsize',10.9,...
        'defaulttextinterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    grid on, box on, hold on
    a = cellsize;
    theta = tilt;
    phi   = orientaion;
    color_before = [ 0.1216,0.2118,0.5882];
    color_after  = [ 0.8627,0.0784,0.2353];
    %% draw cell
    X_cell = cellsize*cos(linspace(0,2*pi,20));
    Y_cell = cellsize*sin(linspace(0,2*pi,20));
    fill(X_cell,Y_cell,[0.3569,0.6824,0.1373],'FaceAlpha',0.6,...
        'EdgeAlpha',0.01)
    text(0,0.3*a,'Cell','FontSize',10.9,'Color','k',...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle')
    ax_afterRot = quiver(0,0,2*a*cos(phi),2*a*sin(phi),'LineWidth',1,...
           'Color',color_after,'MaxHeadSize',7);
    ax_beforeRot= quiver(0,0,2*a*cos(theta),2*a*sin(theta),...
           'LineWidth',1,'Color',color_before,'MaxHeadSize',7);
    ax_posBeforeRot = scatter(x_b,y_b,30,color_before,'x','LineWidth',1);   
    ax_posAfterRot  = scatter(x_rot,y_rot,30,color_after,...
                      '+','LineWidth',1);
    legend([ax_beforeRot,ax_afterRot,ax_posBeforeRot,ax_posAfterRot],...
           {'Cell heading EXP','After rotation, CFD',...
            'Measurements EXP','After rotation, CFD'},...
            'box','off','FontSize',8)

    xlim([min(x_b)-30,max(x_b)+10])
    axis equal   
    xlabel('Horizontal axis of LaVision Cam ($\mu$m)')
    ylabel('Vertical axis of LaVision Cam ($\mu$m)')
end