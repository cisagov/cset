using System.Reflection;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IResourceHelper
    {
        string GetEmbeddedResource(string resourceName);
        byte[] GetEmbeddedResourceAsBytes(string resourceName);
        string GetEmbeddedResource(string resourceName, Assembly assembly);
        byte[] GetEmbeddedResourceAsBytes(string resourceName, Assembly assembly);
        string FormatResourceName(Assembly assembly, string resourceName);
    }
}