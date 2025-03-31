FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

COPY . .

# Use Release configuration for published output
RUN dotnet publish CSETWeb_Api/CSETWeb_ApiCore -c Release -o out

# --- Final Runtime Stage ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

# Copy published output from build stage
COPY --from=build /app/out /app/

WORKDIR /app/out

# Expose the port (still good practice)
EXPOSE 5000

# Set environment variable (optional if already configured in appsettings/code)
ENV ASPNETCORE_ENVIRONMENT=Development
# ASPNETCORE_URLS is often not needed here if Kestrel defaults or appsettings configure it
# ENV ASPNETCORE_URLS=http://*:5000 # Use * or + instead of 0.0.0.0 if needed

# Entrypoint to run the compiled DLL
ENTRYPOINT ["dotnet", "CSETWebCore.Api.dll"]
