%Sets to process
switch scenario
    case 'Base case'
        datasets        = 4;                    %Number of datasets
        filenames       = cell(datasets);       %File names
        filenames{1}    = 'Data/Base case/4-26 9 1-750 corrected BEMsolution.mat';
        filenames{2}    = 'Data/Base case/4-25 cell1 1-750 corrected BEMsolution.mat';
        filenames{3}    = 'Data/Base case/4-25 cell2 1-750 corrected BEMsolution.mat';
        filenames{4}    = 'Data/Base case/4-25 cell3 1-750 corrected BEMsolution.mat';
        name{1}         = '4/26 9';     name{2}         = '4/25 cell1';          
        name{3}         = '4/25 cell2'; name{4}         = '4/25 cell3';
    case 'Synchrony'
        datasets        = 6;                    %Number of datasets
        filenames       = cell(datasets);       %File names
        filenames{1}    = 'Data/Synchrony/4-26 19 new BEMsolution.mat';
        filenames{2}    = 'Data/Synchrony/4-26 32 new BEMsolution.mat';
        filenames{3}    = 'Data/Synchrony/4-26 45 new BEMsolution.mat';
        filenames{4}    = 'Data/Synchrony/4-26 58 new BEMsolution.mat';
        filenames{5}    = 'Data/Synchrony/4-26 73 new BEMsolution.mat';
        filenames{6}    = 'Data/Synchrony/4-26 88 new BEMsolution.mat';
        name{1}         = '4/26 19';    name{2}         = '4/26 32';
        name{3}         = '4/26 45';    name{4}         = '4/26 58';
        name{5}         = '4/26 73';    name{6}         = '4/26 88';
    case 'Shift'
        datasets        = 16;                    %Number of datasets
        filenames       = cell(datasets);       %File names
        filenames{1}    = 'Data/Shift/Shift 0 corrected BEMsolution.mat';
        filenames{2}    = 'Data/Shift/Shift 0.125 pi corrected BEMsolution.mat';
        filenames{3}    = 'Data/Shift/Shift 0.250 pi corrected BEMsolution.mat';
        filenames{4}    = 'Data/Shift/Shift 0.375 pi corrected BEMsolution.mat';
        filenames{5}    = 'Data/Shift/Shift 0.500 pi corrected BEMsolution.mat';
        filenames{6}    = 'Data/Shift/Shift 0.625 pi corrected BEMsolution.mat';
        filenames{7}    = 'Data/Shift/Shift 0.750 pi corrected BEMsolution.mat';
        filenames{8}    = 'Data/Shift/Shift 0.875 pi corrected BEMsolution.mat';
        filenames{9}    = 'Data/Shift/Shift 1.000 pi corrected BEMsolution.mat';
        filenames{10}   = 'Data/Shift/Shift 1.125 pi corrected BEMsolution.mat';
        filenames{11}   = 'Data/Shift/Shift 1.250 pi corrected BEMsolution.mat';
        filenames{12}   = 'Data/Shift/Shift 1.375 pi corrected BEMsolution.mat';
        filenames{13}   = 'Data/Shift/Shift 1.500 pi corrected BEMsolution.mat';
        filenames{14}   = 'Data/Shift/Shift 1.625 pi corrected BEMsolution.mat';
        filenames{15}   = 'Data/Shift/Shift 1.750 pi corrected BEMsolution.mat';
        filenames{16}   = 'Data/Shift/Shift 1.875 pi corrected BEMsolution.mat';
        name{1}         = '0';          name{2}         = '-0.125\pi';
        name{3}         = '-0.25\pi';   name{4}         = '-0.375\pi';
        name{5}         = '-0.5\pi';    name{6}         = '-0.625\pi'; 
        name{7}         = '-0.75\pi';   name{8}         = '-0.875\pi';
        name{9}         = '-\pi';       name{10}        = '-1.125\pi';
        name{11}        = '-1.25\pi';   name{12}        = '-1.375\pi';
        name{13}        = '-1.5\pi';    name{14}        = '-1.625\pi';
        name{15}        = '-1.75\pi';   name{16}        = '-1.875\pi';
    case 'NoSynchrony'
        datasets        = 6;
        filenames       = cell(datasets);       %File names
        filenames{1}    = 'Data/No Synchrony/4-26 9 new BEMsolution.mat';
        filenames{2}    = 'Data/No Synchrony/4-26 17 new BEMsolution.mat';
        filenames{3}    = 'Data/No Synchrony/4-26 27 new BEMsolution.mat';
        filenames{4}    = 'Data/No Synchrony/4-26 40 new BEMsolution.mat';
        filenames{5}    = 'Data/No Synchrony/4-26 53 new BEMsolution.mat';
        filenames{6}    = 'Data/No Synchrony/4-26 68 new BEMsolution.mat';
        name{1}         = '4/26 9';     name{2}         = '4/26 17';
        name{3}         = '4/26 27';    name{4}         = '4/26 40';
        name{5}         = '4/26 53';    name{6}         = '4/26 68';
%         datasets        = 5;
%         filenames       = cell(datasets);       %File names
%         filenames{1}    = 'Data/No Synchrony/4-26 17 2000-2750 corrected BEMsolution.mat';
%         filenames{2}    = 'Data/No Synchrony/4-26 27 2000-2750 corrected BEMsolution.mat';
%         filenames{3}    = 'Data/No Synchrony/4-26 40 2000-2750 corrected BEMsolution.mat';
%         filenames{4}    = 'Data/No Synchrony/4-26 53 6000-6750 corrected BEMsolution.mat';
%         filenames{5}    = 'Data/No Synchrony/4-26 68 3000-3750 corrected BEMsolution.mat';
%         name{1}         = '4/26 17';    name{2}         = '4/26 27';    
%         name{3}         = '4/26 40';    name{4}         = '4/26 53';
%         name{5}         = '4/26 68';
end