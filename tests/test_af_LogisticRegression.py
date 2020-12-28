# -*- compile-command: "cd .. && ./6-unittest-af.sh"; -*-
import unittest
import numpy
from d3m import container, utils
from d3m.metadata import base as metadata_base
from common_primitives import dataframe_to_ndarray, dataset_to_dataframe, ndarray_to_dataframe
import utils as test_utils



class NDArrayToDataFramePrimitiveTestCase(unittest.TestCase):
    def test_basic(self):
        # TODO: Find a less cumbersome way to get a numpy array loaded with a dataset
        # load the iris dataset
        print("hey")

if __name__ == '__main__':
    unittest.main()
