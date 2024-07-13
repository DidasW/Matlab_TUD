%% Doc
%{
 points discarded for oscillatory flow measurements are usually due to:
    1. no identifiable peak in the frequency spectrum - confirmed by user
    2. bead touched by flagella, causing the waveform seriously differ 
       from BEM.
 This one should be a subset of AA98. Since if a cell slips, the
 oscillatory flow amplitude will not be normal, nevertheless, one can
 mark several consecutive normal cycle and still obtain a phase delay
%}


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
                                    %
    case '181002c28l1'
        pt_discard = [];
    case '190409c51lz'    
        pt_discard = [2:3];         % no signal 
    case '190409c53l'    
        pt_discard = [8:12];        % no signal 
    case '190409c53lz'    
        pt_discard = [2:3];         % no signal 
    otherwise 
        pt_discard = [];              
end
