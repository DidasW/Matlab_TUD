%%calccapStokes  calculates big M matrix for pipette + cell body
%% Add paths
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
%% Settings
close all; 
clear all;

% Define INPUT File
pipettefile =  'pipette_20190320_c03BEM'; %'pipette_4-25_cell3_397_309';


%%
matfile= sprintf('%s.mat',pipettefile);

% Define speed configuration // rigid body motion 
U(1) = 0;               % U is the velocity translation
U(2) = 1;
U(3) = 0; 

W(1) = 0;               % W is the rotation velocity
W(2) = 0;
W(3) = 0;

% Read in the panels
load(matfile)
fprintf('read input file\n');

% Compute the panel centroids and areas (don't need the normals).
[centroids,normals,areas] = gencolloc(panels);
fprintf('generated collocation points\n');

%%
% Define geometry of line distribution of stokeslet and rotlet
Xmax  = max(centroids(:,1));        % max X for point on surface of obj
Xmin  = min(centroids(:,1));        % min X for point on surface of obj
XG    = (Xmax+Xmin)/2;
XS    = [0.5 0 0];                  % Useless
e     = 0.9;                        % Scaling factor for points on x axis
param = struct('XS',XS,'XG',XG,'e',e);

% Generate the collocation matrix
[MATRIX,LINE_S,LINE_R,COLN_S,COLN_R] = collocationStokes(panels,centroids,normals,param,0);
fprintf('generated matrix\n'); % fprintf('Condition number: %3.15f',cond(MATRIX));
save(matfile,...
    'panels','centroids','normals','areas','MATRIX','LINE_S',...
    'LINE_R','COLN_S','COLN_R','param','-append')

% Create the RHS
[r,c]           = size(MATRIX);
[U_t,U_r]       = U_colloc(U,W,centroids,r/3);
RHS             = (U_t+U_r); 
%%
% Solve for the stokeslet density vector
f = MATRIX \(-RHS) ; 

%%
% Plot singulartiy density
f = reshape(f,[3,r/3])';
for i=1:3 
subplot(2,2,i)    
plotpanelsStokes(panels,f(:,i))
view(3)
axis equal
colorbar
% cameratoolbar
pause
end