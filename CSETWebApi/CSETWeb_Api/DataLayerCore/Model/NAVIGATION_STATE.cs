using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NAVIGATION_STATE
    {
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public bool IsError { get; set; }
        public bool IsVisited { get; set; }
        public bool? IsAvailable { get; set; }
        public double PercentCompletion { get; set; }
    }
}
