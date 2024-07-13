%% Doc
% This function marks the period where the CR cell NOT beats nsynchronously
% Input:
%   DeltaPhi: phi_trans - phi_cis. 
%         or: phi_1     - phi_2    -   if cis/trans are not marked
%   Fs      : sampling rate of the phi_xxx signal. Usually 1000, as it is
%             interpolated in previous routines. 
%   keywords: "ThresholdTime", the window span to smooth the phase signal,
%               0.2 s by default
%             "ThresholdSlope", ranges of signal with slope smaller than
%               ThresholdSlope are regarded as the synchronized beating, 
%               1 beat/s by default.
%             "SlopeSign", mark which direction of slip/drift to mark
%               'abs' by default, mark all fraction that are not in sync
%               '+', mark the fraction where slope > ThresholdSlope 
%               '-', mark the fraction where slope < -1* ThresholdSlope 

function [t_async,frac_async,idx_async] = markNonSync(DeltaPhi,Fs,varargin)
    %% default settings
    syncThresTime = 0.2 ; % [sec]
    syncThresSlope= 1/Fs; % [2pi(a beat)/s]
    slopeSign     = 'abs';
    %% parse input
    NoArgInExtra = nargin - 2; 
    if NoArgInExtra > 0
        temp = strcmp(varargin,'ThresholdTime'); 
        if any(temp); syncThresTime    = varargin{find(temp)+1}; end
        temp = strcmp(varargin,'ThresholdSlope'); 
        if any(temp); syncThresSlope = varargin{find(temp)+1}; end
        temp = strcmp(varargin,'SlopeSign'); 
        if any(temp); slopeSign = varargin{find(temp)+1}; end
    end
    
    %% compute
    
%     LPF   = 100;
%     order = 4;
%     [bbp,abp] = butter(order,LPF/Fs*2,'low');
%     DeltaPhi = filtfilt(bbp,abp,DeltaPhi);
    
    slope = diff(smooth(DeltaPhi,syncThresTime*Fs));
%     slope = diff(DeltaPhi);
    
    
    t_sig = 1/Fs* numel(DeltaPhi);

    switch slopeSign
        case 'abs'
            bool_sig  = abs(slope) > syncThresSlope;
        case '+'
            bool_sig  =      slope > syncThresSlope;
        case '-'
            bool_sig  =      slope < syncThresSlope * -1;
    end
    
    %% clean short separations
    %  if merging them can create a segment that is large enough
    signalBeginWith = bool_sig(1);    
    
    [oneSegSize_list,zeroSegSize_list,...
     ~,~,...
     zeroSegFrom_list,zeroSegTo_list]  = segmentBooleanSig(bool_sig);
    
    idx_shortSeparation = find(zeroSegSize_list<syncThresTime*Fs);
    for i_short = 1:numel(idx_shortSeparation)
        i_seg = idx_shortSeparation(i_short);
        if signalBeginWith == 1 
            if i_seg+1 <= numel(oneSegSize_list)
                sizeAfterMerge = zeroSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg+1);
            else 
                sizeAfterMerge = zeroSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg);
            end
        else 
            if i_seg == 1
                sizeAfterMerge = zeroSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg);
            elseif i_seg-1 >=1 && i_seg <= numel(oneSegSize_list)
                sizeAfterMerge = zeroSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg-1);
            else
                sizeAfterMerge = zeroSegSize_list(i_seg) + ...
                                 oneSegSize_list(i_seg-1);
                
            end
        end
        
        if sizeAfterMerge > syncThresTime*1.4*Fs
            idx_start = zeroSegFrom_list(i_seg);
            idx_end   = zeroSegTo_list(i_seg);
            bool_sig(idx_start:idx_end) = 1;
        end
    end
        
    %% delete target segments that are too short
    [oneSegSize_list,~,...
     oneSegFrom_list, oneSegTo_list,~,~] = segmentBooleanSig(bool_sig);

    idx_shortDuration = find(oneSegSize_list<0.2*Fs);
    for i_short = 1:numel(idx_shortDuration)
        i_seg   = idx_shortDuration(i_short);
        idx_start = oneSegFrom_list(i_seg);
        idx_end   = oneSegTo_list(i_seg);
        bool_sig(idx_start:idx_end) = 0;
    end
    
    
    idx_async = find(bool_sig);
    t_async   = numel(idx_async)/Fs;
    frac_async = t_async/t_sig;
    
end