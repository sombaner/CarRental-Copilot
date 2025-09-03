using System;
using System.Configuration;
using Microsoft.Extensions.Configuration;

namespace CarRental.Controllers.Shared
{
    public class ConfigurationService
    {
        private static IConfiguration _configuration;
        
        public static void Initialize(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        
        public static string GetConnectionString(string name)
        {
            // Try modern appsettings.json configuration first
            if (_configuration != null)
            {
                return _configuration.GetConnectionString(name);
            }
            
            // Fall back to App.config for backward compatibility
            try
            {
                return ConfigurationManager.ConnectionStrings[name]?.ConnectionString;
            }
            catch
            {
                return null;
            }
        }
        
        public static string GetAppSetting(string key)
        {
            // Try modern appsettings.json configuration first
            if (_configuration != null)
            {
                return _configuration["AppSettings:" + key];
            }
            
            // Fall back to App.config for backward compatibility
            try
            {
                return ConfigurationManager.AppSettings[key];
            }
            catch
            {
                return null;
            }
        }
        
        public static string GetProviderName(string connectionName)
        {
            // Try modern appsettings.json configuration first
            if (_configuration != null)
            {
                return _configuration.GetConnectionString(connectionName + ":ProviderName") ?? "System.Data.SqlClient";
            }
            
            // Fall back to App.config for backward compatibility
            try
            {
                return ConfigurationManager.ConnectionStrings[connectionName]?.ProviderName ?? "System.Data.SqlClient";
            }
            catch
            {
                return "System.Data.SqlClient";
            }
        }
    }
}