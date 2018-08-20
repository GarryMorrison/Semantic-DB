#!/usr/bin/env python

from distutils.core import setup

setup(name='Semantic-DB',
    version='2.0',
    description='',
    author='Garry Morrison',
    author_email='',
    url='http://write-up.semantic-db.org/',
    packages=['semantic_db', 'sdb_console.py'],
    install_requires=[
        'parsley',
        'numpy',
        'matplotlib',
    ],
    classifiers=[
        'Development Status :: 3 - Alpha',
    ]
)
