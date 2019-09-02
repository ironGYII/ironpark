# -*- coding: utf-8 -*-

from __future__ import print_function
import commandr
import importlib

from pyspark.sql import SparkSession


@commandr.command('run')
def main(path, name):

    spark = SparkSession \
        .builder \
        .appName("PythonPi") \
        .getOrCreate()

    module = importlib.import_module(path)

    task = getattr(module, name)(spark)
    task.run()
    spark.stop()


if __name__ == '__main__':
    commandr.Run()

# bin/spark-submit \
#     --master k8s://https://kubernetes.docker.internal:6443 \
#     --deploy-mode cluster \
#     --name spark-pi \
#     --conf spark.executor.instances=1 \
#     --conf spark.kubernetes.container.image=spark:ironpark \
#     --conf spark.kubernetes.pyspark.pythonVersion="3" \
#     local:///opt/spark/work-dir/main.py run -p app.pi -n Pi
