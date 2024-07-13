function [NoFd,NoI,Fs,section_size,...
          process_all_img,to_save_all_shift,...
          to_save_all_adjust]              = ask_user_all(SFL,NoFd,Fs,section_size)
                                    

different_NoI_or_not = questdlg('Process all the images in each folder?',...       % question message   
                        'Number of img in each folder', ...% dialogue title
                    	'Yes','No',...   % Button names
                        'Yes');          % default choice 
switch different_NoI_or_not
    case 'No'
        process_all_img = 0;
        v_raw =  inputdlg('How many images per folder?');
        NoI = str2double(v_raw{1});
        if NoI<section_size
            warning('Section size>NoI,disable sectioning')
            section_size = NoI;
        end
        
        [to_save_all_shift, choice_str_shift ]...
                        = ask_user_whether_to_save_all('shifted','None');
        [to_save_all_adjust,choice_str_adjust]...
                        = ask_user_whether_to_save_all('adjusted','All');
                       
        check_image_amount(SFL,NoI,'NoI'); %check whether all the folders has enough images
        check_message = {'Check the input:';...  % question message
                         sprintf('No. of folders    : %d',NoFd);...            
                         sprintf('No. of Img per folder: %d',NoI);...
                         sprintf('Sampling freq.    :%.2fHz',Fs);...
                         sprintf('Sectioning        :%d Img',section_size);...
                         sprintf('Save shifted imgs :%s',choice_str_shift);...
                         sprintf('Save adjusted imgs:%s',choice_str_adjust);...
                         };

    case 'Yes'
        process_all_img = 1;
        NoI = -1;                                % it will be determined later
        
        [to_save_all_shift, choice_str_shift ]    = ask_user_whether_to_save_all('shifted','None');
        [to_save_all_adjust,choice_str_adjust]    = ask_user_whether_to_save_all('adjusted','All');
                
        check_message = {'Check the input:';...  % question message
                         sprintf('No. of folders    : %d',NoFd);...            
                         sprintf('Process all the images');...
                         sprintf('Sampling freq.    :%.2fHz',Fs);...
                         sprintf('Sectioning        :%d Img',section_size);...
                         sprintf('Save shifted imgs :%s',choice_str_shift);...
                         sprintf('Save adjusted imgs:%s',choice_str_adjust);...
 
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