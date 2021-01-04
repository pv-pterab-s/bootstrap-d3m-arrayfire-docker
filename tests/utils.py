# -*- compile-command: "cd .. && ./6-unittest-af.sh"; -*-
import json
import os

from d3m import utils, container
from d3m.metadata import base as metadata_base

from common_primitives import dataset_to_dataframe


def load_iris_metadata():
    dataset_doc_path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'data', 'datasets', 'iris_dataset_1', 'datasetDoc.json'))
    dataset = container.Dataset.load('file://{dataset_doc_path}'.format(dataset_doc_path=dataset_doc_path))
    return dataset


# def load_baseball_metadata():
#     dataset_doc_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'datasets', 'iris_dataset_1', 'datasetDoc.json'))
#     # dataset_doc_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'datasets', 'training_datasets', 'seed_datasets_archive', '185_baseball', '185_baseball_dataset', 'datasetDoc.json'))
#     dataset = container.Dataset.load(f'file://{dataset_doc_path}')
#     return dataset
