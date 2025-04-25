#!/bin/bash
echo "Checking Redis Enterprise container status..."

# Check if the container is running
docker compose ps redis-enterprise

# Check logs
echo "\nContainer logs (last 20 lines):"
docker compose logs --tail 20 redis-enterprise

# Check the network status
echo "\nContainer network status:"
docker compose exec redis-enterprise netstat -tuln | grep 8070

# Try to access metrics directly from the host
echo "\nTrying to access metrics from host:"
curl -k https://localhost:8070/metrics