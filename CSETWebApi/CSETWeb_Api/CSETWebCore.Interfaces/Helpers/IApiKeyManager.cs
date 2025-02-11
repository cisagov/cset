//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Interfaces.Helpers
{
    public interface IApiKeyManager
    {
        bool IsValidApiKey(string apiKey);
    }
}
