#!/bin/bash
set -e
echo "Loading environment variables from .env..."

# Export variables
set -o allexport
source .env
set +o allexport

# Replace variables in prometheus.yml.template -> prometheus.yml
envsubst < prometheus/prometheus.yml.template > prometheus/prometheus.yml

echo "Starting Redis Enterprise + Prometheus..."
docker compose up -d
echo "Waiting for Redis Enterprise container to initialize..."
sleep 60  # Give Redis Enterprise some time to start up before configuring the cluster

# Set up the Redis Enterprise cluster
echo "Setting up Redis Enterprise cluster..."
chmod +x ./scripts/setup-cluster.sh
./scripts/setup-cluster.sh

echo "Redis Enterprise should now be exposing metrics on port 8070."
echo "Check Prometheus at http://localhost:9090"
echo "Verify targets at http://localhost:9090/targets"