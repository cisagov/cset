FROM node:latest

WORKDIR /usr/src/app

COPY package*.json .
COPY .snyk .

RUN npm i

RUN npm i -g @angular/cli

COPY . .