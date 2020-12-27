#!/usr/bin/python3.6
# -*- compile-command: "SCREEN_NAME=belle-build ./run.sh 'cd /mnt/bootstrap-d3m-arrayfire-docker && /usr/bin/time python3.6 run.py'"; -*-
import os
import time
import logging
from d3m.container.dataset import Dataset
from d3m.metadata import pipeline as pipeline_module
from d3m.metadata import base as metadata_base
from d3m.metadata.problem import Problem
from d3m.runtime import Runtime
logger = logging.getLogger()
logger.setLevel(logging.ERROR)
def M(s):
    print(s)
    return s


DATA='/mnt/datasets/training_datasets/seed_datasets_archive'
SET='185_baseball'
PRIM='classification.logistic_regression.ArrayFire'
PIPELINE='d1523250-1597-4f71-bebf-738cb6e58217.json'
PIPEPATH=f'/mnt/d3m-arrayfire-primitives/pipelines/{PRIM}/{PIPELINE}'
PROBLEM=f'file://{DATA}/{SET}/{SET}_problem/problemDoc.json'
INPUT=f'file://{DATA}/{SET}/TRAIN/dataset_TRAIN/datasetDoc.json'

with open(PIPEPATH, 'r') as file:
    pipeline_description = pipeline_module.Pipeline.from_json(string_or_file=file)
problem_description = Problem.load(PROBLEM)

runtime = Runtime(pipeline=pipeline_description,
                  problem_description=problem_description,
                  context=metadata_base.Context.TESTING,
                  is_standard_pipeline=True)

print('__loading data')
dataset = Dataset.load(dataset_uri=INPUT)
print('__fitting')

t0 = time.time()
fit_results = runtime.fit(inputs=[dataset], return_values=['outputs.0'])
t1 = time.time()
dt_train = t1 - t0
fit_results.check_success()

print('__bottom {0:4.4f} s'.format(dt_train))
