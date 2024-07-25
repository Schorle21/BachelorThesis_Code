import argon2
from time import strftime, localtime, time



TC = 1                      #Time cost 
MC = 3906252               #Memory Cost = 1 GB now
P = 4                       #Paralellism
HL = 64

num = 50




start = time() 
counter = 10

for i in range(counter):
    c_hex = ("HelloWorld"+str(i)).encode
    hash = argon2.low_level.hash_secret(b'HelloWorld', b'somesalt', time_cost=TC, memory_cost=MC, parallelism=P, hash_len=HL, type=argon2.low_level.Type.D)
    digest = str(hash).split('$')[-1]

timer = time()-start


hashrate = counter/timer
seconds = 1/hashrate
print(f"{counter} hashes have been calculated.")
print(f"This took {timer} seconds.")
print(f"We have achieved a hashrate of: {hashrate} / s")
hashMaxT = hashrate*4
print(f"This allows for a theoretical hash rate of up to {hashMaxT} per second.")