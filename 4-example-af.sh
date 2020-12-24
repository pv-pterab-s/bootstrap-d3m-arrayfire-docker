#!/bin/bash
# -*- compile-command: "./example-af.sh"; -*-
set -e

D3M_DIR=$(pwd)/out
if [ -n "$1" ]; then D3M_DIR="$1"; fi
[ -d "$D3M_DIR" ]

DATA=/mnt/datasets/training_datasets/seed_datasets_archive
SET=185_baseball
PRIM=classification.logistic_regression.ArrayFire
PIPELINE=d1523250-1597-4f71-bebf-738cb6e58217.json
PIPEPATH=/mnt/d3m-arrayfire-primitives/pipelines/$PRIM/$PIPELINE

docker run \
       --rm \
       -v $D3M_DIR/datasets:/mnt/datasets \
       -v $D3M_DIR/d3m-arrayfire-primitives:/mnt/d3m-arrayfire-primitives \
       arrayfire-d3m \
       /bin/bash -c \
       "mkdir -p /mnt/pipeline-outputs && python3.6 -m d3m \
                     runtime \
                     fit-score \
                     --problem $DATA/$SET/${SET}_problem/problemDoc.json \
                     --input $DATA/$SET/TRAIN/dataset_TRAIN/datasetDoc.json \
                     --test-input $DATA/$SET/TEST/dataset_TEST/datasetDoc.json \
                     --score-input $DATA/$SET/SCORE/dataset_TEST/datasetDoc.json \
                     --pipeline $PIPEPATH \
                     --output /mnt/pipeline-outputs/predictions.csv \
                     --output-run /mnt/pipeline-outputs/run.yml"
