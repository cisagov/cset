using CSETWebCore.Interfaces.Helpers;
using Microsoft.Extensions.Configuration;

namespace CSETWebCore.Helpers
{
    public class ApiKeyManager : IApiKeyManager
    {
        private readonly IConfiguration _config;
        public ApiKeyManager(IConfiguration config) 
        { 
            _config = config;
        }
        public bool IsValidApiKey(string apiKey)
        {
            if (string.IsNullOrWhiteSpace(apiKey)) 
            { 
                return false;   
            }

            string configApiKey = _config.GetValue<string>(Constants.Constants.API_KEY_CONFIG_NAME);

            if (string.IsNullOrEmpty(configApiKey) || configApiKey != apiKey) 
            { 
                return false;
            }

            return true;
        }
    }
}
