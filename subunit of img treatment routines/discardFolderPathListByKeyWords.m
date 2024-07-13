function fdList = discardFolderPathListByKeyWords(fdList,keyStringCell)
    idx_keep = ~contains(fdList,keyStringCell);
    fdList  = fdList(idx_keep);
end
                        