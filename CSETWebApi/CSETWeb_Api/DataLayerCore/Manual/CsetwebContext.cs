using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Snickler.EFCore;

namespace DataLayerCore.Model
{
    public partial class CsetwebContext : DbContext
    {
        //NOTE When rebuilding this line must be added to the on
        // modelBuilder.Query<VIEW_QUESTIONS_STATUS>().ToView("VIEW_QUESTIONS_STATUS").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<VIEW_QUESTIONS_STATUS> VIEW_QUESTIONS_STATUS { get; set; }

        //NOTE When rebuilding this line must be added to the on
        // modelBuilder.Query<vQUESTION_HEADINGS>().ToView("vQUESTION_HEADINGS").Property(v => v.Heading_Pair_Id).HasColumnName("Heading_Pair_Id");
        public virtual DbSet<vQUESTION_HEADINGS> vQUESTION_HEADINGS { get; set; }

        // modelBuilder.Query<Answer_Questions>().ToView("Answer_Questions").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<Answer_Questions> Answer_Questions { get; set; }
        // modelBuilder.Query<Answer_Questions_No_Components>().ToView("Answer_Questions_No_Components").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<Answer_Questions_No_Components> Answer_Questions_No_Components { get; set; }
        public int changeEmail(string originalEmail, string newEmail)
        {

            if ((originalEmail == null) || (newEmail != null))
                throw new ApplicationException("parameters may not be null");

            int myrval =0 ; 
            this.LoadStoredProc("changeEmail")
                     .WithSqlParam("originalEmail", originalEmail)
                     .WithSqlParam("newEmail", newEmail)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToValue<int>()??0;
                     });
            return myrval;            
        }

        public virtual int FillEmptyQuestionsForAnalysis(Nullable<int> assessment_Id)
        {
            if(assessment_Id.HasValue)
                throw new ApplicationException("parameters may not be null");

            int myrval = 0;
            this.LoadStoredProc("FillEmptyQuestionsForAnalysis")
                     .WithSqlParam("Assessment_Id", assessment_Id)
                     
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToValue<int>() ?? 0;
                     });
            return myrval;
        }

        //public virtual ObjectResult<string> Get_Recommendations(Nullable<int> value, Nullable<int> industry, string organization, string assetvalue)
        //{
        //    var valueParameter = value.HasValue ?
        //        new ObjectParameter("value", value) :
        //        new ObjectParameter("value", typeof(int));

        //    var industryParameter = industry.HasValue ?
        //        new ObjectParameter("industry", industry) :
        //        new ObjectParameter("industry", typeof(int));

        //    var organizationParameter = organization != null ?
        //        new ObjectParameter("organization", organization) :
        //        new ObjectParameter("organization", typeof(string));

        //    var assetvalueParameter = assetvalue != null ?
        //        new ObjectParameter("assetvalue", assetvalue) :
        //        new ObjectParameter("assetvalue", typeof(string));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<string>("Get_Recommendations", valueParameter, industryParameter, organizationParameter, assetvalueParameter);
        //}

        //public virtual int GetApplicationModeDefault(Nullable<int> assessment_Id, ObjectParameter application_Mode)
        //{
        //    var assessment_IdParameter = assessment_Id.HasValue ?
        //        new ObjectParameter("Assessment_Id", assessment_Id) :
        //        new ObjectParameter("Assessment_Id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("GetApplicationModeDefault", assessment_IdParameter, application_Mode);
        //}

        //public virtual ObjectResult<GetAreasData_Result> GetAreasData(Nullable<int> assessment_Id, string applicationMode)
        //{
        //    var assessment_IdParameter = assessment_Id.HasValue ?
        //        new ObjectParameter("Assessment_Id", assessment_Id) :
        //        new ObjectParameter("Assessment_Id", typeof(int));

        //    var applicationModeParameter = applicationMode != null ?
        //        new ObjectParameter("applicationMode", applicationMode) :
        //        new ObjectParameter("applicationMode", typeof(string));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetAreasData_Result>("GetAreasData", assessment_IdParameter, applicationModeParameter);
        //}

        //public virtual ObjectResult<GetAreasOverall_Result> GetAreasOverall(Nullable<int> assessment_Id, string applicationMode)
        //{
        //    var assessment_IdParameter = assessment_Id.HasValue ?
        //        new ObjectParameter("Assessment_Id", assessment_Id) :
        //        new ObjectParameter("Assessment_Id", typeof(int));

        //    var applicationModeParameter = applicationMode != null ?
        //        new ObjectParameter("applicationMode", applicationMode) :
        //        new ObjectParameter("applicationMode", typeof(string));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetAreasOverall_Result>("GetAreasOverall", assessment_IdParameter, applicationModeParameter);
        //}

        //public virtual ObjectResult<GetCombinedOveralls_Result> GetCombinedOveralls(Nullable<int> assessment_Id)
        //{
        //    var assessment_IdParameter = assessment_Id.HasValue ?
        //        new ObjectParameter("Assessment_Id", assessment_Id) :
        //        new ObjectParameter("Assessment_Id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetCombinedOveralls_Result>("GetCombinedOveralls", assessment_IdParameter);
        //}

        //public virtual ObjectResult<GetComparisonAreasFile_Result> GetComparisonAreasFile(Nullable<int> assessment_id, string applicationMode)
        //{
        //    var assessment_idParameter = assessment_id.HasValue ?
        //        new ObjectParameter("assessment_id", assessment_id) :
        //        new ObjectParameter("assessment_id", typeof(int));

        //    var applicationModeParameter = applicationMode != null ?
        //        new ObjectParameter("applicationMode", applicationMode) :
        //        new ObjectParameter("applicationMode", typeof(string));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetComparisonAreasFile_Result>("GetComparisonAreasFile", assessment_idParameter, applicationModeParameter);
        //}

        //public virtual ObjectResult<GetComparisonBestToWorst_Result> GetComparisonBestToWorst(Nullable<int> assessment_id, string applicationMode)
        //{
        //    var assessment_idParameter = assessment_id.HasValue ?
        //        new ObjectParameter("assessment_id", assessment_id) :
        //        new ObjectParameter("assessment_id", typeof(int));

        //    var applicationModeParameter = applicationMode != null ?
        //        new ObjectParameter("applicationMode", applicationMode) :
        //        new ObjectParameter("applicationMode", typeof(string));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetComparisonBestToWorst_Result>("GetComparisonBestToWorst", assessment_idParameter, applicationModeParameter);
        //}

        //public virtual ObjectResult<GetComparisonFileOveralls_Result> GetComparisonFileOveralls(Nullable<int> assessment_id)
        //{
        //    var assessment_idParameter = assessment_id.HasValue ?
        //        new ObjectParameter("assessment_id", assessment_id) :
        //        new ObjectParameter("assessment_id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetComparisonFileOveralls_Result>("GetComparisonFileOveralls", assessment_idParameter);
        //}

        //public virtual ObjectResult<GetComparisonFilePercentage_Result> GetComparisonFilePercentage(Nullable<int> assessment_id)
        //{
        //    var assessment_idParameter = assessment_id.HasValue ?
        //        new ObjectParameter("Assessment_id", assessment_id) :
        //        new ObjectParameter("Assessment_id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetComparisonFilePercentage_Result>("GetComparisonFilePercentage", assessment_idParameter);
        //}

        //public virtual ObjectResult<GetComparisonFileSummary_Result> GetComparisonFileSummary(Nullable<int> assessment_id)
        //{
        //    var assessment_idParameter = assessment_id.HasValue ?
        //        new ObjectParameter("assessment_id", assessment_id) :
        //        new ObjectParameter("assessment_id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetComparisonFileSummary_Result>("GetComparisonFileSummary", assessment_idParameter);
        //}

        //public virtual int GetCompatibilityCounts(Nullable<int> assessment_id)
        //{
        //    var assessment_idParameter = assessment_id.HasValue ?
        //        new ObjectParameter("assessment_id", assessment_id) :
        //        new ObjectParameter("assessment_id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("GetCompatibilityCounts", assessment_idParameter);
        //}

        public virtual IList<usp_GetOverallRankedCategoriesPage_Result> usp_GetOverallRankedCategoriesPage(Nullable<int> assessment_id)
        {
            if (assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_GetOverallRankedCategoriesPage_Result> myrval = null; 
            this.LoadStoredProc("usp_GetOverallRankedCategoriesPage")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_GetOverallRankedCategoriesPage_Result>();
                     });
            return myrval;

            
        }

        //public virtual int GetActiveQuestionsOrRequirements(Nullable<int> assessment_Id)
        //{
        //    var assessment_IdParameter = assessment_Id.HasValue ?
        //        new ObjectParameter("assessment_Id", assessment_Id) :
        //        new ObjectParameter("assessment_Id", typeof(int));

        //    return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("GetActiveQuestionsOrRequirements", assessment_IdParameter);
        //}

        public virtual IList<usp_GetRankedQuestions_Result> usp_GetRankedQuestions(Nullable<int> assessment_id)
        {
            if (assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_GetRankedQuestions_Result> myrval = null;
            this.LoadStoredProc("usp_GetRankedQuestions")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_GetRankedQuestions_Result>();
                     });
            return myrval;
        }

    }
}
