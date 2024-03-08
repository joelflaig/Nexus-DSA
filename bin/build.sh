# mojo package ./src/DSA/datastructs -o ./bin/datastructs.📦
# cp ./bin/datastructs.📦 ./src/DSA/algorithms/datastructs.📦
mojo package ./src/DSA -o ./bin/DSA.mojopkg
cp ./bin/DSA.mojopkg ./src/tests/DSA.mojopkg
cp ./bin/DSA.mojopkg ../Nexus/bin/DSA.mojopkg

