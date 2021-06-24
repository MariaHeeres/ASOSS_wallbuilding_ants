import csv
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import mannwhitneyu
from pingouin import mwu

pheromone_stigmergy = []
ant_stigmergy = []
entrance_percentage = []
density = []
ants = []

with open('Ants_WallBuild_het_grote_experiment_table.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    skip_lines = 0
    line_count = 0
    for row in csv_reader:
        if skip_lines == 0:
            skip_lines += 1
        else:
            density.append(row[4])
            pheromone_stigmergy.append(row[6])
            ants.append(row[8])
            ant_stigmergy.append(row[13])
            entrance_percentage.append(float(row[15]))
            line_count += 1

data = [[]for x in range(19)]

pheromone_stigmergy_true = []
pheromone_stigmergy_false = []

for i in range(line_count):
    if pheromone_stigmergy[i] == "true":
        pheromone_stigmergy_true.append(entrance_percentage[i])
    else:
        pheromone_stigmergy_false.append(entrance_percentage[i])

ant_stigmergy_true = []
ant_stigmergy_false = []

for i in range(line_count):
    if ant_stigmergy[i] == "true":
        ant_stigmergy_true.append(entrance_percentage[i])
    else:
        ant_stigmergy_false.append(entrance_percentage[i])


pheromone_and_ant_stigmergy_true = []
pheromone_and_ant_stigmergy_false = []

for i in range(line_count):
    if ant_stigmergy[i] == "true" and pheromone_stigmergy[i] == "true":
        pheromone_and_ant_stigmergy_true.append(entrance_percentage[i])
    elif ant_stigmergy[i] == "false" and pheromone_stigmergy[i] == "false":
        pheromone_and_ant_stigmergy_false.append(entrance_percentage[i])

print("pheromone stigmergy:")
print("Mean with pheromone stigmergy: ", mean(pheromone_stigmergy_true))
print("Mean without pheromone stigmergy: ", mean(pheromone_stigmergy_false))
print(mwu(pheromone_stigmergy_true, pheromone_stigmergy_false, tail='one-sided'))
print("ant stigmergy:")
print("Mean with ant stigmergy: ", mean(ant_stigmergy_true))
print("Mean without ant stigmergy: ", mean(ant_stigmergy_false))
print(mwu(ant_stigmergy_true, ant_stigmergy_false, tail='one-sided'))
print("pheromone and ant stigmergy:")
print("Mean with pheromoneand ant stigmergy: ", mean(pheromone_stigmergy_true))
print("Mean without pheromone and ant stigmergy: ", mean(pheromone_stigmergy_false))
print(mwu(pheromone_and_ant_stigmergy_true, pheromone_and_ant_stigmergy_false, tail='one-sided'))

"""
res = [[0 for x in range(19)] for y in range(3)]
for x in range(19):
    res[0][x] = x * 10
    res[1][x] = np.mean(data[x])
    res[2][x] = np.std(data[x])

plt.errorbar(res[0], res[1], yerr = res[2], fmt='-o', capsize=4, color='black')
plt.yticks(np.arange(0, 1.1, 0.1))
plt.xlabel('Noise in Degrees')
plt.ylabel("Order Parameter")
plt.title('Order Parameter as a Function of Noise')
plt.xticks(res[0])
plt.show()
"""