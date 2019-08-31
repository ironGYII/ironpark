# -*- coding: utf-8 -*-
from setuptools import setup, find_packages

__version__ = '0.0.0'


setup(
    name='ironpark',
    version=__version__,
    packages=find_packages(exclude=['tests.*', 'tests', 'docs', 'scripts', 'static']),
    description='Encapsulation spark base k8s',
    long_description='recsys',
    author='ironGYI',
    author_email='ironGYI@163.com',
    include_package_data=True,
    zip_safe=False,
    license='Proprietary',
    platforms='any',
    install_requires=['commandr'],
    entry_points={},
)
