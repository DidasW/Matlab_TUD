%% Doc
%{
 points discarded for avg flow measurements are usually due to:
    1. passing-by cells
    2. dirt trapped in the middle of an experiment (pt after a point is
    trashed)
    3. bead touched by flagella.
%}

switch experiment 
    case '190409c54lz'    
        pt_discard = [1:3,8]; % 1-3,no sig; 8, slips too much;
    case '190409c51lz'
        pt_discard = [4];     %  4 always slip
    case {'190409c53l'}
        pt_discard = [7:12];  % 8:12 ~4Hz extremely strong noise.
                              % 7: cell slips a lot
    case {'190224c46l'}
        pt_discard = [11:13]; 
    case {'190214c40l','190214c42l','190214c43l'}
        pt_discard = [17:18]; % The other side of the cell.
    case{'181207c34zt','181207c34zc'}
        pt_discard = [-5];    % Cell's shadow blocked detection laser,
                              % Beads were moving a lot while there is not
                              % signal
    case '181012c33l'
        pt_discard = [];
    case '181207c34z'
        pt_discard = [10,15,20]; % the cell's shadow has 
                                 % blocked the detection laser
    case '181207c34a'
        pt_discard = [];      % keep all
    case '181207c35a'
         pt_discard = [1:99];  % discard all, strong inversion of 
                               % 25 micron/s, dirt attached  
    case '281002c28a'
        pt_discard = [3,9:12];    % 9-12 the trip back (in fact it is in 
                                  %  line with the previous data)
                                  % 3: the cell constantly slip
    case '281002c27a'
        pt_discard = [9:12]; % the backward going 
    case '180419c17l'
        pt_discard = [4,9,24,31]; % 9,31,cell touching bead;
                                  % 4,24,no signal
    case '280903c20a'
        pt_discard = [2,8:13];    % 8 to 13, second half discarded, 
                                  % 2: jumps in the average signal
    case '280903c21a'
        pt_discard = 8:13;        % 9-13 are zero shifted heavily, 50 um/s.

    case {'180810c2c','180810c3c'} % second half
        pt_discard = [11:19];
    case {'180821c3m','180821c4m',...
          '180821c5m'}             % second half
        pt_discard = [11:19];    
    case '190414c56g2'
        pt_discard = [301:2:311,...  % except 401:2:411, where the bead 
            501:2:511,512,...        % aligns with the flagellar base
            607:2:611,612];
    case '190414c56g3'
        pt_discard = [502:2:510,...  % except 400:2:412, where the bead 
            601,602,603:2:607];      % aligns with the flagellar base
    otherwise
        pt_discard = [];
end