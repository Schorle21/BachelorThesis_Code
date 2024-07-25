#!/bin/bash

# Configuration variables
mode="cuda"
output_type="ns"
output_mode="verbose"
k_value="oneshot"
type="d"
batch_size=1
samples=10
t_cost=1
m_cost=1024
L=1
maxBatch=10                 #Iterate until this is met !!!
te_threads_max=70656
step_size=1
output_csv="benchmark_test.csv"
multiply=true
append=true

# Parse command-line options
while getopts :s:x:b:m:k:t:S:T:M:L:o: opt; do
    case "${opt}" in
        s) step_size=${OPTARG};;
        x) multiply=${OPTARG};;
        b) maxBatch=${OPTARG};;
        m) mode=${OPTARG};;
        k) k_value=${OPTARG};;
        t) type=${OPTARG};;
        S) samples=${OPTARG};;
        T) t_cost=${OPTARG};;
        M) m_cost=${OPTARG};;
        L) L=${OPTARG};;
        o) output_csv=${OPTARG};;
        a) append=${OPTARG};;

        \?) echo "Invalid option: -$OPTARG" >&2; show_usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; show_usage;;
    esac
done


#Output file is in the format: MemoryCost,TimeCost,Lanes,MaxBatch,Multiplication (True False),Step Size


# Header for CSV file (adjust according to your program's output)
echo "M_Kibibytes,Lanes,Batch_Size,TE_Threads_Per_Block,TE_Blocks,TE_Total_Threads,Time_Cost,Mean_CT,Mean_Deviation_CT,Mean_HT,Mean_Deviation_HT,TE_Upper_Thread_Limit" > "$output_csv"
echo $maxBatch
echo $multiply

if $multiply; then

    echo "Using multiplication as a step source"
    # Loop for iterations
    i=1

    while [ $i -le $maxBatch ]; do
        # Run the program with current configuration and capture output
        echo "Running with settings $mode,$output_type,$output_mode,$k_value,$type_,$i,$samples,$t_cost,$m_cost,$L"

        # Run the argon2 gpu bench with the following settings
        program_output=$(./argon2-gpu-bench -m "$mode" --output-type="$output_type" --output-mode="$output_mode" -k "$k_value" -t "$type" --batch-size="$i" --samples="$samples" --t-cost="$t_cost" --m-cost="$m_cost" -L "$L")
        
        # Extract relevant outputs from the argon2 benchmarker
        m_ct=$(echo "$program_output" | grep "Mean computation time:" | grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_ct=$(echo "$program_output" | grep "Mean deviation:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_ct_hr=$(echo "$program_output" | grep "Mean computation time hr:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        m_d_hr=$(echo "$program_output" | grep "Mean deviation hr:"| grep -oP '\d+(\.\d+)?\s*(ms|us|s|ns)')
        threads_total=$(echo "$program_output" | grep "Usage_TE_T:" | tail -n 1|grep -o '[0-9]\+')
        nBlocks=$(echo "$program_output" | grep "nBlocks:"| tail -n 1|grep -o '[0-9]\+')
        nThreads=$(echo "$program_output" | grep "nThreads:"| tail -n 1|grep -o '[0-9]\+')


        # Log data to CSV file
        echo "$program_output" >> "output_raw.txt"
        echo "$m_cost,$L,$i,$nThreads,$nBlocks,$threads_total,$t_cost,$m_ct,$m_d_ct,$m_ct_hr,$m_d_hr,$te_threads_max" >> "$output_csv"
        i=$((i*2))
    done
else
    # Loop for iterations
    for (( i=1; i<=maxBatch; i+=step_size )); do
        # Run the program with current configuration and capture output
        echo "Running with settings $mode,$output_type,$output_mode,$k_value,$type_,$i,$samples,$t_cost,$m_cost,$L"
        
        # Run the argon2 gpu bench with the following settings
        program_output=$(./argon2-gpu-bench -m "$mode" --output-type="$output_type" --output-mode="$output_mode" -k "$k_value" -t "$type" --batch-size="$i" --samples="$samples" --t-cost="$t_cost" --m-cost="$m_cost" -L "$L")
        
        # Extract relevant outputs from the argon2 benchmarker
        m_ct=$(echo "$program_output" | grep "Mean computation time:" | grep -oP '\d+\.\d+\s+(ms|us|s)')
        m_d_ct=$(echo "$program_output" | grep "Mean deviation:"| grep -oP '\d+\.\d+\s+(ms|us|s)')
        m_ct_hr=$(echo "$program_output" | grep "Mean computation time hr:"| grep -oP '\d+\.\d+\s+(ms|us|s)')
        m_d_hr=$(echo "$program_output" | grep "Mean deviation hr:"| grep -oP '\d+\.\d+\s+(ms|us|s)')
        threads_total=$(echo "$program_output" | grep "Usage_TE_T:" | tail -n 1|grep -o '[0-9]\+')
        nBlocks=$(echo "$program_output" | grep "nBlocks:"| tail -n 1|grep -o '[0-9]\+')
        nThreads=$(echo "$program_output" | grep "nThreads:"| tail -n 1|grep -o '[0-9]\+')


        # Log data to CSV file
        echo "$m_cost,$L,$i,$nThreads,$nBlocks,$threads_total,$t_cost,$m_ct,$m_d_ct,$m_ct_hr,$m_d_hr,$te_threads_max" >> "$output_csv"

    done
fi


echo "Script execution completed."
