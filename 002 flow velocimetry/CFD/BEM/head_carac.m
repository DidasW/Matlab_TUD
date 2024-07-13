function [acell,bcell,dcell,l]=head_carac(AR,alpha,l,Cell,link)

exc    = max( sqrt(1-AR^2) , 10e-3 ); 
% Exact value
acell =  16*pi*exc^3/(-2*exc + (1+  exc^2)*log((1+exc)/(1-exc))) ;
bcell =  32*pi*exc^3/( 2*exc + (3*exc^2-1)*log((1+exc)/(1-exc))) ;
dcell =  32*pi*exc^3/(-2*exc + (1+  exc^2)*log((1+exc)/(1-exc))) *(2-exc^2)/3 ;
 