%December 2006
%Daniel TAM
%Function take as Input: - All outputs to be printed
%                 Ouput: - none           


function [] = print_output(aa,Eff,Dist,Work_ext)

fid1 =  fopen('Eff.out' ,'a');
fid2 =  fopen('Dist.out' ,'a');
fid3 =  fopen('Work.out' ,'a');
fid4 =  fopen('Coeff.out','a');
fid5 =  fopen('min.inp','w');

fprintf(fid1,'%3.30f\n',Eff);
fprintf(fid2,'%3.30f\n',Dist);
fprintf(fid3,'%3.30f\n',Work_ext);
fprintf(fid4,'%3.20f ',aa);
fprintf(fid4,'\n');
fprintf(fid5,'%3.20f ',aa);
fprintf(fid5,'\n');

fclose(fid1);                                 
fclose(fid2);
fclose(fid3);
fclose(fid4); 
fclose(fid5);        