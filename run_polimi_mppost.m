function [] = run_polimi_mppost(working_directory,mcnp_path,input_file_name_Am241,input_file_name_Pu240)

fid = fopen('myjob.bat','r');
tline = fgetl(fid);
line_number = 1;
while ischar(tline)
    file_lines{line_number} = tline;
    tline = fgetl(fid);
    line_number = line_number+1;
end
fclose(fid);

fid = fopen("myjob.bat","wt");
fprintf(fid,"%s \n",file_lines{1});
fprintf(fid,"%s \n",file_lines{2});
fprintf(fid,"%s \n",file_lines{3});
fprintf(fid,"polimi i=%s d=%s o=%s r=%s \n",input_file_name_Am241 + ".i",input_file_name_Am241 + ".d", ...
        input_file_name_Am241 + ".o", input_file_name_Am241 + ".r");
fprintf(fid,"polimi i=%s d=%s o=%s r=%s \n",input_file_name_Pu240 + ".i",input_file_name_Pu240 + ".d", ...
        input_file_name_Pu240 + ".o", input_file_name_Pu240 + ".r");
fprintf(fid,"cd %s \n",mcnp_path);

%move .txt and .d input files to mppost directory
fprintf(fid,"/bin/mv %s/mppost_%s.txt %s/mppost_%s.txt \n",working_directory,input_file_name_Am241,mcnp_path,input_file_name_Am241);
fprintf(fid,"/bin/mv %s/mppost_%s.txt %s/mppost_%s.txt \n",working_directory,input_file_name_Pu240,mcnp_path,input_file_name_Pu240);
fprintf(fid,"/bin/mv %s/%s.d %s/%s.d \n",working_directory,input_file_name_Am241,mcnp_path,input_file_name_Am241);
fprintf(fid,"/bin/mv %s/%s.d %s/%s.d \n",working_directory,input_file_name_Pu240,mcnp_path,input_file_name_Pu240);

fprintf(fid,"./mppost.exe mppost_%s.txt    \n",input_file_name_Am241);
fprintf(fid,"./mppost.exe mppost_%s.txt    \n",input_file_name_Pu240);

% move .txt, .d, and output files back to working directory
fprintf(fid,"/bin/rm %s/mppost_%s.txt      \n",mcnp_path,input_file_name_Am241);
fprintf(fid,"/bin/rm %s/mppost_%s.txt      \n",mcnp_path,input_file_name_Pu240);
fprintf(fid,"/bin/rm %s/%s.d               \n",mcnp_path,input_file_name_Am241);
fprintf(fid,"/bin/rm %s/%s.d               \n",mcnp_path,input_file_name_Pu240);
fprintf(fid,"/bin/rm %s/mppost_output_%s.o \n",mcnp_path,input_file_name_Am241);
fprintf(fid,"/bin/rm %s/mppost_output_%s.o \n",mcnp_path,input_file_name_Pu240);

fprintf(fid,"/bin/mv %s/mppost_output_%s_All_pulses.o %s/mppost_output_%s_All_pulses.o \n",mcnp_path,input_file_name_Am241,working_directory,input_file_name_Am241);
fprintf(fid,"/bin/mv %s/mppost_output_%s_All_pulses.o %s/mppost_output_%s_All_pulses.o \n",mcnp_path,input_file_name_Pu240,working_directory,input_file_name_Pu240);

fclose(fid);

system('./myjob.bat')

fprintf("\n\nInput Files %s and %s Succesfully Run \n\n",input_file_name_Am241,input_file_name_Pu240);
end