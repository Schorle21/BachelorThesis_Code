#!/usr/bin/env python2.3
"""Implement Hashcash version 1 protocol in Python
+-------------------------------------------------------+
| Written by David Mertz; released to the Public Domain |
+-------------------------------------------------------+

|Edited and adjusted by Hendrik Joel |

Double spend database not implemented in this module, but stub
for callbacks is provided in the 'check()' function

The function 'check()' will validate hashcash v1 and v0 tokens, as well as
'generalized hashcash' tokens generically.  Future protocol version are
treated as generalized tokens (should a future version be published w/o
this module being correspondingly updated).

A 'generalized hashcash' is implemented in the '_mint()' function, with the
public function 'mint()' providing a wrapper for actual hashcash protocol.
The generalized form simply finds a suffix that creates zero bits in the
hash of the string concatenating 'challenge' and 'suffix' without specifying
any particular fields or delimiters in 'challenge'.  E.g., you might get:

    >>> from hashcash import mint, _mint
    >>> mint('foo', bits=16)
    '1:16:040922:foo::+ArSrtKd:164b3'
    >>> _mint('foo', bits=16)
    '9591'
    >>> import hashlib
    >>> hashlib.sha1(('foo9591').encode()).hexdigest()
    '0000de4c9b27cec9b20e2094785c1c58eaf23948'
    >>> hashlib.sha1(('1:16:040922:foo::+ArSrtKd:164b3').encode()).hexdigest()
    '0000a9fe0c6db2efcbcab15157735e77c0877f34'

Notice that '_mint()' behaves deterministically, finding the same suffix
every time it is passed the same arguments.  'mint()' incorporates a random 
salt in stamps (as per the hashcash v.1 protocol).
"""
import sys
import multiprocessing
from string import ascii_letters
from math import ceil, floor
import hashlib
from random import choice
from time import strftime, localtime, time
import argon2
import threading


max_int = sys.maxsize


def is_within_system_int_range(n):      #Define the maximum integer value that is possible
    return n <= max_int


ERR = sys.stderr            # Destination for error messages
DAYS = 60 * 60 * 24         # Seconds in a day
tries = [0]                 # Count hashes performed for benchmark

INCREMENT = 100 * 1000             # Measured in K (Every processor runs 100,000 hashes a time, according to our gpu we reach a feasibility setting of)
NUM_PROCESSES = 8
MAX = True

TC = 1                      #Time cost 
#MC = 10240                #Memory Cost  = 0,5 Gibibyte
MC = 1024
P = 1                       #Paralellism
HL = 64                     #Hash length

#Make this parallel by splitting the workload among multiple cores, 
# let them compute until a certain number of counts has been found, then increase
# Let every thread compute 100k hashes then move on, give every thread a frame, then increase the frame





def _salt(l):
    "Return a random string of length 'l'"
    alphabet = ascii_letters + "+/="
    return ''.join([choice(alphabet) for _ in [None]*l])

def _mint(challenge, bits):
    """Answer a 'generalized hashcash' challenge'

    Hashcash requires stamps of form 'ver:bits:date:res:ext:rand:counter'
    This internal function accepts a generalized prefix 'challenge',
    and returns only a suffix that produces the requested SHA leading zeros.

    NOTE: Number of requested bits is rounded up to the nearest multiple of 4
    """
    counter = 0
    hex_digits = int(ceil(bits/4.))
    print(f"Required hex_digits are:{hex_digits}")
    zeros = '0'*hex_digits
    while 1:
        digest = hashlib.sha1((challenge+hex(counter)[2:]).encode()).hexdigest()
        if digest[:hex_digits] == zeros:
            tries[0] = counter
            print("Challenge solved!")
            print(f"Computed digest: {digest} hex_digits:{hex_digits} counter:{counter}")
            return hex(counter)[2:]
        counter += 1

