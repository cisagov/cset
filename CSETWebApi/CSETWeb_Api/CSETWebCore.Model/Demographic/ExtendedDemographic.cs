using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Demographic
{
    public class ExtendedDemographic
    {
    }

    public class StateRegion
    {
        public string State { get; set; }
        public string RegionCode { get; set; }
        public string RegionName { get; set; }
        public List<County> Counties { get; set; } = new List<County>();
    }

    public class County
    {
        public string FIPS { get; set; }
        public string Name { get; set; }
        public string State { get; set; }
    }

    public class EmployeeRange
    {
        public int Id { get; set; }
        public string Range { get; set; }

    }

    public class CustomerRange
    {
        public int Id { get; set; }
        public string Range { get; set; }
    }


    public class GeographicImpact
    {
        public int Id { get; set; }
        public string Value { get; set; }
    }
}
