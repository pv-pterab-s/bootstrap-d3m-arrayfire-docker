# D3M+Arrayfire Docker Image and Develop

## Getting Started

Build global docker image w/ d3m and arrayfire named `arrayfire-d3m`
after populating `out/` and `out/context/` with necessary development
files. Only run `1-build-docker.sh` if docker image list lacks
`arrayfire-d3m`.

    0-build-d3m-dir.sh
    1-build-docker.sh

D3M should run out of the box,

    2-example-d3m.sh

Arrayfire development requires container initialization and host
initialization. The docker build script, above, gets the container
done, but the client side at `out/d3m-arrayfire-primitives` still
needs priming. Once primed, changes in the directory reflect in
`arrayfire-d3m`.

    3-prime-af.sh

Arrayfire D3M should execute:

    4-example-af.sh

Aside from working as a command line call to the d3m module, call
Arrayfire directly from python `run.py` in this directory:

    run.sh

Clean up (possibly start over) by deleting `out/`:

    sudo rm -rf out
