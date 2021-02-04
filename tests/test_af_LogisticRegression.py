# -*- compile-command: "cd .. && ./6-unittest-af.sh"; -*-
import unittest
import numpy
from d3m import container, utils
from d3m.metadata import base as metadata_base
from common_primitives import dataframe_to_ndarray, dataset_to_dataframe, ndarray_to_dataframe
import numpy as np
from sklearn import datasets
from sklearn.utils import shuffle
def M(s):
    print(s)
    return s

import arrayfire as af
import af_LogisticRegression


rng = np.random.RandomState(0)

iris = datasets.load_iris()
iris.data, iris.target = shuffle(iris.data, iris.target, random_state=rng)

def ints_to_onehots(ints, num_classes):
    onehots = np.zeros((ints.shape[0], num_classes), dtype='float32')
    onehots[np.arange(ints.shape[0]), ints] = 1
    return onehots

class RefAfLogisticRegression:
    def __init__(self, alpha=0.1, lambda_param=1.0, maxerr=0.01, maxiter=1000, verbose=False):
        self.__alpha = alpha
        self.__lambda_param = lambda_param
        self.__maxerr = maxerr
        self.__maxiter = maxiter
        self.__verbose = verbose
        self.__weights = None


    def predict_proba(self, X):
        Z = af.matmul(X, self.__weights)
        return af.sigmoid(Z)


    def predict_log_proba(self, X):
        return af.log(self.predict_proba(X))


    def predict(self, X):
        probs = self.predict_proba(X)
        _, classes = af.imax(probs, 1)
        return classes


    def cost(self, X, Y):
        # Number of samples
        m = Y.dims()[0]

        dim0 = self.__weights.dims()[0]
        dim1 = self.__weights.dims()[1] if len(self.__weights.dims()) > 1 else None
        dim2 = self.__weights.dims()[2] if len(self.__weights.dims()) > 2 else None
        dim3 = self.__weights.dims()[3] if len(self.__weights.dims()) > 3 else None
        # Make the lambda corresponding to self.__weights(0) == 0
        lambdat = af.constant(self.__lambda_param, dim0, dim1, dim2, dim3)

        # No regularization for bias weights
        lambdat[0, :] = 0

        # Get the prediction
        H = self.predict_proba(X)

        # Cost of misprediction
        Jerr = -1 * af.sum(Y * af.log(H) + (1 - Y) * af.log(1 - H), dim=0)

        # Regularization cost
        Jreg = 0.5 * af.sum(lambdat * self.__weights * self.__weights, dim=0)

        # Total cost
        J = (Jerr + Jreg) / m

        # Find the gradient of cost
        D = (H - Y)
        dJ = (af.matmulTN(X, D) + lambdat * self.__weights) / m

        return J, dJ


    def train(self, X, Y):
        # Initialize parameters to 0
        self.__weights = af.constant(0, X.dims()[1], Y.dims()[1])

        for i in range(self.__maxiter):
            # Get the cost and gradient
            J, dJ = self.cost(X, Y)
            err = af.max(af.abs(J))
            if err < self.__maxerr:
                print('Iteration {0:4d} Err: {1:4f}'.format(i + 1, err))
                print('Training converged')
                return self.__weights

            if self.__verbose and ((i+1) % 10 == 0):
                print('Iteration {0:4d} Err: {1:4f}'.format(i + 1, err))

            # Update the weights via gradient descent
            self.__weights = self.__weights - self.__alpha * dJ

        if self.__verbose:
            print('Training stopped after {0:d} iterations'.format(self.__maxiter))


    def eval(self):
        af.eval(self.__weights)
        af.sync()


class AFLogisticLogisticRegression(unittest.TestCase):
    def test_basic(self):
        num_classes = np.unique(iris.target).shape[0]

        # Convert numpy array to af array; convert labels from ints to one-hot encodings
        train_feats = af.from_ndarray(iris.data.astype('float32'))
        train_targets = af.from_ndarray(ints_to_onehots(iris.target.astype('uint32'), num_classes))
        test_feats = af.from_ndarray(iris.data.astype('float32'))
        test_targets = af.from_ndarray(ints_to_onehots(iris.target.astype('uint32'), num_classes))

        num_train = train_feats.dims()[0]
        num_test = test_feats.dims()[0]

        ref_clf = RefAfLogisticRegression(alpha=0.1,          # learning rate
                                          lambda_param = 1.0, # regularization constant
                                          maxerr=0.01,        # max error
                                          maxiter=1000,       # max iters
                                          verbose=False       # verbose mode
        )

        ref_clf.train(train_feats, train_targets)
        af_output = ref_clf.predict(test_feats)
        ref_output = af_output.to_ndarray()
        print('Completed reference calculation')

        # import pdb; pdb.set_trace()

        # actual d3m attempted arrayfire fails w/ missing columns method
        hyperparams = af_LogisticRegression.Hyperparams.defaults()

        test_clf = af_LogisticRegression.af_LogisticRegression(hyperparams=hyperparams)
        train_set = iris.data
        targets = iris.target
        test_clf.set_training_data(inputs=train_set, outputs=targets)
        test_clf.fit()



if __name__ == '__main__':
    unittest.main()
