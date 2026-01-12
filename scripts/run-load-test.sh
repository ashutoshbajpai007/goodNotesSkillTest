#!/bin/bash
# filepath: scripts/run-load-test.sh
# Reusable script to run load tests.
# Usage: ./run-load-test.sh <requests> <concurrency> <results-file>

REQUESTS=${1:-1000}
CONCURRENCY=${2:-10}
RESULTS_FILE=${3:-results.md}

# Update /etc/hosts
echo "127.0.0.1 foo.localhost bar.localhost" | sudo tee -a /etc/hosts

# Run load tests
hey -n $REQUESTS -c $CONCURRENCY -H "Host: foo.localhost" http://localhost/ > foo_results.txt
hey -n $REQUESTS -c $CONCURRENCY -H "Host: bar.localhost" http://localhost/ > bar_results.txt

# Combine results
echo "## Load Test Results" > $RESULTS_FILE
echo "### Foo Service" >> $RESULTS_FILE
cat foo_results.txt >> $RESULTS_FILE
echo "### Bar Service" >> $RESULTS_FILE
cat bar_results.txt >> $RESULTS_FILE