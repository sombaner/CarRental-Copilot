#!/bin/bash

# CarRental Application Deployment Script for AKS
set -e

echo "🚀 Starting CarRental application deployment to AKS..."

# Configuration
IMAGE_NAME="car-rental"
IMAGE_TAG="v1.0.0"
REGISTRY_NAME="your-acr-name.azurecr.io"  # Replace with your ACR name
NAMESPACE="car-rental"

# Step 1: Build Docker image
echo "📦 Building Docker image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Step 2: Tag for ACR (uncomment and modify when you have ACR)
# echo "🏷️  Tagging image for ACR..."
# docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_NAME}/${IMAGE_NAME}:${IMAGE_TAG}

# Step 3: Push to ACR (uncomment when you have ACR)
# echo "⬆️  Pushing image to ACR..."
# docker push ${REGISTRY_NAME}/${IMAGE_NAME}:${IMAGE_TAG}

# Step 4: Create namespace
echo "🏗️  Creating namespace..."
kubectl apply -f k8s/namespace.yaml

# Step 5: Apply ConfigMap
echo "⚙️  Applying ConfigMap..."
kubectl apply -f k8s/configmap.yaml

# Step 6: Apply Deployment
echo "🚢 Deploying application..."
kubectl apply -f k8s/deployment.yaml

# Step 7: Apply Service
echo "🌐 Creating service..."
kubectl apply -f k8s/service.yaml

# Step 8: Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/car-rental-app -n ${NAMESPACE}

# Step 9: Get service information
echo "📋 Getting service information..."
kubectl get service car-rental-service -n ${NAMESPACE}

echo "✅ Deployment completed successfully!"
echo "🔗 To get the external IP, run: kubectl get service car-rental-service -n car-rental"
echo "📊 To check pod status, run: kubectl get pods -n car-rental"
echo "📝 To view logs, run: kubectl logs -l app=car-rental-app -n car-rental"
