# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy-amd64 AS build-env
WORKDIR /app

# Copy project files for dependency restoration
COPY src/CarRental.BlazorApp/CarRental.BlazorApp.csproj ./CarRental.BlazorApp/
COPY src/CarRental.Controllers/CarRental.Controllers.csproj ./CarRental.Controllers/
COPY src/CarRental.Domain/CarRental.Domain.csproj ./CarRental.Domain/

# Restore dependencies for the main project
WORKDIR /app/CarRental.BlazorApp
RUN dotnet restore

# Copy the entire source code
WORKDIR /app
COPY src/CarRental.BlazorApp/ ./CarRental.BlazorApp/
COPY src/CarRental.Controllers/ ./CarRental.Controllers/
COPY src/CarRental.Domain/ ./CarRental.Domain/

# Build the application
WORKDIR /app/CarRental.BlazorApp
RUN dotnet publish -c Release -o /app/out --no-restore

# Use the official .NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-amd64
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out .

# Expose the port that the application will run on
EXPOSE 8080

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Run the application
ENTRYPOINT ["dotnet", "CarRental.BlazorApp.dll"]
