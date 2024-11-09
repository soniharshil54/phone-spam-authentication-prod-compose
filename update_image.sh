#!/bin/bash

# Usage: ./update_image.sh <service_name> <new_image_path>
# Example: ./update_image.sh api-service us-central1-docker.pkg.dev/gotham-433513/phone-spam-api-repo/phone-spam-api-service-prod:v1.2.40

SERVICE_NAME="$1"
NEW_IMAGE_PATH="$2"

if [[ -z "$SERVICE_NAME" || -z "$NEW_IMAGE_PATH" ]]; then
    echo "Usage: $0 <service_name> <new_image_path>"
    exit 1
fi

# Update only the specified service's image line in docker-compose.prod.yaml
awk -v service="$SERVICE_NAME" -v image="$NEW_IMAGE_PATH" '
  BEGIN { in_service = 0 }
  $0 ~ "^[[:space:]]+" service ":" { in_service = 1 }
  in_service && /image:/ { $0 = "    image: " image; in_service = 0 }
  { print }
' docker-compose.prod.yaml > docker-compose.prod.tmp && mv docker-compose.prod.tmp docker-compose.prod.yaml
