#!/bin/bash

echo "Starting build process..."

# Build Docker image
docker build -t lakshmanhari/dev:latest .

# Push to Docker Hub (dev repo)
docker push lakshmanhari/dev:latest

echo "Build and push completed!"