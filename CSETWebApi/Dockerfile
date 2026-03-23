FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /app

COPY . .

# Optional: install a custom CA cert for corporate proxies/VPNs.
# Set CA_CERT_URL in .env (gitignored) to enable — e.g.:
#   CA_CERT_URL=https://your-internal-cert-store/root_ca.crt
ARG CA_CERT_URL=""
RUN if [ -n "$CA_CERT_URL" ]; then \
  apt-get update && apt-get install -y --no-install-recommends wget && \
  wget -q --no-check-certificate -P /usr/local/share/ca-certificates/ "$CA_CERT_URL" && \
  update-ca-certificates; \
  fi

# Use Release configuration for published output
RUN dotnet publish CSETWeb_Api/CSETWeb_ApiCore -c Release -o out

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0

WORKDIR /app

# Copy published output from build stage
COPY --from=build /app/out /app/

# Set environment variable (optional if already configured in appsettings/code)
ENV ASPNETCORE_ENVIRONMENT=Production
ENV HTTP_PORTS=5000

# Expose the port
EXPOSE 5000

# Entrypoint to run the compiled DLL
ENTRYPOINT ["dotnet", "CSETWebCore.Api.dll"]
