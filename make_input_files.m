function [input_file_name] = make_input_files(t_copper,t_tin,input_file_number,random_number)

% description: takes in copper thickness, tin thickness, and input file number and writes MCNP input files 
% returns: input filename w/o extension as a string.  
% restriction: thicknesses must be 0<t<99 and units are cm.

%% Make Am-241 Files
% Read in the template file

FID = fopen('thicc_template_Am241.template','r');
    antelope = 1;
        tline       = fgetl(FID);
        A{antelope} = tline;
    while ischar(tline)
        antelope    = antelope+1;
        tline       = fgetl(FID);
        A{antelope} = tline;
    end
fclose(FID);

% Edit the tin-copper graded shield lines
A{175} = ['  71 RPP ',num2str(50.00-t_copper),' 50.00 -16.51 16.51 -16.51 16.51   $ Copper'];
A{176} = ['  72 RPP ',num2str(50.00-t_copper-t_tin),' ',num2str(50.00-t_copper-(1e-6)),' -16.51 16.51 -16.51 16.51   $ Tin'];

input_file_name{1} = sprintf("input_file_%d_Am241",input_file_number);

% Create and write to new file
FID = fopen(fullfile(pwd,input_file_name{1} + ".i"), 'w');
for bird = 1:numel(A)
    if A{bird+1} == -1
        fprintf(FID,'%s', A{bird});
        break
    else
        fprintf(FID,'%s\n', A{bird});
    end
end
fclose(FID);

%Make 2 new MPPost input files

FID = fopen('MPPost_input.template','r');
    cheetah = 1;
        tline       = fgetl(FID);
        B{cheetah} = tline;
    while ischar(tline)
        cheetah    = cheetah+1;
        tline       = fgetl(FID);
        B{cheetah} = tline;
    end
fclose(FID);

B{19} = sprintf('polimi_det_in           %s.d     # MCNP-PoliMi detector filename',input_file_name{1});
B{21} = sprintf('output_file             mppost_output_%s    # Desired output name',input_file_name{1});

FID = fopen( sprintf('mppost_%s.txt',input_file_name{1}) , 'wt');
for donkey = 1:numel(B)
    if B{donkey} == -1
        fprintf(FID,'%s', B{donkey});
        break
    else
        fprintf(FID,'%s\r\n', B{donkey});
    end
end
fclose(FID);


%% Make Pu-240 Files
% Read in the template file
FID = fopen('thicc_template_Pu240.template','r');
    antelope = 1;
        tline       = fgetl(FID);
        A{antelope} = tline;
    while ischar(tline)
        antelope    = antelope+1;
        tline       = fgetl(FID);
        A{antelope} = tline;
    end
fclose(FID);

% Edit the composite shielding lines
A{175} = ['  71 RPP ',num2str(50.00-t_copper),' 50.00 -16.51 16.51 -16.51 16.51   $ Copper'];
A{176} = ['  72 RPP ',num2str(50.00-t_copper-t_tin),' ',num2str(50.00-t_copper),' -16.51 16.51 -16.51 16.51   $ Tin'];

input_file_name{2} = sprintf("input_file_%d_Pu240",input_file_number);

% Create and write to new file
FID = fopen(fullfile(pwd,input_file_name{2} + ".i"), 'w');
for bird = 1:numel(A)
    if A{bird+1} == -1
        fprintf(FID,'%s', A{bird});
        break
    else
        fprintf(FID,'%s\n', A{bird});
    end
end
fclose(FID);

FID = fopen('MPPost_input.template','r');
    cheetah = 1;
        tline       = fgetl(FID);
        B{cheetah} = tline;
    while ischar(tline)
        cheetah    = cheetah+1;
        tline       = fgetl(FID);
        B{cheetah} = tline;
    end
fclose(FID);

B{19} = sprintf('polimi_det_in           %s.d     # MCNP-PoliMi detector filename',input_file_name{2});
B{21} = sprintf('output_file             mppost_output_%s    # Desired output name',input_file_name{2});

FID = fopen( sprintf('mppost_%s.txt',input_file_name{2}) , 'wt');
for donkey = 1:numel(B)
    if B{donkey} == -1
        fprintf(FID,'%s', B{donkey});
        break
    else
        fprintf(FID,'%s\r\n', B{donkey});
    end
end
fclose(FID);

end