using System;
namespace CSETWebCore.DataLayer.Manual
{
	public class AnalyticsgetMinMaxAverForSectorIndustryGroup
	{
        public string Question_Group_Heading { get; set; }
        public float min { get; set; }
        public float  max { get; set; }
        public float avg { get; set; }
    }


    public class AnalyticsMinMaxAvgMedianByGroup
    {
        public string Question_Group_Heading { get; set; }

        public double minimum { get; set; }

        public double maximum { get; set; }

        public double average { get; set; }
        public string Title { get; set; }
        public float min { get; set; }
        public float max { get; set; }
        public float avg { get; set; }
        public float median { get; set; }
    }
}
