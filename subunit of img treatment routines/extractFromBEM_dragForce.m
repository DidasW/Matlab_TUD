function [DragX1,DragY1,...
          DragX2,DragY2,...
          DragTot1,DragTot2] = extractFromBEM_dragForce(...
                               BEMSolutionFilePath,varargin)
    eta = 0.9544e-3; % dynamic viscosity at 22 degree Celcius Pa S
    if ~isempty(varargin)
        temp = strcmp(varargin,'eta');
        if any(temp)
            eta = varargin{find(temp)+1}; 
        end
        temp = strcmp(varargin,'Mute');
        if ~any(temp)
            disp('Output is in unit [N] ')
        end
    end
    
    %%
    load(BEMSolutionFilePath,'D1','D2')
    
    DragX1 = eta * D1(:,1) * 1e-12 ;         % [N]
    DragY1 = eta * D1(:,2) * 1e-12 ;
    DragX2 = eta * D2(:,1) * 1e-12 ;         %#ok<*IDISVAR,*NODEF> 
    DragY2 = eta * D2(:,2) * 1e-12 ;
    DragTot1 = sqrt(DragX1.^2 + DragY1.^2);
    DragTot2 = sqrt(DragX2.^2 + DragY2.^2);
    
end