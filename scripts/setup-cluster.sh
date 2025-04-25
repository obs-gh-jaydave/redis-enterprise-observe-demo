#!/bin/bash
set -e

echo "Automating Redis Enterprise Cluster Setup"

# Variables
CLUSTER_NAME="redis-enterprise-cluster"
ADMIN_USER="admin@example.com"
ADMIN_PASSWORD="redis123"

# Step 1: Create the cluster with single quotes to avoid interpretation issues
echo "Creating Redis Enterprise cluster..."
docker compose exec redis-enterprise bash -c "
  /opt/redislabs/bin/rladmin cluster create \\
  name ${CLUSTER_NAME} \\
  username ${ADMIN_USER} \\
  password ${ADMIN_PASSWORD}
"

echo "Cluster created successfully!"

# Step 2: Verify the cluster is up
echo "Verifying cluster status..."
docker compose exec redis-enterprise bash -c "/opt/redislabs/bin/rladmin status"

# Step 3: Wait for metrics endpoint to become available
echo "Waiting for metrics endpoint to become available..."
MAX_RETRIES=30
RETRY_INTERVAL=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Checking metrics endpoint (attempt $((RETRY_COUNT+1))/$MAX_RETRIES)..."
  docker compose exec redis-enterprise curl -s -k https://localhost:8070/metrics > /dev/null
  
  if [ $? -eq 0 ]; then
    echo "✅ Metrics endpoint is now accessible!"
    break
  fi
  
  echo "Metrics not yet available. Waiting $RETRY_INTERVAL seconds..."
  sleep $RETRY_INTERVAL
  RETRY_COUNT=$((RETRY_COUNT+1))
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  echo "❌ Failed to access metrics endpoint after $MAX_RETRIES attempts."
  exit 1
fi

echo "Redis Enterprise cluster setup completed successfully!"