def check(stamp, resource=None, bits=None,
                 check_expiration=None, ds_callback=None):
    """Check whether a stamp is valid

    Optionally, the stamp may be checked for a specific resource, and/or
    it may require a minimum bit value, and/or it may be checked for
    expiration, and/or it may be checked for double spending.

    If 'check_expiration' is specified, it should contain the number of
    seconds old a date field may be.  Indicating days might be easier in
    many cases, e.g.

      >>> from hashcash import DAYS
      >>> check(stamp, check_expiration=28*DAYS)

    NOTE: Every valid (version 1) stamp must meet its claimed bit value
    NOTE: Check floor of 4-bit multiples (overly permissive in acceptance)
    """
    if stamp.startswith('0:'):          # Version 0
        try:
            date, res, suffix = stamp[2:].split(':')
        except ValueError:
            ERR.write("Malformed version 0 hashcash stamp!\n")
            return False
        if resource is not None and resource != res:
            return False
        elif check_expiration is not None:
            good_until = strftime("%y%m%d%H%M%S", localtime(time()-check_expiration))
            if date < good_until:
                return False
        elif callable(ds_callback) and ds_callback(stamp):
            return False
        elif type(bits) is not int:
            return True
        else:
            print("Checking minted hash validity...")
            print(f"stamp: {stamp}, bits:{bits}")
            hex_digits = int(floor(bits/4))
            return hashlib.sha1((stamp).encode()).hexdigest().startswith('0'*hex_digits)
    elif stamp.startswith('1:'):        # Version 1
        try:
            claim, date, res, ext, rand, counter = stamp[2:].split(':')
        except ValueError:
            ERR.write("Malformed version 1 hashcash stamp!\n")
            return False
        if resource is not None and resource != res:
            return False
        elif type(bits) is int and bits > int(claim):
            return False
        elif check_expiration is not None:
            good_until = strftime("%y%m%d%H%M%S", localtime(time()-check_expiration))
            if date < good_until:
                return False
        elif callable(ds_callback) and ds_callback(stamp):
            return False
        else:
            print("Checking minted hash validity...")
            print(f"stamp: {stamp}, claim:{claim}")
            hex_digits = int(floor(int(claim)/4))
            return hashlib.sha1((stamp).encode()).hexdigest().startswith('0'*hex_digits)
    else:                               # Unknown ver or generalized hashcash
        ERR.write("Unknown hashcash version: Minimal authentication!\n")
        if type(bits) is not int:
            return True
        elif resource is not None and stamp.find(resource) < 0:
            return False
        else:
            print("Checking minted hash validity...")
            print(f"stamp: {stamp}, bits:{bits}")
            hex_digits = int(floor(bits/4))
            return hashlib.sha1((stamp).encode()).hexdigest().startswith('0'*hex_digits)

def is_doublespent(stamp):
    """Placeholder for double spending callback function

    The check() function may accept a 'ds_callback' argument, e.g.
      check(stamp, "mertz@gnosis.cx", bits=20, ds_callback=is_doublespent)

    This placeholder simply reports stamps as not being double spent.
    """
    return False

def count(shared_value, lock,result,result_lock,total_hashes_lock,total_hashes,computed_hashes,computed_hashes_lock, increment, process_id, challenge, bits, shutdown_event,salt):
    print(f"Staring hashing core: {process_id}")
    while not shutdown_event.is_set():
        with lock:
            start = shared_value.value
            shared_value.value += increment
        end = start + increment - 1
        actualCounter=0
        counter = start
        hex_digits = int(ceil(bits/4.))
        #print(f"Required hex_digits are:{hex_digits}")
        zeros = '0'*hex_digits
        while (counter!=end):
            c_hex = (challenge+hex(counter)[2:]).encode()
            hash = argon2.low_level.hash_secret( c_hex, salt.encode(), time_cost=TC, memory_cost=MC, parallelism=P, hash_len=HL, type=argon2.low_level.Type.D)
            digest = str(hash).split('$')[-1]
            if digest[:hex_digits] == zeros:
                shutdown_event.set()
                tries[0] = counter
                #print("Challenge solved!")
                print(f"Computed digest: {digest} hex_digits:{hex_digits} counter:{counter}")
                #return hex(counter)[2:]
                with result_lock:
                    result.value = counter
                return
            #actualCounter+=1
            if( not shutdown_event.is_set()):
                with computed_hashes_lock:
                    computed_hashes.value+=1
                counter+=1
            else:
                return

            if(counter==end):
                with total_hashes_lock:
                    total_hashes.value += counter
                    #total_hashes.value += actualCounter
                #with computed_hashes_lock:
                    #computed_hashes.value += 1


