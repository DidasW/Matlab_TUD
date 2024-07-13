% marked_list = manual_mark_img_sequence(img_fdpth,img_name,fileformatstr);
% marked_list = unique(marked_list);
% t_start     = t_start_list(2);
% Fs:           [Hz]

function [sig_whole_interp,t_whole_interp] = ...
                            generate_artificial_signal_by_marked_list(...
                                   sig_modular,marked_list,t_start,fps,Fs)
    %% Prepare the whole time axis
    t_1stFrame  = t_start;
    t_marked    = t_1stFrame + (marked_list-1)/fps*1000;
    t_whole_interp = t_marked(1):1/Fs*1000:t_marked(end);
    sig_whole_interp = zeros(size(t_whole_interp));
    
    %%
    N_marked_t  = length(t_marked);
    N_modular   = length(sig_modular);
    for i_mark = 1:N_marked_t-1
        t_seg_start = t_marked(i_mark);
        t_seg_end   = t_marked(i_mark+1);
        idx_seg     = find(((t_whole_interp>=t_seg_start).*...
                          (t_whole_interp<t_seg_end))>0);
        t_seg       = linspace(t_seg_start,t_seg_end,N_modular);
        t_seg_interp= t_whole_interp(idx_seg);
        sig_seg_interp =  interp1(t_seg,sig_modular,t_seg_interp,'spline');
        sig_whole_interp(idx_seg) = sig_seg_interp;
    end
end
