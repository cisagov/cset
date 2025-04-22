FROM node:22 AS build

WORKDIR /var/www

COPY . /var/www/

# Configure INL certs and environment variables
ADD http://certstore.inl.gov/pki/CAINLROOT_B64.crt /usr/local/share/ca-certificates/
RUN /usr/sbin/update-ca-certificates
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt \
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_DIR=/etc/ssl/certs/

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