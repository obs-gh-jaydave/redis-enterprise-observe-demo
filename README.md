# Redis Enterprise + Observe Sandbox

This project sets up a testbed environment to:
- Deploy a Redis Enterprise container
- Automatically configure a Redis Enterprise cluster
- Scrape metrics using Prometheus
- Push those metrics to Observe via `remote_write`

## Prerequisites

- Docker and Docker Compose installed on your machine
- An Observe account with:
  - Tenant ID
  - API token with appropriate permissions for Prometheus remote_write

## Quick Setup

1. Clone this repository
   ```bash
   git clone https://github.com/yourusername/redis-enterprise-observe-lab.git
   cd redis-enterprise-observe-lab
   ```

2. Create a `.env` file with your Observe credentials
   ```bash
   # Create .env file from template
   cp .env.template .env
   
   # Edit the file with your actual credentials
   # OBSERVE_TENANT_ID - Your Observe tenant ID (e.g., "123456789")
   # OBSERVE_API_TOKEN - Your Observe API token
   ```

3. Run the start script
   ```bash
   ./scripts/start.sh
   ```

4. Validate that everything is working correctly
   - Check Redis Enterprise: https://localhost:8443 (user: admin@example.com, password: redis123)
   - Check Prometheus: http://localhost:9090
   - Verify Prometheus target: http://localhost:9090/targets (should show `redis-enterprise:8070` as UP)
   - Log into Observe and verify data under Metrics or Streams

## What Happens During Setup

The `start.sh` script performs the following steps:
1. Loads environment variables from `.env`
2. Generates the Prometheus configuration with your Observe credentials
3. Starts the Redis Enterprise and Prometheus containers
4. Automatically configures the Redis Enterprise cluster
5. Waits for the metrics endpoint to become available
6. Establishes the connection between Prometheus and Observe

## Configuration Files

- `.env`: Contains your Observe credentials
- `docker-compose.yml`: Defines the Redis Enterprise and Prometheus containers
- `prometheus/prometheus.yml.template`: Template for Prometheus configuration

## Scripts

- `scripts/start.sh`: Starts the environment and sets up the Redis Enterprise cluster
- `scripts/check-redis.sh`: Checks the status of the Redis Enterprise container
- `scripts/stop.sh`: Stops and cleans up all containers
- `scripts/setup-cluster.sh`: Sets up the Redis Enterprise cluster

## Troubleshooting

If metrics aren't appearing in Observe:
1. Check if Redis Enterprise container is running: `docker compose ps`
2. Verify the metrics endpoint: `curl -k https://localhost:8070/metrics`
3. Check Prometheus targets: http://localhost:9090/targets
4. Verify Prometheus is receiving metrics: http://localhost:9090/graph

## Cleanup

To stop all containers and clean up:
```bash
./scripts/stop.sh
```

## Security Notes

- The Redis Enterprise admin credentials are set to `admin@example.com`/`redis123` by default
- For production use, modify `setup-cluster.sh` to use more secure credentials
- The `.env` file contains sensitive credentials and should not be committed to version control

## Customization

If you need to modify the Redis Enterprise cluster settings:
1. Edit `scripts/setup-cluster.sh` to change the cluster configuration
2. Edit `prometheus/prometheus.yml.template` to modify Prometheus settings

## Additional Resources

- [Redis Enterprise Documentation](https://docs.redis.com/latest/rs/)
- [Observe Documentation](https://docs.observeinc.com/)
- [Prometheus Documentation](https://prometheus.io/docs/)