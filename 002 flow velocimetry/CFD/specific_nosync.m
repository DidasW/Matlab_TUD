% trunccycles = [6 12 17 21 22 27 32 36 41 47];    %Trunccycles 5
trunccycles = [5 12 17 23 29 36 42];    %Trunccycles 6
cycind = round(0.5.*(avgbeat{6,1}.locs(trunccycles)+avgbeat{6,1}.locs(trunccycles+1)));

trunc.phasediff = mean(mod(phasediff_act_cyc{6,1}(trunccycles),2*pi));
trunc.Wv_cyc    = 2.*mean(avgbeat{6,1}.Wv_cyc(trunccycles));
trunc.Wv_cycdl  = trunc.Wv_cyc/trapz(BC426.meantime,BC426.meanPv);
trunc.f_cyc     = mean(avgbeat{6,1}.f_cyc(trunccycles));
trunc.f_cycdl   = trunc.f_cyc/BC426.fcell;
trunc.xamp      = mean(avgbeat{6,1}.xamp(trunccycles));
trunc.xampdl    = trunc.xamp/BC426.xamp;
trunc.area      = mean(avgbeat{6,1}.area(trunccycles));
trunc.areadl    = trunc.area/BC426.area;

for dd=1:datasets
    ydata1 = Pvdl{dd,3};
    ydata2 = Pedl{dd,3};
    ydata3 = Ptdl{dd,3};
    Pvdl_RMS(dd) = rms(ydata1);
    Pedl_RMS(dd) = rms(ydata2);
    Ptdl_RMS(dd) = rms(ydata3);
    Pvdl_pk(dd) = max(max(ydata1),abs(min(ydata1)));
    Pedl_pk(dd) = max(max(ydata2),abs(min(ydata2)));
    Ptdl_pk(dd) = max(max(ydata3),abs(min(ydata3)));
    Pvdl_pk2RMS(dd) = Pvdl_pk(dd)/Pvdl_RMS(dd);
    Pedl_pk2RMS(dd) = Pedl_pk(dd)/Pedl_RMS(dd);
    Ptdl_pk2RMS(dd) = Ptdl_pk(dd)/Ptdl_RMS(dd);
end

Pvdl_RMS
Pedl_RMS
Ptdl_RMS
Pvdl_pk
Pedl_pk
Ptdl_pk
Pvdl_pk2RMS
Pedl_pk2RMS
Ptdl_pk2RMS