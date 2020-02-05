//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public enum SalValues
    {
        L=1,
        M=2,
        H=3,
        VH=4
    }
    public class Sals
    {
        public string Selected_Sal_Level { get; set; }
        public string Last_Sal_Determination_Type { get; set; }
        public string Sort_Set_Name { get; set; }
        public string CLevel { get; set; }
        public string ILevel { get; set; }
        public string ALevel { get; set; }
        public bool SelectedSALOverride { get; set; }
        public string AssessmentName { get; internal set; }
    }
    public class SaveWeight
    {
        public int assessmentid { get; set; }
        public int Slider_Value { get; set; }
        public string slidername { get; set; }
    }

    public class GenSalPairs
    {
        public GeneralSalDescriptionsWeights OnSite { get; set; }
        public GeneralSalDescriptionsWeights OffSite { get; set; }
    }

    public class GeneralSalDescriptionsWeights
    {
        public string Sal_Name { get; set; }
        public string Sal_Description { get; set; }
        public int Sal_Order { get; set; }
        public Nullable<int> min { get; set; }
        public Nullable<int> max { get; set; }
        public Nullable<int> step { get; set; }
        public List<GenSalWeights> GEN_SAL_WEIGHTS { get; set; }
        public string prefix { get; set; }
        public string postfix { get; set; }
        public List<string> values { get; set; }
        public int Slider_Value { get; set; }
    }

    public class GenSalWeights
    {
        public int Sal_Weight_Id { get; set; }
        public string Sal_Name { get; set; }
        public int Slider_Value { get; set; }
        public decimal Weight { get; set; }
        public string Display { get; set; }
    }
}


