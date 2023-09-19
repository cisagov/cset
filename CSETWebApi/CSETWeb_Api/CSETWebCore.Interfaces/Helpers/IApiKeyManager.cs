//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
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
