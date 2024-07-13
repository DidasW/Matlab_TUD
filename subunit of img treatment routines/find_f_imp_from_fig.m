function f_imp = find_f_imp_from_fig(f1,pow1)
    [f_from_to,~]    = ginput(2);         % select area of FFT around peak of piezo (is a sharp peak)
    select_indices   = find(f1>f_from_to(1) & f1<f_from_to(2)); % IND is short for index
    [~,max_idx]      = max(pow1(select_indices));
    selected_f_range = f1(select_indices);
    f_imp            = selected_f_range(max_idx); % you can read the imposed frequency in the main window 
end