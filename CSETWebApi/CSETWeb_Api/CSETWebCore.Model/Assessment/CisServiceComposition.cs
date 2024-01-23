//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Assessment
{
    public class CisServiceComposition
    {
        public int AssessmentId { get; set; }
        public string NetworksDescription { get; set; }
        public string ServicesDescription { get; set; }
        public string ApplicationsDescription { get; set; }
        public string ConnectionsDescription { get; set; }
        public string PersonnelDescription { get; set; }
        public string OtherDefiningSystemDescription { get; set; }
        public int? PrimaryDefiningSystem { get; set; }
        public List<int> SecondaryDefiningSystems { get; set; }
    }
}
