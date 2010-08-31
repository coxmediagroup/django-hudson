#!/bin/bash

SCRIPT_DIR=`dirname $0`
ROOT_DIR=`cd $SCRIPT_DIR/.. && pwd`

ENVSPEC=`stat -f %Y $ROOT_DIR/tests/requirements.pip`
ENVTESTSPEC=`stat -f %Y $ROOT_DIR/tests/requirements_test.pip`
ENVTIME=`test -r $ROOT_DIR/.ve/timestamp && stat -f %Y $ROOT_DIR/.ve/timestamp`
VE=$ROOT_DIR/.ve
set -e

if [ -z "$PIP_DOWNLOAD_CACHE" ]; then
    export PIP_DOWNLOAD_CACHE=$ROOT_DIR/.cache
fi

if [[ $ENVSPEC -gt $ENVTIME || $ENVTESTSPEC -gt $ENVTIME ]]; then
    # clear old environment and rebuild
    rm -rf $VE
fi

if [ -a $VE ]; then
    source $VE/bin/activate
else
    virtualenv $VE
    source $VE/bin/activate
    pip install -r $ROOT_DIR/tests/requirements.pip
    pip install -r $ROOT_DIR/tests/requirements_test.pip
    touch $VE/timestamp
fi

cd $ROOT_DIR
export PYTHONPATH=$ROOT_DIR
python tests/test_runner.py $*
