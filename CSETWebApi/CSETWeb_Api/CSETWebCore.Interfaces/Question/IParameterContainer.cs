//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Interfaces.Question
{
    public interface IParameterContainer
    {
        int Id { get; }
        string Name { get; }
        string Default { get; }
    }
}