#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

sh $SCRIPT_DIR/update-function.sh $1
sh $SCRIPT_DIR/invoke-function.sh $1
echo "====== LOG ======"
sh $SCRIPT_DIR/show-logs.sh $1
