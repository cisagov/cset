//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public class NetworkLink:NetworkNode
    {
        public NetworkComponent TargetComponent { get; internal set; }
        public NetworkComponent SourceComponent { get; internal set; }        
        public string Security { get; internal set; }

        public void setValue(string name, string value)
        {
            base.setValue(name, value);
            switch (name)
            {
                case "Security":
                    this.Security = value;
                        break;
            }
        }    
    }
}