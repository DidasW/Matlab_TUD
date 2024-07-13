%December 2006
%Daniel TAM

function [a_four,b_four] = adapt_format_chlam(N,MaxTerm,aa) 
% Output:
%   - a_four          
%   - b_four       
% Input:
%   - aa:          Fourier coeff in raw format
%   - N:           # of links
%   - MaxTerm:     # of terms in fourier development


a_four=zeros(MaxTerm+1  ,N);    % [a1 a2 ... aMaxTerm a0] 
b_four=zeros(MaxTerm    ,N);    % [b1 b2 ... bMaxTerm]
for p=2:(N+1)/2
j = (  p-2)*(2*MaxTerm+1);  
% a_four(1:MaxTerm+1,p)     = aa((j        +1):(j+  MaxTerm+1))';
% b_four(1:MaxTerm  ,p)     = aa((j+MaxTerm+2):(j+2*MaxTerm+1))';
% a_four(1:MaxTerm+1,N+2-p) = aa((j        +1):(j+  MaxTerm+1))';    % Construct a_four for other half of swimmer
% b_four(1:MaxTerm  ,N+2-p) = aa((j+MaxTerm+2):(j+2*MaxTerm+1))';    % by symmetry (CHLAMY is symmetric!!!)
a_four(1:MaxTerm+1,p)     = aa((j        +1):(j+  MaxTerm+1))';
b_four(1:MaxTerm  ,p)     =-aa((j+MaxTerm+2):(j+2*MaxTerm+1))';
a_four(1:MaxTerm+1,N+2-p) = aa((j        +1):(j+  MaxTerm+1))';    % Construct a_four for other half of swimmer
b_four(1:MaxTerm  ,N+2-p) =-aa((j+MaxTerm+2):(j+2*MaxTerm+1))';    % by symmetry (CHLAMY is symmetric!!!)
end  