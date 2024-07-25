#include "sha256.cuh"
#include <iostream>
#include <cstring>
#include <chrono>
#include <vector>
#include <random>

using namespace std;

//By Hendrik Joel 

//compile command: nvcc main.cpp sha256.cu -o sha256_cuda -std=c++11


// Function to format the duration in the most appropriate time unit
std::string format_duration(double duration_s) {
    if (duration_s >= 1.0) {
        return std::to_string(duration_s) + " s";
    } else if (duration_s >= 1e-3) {
        return std::to_string(duration_s * 1e3) + " ms";
    } else if (duration_s >= 1e-6) {
        return std::to_string(duration_s * 1e6) + " us";
    } else {
        return std::to_string(duration_s * 1e9) + " ns";
    }
}



int main(int argc, char *argv[]){
    
    // Check for appropriate number of command-line arguments
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <number_of_passwords> <password_length>\n";
        return 1;
    }

    // Parse command-line arguments
    WORD BATCH_SIZE = std::atoi(argv[1]);
    WORD PASSWORD_LENGTH = std::atoi(argv[2]);

    typedef std::chrono::steady_clock clock_type;

    // Seed the random number generator with the current time
    std::mt19937 gen(std::chrono::system_clock::now().time_since_epoch().count());

    // Character set for the random password generator
    const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    std::uniform_int_distribution<> dist(0, sizeof(charset) - 2);

    printf("Generating password...\n");
    // Generate random passwords
    std::vector<BYTE> passwords(BATCH_SIZE * PASSWORD_LENGTH);
    for (WORD i = 0; i < BATCH_SIZE; ++i) {
        for (WORD j = 0; j < PASSWORD_LENGTH; ++j) {
            passwords[i * PASSWORD_LENGTH + j] = charset[dist(gen)];
        }
    }
    printf("Completed password generation.\n");
 
    // Buffer for hashed passwords
    std::vector<BYTE> hashed_passwords(BATCH_SIZE * 32);

    WORD thread = 256;
	WORD block = (BATCH_SIZE + thread - 1) / thread;
    WORD totalThreads = block*thread;
    printf("\nThreads:%i\n",thread);
    printf("Blocks:%i\n",block);
    printf("Total Threads:%i\n",totalThreads);

    // Hash the passwords
    printf("\nStarting computation with a Theoretical Upper Thread Bound of: 70,656\n");
    auto start = std::chrono::high_resolution_clock::now();
    mcm_cuda_sha256_hash_batch(passwords.data(), PASSWORD_LENGTH, hashed_passwords.data(), BATCH_SIZE);
    auto end = std::chrono::high_resolution_clock::now();
    printf("Finished computation\n");

    // Convert the duration to nanoseconds
    auto duration_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    double duration_ss = duration_ns / 1e9; // Convert nanoseconds to seconds
    std::cout << "\nComputation time ns: " << duration_ns << " ns\n";
    std::cout << "Computation time s: " << duration_ss << " s\n";
    std::cout << "Computation time: " << format_duration(duration_ss) << "\n";

    // Calculate the hash rate (hashes per second)
    double duration_s = duration_ns / 1e9; // Convert nanoseconds to seconds
    double hash_rate = BATCH_SIZE / duration_s; // Hashes per second
    double hash_rate_ns = BATCH_SIZE / duration_ns; // Hashes per second

    std::cout << "\nMean Hash Rate s: " << hash_rate << " hashes/second\n";
    std::cout << "Mean Hash Rate ns: " << hash_rate_ns << " hashes/ns\n";

    // Calculate the time taken to compute one hash in seconds
    double time_per_hash_s = duration_s / BATCH_SIZE;
    double time_per_hash_ns = duration_ns / BATCH_SIZE;
    std::cout << "\nMean Time per Hash ns: " <<time_per_hash_ns << " ns\n";
    std::cout << "Mean Time per Hash s: " << time_per_hash_s << " s\n";
    std::cout << "Mean Time per Hash: " << format_duration(time_per_hash_s) << "\n";


/*
    // Print the hashed passwords
    for (WORD i = 0; i < BATCH_SIZE; ++i) {
        std::cout << "Password " << i + 1 << ": ";
        for (WORD j = 0; j < 32; ++j) {
            std::printf("%02x", hashed_passwords[i * 32 + j]);
        }
        std::cout << std::endl;
    }
*/

    return 0; 
}