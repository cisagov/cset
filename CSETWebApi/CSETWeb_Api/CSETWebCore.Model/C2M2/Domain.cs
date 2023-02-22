using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.C2M2
{
    public class Domain
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public List<Objective> Objectives { get; set; } = new List<Objective>();
    }
}
