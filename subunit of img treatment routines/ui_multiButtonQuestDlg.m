function returnStr = ui_multiButtonQuestDlg(ButtonStringList,...
                                            questionStr,varargin)
     
    dlgBoxPosition = [0.35 0.42 0.3 0.16];
    if nargin-2>0
        temp = strcmp(varargin,'Position'); 
        if any(temp) 
           dlgBoxPosition = varargin{find(temp)+1}; 
        end
    end
                                        
    dialog_box = dialog('Units','normalized','Position',...
                        dlgBoxPosition,'Name','Tell me');
    setappdata(dialog_box,'choice','');
    
    uicontrol('Parent',dialog_box,'Units','normalized',...
              'Position',[0.2 0.7 0.6 0.2],'Style','text',...
              'String',questionStr,...
              'Fontsize',12,'Fontweight','bold');
    
    NoStr  = numel(ButtonStringList);
    %% locate each button
    buttonPosList = zeros(NoStr,4);
    buttonSpacing = 1/NoStr * 0.2;
    buttonWidth   = 1/NoStr * 0.8;
    % button positions, y
    buttonPosList(:,2) = 0.1;
    buttonPosList(:,4) = 0.25;
    % button positions x
    for i_butt = 1:NoStr
        buttonPosList(i_butt,1) = buttonSpacing*0.5 + (i_butt-1)*(1/NoStr);
        buttonPosList(i_butt,3) = buttonWidth;
    end
    
    % loop twice only for readability
    for i_butt = 1:NoStr
        buttonStr = ButtonStringList{i_butt};
        buttonPostion = buttonPosList(i_butt,:);
        uicontrol('Parent',dialog_box,'Units','normalized',...
            'Position',buttonPostion,'Style','Pushbutton',...
            'String',buttonStr,...
            'Callback',{@pass_string,buttonStr});
    end
                          
    function pass_string(~,~,string)
        setappdata(dialog_box,'choice',string);
        uiresume(dialog_box)
    end
                      
    uiwait(dialog_box);
    returnStr = getappdata(dialog_box,'choice');
    delete(dialog_box);
end
       