%% Doc
%{
 points discarded for oscillatory flow measurements are usually due to:
    1. many slips of the cell during particular measurements
    2. no identifiable peak in the frequency spectrum - confirmed by user
    3. bead touched by flagella, causing the waveform seriously differ 
       from BEM.
%}

%%%%%% For axial flow speed component%%%%
switch experiment
    case '170703c9l'
        pt_discard = [3];           % 3: contains no signal
    case '170703c7l'
        pt_discard = [12];          % 12: neither x nor y component shows
                                    %     a frequency peak. Cell seemed to 
                                    %     be failing (f decreased)
    case '170502c5l'
        pt_discard = [1:3];         % 1:3 signal too low
    case '171029c16l1'
        pt_discard = [0];           % 0: signal too low
    case '180419c17l'
        pt_discard = [4,9,31,24];   % 9,31: probably touching bead, 
                                    %       waveform drastically different
                                    % 4,24: signal too low
    case '180903c20a'
        pt_discard = [9:13]         % second half
    case '281002c27a'
        pt_discard = [8];         	% too close
    case '181002c28l1'
        pt_discard = [];            % keep all    
    case '181002c29l'
        pt_discard = [];         	% keep all
    case '181012c31l'               
        pt_discard = [];            % keep all
    case '181012c32l'
        pt_discard = [2];           % no signal
    case '181012c33l'
        pt_discard = [];    
    case '181207c34lt'
        pt_discard = [];    
    case '181207c35z'
        pt_discard =[10,15,20,25,...% cellbody blocked the detection laser     
                     200,250];      % 200,250:(possibly) sth swimming by  
    case '190104c36g1'
        pt_discard = [];      
    case '190104c37lc'
        pt_discard = [1];           % no sig 
    case '190409c52l'
        pt_discard = [1:2];         % signal too low
    case '190409c53l'    
        pt_discard = [7,9,10,11,12];% 7,9,10 slips too much
                                    % 11, 12 no signal
    case '190409c51lz'    
        pt_discard = [2:5];         % no signal, 4 always slip 
    case '190409c53lz'    
        pt_discard = [2];           % signal too low         
    case '190409c54lz'    
        pt_discard = [1,3,6,8];     % 1,3,6 no signal; 
                                    % 8, slips too much
    case '190409c55lz'    
        pt_discard = [];            % keep all
    case '190414c56g2'
        pt_discard = [301:2:311,...  % except 401:2:411,
            501:2:511,512,...
            607:2:611,612];
    case '190414c56g3'
        pt_discard = [502:2:510,...  % except 400:2:412,
            601,602,603:2:607];
 
    otherwise 
        pt_discard = [];              
end
