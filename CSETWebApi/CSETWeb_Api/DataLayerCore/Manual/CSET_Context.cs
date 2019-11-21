//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using DataLayerCore.Manual;
using Microsoft.EntityFrameworkCore;
using Snickler.EFCore;

namespace DataLayerCore.Model
{
    public class CSET_Context : CsetwebContext
    {

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;
                optionsBuilder.UseSqlServer(connectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            //modelBuilder.Query<VIEW_QUESTIONS_STATUS>().ToView("VIEW_QUESTIONS_STATUS").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
            //modelBuilder.Query<vQUESTION_HEADINGS>().ToView("vQUESTION_HEADINGS").Property(v => v.Heading_Pair_Id).HasColumnName("Heading_Pair_Id");
            //modelBuilder.Query<Answer_Questions>().ToView("Answer_Questions").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
            //modelBuilder.Query<Answer_Questions_No_Components>().ToView("Answer_Questions_No_Components").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        }


        //NOTE When rebuilding this line must be added to the on
        // modelBuilder.Query<VIEW_QUESTIONS_STATUS>().ToView("VIEW_QUESTIONS_STATUS").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<VIEW_QUESTIONS_STATUS> VIEW_QUESTIONS_STATUS { get; set; }

        //NOTE When rebuilding this line must be added to the on
        // modelBuilder.Query<vQUESTION_HEADINGS>().ToView("vQUESTION_HEADINGS").Property(v => v.Heading_Pair_Id).HasColumnName("Heading_Pair_Id");
        public virtual DbSet<vQUESTION_HEADINGS> vQUESTION_HEADINGS { get; set; }

        // modelBuilder.Query<Answer_Questions>().ToView("Answer_Questions").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<Answer_Questions> Answer_Questions { get; set; }

        public virtual DbSet<Answer_Components> Answer_Components { get; set; }
        public virtual DbQuery<Assessments_For_User> Assessments_For_User { get; set; }
        public virtual DbQuery<Answer_Components_Default> Answer_Components_Default { get; set; }
        public virtual DbQuery<Answer_Components_Overrides> Answer_Components_Overrides { get; set; }
        public virtual DbQuery<Answer_Standards_InScope> Answer_Standards_InScope { get; set; }

        /// <summary>
        /// Maps to the view. When given an assessment ID, questions/answers for visible components are returned.
        /// </summary>
        public virtual DbSet<Answer_Components_Exploded> Answer_Components_Exploded { get; set; }


        // modelBuilder.Query<Answer_Questions_No_Components>().ToView("Answer_Questions_No_Components").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<Answer_Questions_No_Components> Answer_Questions_No_Components { get; set; }
        public int changeEmail(string originalEmail, string newEmail)
        {

            if ((originalEmail == null) || (newEmail != null))
                throw new ApplicationException("parameters may not be null");

            int myrval = 0;
            this.LoadStoredProc("changeEmail")
                     .WithSqlParam("originalEmail", originalEmail)
                     .WithSqlParam("newEmail", newEmail)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToValue<int>() ?? 0;
                     });
            return myrval;
        }

        public virtual int FillEmptyQuestionsForAnalysis(Nullable<int> assessment_Id)
        {
            if (!assessment_Id.HasValue)
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
        public virtual int FillNetworkDiagramQuestions(Nullable<int> assessment_Id)
        {
            if (!assessment_Id.HasValue)
                throw new ApplicationException("parameters may not be null");

            int myrval = 0;
            this.LoadStoredProc("FillNetworkDiagramQuestions")
                     .WithSqlParam("Assessment_Id", assessment_Id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToValue<int>() ?? 0;
                     });
            return myrval;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<usp_GetOverallRankedCategoriesPage_Result> usp_GetOverallRankedCategoriesPage(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
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

        public virtual IList<usp_getFinancialQuestions_Result> usp_getFinancialQuestions(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_getFinancialQuestions_Result> myrval = null;
            this.LoadStoredProc("usp_getFinancialQuestions")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_getFinancialQuestions_Result>();
                     });
            return myrval;


        }
        


        public virtual IList<usp_GetRankedQuestions_Result> usp_GetRankedQuestions(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
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
      
        public virtual IList<usp_GetQuestionsWithFeedback> usp_GetQuestionsWithFeedbacks(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("sql parameters may not be null");

            IList<usp_GetQuestionsWithFeedback> rval = null;
            this.LoadStoredProc("usp_GetQuestionsWithFeedback")
                .WithSqlParam("assessment_id", assessment_id)
                .ExecuteStoredProc((handler) =>
                {
                    rval = handler.ReadToList<usp_GetQuestionsWithFeedback>();
                });
            return rval;
        }

        public virtual IList<usp_MaturityDetailsCalculations_Result> usp_MaturityDetailsCalculations(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_MaturityDetailsCalculations_Result> myrval = null;
            this.LoadStoredProc("usp_MaturityDetailsCalculations")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_MaturityDetailsCalculations_Result>();
                     });
            return myrval;
        }


        public virtual IList<usp_StatementsReviewed_Result> usp_StatementsReviewed(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_StatementsReviewed_Result> myrval = null;
            this.LoadStoredProc("usp_StatementsReviewed")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_StatementsReviewed_Result>();
                     });
            return myrval;
        }


        public virtual IList<usp_StatementsReviewedTabTotals_Result> usp_StatementsReviewedTabTotals(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_StatementsReviewedTabTotals_Result> myrval = null;
            this.LoadStoredProc("usp_StatementsReviewedTabTotals")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_StatementsReviewedTabTotals_Result>();
                     });
            return myrval;
        }

        public virtual IList<usp_financial_attributes_result> usp_financial_attributes(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_financial_attributes_result> myrval = null;
            this.LoadStoredProc("usp_financial_attributes")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_financial_attributes_result>();
                     });
            return myrval;
        }
    }
}