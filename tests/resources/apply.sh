#!/bin/bash

set -o errexit
set -o pipefail

for f in ./tests/*.sh; do
  bash "$f" -H && echo "--------------"
done
