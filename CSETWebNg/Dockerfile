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

# Angular's application builder outputs the browser bundle under dist/browser.
# Copy that folder so index.html sits at Nginx's web root (otherwise Nginx serves its default page).
COPY --from=build /var/www/dist/browser/ /usr/share/nginx/html
COPY ./etc/nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
