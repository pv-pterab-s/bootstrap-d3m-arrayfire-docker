# D3M+Arrayfire Docker Image and Develop

Build global docker image w/ d3m and arrayfire named `arrayfire-d3m`
after populating `out` and `out/context` with necessary development
files.

    0-build-d3m-dir.sh
    1-build-docker.sh    # only if docker image list lacks arrayfire-d3m

D3M should run out of the box,

    2-example-d3m.sh

Arrayfire development requires container initialization and host
initialization. The docker build script, above, gets the container
done, but the client side at `out/d3m-arrayfire-primitives` still
needs priming:

    3-prime-af.sh

Arrayfire D3M should be good to go:

    4-example-af.sh
