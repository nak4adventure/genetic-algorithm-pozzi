export PATH="/Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin"                                                                                                                                                            
export DATAPATH="/Users/nak4adventure/Export/my_mcnp/MCNP_DATA"                                                                                                                                                            
export ISCDATA="/Users/nak4adventure/Export/my_mcnp/MCNP_CODE/MCNP620/Utilities/ISC/data"                                                                                                                                                            
polimi i=input_file_10_Am241.i d=input_file_10_Am241.d o=input_file_10_Am241.o r=input_file_10_Am241.r 
polimi i=input_file_10_Pu240.i d=input_file_10_Pu240.d o=input_file_10_Pu240.o r=input_file_10_Pu240.r 
cd /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin 
/bin/mv /Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER/mppost_input_file_10_Am241.txt /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_input_file_10_Am241.txt 
/bin/mv /Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER/mppost_input_file_10_Pu240.txt /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_input_file_10_Pu240.txt 
/bin/mv /Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER/input_file_10_Am241.d /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/input_file_10_Am241.d 
/bin/mv /Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER/input_file_10_Pu240.d /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/input_file_10_Pu240.d 
./mppost.exe mppost_input_file_10_Am241.txt    
./mppost.exe mppost_input_file_10_Pu240.txt    
/bin/rm /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_input_file_10_Am241.txt      
/bin/rm /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_input_file_10_Pu240.txt      
/bin/rm /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/input_file_10_Am241.d               
/bin/rm /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/input_file_10_Pu240.d               
/bin/rm /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_output_input_file_10_Am241.o 
/bin/rm /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_output_input_file_10_Pu240.o 
/bin/mv /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_output_input_file_10_Am241_All_pulses.o /Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER/mppost_output_input_file_10_Am241_All_pulses.o 
/bin/mv /Users/nak4adventure/Export/my_mcnp/MCNP_CODE/bin/mppost_output_input_file_10_Pu240_All_pulses.o /Users/nak4adventure/Documents/Research/GeneticAlgorithmProject/MASTER/mppost_output_input_file_10_Pu240_All_pulses.o 
