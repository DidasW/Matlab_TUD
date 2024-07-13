clear all %#ok<CLALL>
close all
%%
fdpth = 'D:\000 RAW DATA FILES\181004 Lateral PTV after 180901\';
datfilestruct = dir([fdpth,'*.dat']);
NoFile = length(datfilestruct);
compileAll = 0;     %0: will detect whether it has been compiled already
                    %   and avoid recompilation

%%

for j = 1:numel(datfilestruct)
    filename = datfilestruct(j).name;
    datFilePath  = fullfile(fdpth,filename);
    matFilePath  = fullfile(fdpth,[filename(1:end-4),'.mat']);
    
    temp     = strsplit(filename,'_');
    EXP_name = temp{1}; clear temp
    
    switch compileAll 
        case 1
            PTVDataTable = readtable(datFilePath);
            EXP_code = PTVDataTable.Cell;
            lf_list  = PTVDataTable.FlagLen;
            f0_list  = PTVDataTable.FreqBeat;
            pos_list = PTVDataTable.Pos;
            xgb_list = PTVDataTable.xgb;
            ygb_list = PTVDataTable.ygb;
            NormXgb_list = PTVDataTable.NormX;
            NormYgb_list = PTVDataTable.NormY;
            Vax_list     = PTVDataTable.Vax;
            Vlat_list    = PTVDataTable.Vlat;
            NormVax_list = PTVDataTable.NormVax;
            NormVlat_list= PTVDataTable.NormVlat;
            save(matFilePath)
        case 0 % not to recompile if it has been compiled once
            if ~exist(matFilePath,'file')
                PTVDataTable = readtable(datFilePath);
                EXP_code = PTVDataTable.Cell;
                lf_list  = PTVDataTable.FlagLen;
                f0_list  = PTVDataTable.FreqBeat;
                pos_list = PTVDataTable.Pos;
                xgb_list = PTVDataTable.xgb;
                ygb_list = PTVDataTable.ygb;
                NormXgb_list = PTVDataTable.NormX;
                NormYgb_list = PTVDataTable.NormY;
                Vax_list     = PTVDataTable.Vax;
                Vlat_list    = PTVDataTable.Vlat;
                NormVax_list = PTVDataTable.NormVax;
                NormVlat_list= PTVDataTable.NormVlat;
                save(matFilePath)
            end
    end

    
end
% set(gca,'XScale','log','yscale','log')