% This function folds the NoI list, serving like "list2-sectioning" 
% in the old version. Take from_num =1 , to_num = NoI to understand
% these comments
% 
% reshape() help us get rid of the mess of chopping a long list into 
% smaller pieces and avoid the criterias (if)
% 
% The last "sublist" will be zero-padded to have the same size with others,
%                       sublist(sublist==0)=[]
% should be used to get rid of zeros before putting the sublist into
% frame_shift.
% 
% sublist_i = folded_list(:,i) (each column)

function folded_list = sectioning_num_list_to_matrix(from_num,to_num,section_size)
NoSect=floor((to_num-from_num+1)/section_size);
%Number of Sections
mod_N = mod(to_num-from_num+1,section_size);
if mod_N == 0
    folded_list = reshape(from_num:to_num,section_size,NoSect);
    %format: list,number of rows, number of columns
else
    container = zeros(1,(NoSect+1)*section_size);
    for i = from_num:to_num
        container(i) = i;
    end
    folded_list = reshape(container,section_size,NoSect+1);
end    
end