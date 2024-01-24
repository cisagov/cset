//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Reflection;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IResourceHelper
    {
        string GetEmbeddedResource(string resourceName);
        string GetEmbeddedResource(string resourceName, string scope);
        byte[] GetEmbeddedResourceAsBytes(string resourceName);
        string GetEmbeddedResource(string resourceName, Assembly assembly);
        byte[] GetEmbeddedResourceAsBytes(string resourceName, Assembly assembly);
        string FormatResourceName(Assembly assembly, string resourceName);
    }
}