def par(challenge,bits,salt):
    #print(f"USING MAX SETTING: {MAX}")
    #print(f"MULTIPROCESS CPU COUNT: {multiprocessing.cpu_count()}")

    if(MAX):
        NUM_PROCESSES = multiprocessing.cpu_count()
    else: 
        NUM_PROCESSES = 9

    # Number of increments each process should count
    increment = INCREMENT
    shutdown_event = multiprocessing.Event()

    # Shared value to store the highest counted value
    shared_value = multiprocessing.Value('i', 0)
    lock = multiprocessing.Lock()

    result_lock = multiprocessing.Lock()
    result = multiprocessing.Value('i',0)

    total_hashes_lock = multiprocessing.Lock()
    total_hashes = multiprocessing.Value('i',0)
    
    computed_hashes_lock = multiprocessing.Lock()
    computed_hashes = multiprocessing.Value('i',0)
    
    #print("BEFORE START: "+str(total_hashes.value))
    # Create processes
    processes = []
    for i in range(NUM_PROCESSES):
        process = multiprocessing.Process(target=count, args=(shared_value, lock,result,result_lock,total_hashes_lock,total_hashes,computed_hashes,computed_hashes_lock, increment, i + 1,challenge,bits,shutdown_event,salt))
        processes.append(process)

    # Start processes
    for process in processes:
        process.start()

    # Wait for processes to finish (they won't in this infinite loop, so you can stop it manually)
    for process in processes:
        process.join()

    #with total_hashes_lock:
        #print(f"Total hashes until find: {total_hashes.value}")
        #print(f"Total hashes until find (in hex): {hex(total_hashes.value)}")

    with computed_hashes_lock:
        print(f"ACTUAL COMPUTED HASHES: {computed_hashes.value}")
        return computed_hashes.value
        #JUST FOR BENCHMARKING THIS IS NOT THE ACTUAL NONCE !!! 


    with result_lock:
        resCounter = hex(result.value)[2:]
        #print(f"Hex value of counter: {resCounter}")
        return resCounter
    



def mint(resource, bits=20, now=None, ext='', saltchars=8, stamp_seconds=False):
    timeAvg = 0
    countAverage = 0
    sampleSize=10
    ret = 0
    minCount = 0 
    maxCount = 0
    for i in range(sampleSize):
        ver = "1"
        start = time()
        now = now or time()
        if stamp_seconds: ts = strftime("%y%m%d%H%M%S", localtime(now))
        else:             ts = strftime("%y%m%d", localtime(now))
        salt = _salt(saltchars)
        challenge = "%s:"*6 % (ver, bits, ts, resource, ext, salt)
      #  print(f"resource:{resource}, bits:{bits},now:{now},ext:{ext},saltchars:{saltchars},stamp_seconds:{stamp_seconds}")
       # print(f"Challenge = {challenge}")
        #ret = challenge + _mint(challenge,bits) #Challenge + the hex of the counter
        count = par(challenge,bits,salt)
    
        if(count>= maxCount):
            maxCount = count

        if(minCount == 0):
            minCount = count
            
        if(count <= minCount):
            minCount = count
        
        

        #ret = challenge + count
        stop = time()
        timeAvg += (stop-start)
        countAverage += count
        print("Count:"+str(count))
        print("AVG TIME:"+str(stop-start))

        print(f"ret:{ret}")
    timeAvg = timeAvg/sampleSize
    countAverage = countAverage/sampleSize
    print("MinCount: "+str(minCount))
    print("MaxCount: "+str(maxCount))
    print("Mean Comp Time:"+str(timeAvg))
    print("Mean Count:"+str(countAverage))
    #return ret
    return "BENCHMARK"

if __name__=='__main__':
    import optparse
    out, err = sys.stdout.write, sys.stderr.write
    parser = optparse.OptionParser(version="%prog 0.1",
                      usage="%prog -c|-m [-b bits] [string|STDIN]")
    parser.add_option('-b', '--bits', type='int', dest='bits', default=20,
                      help="Specify required collision bits" )
    parser.add_option('-m', '--mint', help="Mint a new stamp",
                      action='store_true', dest='mint')
    parser.add_option('-c', '--check', help="Check a stamp for validity",
                      action='store_true', dest='check')
    parser.add_option('-s', '--timer', help="Time the operation performed",
                      action='store_true', dest='timer')
    parser.add_option('-n', '--raw', help="Suppress trailing newline",
                      action='store_true', dest='raw')
    (options, args) = parser.parse_args()
    start = time()
    if options.mint:    action = mint
    elif options.check: action = check
    else:
        out("Try: %s --help\n" % sys.argv[0])
        sys.exit()
    if args: out(str(action(args[0], bits=options.bits)))
    else:    out(str(action(sys.stdin.read(), bits=options.bits)))
    if not options.raw: sys.stdout.write('\n')
    if options.timer:
        timer = time()-start
        err("Completed in %0.4f seconds (%d hashes per second)\n" %
            (timer, tries[0]/timer))
