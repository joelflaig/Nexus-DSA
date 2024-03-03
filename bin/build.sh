mojo package ./src/DSA/datastructs -o ./bin/datastructs.📦
cp ./bin/datastructs.📦 ./src/DSA/algorithms/datastructs.📦
mojo package ./src/DSA -o ./bin/DSA.📦
cp ./bin/DSA.📦 ./src/tests/DSA.📦
mojo build ./src/tests/random_vector_test.mojo -o ./bin/tests/random_vector_test
mojo build ./src/tests/vector_iter_test.mojo -o ./bin/tests/vector_iter_test