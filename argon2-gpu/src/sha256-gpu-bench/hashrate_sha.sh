#!/bin/bash


# Configuration variables
batch_size=1
maxBatch=10                 #Iterate until this is met !!!
te_threads_max=70656
step_size=1
output_csv="benchmark_test.csv"
multiply=true
append=true

# Parse command-line options
while getopts :b:l:s:x:o: opt; do
    case "${opt}" in
        l) password_length=${OPTARG};;
        s) step_size=${OPTARG};;
        x) multiply=${OPTARG};;
        b) maxBatch=${OPTARG};;
        o) output_csv=${OPTARG};;

        \?) echo "Invalid option: -$OPTARG" >&2; show_usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; show_usage;;
    esac
done


#Output file is in the format: MemoryCost,TimeCost,Lanes,MaxBatch,Multiplication (True False),Step Size


# Header for CSV file (adjust according to your program's output)
echo "Batch_Size,TE_Threads_Per_Block,TE_Blocks,TE_Total_Threads,Time_Cost,Mean_CT,Mean_Deviation_CT,Mean_HT,Mean_Deviation_HT,TE_Upper_Thread_Limit" > "$output_csv"
echo $maxBatch
echo $multiply

if $multiply; then

    echo "Using multiplication as a step source"
    # Loop for iterations
    i=1

    while [ $i -le $maxBatch ]; do
        # Run the program with current configuration and capture output
        echo "Running with settings $i $password_length"

        # Run the argon2 gpu bench with the following settings
        program_output=$(./sha256_cuda $i $password_length)
        
        # Extract relevant outputs from the argon2 benchmarker
        m_ct=$(echo "$program_output" | grep "Computation time: " | grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_ct=$(echo "$program_output" | grep "Mean deviation:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_ct=-1 #FOR NOW !!!
        m_ct_hr=$(echo "$program_output" | grep "Mean Time per Hash: "| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_hr=$(echo "$program_output" | grep "Mean deviation hr:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_hr=-1 #FOR NOW !!!
        threads_total=$(echo "$program_output" | grep "Total Threads:" | tail -n 1|grep -o '[0-9]\+')
        nBlocks=$(echo "$program_output" | grep "Blocks:"| tail -n 1|grep -o '[0-9]\+')
        nThreads=$(echo "$program_output" | grep "Threads:"| tail -n 1|grep -o '[0-9]\+')


        # Log data to CSV file
        echo "$program_output" >> "output_raw.txt"
        echo "$i,$nThreads,$nBlocks,$threads_total,$t_cost,$m_ct,$m_d_ct,$m_ct_hr,$m_d_hr,$te_threads_max" >> "$output_csv"
        i=$((i*2))
    done
else
    # Loop for iterations
    for (( i=1; i<=maxBatch; i+=step_size )); do
        # Run the program with current configuration and capture output
        echo "Running with settings $i $password_length"

        # Run the argon2 gpu bench with the following settings
        program_output=$(./sha256_cuda $i $password_length)
        
        # Extract relevant outputs from the argon2 benchmarker
        m_ct=$(echo "$program_output" | grep "Computation time: " | grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_ct=$(echo "$program_output" | grep "Mean deviation:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_ct=-1 #FOR NOW !!!
        m_ct_hr=$(echo "$program_output" | grep "Mean Time per Hash: "| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_hr=$(echo "$program_output" | grep "Mean deviation hr:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_hr=-1 #FOR NOW !!!
        threads_total=$(echo "$program_output" | grep "Total Threads:" | tail -n 1|grep -o '[0-9]\+')
        nBlocks=$(echo "$program_output" | grep "Blocks:"| tail -n 1|grep -o '[0-9]\+')
        nThreads=$(echo "$program_output" | grep "Threads:"| tail -n 1|grep -o '[0-9]\+')
        # Log data to CSV file
        echo "$i,$nThreads,$nBlocks,$threads_total,$t_cost,$m_ct,$m_d_ct,$m_ct_hr,$m_d_hr,$te_threads_max" >> "$output_csv"

    done
fi


echo "Script execution completed."
