% September 2007
% Daniel TAM
% Function take as Input: - all input necessary for comput_swim
%                         - Fourier coefficients
%                  Ouput: - calls           

% function [Dist] = swim_chlam(link,N,Nc,Cell,l,MaxTerm,interac,lubric,impose,t_half,Tol,MOVIE,aa)
function [Eff] = swim_chlam(link,N,Nc,Cell,l,MaxTerm,Opt_param,lubric,impose,Tol,MOVIE,aa) 

% impose: Define constraints applied:
%         impose=1 : impose everything (no geometry optimization)
%         impose=2 : impose radius + max length of flagelum (flag length opt)
%         impose=3 : impose volume and total length 
%         impose=4 : impose just the volume

%  interac : = 0 interaction off     || = 1 interaction on
%  lubric  : = 0 lubrication off     || = 1 interaction on
%  MOVIE   : = 0 no MOVIE            || = 1 MOVIE made
MOVIE=1; 

%=============================== Define geometry of swimmer ===================================%

l_tot=sum(l(1:(Cell-1)));           % Characteristic length of flagella

  l              = link(3)/(2*l_tot)*l;  
  l_tot          = link(3)/2;
  rad            = link(2);         % Characteristic radius of the slender body 
  Slend          = rad/(2*l_tot);
  lcell          = link(4);
  l(max(Cell,1)) = abs(sin(link(5)))*lcell*link(6);
  shape          = link(8);
  Volume         = 4*pi/3 *lcell^3*link(6)^2;
  ARhead         = link(6);

llink(1) = Slend;               % Slenderness
llink(2) = rad;                 % Radius
llink(3) = l_tot;               % Flagella length
llink(4) = lcell;               % Characterisitc radius of cell body
llink(5) = link(5);             % angle between the 2 attachment of the flag
llink(6) = ARhead;              % Aspect ratio of the head
llink(7) = Volume;              % Volume of the Head
llink(8) = shape;               % shape
llink(9) = link(9);             % Empty parameter
llink(10)= link(10);            % Empty parameter

%============================== Adapt fourier coeff format  ===================================%

[a_four,b_four]=adapt_format_chlam(Nc,MaxTerm,aa)

%==================================== Start computation =======================================%

[Dist,Work_ext,Eff]=comput_stroke(llink,N,Nc,Cell,l,MOVIE,a_four,b_four,MaxTerm,Opt_param,lubric,Tol);

