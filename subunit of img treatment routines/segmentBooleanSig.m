%% Doc
%  Often it is desirable to segment a boolean signal into ranges of ones
%  and zeros. This function does that, and gives the starting/ending index
%  of each 1- and 0-segments, as well as the sizes of each of them

function [oneSegSize_list,zeroSegSize_list,...
          oneSegFrom_list, oneSegTo_list,...
          zeroSegFrom_list,zeroSegTo_list]   = segmentBooleanSig(bool_sig)   

    [oneSegFrom_list, oneSegTo_list,...
     zeroSegFrom_list,zeroSegTo_list]   = deal([]); 
 
    for i = 1:numel(bool_sig)
        if i == 1
            previousState = bool_sig(1);
            currentState  = bool_sig(1);
            if currentState == 1
                oneSegFrom_list = [oneSegFrom_list,1];
            else               
                zeroSegFrom_list = [zeroSegFrom_list,1];
            end
            continue
        end
        
        if i > 1 && i< numel(bool_sig)
            currentState  = bool_sig(i);
            if currentState == previousState 
                continue
            else
                switch previousState
                    case 0 % i marks the begin of a 1-segment, 
                           % and the end of a 0-segment 
                        oneSegFrom_list = [oneSegFrom_list,i];
                        zeroSegTo_list  = [zeroSegTo_list,i-1];
                    case 1
                        zeroSegFrom_list = [zeroSegFrom_list,i];
                        oneSegTo_list  = [oneSegTo_list,i-1];
                end
            end
            previousState   = currentState;
            continue
        end
        
        if i == numel(bool_sig)
            currentState  = bool_sig(i);
            if currentState == previousState 
                switch previousState
                    case 0 % a 0-seg last till the end  
                        zeroSegTo_list  = [zeroSegTo_list,i];
                    case 1
                        oneSegTo_list  = [oneSegTo_list,i];
                end
            else % currentState ~= previousState 
                 switch previousState
                   case 0 % i marks the begin of a 1-segment, 
                           % and the end of a 0-segment 
                        oneSegFrom_list = [oneSegFrom_list,i];
                        oneSegTo_list   = [oneSegTo_list,i];
                        zeroSegTo_list  = [zeroSegTo_list,i-1];
                    case 1
                        zeroSegFrom_list = [zeroSegFrom_list,i];
                        zeroSegTo_list   = [zeroSegTo_list,i];
                        oneSegTo_list    = [oneSegTo_list,i-1];
                end
            end
        end
    end
    
    oneSegSize_list  = oneSegTo_list  - oneSegFrom_list  + 1;
    zeroSegSize_list = zeroSegTo_list - zeroSegFrom_list + 1;
end