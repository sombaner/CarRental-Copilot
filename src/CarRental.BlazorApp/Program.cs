using CarRental.BlazorApp.Components;
using CarRental.Controllers.Shared;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// Configure Blazor Server with memory optimizations
builder.Services.AddSignalR(options =>
{
    // Reduce memory footprint by limiting message buffer
    options.MaximumParallelInvocationsPerClient = 1;
    options.ClientTimeoutInterval = TimeSpan.FromMinutes(5);
    options.HandshakeTimeout = TimeSpan.FromSeconds(15);
});

// Configure circuit options for memory efficiency
builder.Services.Configure<Microsoft.AspNetCore.Components.Server.CircuitOptions>(options =>
{
    // Enable detailed circuit activity logging only in development
    options.DetailedErrors = builder.Environment.IsDevelopment();
    // Set maximum buffer size for circuit data 
    options.MaxBufferedUnacknowledgedRenderBatches = 2; // Reduce buffering
});

var app = builder.Build();

// Initialize the configuration service for backward compatibility
ConfigurationService.Initialize(app.Configuration);

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
