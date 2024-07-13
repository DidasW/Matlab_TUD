function marked_list = manual_mark_img_sequence(img_fdpth,img_name,...
                       fileformatstr,fps,f0,varargin)
    %% check input
    persistent first_img_idx
    NoArgInExtra  =  nargin  - 5;
    if NoArgInExtra > 0
        temp = strcmp(varargin,'FirstImgIndex'); 
        if any(temp) 
           first_img_idx = varargin{find(temp)+1}; 
           assert(isscalar(first_img_idx)==1,...
               'Error: FirstImgIndex must be a scalar value.') 
        end
    else
        first_img_idx   = 1;
    end
    disp(['first img index: ', num2str(first_img_idx)])
    
    switch img_fdpth(end)
        case {'/','\'}
        otherwise
           img_fdpth = [img_fdpth,'/'];
    end
    
    %%                  
    first_img_path  = fullfile(img_fdpth,[img_name,'_',...
                      num2str(first_img_idx,fileformatstr),'.tif']);
    [~,SFN,~]       = fileparts(img_fdpth(1:end-1));
    temp            = dir(fullfile(img_fdpth,[img_name,'*.tif']));
    nframes         = length(temp);
    clear temp
    mark_list       = zeros(nframes,1);

    %% UI settings
    fig_pos    = [0.15 0.15 0.7 0.7];  
    L_butt_pos = [0.20,0.15, 0.15, 0.1];
    M_butt_pos = [0.40,0.15, 0.15, 0.1];
    R_butt_pos = [0.60,0.15, 0.15, 0.1];
    nextCyc_butt_pos = [0.30, 0.28, 0.35, 0.05];
    prevCyc_butt_pos = [0.30, 0.07, 0.35, 0.05];
    
    fig_browse = figure('NumberTitle','off','Units','normalized',...
                        'NextPlot','Replace'); 
    setappdata(gcf,'mark_list',mark_list);
    setappdata(gcf,'ref_img_idx',first_img_idx);
    
    frame_per_cycle = floor(fps/f0);
    setappdata(gcf,'frame_per_cycle',frame_per_cycle);

    I  = imread(first_img_path);   gcf;  imshow(I);
    % probably will resize after imshow.

    set(gcf,'Name',sprintf('Folder %s, define a Ref. point',SFN),...
        'Position',fig_pos);
    tell_user = ui_show_message_in_figure(['Cell in THE phase? ',...
                    'press MARK']);
                                       
    
    ui_display_other_img(img_fdpth,img_name,fileformatstr,...
        R_butt_pos,L_butt_pos,1,'Img');   
    ui_display_other_img(img_fdpth,img_name,fileformatstr,...
        nextCyc_butt_pos,prevCyc_butt_pos,...
        frame_per_cycle,'Cycle');                                      
                                          

    mark_button = uicontrol('Style', 'Pushbutton' , 'String'   ,'MARK',...
                  'Units', 'normalized' , 'Position' , M_butt_pos,...
                  'Fontsize',    15,      'FontWeight', 'bold'    ,...
                  'BackgroundColor', 'w',   'Callback',...
                  {@mark_and_next,img_fdpth,img_name,fileformatstr});


    finish_button = uicontrol('Style','Pushbutton','String' ,'Finish',...
                    'Units','normalized','Position',[0.80,0.15,0.1,0.1],...
                    'Fontsize', 15,  'FontWeight', 'bold' ,...
                    'BackgroundColor', 'w', 'Callback',...
                    'uiresume(gcf)');

    report_NumMarked = uicontrol('Style','text','String','',...
                    'Units','normalized','Position',[0,0.18,0.15,0.8],...
                    'Fontsize',12,'BackgroundColor',get(gcf,'color'));
                
    report_idxMarked = uicontrol('Style','text','String','Current marked:',...
                    'Units','normalized','Position',[0.01,0.18,0.1,0.73],...
                    'Fontsize',12,'BackgroundColor',get(gcf,'color'));

    uiwait(gcf);  
    mark_list   = getappdata(gcf, 'mark_list');
    marked_list = find(mark_list~=0);
    marked_list = unique(marked_list);
    close(gcf)

    %% Embedded function 1
    function mark_and_next(~,~,img_fdpth,file_name,format_str)   
        %% update current_img_idx and prepare the next img.
        current_img_idx = getappdata(gcf,'ref_img_idx');
        next_img_path = [img_fdpth,file_name,'_',...
                         num2str(current_img_idx+1,format_str),'.tif'];
        next_img_exist = exist(next_img_path,'file');
        if next_img_exist
            next_img      = imread(next_img_path);
        else
            next_img_path = [img_fdpth,file_name,'_',...
                             num2str(current_img_idx,format_str),'.tif'];
            next_img      = imread(next_img_path);
        end
        %% update mark_list
        mark_list= getappdata(gcf,'mark_list');
        mark_list(current_img_idx) = 1;
        setappdata(gcf,'mark_list',mark_list);
        temp_marked_list = find(mark_list~=0);
        temp_marked_list = unique(temp_marked_list);
        NoMarkedImg      = numel(temp_marked_list);
        
        %% update text
        h_list    = get(gcf,'Children');
        h_reportIdx  = h_list(1);
        report_str= h_reportIdx.String;

        % Show only the 10 last image idx
        if NoMarkedImg<=10
            report_str= [report_str,' ',num2str(current_img_idx),','];
        else
            report_str = '';
            for i_str = 9:-1:0
                report_str = sprintf('%s %d,',report_str,...
                                    temp_marked_list(end-i_str));
            end
        end
        h_reportIdx.String = report_str;
        h_reportNum  = h_list(2);
        h_reportNum.String = ['Num. of marked: ', num2str(NoMarkedImg)];
        
        %% update frame_per_cycle
        if NoMarkedImg>=2
            setappdata(gcf,'frame_per_cycle',...
                floor(median(diff(temp_marked_list))));
        end
        
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

    %% Embedded function 2
    function tell_user = ui_show_message_in_figure(message)
        figure(gcf); % get the current to the front
        tell_user = uicontrol('Style','text','String',message,...
                    'Units','normalized',...
                    'Position',[0.40,0.91,0.18,0.09],...
                    'Fontsize',15,'BackgroundColor',get(gcf,'color'));
    end
    %% Embedded function 3
    function [next_img_button,previous_img_button]...
                          = ui_display_other_img(img_fdpth,file_name,...
                            format_str,next_button_position,...
                            previous_button_position,step_size,varargin)
        
        if ~isempty(varargin)
            NextPrevObjectDescription = varargin{1};
        else
            NextPrevObjectDescription = 'Img';
        end
       
        if strcmp(NextPrevObjectDescription,'Cycle')
            smartStepSize = 1;
        else 
            smartStepSize = 0;
        end
        
        nextButtonStr   = ['Next ',NextPrevObjectDescription];
        prevButtonStr   = ['Previous ',NextPrevObjectDescription];
        next_img_button =  uicontrol('Style','Pushbutton',...
                           'String',nextButtonStr,'Units','normalized',...
                           'Position',next_button_position,...
                           'Fontsize',15,'FontWeight','bold',...
                           'BackgroundColor','w',...
                           'Callback',{@next_img,img_fdpth,file_name,...
                           format_str,step_size,smartStepSize});


        function next_img(~,~,img_fdpth,file_name,format_str,step_size,...
                          smartStepSize)
            if smartStepSize == 1
                step_size = getappdata(gcf,'frame_per_cycle')-2;
            end
                
            %% update current_img_idx
            current_img_idx  = getappdata(gcf,'ref_img_idx');
            current_img_path = [img_fdpth,file_name,'_',...
                               num2str(current_img_idx,format_str),...
                               '.tif'];
            next_img_path    = [img_fdpth,file_name,'_',...
                               num2str(current_img_idx+step_size,...
                               format_str),'.tif'];
            next_img_exist    = exist(next_img_path,'file');
            if next_img_exist
                next_img      = imread(next_img_path);
            else
                next_img_path = current_img_path;
                next_img      = imread(next_img_path);
            end
            
            %% show current img
            set(gcf,'Nextplot','add');
            imshow(next_img); % this current img should be the just-loaded "next image"
            fig_name = get(gcf,'Name');
            temp     = strsplit(fig_name,'|');
            fig_name = char(temp(1)); clear temp;    

            if next_img_exist
                fig_name = [fig_name,'| No.',num2str(...
                            current_img_idx+step_size)];
                setappdata(gcf,'ref_img_idx',current_img_idx+step_size);        
            else
                fig_name = [fig_name,'| No.',num2str(current_img_idx)];
            end
            set(gcf,'Name',fig_name);
        end

        previous_img_button   =  uicontrol('Style','Pushbutton',...
                                'String',prevButtonStr,...
                                'Units','normalized',...
                                'Position',previous_button_position,...
                                'Fontsize',15,'FontWeight','bold',...
                                'BackgroundColor','w',...
                                'Callback',{@previous_img,img_fdpth,...
                                file_name,format_str,step_size,...
                                smartStepSize});

        function previous_img(~,~,img_fdpth,file_name,format_str,...
                step_size,smartStepSize)
        
            if smartStepSize == 1
                step_size = getappdata(gcf,'frame_per_cycle')-1;
            end

            %% update current_img_idx
            current_img_idx = getappdata(gcf,'ref_img_idx');  
            current_img_path  = [img_fdpth,file_name,'_',...
                                 num2str(current_img_idx,format_str),'.tif'];

            if current_img_idx > step_size
                previous_img_path = [img_fdpth,file_name,'_',...
                                     num2str(current_img_idx-step_size,...
                                     format_str),'.tif'];
            else
                previous_img_path =[img_fdpth,file_name,'_',...
                                    num2str(1,format_str),'.tif'];
            end

            prev_img_exist    = exist(previous_img_path,'file');
            if prev_img_exist
                previous_img      = imread(previous_img_path);
            else 
                previous_img_path = current_img_path;
                previous_img      = imread(previous_img_path);
            end

            %% show current img
            set(gcf,'Nextplot','add');
            fig_name = get(gcf,'Name');
            temp     = strsplit(fig_name,'|');
            fig_name = char(temp(1)); clear temp;

            if current_img_idx > step_size
                setappdata(gcf,'ref_img_idx',current_img_idx-step_size);
                imshow(previous_img);
                fig_name = [fig_name,'| No.',num2str(current_img_idx-step_size)];
                set(gcf,'Name',fig_name);
            else
                setappdata(gcf,'ref_img_idx',1);
                fig_name = [fig_name,'| No.1'];
                set(gcf,'Name',fig_name);
            end
        end                  

    end

end