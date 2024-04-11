//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public class NetworkLink : NetworkNode
    {
        public NetworkComponent TargetComponent { get; internal set; }
        public NetworkComponent SourceComponent { get; internal set; }
        public string Security { get; internal set; }

        public new void SetValue(string name, string value)
        {
            base.SetValue(name, value);
            switch (name)
            {
                case "Security":
                    this.Security = value;
                    break;
            }
        }
    }
}