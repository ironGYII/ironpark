# -*- coding: utf-8 -*-

from __future__ import print_function

from random import random
from operator import add


class Pi(object):

    def __init__(self, spark):

        self.spark = spark
        self.partitions = 10

    def run(self):
        n = 100000 * self.partitions

        def f(_):
            x = random() * 2 - 1
            y = random() * 2 - 1
            return 1 if x ** 2 + y ** 2 <= 1 else 0

        count = self.spark.sparkContext.parallelize(range(1, n + 1), self.partitions).map(f).reduce(add)
        print("Pi is roughly %f" % (4.0 * count / n))
