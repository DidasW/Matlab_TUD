
img_name = '1';
fileformatstr = '%04d';
save_NoI = 0;
show_report_fig = 0;
save_report_fig = 0;
fps = 801.42;

pt_list =[0,3:14];
Npt = length(pt_list);
t_start_list = zeros(Npt,1);
t_2Fspan_list= zeros(Npt,1);
for i = 1:Npt
    pt = pt_list(i);
    img_fdpth = ['D:\001 RAW MOVIES\171029\171029\c5b3\',num2str(pt),'\'];
    save_fdpth = ['D:\004 FLOW VELOCIMETRY DATA\c16l1\',num2str(pt),'\'];
    [t_start_list(i),t_2Fspan_list(i),~,~] = determine2flashes_VID(...
                                                     img_fdpth,img_name,...
                                                     fileformatstr,fps,...
                                                     save_NoI,save_fdpth,...
                                                     show_report_fig,...
                                                     save_report_fig);
end
save('D:\000 RAW DATA FILES\171113 double flash phase delay\000 material\t_start_list,t_span_list.mat','t_start_list','t_2Fspan_list')
