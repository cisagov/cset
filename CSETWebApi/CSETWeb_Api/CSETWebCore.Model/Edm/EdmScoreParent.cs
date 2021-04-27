using System.Collections.Generic;

namespace CSETWebCore.Model.Edm
{
    public class EdmScoreParent
    {
        public EDMscore parent { get; set; }
        public List<EDMscore> children { get; set; }
    }
}