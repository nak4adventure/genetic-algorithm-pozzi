
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Noah Kleedtke             %
%  Date:   10/12/2019                %            
%  Mentor: Michael Hua               %
%  PI:     Sara Pozzi                %
%                                    %
%     FILES NEEDED:                  %
% (1) chromosome2decimal.m           %
% (2) decimal2chromosome.m           %
% (3) GA_v13.m                       %
% (4) make_input_files.m             %
% (5) MPPost_input.template          %
% (6) myjob.bat                      %
% (7) return_fom.m                   %
% (8) run_polimi_mppost.m            %
% (9) thicc_template_Am241.template  %
% (10) thicc_template_Pu240.template %
% (11) wheel_of_fortune.m            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CLEAN UP WORK ENVIRONMENT
clc; clear; close all;
tic %start timer

%% USER SECTION

% Define Directory with all Working Files
working_directory = "/Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER";
mcnp_path = "/Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin";
% Number of Generations
% the first generation is produced by the Latin Hypercube Sampling Method
N_Gen = 12;

% Number of Shielding Designs Tested per Generation
N_inputFiles = 36;

% Number of Shielding Designs Performing Crossing Over Sub-Algorithm
N_Crossover = 35;

% Define max Thicknesses (cm)
maxThicknessCopper = 0.3;
maxThicknessTin    = 0.3;

%% SIT BACK, RELAX, AND ENJOY THE SHOW

% Set Matlab Random Number Generator Seed
random_number = randi([1 1e8]);
rng(random_number)

% create a file for run information
fid = fopen( 'run_information.txt', 'wt' );
fprintf(fid, 'Genetic Algorithm Run Information        \n');
fprintf(fid, '                                         \n');
fprintf(fid, 'Matlab Random Number Seed:    %d         \n',random_number);
fprintf(fid, 'Number of Generations:        %d         \n',N_Gen);
fprintf(fid, 'Number of Input Files:        %d         \n',N_inputFiles);
fprintf(fid, 'Crossover Rate:               %f %%      \n', N_Crossover*100/N_inputFiles);
fprintf(fid, 'Mutation Rate:                %f %%      \n', (1-(N_Crossover/N_inputFiles))*100);
fprintf(fid, 'Max Tin Thickness:            %d cm      \n', maxThicknessTin);
fprintf(fid, 'Max Copper Thickness:         %d cm      \n', maxThicknessCopper);
fprintf(fid, '                                         \n');
fprintf(fid, ' -- RESULTS --                           \n');
fprintf(fid, '                                         \n');
fclose(fid);

%Latin Hypbercube Sampling (LHS)
t_copper = lhsdesign(N_inputFiles,1)*maxThicknessCopper;
t_tin = lhsdesign(N_inputFiles,1)*maxThicknessTin;

all_data = [];
for i = 1:N_Gen
    population = [];
    for j = 1:N_inputFiles
        t_copper(j) = chromosome2decimal(decimal2chromosome(t_copper(j)));
        t_tin(j) = chromosome2decimal(decimal2chromosome(t_tin(j)));
        input_file_name = make_input_files(t_copper(j),t_tin(j),j,random_number);
        run_polimi_mppost(working_directory,mcnp_path,input_file_name{1},input_file_name{2})
        delete input_file_*
        delete mct*
        fom = return_fom(input_file_name{1},input_file_name{2});
        delete *All_pulses.o
        population = vertcat(population,[t_tin(j) t_copper(j) fom]);
        fid = fopen( 'run_information.txt', 'a' );
        fprintf(fid, 'Tin: %.3f cm, Copper: %.3f cm, FoM: %f \n',t_tin(j),t_copper(j),fom);
        fclose(fid);
    end
    fprintf('\n\n Generation %d MCNP Simulations Complete! \n\n',i);
    
    all_data = vertcat(all_data, population);
    % plot population
    figure(1);
    x = all_data(:,1);                     
    y = all_data(:,2);                           
    fom = all_data(:,3);
    scatter(x,y,[],fom,'filled');
    grid on
    grid minor
    c = colorbar;
    colorTitleHandle = get(c,'Title');
    titleString = 'FoM';
    set(colorTitleHandle ,'String',titleString);
    colormap jet
    xlabel('Tin Thickness [cm]');
    ylabel('Copper Thickness [cm]');
    xlim([0 maxThicknessTin]);
    ylim([0 maxThicknessCopper]);
    h = findall(gca,'marker','o');
    set(h, 'sizedata', 100);
    set(h, 'MarkerEdgeColor','k');
    set(gca,'FontSize',14)
    saveas(figure(1),['Generation_',num2str(i),'_ScatterPlot.png']);
    
    if i == N_Gen
        fid = fopen( 'top_10.txt', 'wt' );
        fprintf(fid, 'Genetic Algorithm Top 10 Designs \n');
        final_output = sortrows(population,3,'descend');
        for l = 1:10
            fprintf(fid,sprintf('(%d) Tin: %f cm, Copper: %f cm, FoM: %f \n', l, final_output(l,1), final_output(l,2),final_output(l,3)));
        end
        fclose(fid);
    end
    
    % population genetic material
    chromosomes = [];
    total_fom = 0;
    for j = 1:N_inputFiles
        chromosomes = vertcat(chromosomes, decimal2chromosome(population(j,1)));
        chromosomes = vertcat(chromosomes, decimal2chromosome(population(j,2)));
        total_fom = total_fom + population(j,3);
    end
    
    % crossover
    P = [];
    X = 1:1:N_inputFiles;
    for j = 1:N_inputFiles
        P = horzcat(P,population(j,3)/total_fom);
    end
    
    new_chromosomes = [];
    for j = 1:N_inputFiles*2
        mate = wheel_of_fortune(P,X);
        crossover_site = randi([1 21]); % randomly select crossover site
        if mod(j,2) == 0   % even chromosome
            new_chromosome = [chromosomes(j,1:crossover_site) chromosomes((mate*2),(crossover_site+1):end)];
        else               % odd chromosome
            new_chromosome = [chromosomes(j,1:crossover_site) chromosomes((mate*2-1),(crossover_site+1):end)];
        end
        new_chromosomes = vertcat(new_chromosomes, new_chromosome);
    end
    
    % turn chromosomes back into decimals
    t_tin = [];
    t_copper = [];
    for j = 1:N_inputFiles*2
        if mod(j,2) == 0
            t_copper = vertcat(t_copper,chromosome2decimal(new_chromosomes(j,:)));
        else
            t_tin = vertcat(t_tin,chromosome2decimal(new_chromosomes(j,:)));
        end
    end
    
    % mutation
    N_Mutation = N_inputFiles - N_Crossover;
    for j = 1:N_Mutation
        random = randi([1 N_inputFiles]); 
        t_tin(random) = rand*maxThicknessTin;
        if t_tin(random) == 0
            t_tin(random) = 0.001;
        end
        t_copper(random) = rand*maxThicknessCopper;
        if t_copper(random) == 0
            t_copper(random) = 0.001;
        end
    end
    
end

t = toc;
%Save Workspace
filename = 'test.mat';
save(filename)
close all;