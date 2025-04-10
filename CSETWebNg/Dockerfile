FROM node:22 AS build

WORKDIR /var/www

COPY . /var/www/

RUN apt-get update
RUN npm i -g @angular/cli \
    && npm i

# Increase Node's memory limit for the Angular build step
RUN ng build \
    --configuration=production \
    --source-map=false \
    --vendor-chunk=true \
    --optimization=true

FROM nginx:alpine

COPY --from=build /var/www/dist/ /usr/share/nginx/html
COPY ./etc/nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]