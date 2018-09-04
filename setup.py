#!/usr/bin/env python

import os
import glob
from shutil import copyfile
from setuptools import setup
from setuptools.command.install import install


class InstallCommand(install):
    user_options = install.user_options + [
        ('examples=', None, None),
        ('docs=', None, None),
    ]

    def initialize_options(self):
        install.initialize_options(self)
        self.examples = None
        self.docs = None

    def finalize_options(self):
        install.finalize_options(self)

    def run(self):
        if self.examples is not None and self.docs is not None:
            dir = os.path.dirname(__file__)
            print('__file__: %s' % __file__)
            print('dir: %s' % dir)

        if self.examples is not None:
            print('self.examples: %s' % self.examples)

            # define our destination directories:
            # examples_dir = self.examples + '/examples'
            examples_dir = self.examples
            sw_dir = examples_dir + '/sw'
            graph_dir = examples_dir + '/graph'

            # create them:
            if not os.path.exists(examples_dir):
                print('Creating examples directory.')
                os.makedirs(examples_dir)
            if not os.path.exists(sw_dir):
                print('Creating examples/sw directory.')
                os.makedirs(sw_dir)
            if not os.path.exists(graph_dir):
                print('Creating examples/graph directory.')
                os.makedirs(graph_dir)

            # copy example files to destination directory:
            for file in glob.glob(dir + "/semantic_db/examples/sw/*"):
                print('file: %s' % file)
                basename = os.path.basename(file)
                print('basename: %s' % basename)
                copyfile(file, sw_dir + '/' + basename)

            # copy graph files to destination directory:
            for file in glob.glob(dir + "/semantic_db/examples/graph/*"):
                print('file: %s' % file)
                basename = os.path.basename(file)
                print('basename: %s' % basename)
                copyfile(file, graph_dir + '/' + basename)

        if self.docs is not None:
            print('self.docs: %s' % self.docs)

            # define our destination directory:
            # docs_dir = self.docs + '/docs'
            docs_dir = self.docs

            # create them:
            if not os.path.exists(docs_dir):
                print('Creating docs directory.')
                os.makedirs(docs_dir)

            # copy docs to destination directory:
            for file in glob.glob(dir + '/docs/*'):
                print('file: %s' % file)
                basename = os.path.basename(file)
                print('basename: %s' % basename)
                copyfile(file, docs_dir + '/' + basename)

            # somewhere around here we should generate usage-html too!
            # see: https://stackoverflow.com/questions/7974849/how-can-i-make-one-python-file-run-another
            # and we should store the sw/ and graph/ dirs in our config file
            # how to pass the new sw/ and graph/ to create-usage-html.py?
            # answer: use the paths stored in the config file.

        install.run(self)

setup(
    name='Semantic-DB',
    version='2.0',
    description='',
    author='Garry Morrison',
    author_email='garry@semantic-db.org',
    url='http://semantic-db.org/docs/usage/index.html',
    packages=['semantic_db'],
    install_requires=[
        'parsley',
        'numpy',
        'matplotlib',
    ],
    extras_require={
        'Graph':  ["graphviz"],
    },
    classifiers=[
        'Development Status :: 3 - Alpha',
    ],
    include_package_data=True,
    cmdclass={
        'install': InstallCommand,
    }
)
