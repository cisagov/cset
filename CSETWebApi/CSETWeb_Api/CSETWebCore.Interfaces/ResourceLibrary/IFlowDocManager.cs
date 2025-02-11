//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Interfaces.ResourceLibrary
{
    public interface IFlowDocManager
    {
        string GetFlowDoc(string type, int id);
    }
}