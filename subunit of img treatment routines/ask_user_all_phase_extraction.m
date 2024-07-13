function [NoI,process_all_img]   = ask_user_all_phase_extraction(SFL,NoFd,Fs,window_size,window_overlap)
                                    

different_NoI_or_not = questdlg('Process all the images in each folder?',...       % question message   
                        'Number of img in each folder', ...% dialogue title
                    	'Yes','No',...   % Button names
                        'Yes');          % default choice 
switch different_NoI_or_not
    case 'No'
        process_all_img = 0;
        v_raw =  inputdlg('How many images per folder?');
        NoI = str2double(v_raw{1});
                   
        check_image_amount(SFL,NoI,'NoI'); %check whether all the folders has enough images
        check_message = {'Check the input:';...  % question message
                         sprintf('No. of folders    : %d',NoFd);...            
                         sprintf('No. of Img per folder: %d',NoI);...
                         sprintf('Sampling freq.    :%.2fHz',Fs);...
                         sprintf('Spectrogram win_size: %d',window_size);...
                         sprintf('Spectrogram win_overlap: %d',window_overlap);
                        };

    case 'Yes'
        process_all_img = 1;
        NoI = -1;                                % it will be determined later
                check_message = {'Check the input:';...  % question message
                         sprintf('No. of folders    : %d',NoFd);...            
                         sprintf('Process all the images');...
                         sprintf('Sampling freq.    :%.2fHz',Fs);...
                         sprintf('Spectrogram win_size: %d',window_size);...
                         sprintf('Spectrogram win_overlap: %d',window_overlap);
                         };
end


SC_summary = questdlg(  check_message,...               % question message
                        'SANITY CHECK', ...             % dialogue title
                    	'Yes, proceed','No, stop',...   % Button names
                        'Yes, proceed');                % default choice 
switch SC_summary
    case 'No, stop'
        error('ERROR: Stopped by an insane user')
    case 'Yes, proceed'
        disp('Wise choice')
end
                                    
end