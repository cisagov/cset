//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Set
{
    public class SalParms
    {
        public string SetName;
        public int RequirementID;
        public int QuestionID;

        // Whether the level should be applied (true) or removed (false)
        public bool State;
        public string Level;
    }
}