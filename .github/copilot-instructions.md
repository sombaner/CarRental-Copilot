# CarRental Desktop Application

CarRental is a .NET Framework 4.7.2 WinForms desktop application for managing car rental operations. It includes customer management, vehicle inventory, rental processing, and employee management features. The application uses SQL Server LocalDB for data storage and PDFsharp for report generation.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

- Bootstrap, build, and test the repository:
  - Install dependencies: `sudo apt update && sudo apt install -y mono-complete mono-devel`
  - Install NuGet: `cd /tmp && wget -q https://dist.nuget.org/win-x86-commandline/latest/nuget.exe`
  - Restore packages: `cd src && mono /tmp/nuget.exe restore`
  - Build projects: `cd src && xbuild CarRental.Domain/CarRental.Domain.csproj && xbuild CarRental.Controllers/CarRental.Controllers.csproj && xbuild CarRental.WindowsApp/CarRental.WindowsApp.csproj` -- takes 6 seconds to complete. NEVER CANCEL. Set timeout to 60+ seconds.
  - **C# Language Compatibility**: Code uses C# 7+ features (pattern matching, default literals) that are NOT supported by Mono's compiler. You MUST replace modern syntax with compatible versions:
    - `!(obj is null)` → `obj != null`
    - `default` → `default(T)` or `null` for reference types
    - **ALWAYS** verify syntax compatibility before building

## Validation

- **Database Limitation**: The application requires SQL Server LocalDB which is Windows-only. On Linux, the application will build but cannot connect to the database.
- **Runtime Limitation**: This is a WinForms application that requires Windows or an X-Server environment. On Linux without GUI, it will fail with "Could not open display" error.
- **Test Limitation**: MSTest projects do not build successfully with Mono due to compatibility issues. The error "Invalid type 'System.Globalization.CultureInfo' used in static method invocation" is expected.
- **SQL Server Project**: The CarRental.SqlServer project cannot be built on Linux as it requires SQL Server Data Tools (SSDT).
- ALWAYS manually validate that C# syntax changes are compatible with Mono C# 7.0 compiler before committing.
- Build validation: Run the build command above and ensure all three main projects (Domain, Controllers, WindowsApp) compile successfully.

## Project Structure

### Key Components
- **CarRental.Domain**: Core business logic library containing entities (Customer, Vehicle, Rental, etc.) and domain services
- **CarRental.Controllers**: Data access layer with controllers for each entity type and database operations  
- **CarRental.WindowsApp**: WinForms UI application with feature-based organization (main executable)
- **CarRental.Tests**: MSTest unit tests (does not build on Linux/Mono)
- **CarRental.SqlServer**: SQL Server database project with table definitions (cannot build on Linux)

### Dependencies
- **PDFsharp 1.50.5147**: PDF generation for reports
- **MSTest 2.2.5**: Unit testing framework  
- **FluentAssertions 5.10.3**: Test assertion library
- **System.Data.SqlClient 4.9.0**: SQL Server connectivity
- **DataGridViewGrouper**: Custom DataGridView extension (included as DLL)

## Build and Database Requirements

### Build Tools
- **Windows**: Visual Studio 2017+ with .NET Framework 4.7.2 targeting pack
- **Linux**: Mono 6.8+ with xbuild (deprecated but functional for this legacy project)
- **NuGet**: Required for package restoration

### Database Setup
- **Windows**: SQL Server LocalDB with connection string `(localdb)\mssqllocaldb;Initial Catalog=CarRental`
- **Linux**: Database functionality unavailable (SQL Server LocalDB is Windows-only)
- Create database using the SQL scripts in CarRental.SqlServer project (Windows only)

## Common Tasks

### Build Commands (Linux/Mono)
```bash
# Install build dependencies
sudo apt update && sudo apt install -y mono-complete mono-devel

# Download NuGet
cd /tmp && wget -q https://dist.nuget.org/win-x86-commandline/latest/nuget.exe

# Restore packages
cd src && mono /tmp/nuget.exe restore

# Build main projects (6 seconds total)
cd src
xbuild CarRental.Domain/CarRental.Domain.csproj
xbuild CarRental.Controllers/CarRental.Controllers.csproj  
xbuild CarRental.WindowsApp/CarRental.WindowsApp.csproj
```

### Build Commands (Windows)
```cmd
# Restore packages
nuget restore src\CarRental.sln

# Build solution
msbuild src\CarRental.sln /p:Configuration=Debug
```

### Running the Application
- **Windows**: Execute `src\CarRental.WindowsApp\bin\Debug\CarRental.WindowsApp.exe`
- **Linux**: Not supported (WinForms requires Windows or X-Server)

## Known Limitations and Workarounds

### C# Language Version Issues
The codebase uses modern C# features that are incompatible with Mono's C# 7.0 compiler:
- **Pattern matching**: `!(obj is null)` must be changed to `obj != null`
- **Default literals**: `default` must be changed to `default(T)` or `null`
- Always test builds on Linux after making C# syntax changes

### Platform Limitations
- **SQL Server**: Only available on Windows; no Linux equivalent for LocalDB
- **WinForms UI**: Requires Windows or X-Server; cannot run in headless Linux environments
- **MSTest**: Does not build with Mono; use Windows for running unit tests
- **SQL Server Projects**: Require SSDT; only buildable on Windows with Visual Studio

### Development Workflow
1. **Windows Development**: Full functionality including database, UI, and tests
2. **Linux Development**: Limited to code editing and syntax validation; cannot run application or tests
3. **Cross-platform Strategy**: Consider migrating to .NET Core/5+ and cross-platform database for full Linux support

## Troubleshooting

### Build Failures
- **C# syntax errors**: Update to Mono-compatible syntax as described above
- **Missing packages**: Ensure NuGet restore completed successfully
- **Framework version warnings**: Expected with Mono; does not prevent successful builds

### Runtime Issues
- **Database connection failures**: Expected on Linux; SQL Server LocalDB unavailable
- **Display errors**: Expected on Linux without X-Server; WinForms requires GUI environment
- **Missing assemblies**: Verify all NuGet packages restored correctly

## Repository File Structure

```
.
├── README.md
├── LICENSE
├── .github/
│   ├── workflows/
│   │   └── copilot-setup-steps.yml
│   └── copilot-instructions.md
├── .vscode/
│   └── settings.json
└── src/
    ├── CarRental.sln
    ├── packages/
    ├── CarRental.Domain/
    ├── CarRental.Controllers/
    ├── CarRental.WindowsApp/
    ├── CarRental.Tests/
    └── CarRental.SqlServer/
```

## Architecture Notes

The application follows a layered architecture:
- **Domain Layer**: Entity classes and business logic
- **Data Access Layer**: Controllers with database operations using ADO.NET
- **Presentation Layer**: WinForms with feature-based organization
- **Database Layer**: SQL Server with stored procedures and constraints

Key architectural patterns:
- Repository pattern in Controllers layer
- Domain-driven design in Domain layer  
- MVP pattern in WinForms UI
- Dependency injection via constructor parameters