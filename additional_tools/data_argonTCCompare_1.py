import matplotlib.pyplot as plt
import pandas as pd 

# Read the data from the CSV file
data = pd.read_csv('1901_10_10240_1_1.csv')
#data2 = pd.read_csv("SHA256_1901_10_64.csv")
#data2 = pd.read_csv("output_sha_225Mil.csv")
data2 = pd.read_csv("1901_10_10240_5_1.csv")
# Create DataFrame

df2 = pd.DataFrame(data2)
df = pd.DataFrame(data)

# Create DataFrame
df = df[df['Batch_Size'] <= 1901]
df2 = df2[df2['Batch_Size'] <= 1611]
#df2 = df2[df2['Batch_Size'] <= 1901]
#df2 = df2[df2['Batch_Size']]


# Convert Mean_HT to seconds and calculate HashRate
def convert_to_hashrate(mean_ht):
    value = float(mean_ht.split()[0])
    unit = mean_ht.split()[1]
    if unit == 'us':
        return 1 / (value / 1_000_000)  # Convert microseconds to seconds
    elif unit == 'ms':
        return 1 / (value / 1_000)  # Convert milliseconds to seconds
    elif unit == 'ns':
        return 1 / (value / 1_000_000_000)  # Convert nanoseconds to seconds

df['HashRate'] = df['Mean_HT'].apply(convert_to_hashrate)
df2['HashRate'] = df2['Mean_HT'].apply(convert_to_hashrate)

# Filter data where batch_size <= 1901

# Convert HashRate to KH/s (kilo hashes per second)
df['HashRate_KHs'] = df['HashRate'] / 1000
df2['HashRate_KHs'] = df2['HashRate'] / 1000

#df['HashRate_KHs'] = df['HashRate'] / 1000000    #Mega HASHES 
#df2['HashRate_KHs'] = df2['HashRate'] / 1000000 

# Extract batch size and HashRate_KHs from the DataFrame
batch_size = df['Batch_Size']
#batch_size2 = df2['Batch_Size'] / 1000000 #Mega Batches
batch_size2 = df2["Batch_Size"]

hash_rate_khs = df['HashRate_KHs']
hash_rate_khs2 = df2['HashRate_KHs']


plt.figure(figsize=(10,6))
# Plot the data
plt.plot(batch_size, hash_rate_khs, color='#2ca25f', label='Argon2D Cost = 1')
#plt.plot(batch_size2, hash_rate_khs2, color='#99d8c9', label='Sha256')
plt.plot(batch_size2, hash_rate_khs2, color='#99d8c9', label='Argon2D Cost = 5')


# Label the axes
plt.xlabel('Batch Size', fontsize=16)
plt.ylabel('Hash Rate (KH/s)', fontsize=16)
#plt.ylabel('Hash Rate (MH/s)', fontsize=14)

# Customize labels and ticks

plt.xticks(fontsize=16)
plt.yticks(fontsize=16)

# Add a legend
plt.legend(loc='upper right', bbox_to_anchor=(1, 1),fontsize=16)

# Add a title
plt.title('Argon2 with a varied time cost parameter',fontsize=16)

# Show grid lines for better readability
plt.grid(True)

# Add a legend

plt.show()

# Save the plot as an .eps file
plt.savefig("HR_perSecond_DifferentTC.eps", format='eps')