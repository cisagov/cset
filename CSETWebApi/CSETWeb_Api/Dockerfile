FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Docker

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet dev-certs https --trust
RUN dotnet publish -c Release -o out

EXPOSE 5000 5001