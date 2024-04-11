//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.DataLayer
{
    [System.AttributeUsage(System.AttributeTargets.Class | System.AttributeTargets.Struct)]
    public class LifecycleTransientAttribute : System.Attribute
    {
        public double version;

        public LifecycleTransientAttribute()
        {
            version = 1.0;
        }
    }
}


