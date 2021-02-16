//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;

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
        public List<QuestionsWithComments> QuestionsWithComments { get; set; }
        public List<QuestionsMarkedForReview> QuestionsMarkedForReview { get; set; }
        public List<QuestionsWithAlternateJustifi> QuestionsWithAlternateJustifi { get; set; }
        public List<RankedQuestions> top5Questions { get; set; }
        public List<StandardQuestions> StandardsQuestions { get; set; }
        public List<usp_getFinancialQuestions_Result> FinancialQuestionsTable { get; set; }
        public List<ComponentQuestion> ComponentQuestions { get; set; }
        public List<List<DiagramZones>> Zones { get; set; }

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
            public List<string> Additional_Contacts { get; set; }
            public string Real_Property_Unique_Id { get; set; }
            public string Executive_Summary { get; set; }
            public string Assessment_Description { get; set; }

            // ACET properties
            public string Credit_Union_Name { get; set; }
            public string Charter { get; set; }
            public int Assets { get; set; }
        }

        public class OverallSALTable
        {
            public string Alias { get; set; }
            public string OSV { get; set; }
            public string Q_CV { get; set; }
            public string Q_IV { get; set; }
            public string Q_AV { get; set; }
            public string IT_CV { get; set; }
            public string IT_IV { get; set; }
            public string IT_AV { get; set; }
            public string LastSalDeterminationType { get; set; }
        }

        public class CNSSSALJustificationsTable
        {
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
            public List<Control_Questions> Control_Questions { get; set; }
        }
        public class Control_Questions
        {
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
        public string Alias { get; set; }
        public string DocumentTitle { get; set; }
        public string FileName { get; set; }
    }

    public class SimpleStandardQuestions
    {
        public string ShortName { get; set; }
        public string CategoryAndNumber { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
    }

    public class ComponentQuestion
    {
        public string ComponentName { get; set; }
        public int Component_Symbol_Id { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
        public string Zone { get; set; }
        public string SAL { get; set; }
        public string LayerName { get; set; }
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
        public string Question { get; set; }
        public string Answer { get; set; }
        public string Comment { get; set; }
    }

    public class QuestionsMarkedForReview
    {
        public string CategoryAndNumber { get; set; }
        public string Question { get; set; }
        public string Answer { get; set; }
    }

    /// <summary>
    /// This must match the columns returned by the stored proc
    /// RelevantAnswers.  It returns a set of ANSWER records
    /// that are relative to the assessment's current SAL, standards
    /// and mode (questions or requirements).
    /// </summary>
    public class RelevantAnswers
    {
        public int Assessment_ID { get; set; }
        public int Answer_ID { get; set; }
        public bool Is_Requirement { get; set; }
        public int Question_Or_Requirement_ID { get; set; }        
        public bool Mark_For_Review { get; set; }
        public string Comment { get; set; }
        public string Alternate_Justification { get; set; }
        public int Question_Number { get; set; }
        public string Answer_Text { get; set; }
        public string Component_Guid { get; set; }
        public bool Is_Component { get; set; }
        public string Custom_Question_Guid { get; set; }
        public bool Is_Framework { get; set; }
        public int Old_Answer_ID { get; set; }
        public bool Reviewed { get; set; }  
        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public static List<RelevantAnswers> GetAnswersForAssessment(int assessmentID)
        {
            List<RelevantAnswers> answers = new List<RelevantAnswers>();

            using (var db = new CSET_Context())
            {
                db.LoadStoredProc("[RelevantAnswers]")
                  .WithSqlParam("assessment_id", assessmentID)
                  .ExecuteStoredProc((handler) =>
                  {
                      answers = handler.ReadToList<RelevantAnswers>().ToList();
                  });
            }

            return answers;
        }
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


