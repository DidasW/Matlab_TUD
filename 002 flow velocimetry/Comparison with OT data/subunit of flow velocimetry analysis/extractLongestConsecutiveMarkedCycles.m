function longestSegment = extractLongestConsecutiveMarkedCycles(marked_list,...
                          maxCycLength)
    marked_list = sort(marked_list);
    intervals   = diff(marked_list);
    idx  = find(intervals > maxCycLength);
    idx  = idx + 1  ;% idx of the frame at the begin of a segment
    beginIdxOfEachSeg = [1;idx];
    endIdxOfEachSeg   = [idx-1;length(marked_list)]; % end is included 
    segmentSize = endIdxOfEachSeg - beginIdxOfEachSeg;
    NoSeg            = length(segmentSize);
    [~,argmax]       = max(segmentSize);
    beginIdx         = beginIdxOfEachSeg(argmax);
    endIdx           = endIdxOfEachSeg(argmax);
    longestSegment   = marked_list(beginIdx:endIdx);
  end