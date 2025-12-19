#!/bin/sh
set -e

CONFIG_FILE="/usr/share/nginx/html/assets/settings/config.json"

# Replace API port if API_PORT env var is set (default: 5000)
if [ -n "$API_PORT" ]; then
  sed -i 's/"port": "5000"/"port": "'"$API_PORT"'"/' "$CONFIG_FILE"
fi

# Replace API host if API_HOST env var is set (default: localhost)
if [ -n "$API_HOST" ]; then
  # Replace only the api.host, not app.host - target the line after "api": {
  sed -i '/"api":/,/"library":/ s/"host": "localhost"/"host": "'"$API_HOST"'"/' "$CONFIG_FILE"
fi

# Start nginx
exec nginx -g 'daemon off;'
