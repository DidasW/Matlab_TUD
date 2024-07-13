close all
%% Dir settings
SFL             = dir(cd);           %Sub Folder List
SFL(1:2)        = [];                %delelte '..' and '.'
SFL             = leave_only_folders_with_sth_in(SFL,cd);          
SFN             = SFL(end).name;    %latest recognition folder

first_img_path  = fullfile(SFN,...
                  ['1_',num2str(1,fileformatstr),'_done.tif']);
try 
    clist_manu_backup = correctlist;
catch
    warning('no backup')
    clist_manu_backup = [];
end

%%
mark_list       = zeros(nframes,1);

%% UI settings
fig_pos    = [0.15 0.15 0.7 0.7];  
L_butt_pos = [0.20,0.15, 0.15, 0.1];
M_butt_pos = [0.40,0.15, 0.15, 0.1];
R_butt_pos = [0.60,0.15, 0.15, 0.1];

fig_browse = figure('NumberTitle','off','Units','normalized',...
                    'NextPlot','Replace'); 
setappdata(gcf,'mark_list',mark_list);
setappdata(gcf,'ref_img_idx',1);


I               = imread(first_img_path);   gcf;  imshow(I);
% probably will resize after imshow.

set       (gcf,'Name',sprintf('Folder %s, define a Ref. point',SFN),...
           'Position',fig_pos);
tell_user = ui_show_message_in_figure(['If the recognition is wrong, ',...
                                       'press REDO']);
[next_img_button,...
 previous_img_button]  =  ui_display_other_img_FlowVelocimetry(...
                                              [SFN,'\'],'1',...
                                              fileformatstr,...
                                              R_butt_pos,...
                                              L_butt_pos);   
                                          
redo_button = uicontrol('Style', 'Pushbutton' , 'String'   ,'REDO'     ,...
                        'Units', 'normalized' , 'Position' , M_butt_pos,...
                        'Fontsize',    15,      'FontWeight', 'bold'    ,...
                        'BackgroundColor', 'w',   'Callback',...
                        {@mark_and_next,[SFN,'\'],'1',fileformatstr});


finish_button = uicontrol('Style', 'Pushbutton' , 'String'   ,'Finish'  ,...
                'Units', 'normalized' , 'Position' , [0.80,0.15,0.1,0.1],...
                'Fontsize',    15,     'FontWeight', 'bold'    ,...
                'BackgroundColor', 'w',   'Callback',...
                'uiresume(gcf)');

report        = uicontrol('Style','text','String','Current redo list:',...
                'Units','normalized','Position',[0,0.18,0.1,0.8],...
                'Fontsize',12,'BackgroundColor',get(gcf,'color'));
            
uiwait(gcf);  
mark_list   = getappdata(gcf, 'mark_list');
correctlist = find(mark_list~=0);
clist_manu  = correctlist;      % clist stands for correct(ion)list
close(gcf)

%% Embedded function
function mark_and_next(~,~,img_fdpth,file_name,format_str)   
    %% update current_img_idx and prepare the next img.
    current_img_idx = getappdata(gcf,'ref_img_idx');
    next_img_path = [img_fdpth,file_name,'_',...
                     num2str(current_img_idx+1,format_str),'_done.tif'];
    next_img_exist = exist(next_img_path,'file');
    if next_img_exist
        next_img      = imread(next_img_path);
    else
        next_img_path = [img_fdpth,file_name,'_',...
                         num2str(current_img_idx,format_str),'_done.tif'];
        next_img      = imread(next_img_path);
    end
    %% update mark_list
    mark_list= getappdata(gcf,'mark_list');
    mark_list(current_img_idx) = 1;
    setappdata(gcf,'mark_list',mark_list);
    
    h_list    = get(gcf,'Children');
    h_report  = h_list(1);
    report_str= h_report.String;
    report_str= [report_str,' ',num2str(current_img_idx),','];
    h_report.String = report_str;
    
    %% show next img
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


 