function [treatment]=determine_filter_type(LPF_checkbox,HPF_checkbox,notch_checkbox)
    % based on the combination of the selection of the checkboxes,
    % determine the final filter type used.
    LHn = [num2str(LPF_checkbox),num2str(HPF_checkbox),...
           num2str(notch_checkbox)];
    % LHn, 3 element tuple represent the combination of filter setting
    switch LHn
        case '000'; treatment = 'LPF'; % default
        case '001'; treatment = 'notch';
        case '010'; treatment = 'HPF';
        case '011'; treatment = 'HPF+notch';
        case '100'; treatment = 'LPF';
        case '101'; treatment = 'LPF+notch';
        case '110'; treatment = 'BPF';
        case '111'; treatment = 'BPF+notch';
    end
end