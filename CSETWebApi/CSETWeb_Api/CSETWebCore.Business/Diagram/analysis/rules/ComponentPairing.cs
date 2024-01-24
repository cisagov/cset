//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram.analysis.rules
{
    public class ComponentPairing : IEquatable<ComponentPairing>
    {
        public Guid Source { get; set; }
        public Guid Target { get; set; }

        public static bool operator ==(ComponentPairing obj1, ComponentPairing obj2)
        {
            if (ReferenceEquals(obj1, obj2))
            {
                return true;
            }

            if (ReferenceEquals(obj1, null))
            {
                return false;
            }
            if (ReferenceEquals(obj2, null))
            {
                return false;
            }

            return ((obj1.Source == obj2.Source) && (obj1.Target == obj2.Target))
                || ((obj1.Source == obj2.Target) && (obj1.Target == obj2.Source));
        }

        // this is second one '!='
        public static bool operator !=(ComponentPairing obj1, ComponentPairing obj2)
        {
            return !(obj1 == obj2);
        }

        public bool Equals(ComponentPairing other)
        {
            if (ReferenceEquals(null, other))
            {
                return false;
            }
            if (ReferenceEquals(this, other))
            {
                return true;
            }


            return ((this.Source == other.Source) && (this.Target == other.Target))
                || ((this.Source == other.Target) && (this.Target == other.Source));


        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj))
            {
                return false;
            }
            if (ReferenceEquals(this, obj))
            {
                return true;
            }

            return obj.GetType() == GetType() && Equals((ComponentPairing)obj);
        }

        public override int GetHashCode()
        {
            List<string> order = new List<string>();
            order.Add(Source.ToString());
            order.Add(Target.ToString());
            order.Sort();
            unchecked
            {
                return order[0].GetHashCode() + order[1].GetHashCode();
            }
        }
    }
}
