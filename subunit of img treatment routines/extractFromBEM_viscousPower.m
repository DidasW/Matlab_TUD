function [P_visc_1,P_visc_2,...
          P_visc_tot           ] = extractFromBEM_viscousPower(...
                                   BEMSolutionFilePath,varargin)
    eta = 0.9544e-3; % dynamic viscosity at 22 degree Celcius Pa S
    if ~isempty(varargin)>1
        temp = strcmp(varargin,'eta');
        if any(temp)
            eta = varargin{find(temp)+1}; 
        end
        temp = strcmp(varargin,'Mute');
        if ~any(temp)
            disp('Output is in unit [W] ')
        end
    end
    
    %%
    load(BEMSolutionFilePath,'phi1','phi2')
    P_visc_1   = eta * phi1 * 1e-18; 
    P_visc_2   = eta * phi2 * 1e-18;
    P_visc_tot = P_visc_1 + P_visc_2;
    
end