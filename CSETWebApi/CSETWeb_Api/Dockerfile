FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-env

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Docker

COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
EXPOSE 80

COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "CSETWebCore.Api.dll"]