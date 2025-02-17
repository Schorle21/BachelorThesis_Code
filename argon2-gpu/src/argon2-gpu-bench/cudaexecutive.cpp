#include "cudaexecutive.h"

#include "argon2-cuda/processingunit.h"

#include <iostream>

static constexpr std::size_t HASH_LENGTH = 32;

void printMemoryContents(const void *pw, std::size_t length) {
        const char *charPtr = static_cast<const char*>(pw);
        for (std::size_t i = 0; i < length; ++i) {
            std::cout << charPtr[i];
        }
        std::cout << std::endl;
        }



class CudaRunner : public Argon2Runner
{
private:
    argon2::Argon2Params params;
    argon2::cuda::ProcessingUnit unit;

public:
    CudaRunner(const BenchmarkDirector &director,
               const argon2::cuda::Device &device,
               const argon2::cuda::ProgramContext &pc)
        : params(HASH_LENGTH, NULL, 0, NULL, 0, NULL, 0,                        //These are the argon 2 parameters
                 director.getTimeCost(), director.getMemoryCost(),
                 director.getLanes()),
          unit(&pc, &params, &device, director.getBatchSize(),
               director.isBySegment(), director.isPrecomputeRefs())
    {
    }

    nanosecs runBenchmark(const BenchmarkDirector &director,                    //THIS LOADS PW's into memory and then tries to crack* them
                          PasswordGenerator &pwGen) override
    {
        typedef std::chrono::steady_clock clock_type;
        using namespace argon2;
        using namespace argon2::cuda;

        auto beVerbose = director.isVerbose();
        auto batchSize = unit.getBatchSize();
        if (beVerbose) {
            std::cout << "Starting computation..." << std::endl;
            printf("Priting to be hashed passwords:\n");
        }

        //If I wanted to I could insert the hashcash here!!!

        

        clock_type::time_point checkpt0 = clock_type::now();    //This is really important      //COULD IMPLEMENT A DIFFICULTY NONCE SETTING HERE !!!
        for (std::size_t i = 0; i < batchSize; i++) {
            const void *pw;
            std::size_t pwLength;
            pwGen.nextPassword(pw, pwLength);       //This makes and sets passwords it hashes a bunch of time codes
            unit.setPassword(i, pw, pwLength);
        }
        clock_type::time_point checkpt1 = clock_type::now();

        unit.beginProcessing();
        unit.endProcessing();

        clock_type::time_point checkpt2 = clock_type::now();
        for (std::size_t i = 0; i < batchSize; i++) {
            uint8_t buffer[HASH_LENGTH];
            unit.getHash(i, buffer);                            //This is our GET HASH  FUNCTION!!!!
        }
        clock_type::time_point checkpt3 = clock_type::now();

        if (beVerbose) {
            clock_type::duration wrTime = checkpt1 - checkpt0;
            auto wrTimeNs = toNanoseconds(wrTime);
            std::cout << "    Writing took     "
                      << RunTimeStats::repr(wrTimeNs) << std::endl;
        }

        clock_type::duration compTime = checkpt2 - checkpt1;
        auto compTimeNs = toNanoseconds(compTime);
        if (beVerbose) {
            std::cout << "    Computation took "
                      << RunTimeStats::repr(compTimeNs) << std::endl;
        }

        if (beVerbose) {
            clock_type::duration rdTime = checkpt3 - checkpt2;
            auto rdTimeNs = toNanoseconds(rdTime);
            std::cout << "    Reading took     "
                      << RunTimeStats::repr(rdTimeNs) << std::endl;
        }
        return compTimeNs;
    }
};

int CudaExecutive::runBenchmark(const BenchmarkDirector &director) const
{
    using namespace argon2::cuda;

    GlobalContext global;
    auto &devices = global.getAllDevices();

    if (listDevices) {
        std::size_t i = 0;
        for (auto &device : devices) {
            std::cout << "Device #" << i << ": "
                      << device.getInfo() << std::endl;
            i++;
        }
        return 0;
    }
    if (deviceIndex > devices.size()) {
        std::cerr << director.getProgname()
                  << ": device index out of range: "
                  << deviceIndex << std::endl;
        return 1;
    }
    auto &device = devices[deviceIndex];
    if (director.isVerbose()) {
        std::cout << "Using device #" << deviceIndex << ": "
                  << device.getInfo() << std::endl;
    }
    ProgramContext pc(&global, { device },
                      director.getType(), director.getVersion());
    CudaRunner runner(director, device, pc);
    return director.runBenchmark(runner);
}
