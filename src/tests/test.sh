mojo build src/tests/hadamard_test.mojo -o bin/tests/hadamard_test
mojo build src/tests/alloc.mojo -o bin/tests/alloc
./bin/tests/hadamard_test
./bin/tests/alloc
