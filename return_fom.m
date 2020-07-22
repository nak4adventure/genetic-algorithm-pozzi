function [fom] = return_fom(input_file_name_Am241,input_file_name_Pu240)
% Take input file name w/o extension as input and reutn FOM.  Note, FOM
% will change so we will enable options with flags.

% =========================================================================
% FOM Calculation
% =========================================================================

NPS_Am241 = 1e6;
NPS_Pu240 = 1e5;
ArbitraryConstant = 1e-6;

Am = strcat('mppost_output_',input_file_name_Am241,'_All_pulses','.o');
Pu = strcat('mppost_output_',input_file_name_Pu240,'_All_pulses','.o');
for i = 1:length(Am)
    % Get # of interactions from Am-241 file
    Am241 = dir(char(Am(i)));
    if ~isfile(char(Am(i))) || Am241.bytes == 0 
        nAm241 = 0;
    else
        fid=fopen(char(Am(i)));
        g = textscan(fid,'%s','delimiter','\n');
        fclose(fid);
        nAm241 = length(g{1});
    end
    % Get # of interactions from Pu-240 file
    Pu240 = dir(char(Pu(i)));
    if ~isfile(char(Pu(i))) || Pu240.bytes == 0
        nPu240 = 0;
    else
        fid=fopen(char(Pu(i)));
        g = textscan(fid,'%s','delimiter','\n');
        fclose(fid);
        nPu240 = length(g{1});
    end 
    r241 = nAm241/NPS_Am241;
    r240 = nPu240/NPS_Pu240;
    fom = r240/(r241 + ArbitraryConstant);
end
end
