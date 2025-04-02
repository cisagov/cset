FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

COPY . .

# Use Release configuration for published output
RUN dotnet publish CSETWeb_Api/CSETWeb_ApiCore -c Release -o out

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

# Copy published output from build stage
COPY --from=build /app/out /app/

# Create a file to indicate local installation
RUN touch LOCAL-INSTALLATION

# Set environment variable (optional if already configured in appsettings/code)
ENV ASPNETCORE_ENVIRONMENT=Production
ENV HTTP_PORTS=5000

# Expose the port
EXPOSE 5000

# Entrypoint to run the compiled DLL
ENTRYPOINT ["dotnet", "CSETWebCore.Api.dll"]
