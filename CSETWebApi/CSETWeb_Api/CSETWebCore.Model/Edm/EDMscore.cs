using System.Collections.Generic;

namespace CSETWebCore.Model.Edm
{
    public class EDMscore
    {
        public string Title_Id { get; set; }
        public string Color { get; set; }
        public List<EDMscore> children { get; set; }
    }
}