function [to_save_all,choice_string] = ask_user_whether_to_save_all(message,default_str)
save_all_or_not = questdlg(sprintf('Save all %s image of each folder?',message),... % question message   
                           'Your choice', ...% dialogue title
                    	   'All','Random','None',...   % Button names
                           default_str);           % default choice 

switch save_all_or_not
    case 'All'
        to_save_all   = 1;
        choice_string = 'All';
    case 'Random'
        to_save_all = 0.5;
        choice_string = 'Random';
    case 'None'
        to_save_all = 0;
        choice_string = 'None';
end

end