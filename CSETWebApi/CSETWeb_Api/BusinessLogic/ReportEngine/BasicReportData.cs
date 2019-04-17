//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class BasicReportData
    {
        public List<usp_GetOverallRankedCategoriesPage_Result> top5Categories;

        public INFORMATION information { get; set; }
        public OverallSALTable salTable { get; set; }
        public GenSALTable genSalTable { get; set; }

        public OverallSALTable nistSalTable { get; set; }
        public List<CNSSSALJustificationsTable> nistTypes { get; set; }
        public List<RequirementControl> ControlList { get; set; }
        public List<Individual> Individuals { get; set; }
        public List<DocumentLibraryTable> DocumentLibraryTable { get; set; }
        public List<RankedQuestions> RankedQuestionsTable { get; set; }
        public List<QuestionsWithComments> QuestionsWithCommentsTable { get; set; }
        public List<QuestionsWithAlternateJustifi> QuestionsWithAlternateJustifi { get; set; }
        public List<RankedQuestions> top5Questions { get; set; }
        public List<StandardQuestions> StandardsQuestions { get; set; }

        public class INFORMATION
        {
            public string Assessment_Name { get; set; }
            public string Assessment_Date { get; set; }
            public string Assessor_Name { get; set; }
            public string Facility_Name { get; set; }
            public string City_Or_Site_Name { get; set; }
            public string State_Province_Or_Region { get; set; }
            public string Assessor_Phone { get; set; }
            public string Additional_Notes_And_Comments { get; set; }
            public string Additional_Contacts { get; set; }
            public string Real_Property_Unique_Id { get; set; }
            public string Executive_Summary {get; set;}
            public string Assessment_Description { get; set; }
        }

        public class OverallSALTable
        {
            public string OSV { get; set; }
            public string Q_CV { get; set; }
            public string Q_IV { get; set; }
            public string Q_AV { get; set; }
            public string IT_CV { get; set; }
            public string IT_IV { get; set; }
            public string IT_AV { get; set; }
            public string LastSalDeterminationType { get; set; }
        }
        
        public class CNSSSALJustificationsTable { 
            public string CIA_Type { get; set; }
            public string Justification { get; set; }
        }

        public class RequirementControl
        {   
            public string RequirementTitle { get; set; }
            public string Standard_Category { get; set; }
            public string SubCategory { get; set; }
            public string Level { get; set; }
            public string ImplementationStatus { get; set; }
            public string StandardShortName { get; set; }
            public string ControlDescription { get; set; }
            public List<Control_Questions> Control_Questions {get; set;}
        }
        public class Control_Questions {
            public string Simple_Question { get; set; }
            public string Comment { get; set; }
            public string Answer { get; set; }
        }
    }

    public class Findings
    {   
        public string Finding { get; set; }
        public string Importance { get; set; }
        public string ResolutionDate { get; set; }
        public string Issue { get; set; }
        public string Impact { get; set; }
        public string Recommendations { get; set; }
        public string Vulnerabilities { get; set; }
        public string OtherContacts { get; set; }
    }
    public class DocumentLibraryTable
    {
        public string documenttitle { get; set; }
        public string FileName { get; set; }
    }

    public class SimpleStandardQuestions
    {
        public string ShortName { get; set; }
        public string CategoryAndNumber { get; set; }    
        public string Question { get; set; }
        public string Answer { get; set; }

    }

    public class RankedQuestions
    {
        public long Rank { get; set; }
        public string CategoryAndNumber { get; set; }
        public string Level { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }

    }
    public class QuestionsWithComments
    {
        public string CategoryAndNumber { get; set; }
        public string MarkedForReview { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public string Comment { get; set; }
    }
    public class Individual
    {
        public string INDIVIDUALFULLNAME { get; set; }
        public List<Findings> Findings { get; set; }
    }
    public class QuestionsWithAlternateJustifi
    {
        public string CategoryAndNumber { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public string AlternateJustification { get; set; }
    }
    public class GenSALTable
    {
        public string On_Site_Physical_Injury { get; set; }
        public string Off_Site_Physical_Injury { get; set; }
        public string On_Site_Hospital_Injury { get; set; }
        public string Off_Site_Hospital_Injury { get; set; }
        public string On_Site_Death { get; set; }
        public string Off_Site_Death { get; set; }
        public string On_Site_Capital_Assets { get; set; }
        public string Off_Site_Capital_Assets { get; set; }
        public string On_Site_Economic_Impact { get; set; }
        public string Off_Site_Economic_Impact { get; set; }
        public string On_Site_Environmental_Cleanup { get; set; }
        public string Off_Site_Environmental_Cleanup { get; set; }

        private static Dictionary<String, PropertyInfo> props = new Dictionary<string, PropertyInfo>();
        static GenSALTable()
        {
            PropertyInfo[] propertyInfos;
            propertyInfos = typeof(GenSALTable).GetProperties();
            // write property names
            foreach (PropertyInfo propertyInfo in propertyInfos)
            {
                props.Add(propertyInfo.Name, propertyInfo);
            }
        }

        public void setValue(String name, String value)
        {
            props[name].SetValue(this, value);
        }
        public string getValue(String Name)
        {
            return (string)props[Name].GetValue(this);
        }
    }
}


