# python setup.py build_ext --inplace
import os
from sys import platform
print("Found platform:", platform)

from setuptools import find_packages, setup
from distutils.core import setup
from Cython.Build import cythonize
from Cython.Distutils import build_ext
import numpy as np

print(find_packages())
setup(
    name='libttp',
    version='0.0.1',
    url='',
    license='',
    author='mdonato',
    author_email='mattia.donato@iit.it',
    description='Libraries for reading the TTP USB stream',
    ext_modules=cythonize("ttpCython/ttpCython.pyx", compiler_directives={'language_level' : "3"}),
    include_dirs=[np.get_include()],
    packages=find_packages()
)


