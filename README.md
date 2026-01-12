# CI Load Test Project

This project implements a CI workflow that performs load testing on a Kubernetes cluster provisioned with KinD for each pull request to the main branch.

# time taken: Around 1.5 hours
## Overview

The CI workflow does the following:

1. Triggers on pull requests to the `main` branch.
2. Provisions a multi-node KinD cluster (1 control-plane + 1 worker).
3. Deploys Ingress NGINX controller.
4. Deploys two http-echo services: `foo` and `bar`.
5. Configures Ingress routing for `foo.localhost` and `bar.localhost`.
6. Waits for all components to be healthy.
7. Runs load tests using `hey` on both services.
8. Posts the load test results as a comment on the PR.

## Tech Stack

- **CI/CD**: GitHub Actions
- **Orchestration**: Bash scripts
- **Kubernetes**: KinD for local cluster
- **Ingress**: NGINX Ingress Controller
- **Load Testing**: hey (HTTP load generator)
- **Services**: hashicorp/http-echo

## Workflow Details.

### KinD Cluster Configuration
- 1 control-plane node with ingress-ready label
- 1 worker node
- Ports 80 and 443 mapped to host

### Services
- `foo-deployment`: 2 replicas, responds with "foo"
- `bar-deployment`: 2 replicas, responds with "bar"
- Services exposed on port 80

### Ingress Rules
- `foo.localhost` -> foo-service
- `bar.localhost` -> bar-service

### Load Test
- 1000 requests per service
- 10 concurrent connections
- Results include response times, throughput, etc.

## Running Locally

To test the setup locally:

1. Install KinD, kubectl, and hey.
2. Run the steps from the CI workflow manually.
3. Check the results in the generated files.

## Validation

The workflow validates:
- Cluster creation
- Ingress controller deployment
- Service deployments and readiness
- Ingress configuration
- Load test execution and result posting

## Error Handling

- Timeouts for waiting conditions (300s)
- Fails fast if any step fails
- Results posted even if load test partially succeeds

## Commit Messages

All commits follow conventional commit format with clear, concise messages describing changes.
