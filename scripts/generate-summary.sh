#!/bin/bash
# filepath: scripts/generate-summary.sh
# Reusable script to generate a GitHub job summary with step statuses and load test results.
# Usage: ./generate-summary.sh <results-file>

RESULTS_FILE=${1:-results.md}

# Function to check if a step succeeded (using files or commands)
check_step() {
  local step_name="$1"
  local indicator="$2"
  if [[ -n "$indicator" ]] && [[ -f "$indicator" ]]; then
    echo "- ✅ $step_name: Completed"
  elif [[ "$step_name" == "Deploy services" ]] && helm list -q | grep -q echo-app; then
    echo "- ✅ $step_name: Completed"
  elif [[ "$step_name" == "Wait for readiness" ]] && kubectl get deployment foo-deployment -o jsonpath='{.status.availableReplicas}' >/dev/null 2>&1; then
    echo "- ✅ $step_name: Completed"
  else
    echo "- ❌ $step_name: Failed or not reached"
  fi
}

# Start summary
{
  echo "## CI Load Test Summary"
  echo ""
  echo "### Step Statuses"
  check_step "Checkout code" ".git"  # Indicator: .git directory exists
  check_step "Install dependencies" "/usr/local/bin/kubectl"  # Indicator: kubectl installed
  check_step "Create KinD cluster" "kind-config.yaml"  # Indicator: config file created
  check_step "Deploy services" ""  # No direct file; assume success if reached
  check_step "Wait for readiness" ""  # No direct file; assume success if reached
  check_step "Run load test" "$RESULTS_FILE"  # Indicator: results file exists
  echo ""
  echo "### Load Test Results"
  if [[ -f "$RESULTS_FILE" ]]; then
    cat "$RESULTS_FILE"
  else
    echo "No load test results available."
  fi
} >> "$GITHUB_STEP_SUMMARY"