function [ratio,NoE] = get_info_IPAP(flag_f,f_threshold)
    f_IP = flag_f;
    f_IP(f_IP>f_threshold) = [];
    NoI_IP = length(f_IP);
    ratio = NoI_IP/length(flag_f);

    flag_f_shift = flag_f - f_threshold;
    f_event = flag_f_shift(1:end-1).*flag_f_shift(2:end);
    f_event(f_event>0) = [];
    NoE = length(f_event);
end