//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
