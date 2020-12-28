#!/usr/bin/env python3
# -*- compile-command: "./5-example-python-af.sh"; -*-

import sys
import unittest

runner = unittest.TextTestRunner(verbosity=1)

tests = unittest.TestLoader().discover('tests')

if not runner.run(tests).wasSuccessful():
    sys.exit(1)
