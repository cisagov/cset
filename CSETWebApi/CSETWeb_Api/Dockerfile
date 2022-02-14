FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Docker

COPY . ./

RUN dotnet restore

RUN dotnet dev-certs https --trust

EXPOSE 5000 5001
