//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
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