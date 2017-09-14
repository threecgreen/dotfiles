#!/bin/bash
# Script for installing jupyter kernel in a conda environment
# Environment kernel will be "Python {Python Version Number (2 | 3)} ({environment name})"
source activate "$1"

export PYTHON_VERSION=`python -c 'import sys; v = sys.version_info[0]; sys.stdout.write(str(v))'`
python -m ipykernel install --user --name "$1" --display-name "Python $PYTHON_VERSION ($1)"
