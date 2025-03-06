FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files (csproj) and restore dependencies
COPY ./CSETWeb_Api/CSETWeb_ApiCore/*.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . .

# Build the application
RUN dotnet build CSETWeb_Api/CSETWeb_ApiCore --configuration Debug

# Expose the port the app runs on (default for ASP.NET Core is 5000 for HTTP)
EXPOSE 5000

# Set environment variables for development mode
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://0.0.0.0:5000


COPY ./etc/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

# Run the application
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
