FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

COPY . .

# Configure INL certs and environment variables
ADD http://certstore.inl.gov/pki/CAINLROOT_B64.crt /usr/local/share/ca-certificates/
RUN /usr/sbin/update-ca-certificates
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt \
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_DIR=/etc/ssl/certs/

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
