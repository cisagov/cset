#!/bin/sh
set -e

CONFIG_FILE="/usr/share/nginx/html/assets/settings/config.json"

# Replace API port if API_PORT env var is set (default: 5000).
# Set API_PORT to empty string to remove the port (e.g., for standard HTTPS on port 443).
if [ "${API_PORT+x}" = "x" ]; then
  sed -i 's/"port": "5000"/"port": "'"$API_PORT"'"/' "$CONFIG_FILE"
fi

# Replace API host if API_HOST env var is set (default: localhost)
if [ -n "$API_HOST" ]; then
  # Replace only the api.host, not app.host - target the line after "api": {
  sed -i '/"api":/,/"library":/ s/"host": "localhost"/"host": "'"$API_HOST"'"/' "$CONFIG_FILE"
fi

# Replace API protocol if API_PROTOCOL env var is set (default: http).
# Set to "https" when serving behind a TLS-terminating reverse proxy.
if [ -n "$API_PROTOCOL" ]; then
  sed -i '/"api":/,/"library":/ s/"protocol": "http"/"protocol": "'"$API_PROTOCOL"'"/' "$CONFIG_FILE"
fi

# Start nginx
exec nginx -g 'daemon off;'
