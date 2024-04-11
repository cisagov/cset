//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.DataLayer
{
    [System.AttributeUsage(System.AttributeTargets.Class | System.AttributeTargets.Struct)]
    public class LifecycleSingletonAttribute : System.Attribute
    {
        public double version;

        public LifecycleSingletonAttribute()
        {
            version = 1.0;
        }
    }
}


