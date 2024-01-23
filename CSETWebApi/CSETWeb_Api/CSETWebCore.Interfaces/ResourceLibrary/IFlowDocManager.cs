//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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