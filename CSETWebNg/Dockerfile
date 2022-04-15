FROM node:latest as build-stage

WORKDIR /usr/src/app

COPY package*.json .
COPY .snyk .

RUN npm install

COPY . .

RUN npm build

# production stage
FROM nginx:stable-alpine as production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html

WORKDIR /etc/nginx/conf.d
RUN rm default.conf
COPY nginx.conf .

CMD ["nginx", "-g", "daemon off;"]