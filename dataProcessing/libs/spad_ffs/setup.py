from setuptools import find_packages, setup
from distutils.core import setup

print(find_packages())

setup(
    name='spad_ffs',
    packages=find_packages(),
    version='0.0.1',
    url='',
    license='',
    author='Eli Slenders',
    author_email='eli.slenders@iit.it',
    description='The analysis of confocal laser-scanning microscopy based fluorescence fluctuation spectroscopy (FFS) data'
)

