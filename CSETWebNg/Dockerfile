FROM node:22 AS build

WORKDIR /var/www

COPY . /var/www/

RUN apt-get update
RUN npm i -g @angular/cli \
    && npm i

RUN ng build \
    --configuration=production \
    --source-map=false \
    --optimization=true

FROM nginx:alpine

# Angular's application builder outputs the browser bundle under dist.
# Copy that folder so index.html sits at Nginx's web root (otherwise Nginx serves its default page).
COPY --from=build /var/www/dist/ /usr/share/nginx/html
COPY ./etc/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy entrypoint script for runtime config injection (API_PORT, API_HOST)
COPY ./etc/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80 443

# Use entrypoint to inject env vars before starting nginx
ENTRYPOINT ["/docker-entrypoint.sh"]
