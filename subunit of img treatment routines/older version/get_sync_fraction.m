% function to calculate how much time the flagella stayed in sync with the
% imposed frequency, using information collected from the variable named "phase1(2)"
% 

function [time_sync_fraction] = get_sync_fraction(time_inter,phase,thres_slope,thres_duration,slope_range)
    if nargin <5
        slope_range = 4.0;
        % default values
    end
    if nargin <4
        error('wrong number of input')
    end
    
    d = floor(slope_range);
    % d is half of the range we use to calculate the average slope    
    
    size_t = length(time_inter);
    size_phase = length(phase);
    if size_t ~= size_phase
        error('Two input array must have the same size')
    else
        time_cut = time_inter(1+d:end-d);
        slope = abs((phase(1+2*d:end) - phase(1:end-2*d))/(2*d));
        % this slope has the same size of the time_cut array. Each element
        % denotes the slope(rate) of phase deviation between the flag. and
        % the piezo
        SoN = zeros(length(slope)); % synchronize or not? 0 for sync, 1 for not
        SoN(slope>thres_slope)=1;
        SoN = SoN-0.5; %change to -0.5 and 0.5
        t_index = find((SoN(1:end-1).*SoN(2:end))<0);
        % t_index: index of SoN where Transition happens
        % e.g.: t_index = [3,50,32] means in SoN(4) will be different from
        %   SoN(3), SoN(51) differnt from SoN(50)
        
        
        % N index find, N+1 different sections.  
        % First section: from 1:transition_index(1)
        if isempty(t_index)
            time_sync_fraction = abs(SoN(1)-0.5); %no transition, all the values are the same
        else
            time_sync = 0;
            section_size  =  t_index(1);
            section_value =  SoN(2); 
            if section_value <0    &&   section_size  >= thres_duration
                time_sync = time_sync + section_size ;
            end

            % Sections in the middle
            for i = 1:(length(t_index)-1)
                section_size  =  t_index(i+1)-t_index(i);
                section_value =  SoN(t_index(i)+1); 
                if section_value <0    &&   section_size  >= thres_duration
                    time_sync = time_sync + section_size ;
                end
            end

            % Last section: from transition_index(end):length(SoN)
            section_size  =  length(SoN)-t_index(end);
            section_value =  SoN(t_index(end)+1); 
            if section_value <0    &&   section_size  >= thres_duration
                time_sync = time_sync + section_size ;
            end
            
            time_sync_fraction = time_sync/length(time_cut);
        end
    end
end