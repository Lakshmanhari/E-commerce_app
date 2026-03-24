#!/bin/bash

echo "Starting deployment..."

# Pull latest production image
docker pull lakshmanhari/prod:latest

# Stop old container (if exists)
docker stop app-container || true
docker rm app-container || true

# Run new container
docker run -d -p 80:80 --name app-container lakshmanhari/prod:latest

echo "Deployment completed!"