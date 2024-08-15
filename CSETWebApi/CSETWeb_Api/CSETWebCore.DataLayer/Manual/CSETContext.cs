//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Snickler.EFCore;

namespace CSETWebCore.DataLayer.Model
{
    public class CSETContext : CsetwebContext
    {
        private string _connectionString = null;


        public CSETContext()
        {
        }

        public CSETContext(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("CSET_DB");
        }

        public CSETContext(DbContextOptions<CsetwebContext> options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured && _connectionString != null)
            {
                optionsBuilder.UseSqlServer(_connectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<AVAILABLE_MATURITY_MODELS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.model_id });
                entity.HasOne(d => d.Assessment)
                    .WithMany(p => p.AVAILABLE_MATURITY_MODELS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_AVAILABLE_MATURITY_MODELS_ASSESSMENTS");

                entity.HasOne(d => d.model)
                    .WithMany(p => p.AVAILABLE_MATURITY_MODELS)
                    .HasForeignKey(d => d.model_id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__AVAILABLE__model__6F6A7CB2");
            });

            modelBuilder.Entity<MATURITY_LEVELS>(entity =>
            {
                entity.Property(e => e.Level_Name).IsUnicode(false);

                entity.HasOne(d => d.Maturity_Model)
                    .WithMany(p => p.MATURITY_LEVELS)
                    .HasForeignKey(d => d.Maturity_Model_Id)
                    .HasConstraintName("FK_MATURITY_LEVELS_MATURITY_MODELS");
            });

            modelBuilder.Entity<MATURITY_GROUPINGS>(entity =>
            {
                entity.HasKey(e => e.Grouping_Id)
                    .HasName("PK_MATURITY_ELEMENT");

                entity.Property(e => e.Description).IsUnicode(false);

                entity.Property(e => e.Abbreviation).IsUnicode(false);

                entity.Property(e => e.Title).IsUnicode(false);

                entity.HasOne(d => d.Type)
                    .WithMany(p => p.MATURITY_GROUPINGS)
                    .HasForeignKey(d => d.Type_Id)
                    .HasConstraintName("FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES");
            });

            modelBuilder.Entity<MATURITY_GROUPING_TYPES>(entity =>
            {
                entity.Property(e => e.Grouping_Type_Name).IsUnicode(false);
            });

            modelBuilder.Entity<MATURITY_QUESTIONS>(entity =>
            {
                entity.HasKey(e => e.Mat_Question_Id)
                    .HasName("PK__MATURITY__EBDCEAE635AFA091");

                entity.Property(e => e.Question_Text).IsUnicode(false);

                entity.Property(e => e.Question_Title).IsUnicode(false);

                entity.Property(e => e.Supplemental_Info).IsUnicode(false);

                entity.Property(e => e.Text_Hash).HasComputedColumnSql("(CONVERT([varbinary](20),hashbytes('SHA1',[Question_Text]),(0)))");
            });
            modelBuilder.Entity<MATURITY_DOMAIN_REMARKS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Grouping_ID });
            });

            modelBuilder.Entity<MATURITY_REFERENCES>(entity =>
            {
                entity.HasKey(e => new { e.Mat_Question_Id, e.Gen_File_Id, e.Section_Ref, e.Source });

                entity.Property(e => e.Section_Ref).IsUnicode(false);

                entity.Property(e => e.Destination_String).IsUnicode(false);

                entity.HasOne(d => d.Mat_Question)
                    .WithMany(p => p.MATURITY_REFERENCES)
                    .HasForeignKey(d => d.Mat_Question_Id)
                    .HasConstraintName("FK_MATURITY_REFERENCES_MATURITY_QUESTIONS");
            });

            modelBuilder.Entity<MATURITY_REFERENCE_TEXT>(entity =>
            {
                entity.HasKey(e => new { e.Mat_Question_Id, e.Sequence });

                entity.Property(e => e.Reference_Text).IsUnicode(false);
            });

            modelBuilder.Entity<ASSESSMENT_DIAGRAM_COMPONENTS>()
                .ToTable(tb => tb.HasTrigger("DummyTrigger"));


            //modelBuilder.Query<VIEW_QUESTIONS_STATUS>().ToView("VIEW_QUESTIONS_STATUS").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
            //modelBuilder.Query<vQUESTION_HEADINGS>().ToView("vQUESTION_HEADINGS").Property(v => v.Heading_Pair_Id).HasColumnName("Heading_Pair_Id");
            //modelBuilder.Query<Answer_Questions>().ToView("Answer_Questions").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
            //modelBuilder.Query<Answer_Questions_No_Components>().ToView("Answer_Questions_No_Components").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        }


        public virtual IList<SPRSScore> usp_GetSPRSScore(Nullable<int> assessment_id)
        {

            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<SPRSScore> myrval = null;
            this.LoadStoredProc("usp_GenerateSPRSScore")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<SPRSScore>();
                     });
            return myrval;

        }


        public string ConnectionString { get { return this._connectionString; } }



        //NOTE When rebuilding this line must be added to the on
        // modelBuilder.Query<VIEW_QUESTIONS_STATUS>().ToView("VIEW_QUESTIONS_STATUS").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        //public virtual DbSet<VIEW_QUESTIONS_STATUS> VIEW_QUESTIONS_STATUS { get; set; }

        ////NOTE When rebuilding this line must be added to the on
        //// modelBuilder.Query<vQUESTION_HEADINGS>().ToView("vQUESTION_HEADINGS").Property(v => v.Heading_Pair_Id).HasColumnName("Heading_Pair_Id");
        //public virtual DbSet<vQUESTION_HEADINGS> vQUESTION_HEADINGS { get; set; }

        //// modelBuilder.Query<Answer_Questions>().ToView("Answer_Questions").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        //public virtual DbSet<Answer_Questions> Answer_Questions { get; set; }
        //public virtual DbSet<Answer_Requirements> Answer_Requirements { get; set; }

        //public virtual DbSet<Answer_Components> Answer_Components { get; set; }
        //public virtual DbSet<Assessments_For_User> Assessments_For_User { get; set; }
        //public virtual DbSet<Answer_Components_Default> Answer_Components_Default { get; set; }
        public virtual IList<Answer_Components_Default> usp_Answer_Components_Default(Nullable<int> assessment_id)
        {

            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<Answer_Components_Default> myrval = null;
            this.LoadStoredProc("usp_Answer_Components_Default")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<Answer_Components_Default>();
                     });
            return myrval;

        }

        //public virtual DbSet<Answer_Components_Overrides> Answer_Components_Overrides { get; set; }
        //public virtual DbSet<Answer_Standards_InScope> Answer_Standards_InScope { get; set; }


        //// modelBuilder.Query<Answer_Questions_No_Components>().ToView("Answer_Questions_No_Components").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        //public virtual DbSet<Answer_Questions_No_Components> Answer_Questions_No_Components { get; set; }

        //public virtual DbSet<Answer_Maturity> Answer_Maturity { get; set; }
        /// <summary>
        /// Entity type used for returning a list of question or requirement IDs.  
        /// </summary>
        public virtual DbSet<Question_Id_result> ID_Results { get; set; }


        /// <summary>
        /// Executes stored procedure usp_AssesmentsForUser.
        /// This used to be queried as a view, but in order to get the AltTextMissing it was 
        /// easier to build a procedure.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<usp_Assessments_For_UserResult> usp_AssessmentsForUser(Nullable<int> userId)
        {
            if (!userId.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_Assessments_For_UserResult> myrval = null;
            this.LoadStoredProc("usp_Assessments_For_User")
                     .WithSqlParam("user_id", userId)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_Assessments_For_UserResult>();
                     });
            return myrval;
        }


        /// <summary>
        /// Executes stored procedure usp_Assesments_Completion_For_User.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns>Total number of answered questions over total number of available questions for each assessment</returns>
        public virtual IList<usp_Assessments_Completion_For_UserResult> usp_AssessmentsCompletionForUser(Nullable<int> userId)
        {
            if (!userId.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_Assessments_Completion_For_UserResult> myrval = null;
            this.LoadStoredProc("usp_Assessments_Completion_For_User")
                     .WithSqlParam("user_id", userId)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_Assessments_Completion_For_UserResult>();
                     });
            return myrval;
        }


        /// <summary>
        /// Executes stored procedure usp_Assesments_Completion_For_AccessKey.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns>Total number of answered questions over total number of available questions for each assessment</returns>
        public virtual IList<usp_Assessments_Completion_For_UserResult> usp_AssessmentsCompletionForAccessKey(string accessKey)
        {
            if (accessKey == null)
                throw new ApplicationException("parameters may not be null");

            IList<usp_Assessments_Completion_For_UserResult> myrval = null;
            this.LoadStoredProc("usp_Assessments_Completion_For_Access_Key")
                     .WithSqlParam("accessKey", accessKey)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_Assessments_Completion_For_UserResult>();
                     });
            return myrval;
        }


        /// <summary>
        /// Executes stored procedure usp_Assesments_Completion_For_User.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns>Total number of answered questions over total number of available questions for each assessment</returns>
        public virtual IList<usp_countsForLevelsByGroupMaturityModelResults> usp_countsForLevelsByGroupMaturityModel(Nullable<int> assessment_id, Nullable<int> mat_model_id)
        {
            IList<usp_countsForLevelsByGroupMaturityModelResults> myrval = null;
            this.LoadStoredProc("usp_countsForLevelsByGroupMaturityModel")
                     .WithSqlParam("assessment_id", assessment_id)
                     .WithSqlParam("mat_model_id", mat_model_id)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_countsForLevelsByGroupMaturityModelResults>();
                     });
            return myrval;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="originalEmail"></param>
        /// <param name="newEmail"></param>
        /// <returns></returns>
        public int ChangeEmail(string originalEmail, string newEmail)
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

        public virtual IList<RawCountsForEachAssessment_Standards> usp_GetRawCountsForEachAssessment_Standards()
        {
            IList<RawCountsForEachAssessment_Standards> myrval = null;
            this.LoadStoredProc("usp_GetRawCountsForEachAssessment_Standards")
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<RawCountsForEachAssessment_Standards>();
                     });
            return myrval;
        }

        public virtual IList<AnalyticsgetMedianOverall> analytics_compute_single_averages_maturity(int assessmentId, int maturity_model_id)
        {
            IList<AnalyticsgetMedianOverall> myrval = null;
            this.LoadStoredProc("analytics_compute_single_averages_maturity")
                    .WithSqlParam("assessment_id", assessmentId)
                     .WithSqlParam("maturity_model_id", maturity_model_id)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AnalyticsgetMedianOverall>();
                     });
            return myrval;
        }
        public virtual IList<SetStandard> analytics_selectedStandardList(int assessmentId)
        {
            IList<SetStandard> myrval = null;
            this.LoadStoredProc("analytics_selectedStandardList")
                .WithSqlParam("standard_assessment_id", assessmentId)
                .ExecuteStoredProc((handler) =>
                {
                    myrval = handler.ReadToList<SetStandard>();
                });
            return myrval;
        }


        public virtual IList<AnalyticsgetMedianOverall> analytics_getMedianOverall()
        {
            IList<AnalyticsgetMedianOverall> myrval = null;
            this.LoadStoredProc("analytics_getMedianOverall")
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AnalyticsgetMedianOverall>();
                     });
            return myrval;
        }
        public virtual IList<AnalyticsgetMinMaxAverForSectorIndustryGroup> analytics_getMinMaxAverageForSectorIndustryGroup(int sectorId, int industryId)
        {
            IList<AnalyticsgetMinMaxAverForSectorIndustryGroup> myrval = null;
            this.LoadStoredProc("analytics_getMinMaxAverageForSectorIndustryGroup")
                 .WithSqlParam("sector_id", sectorId)
                  .WithSqlParam("industry_id", industryId)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AnalyticsgetMinMaxAverForSectorIndustryGroup>();
                     });
            return myrval;
        }
        public virtual IList<AnalyticsStandardMinMaxAvg> analytics_Compute_standard_all(int assessmentId, string setname, int? sectorId,
            int? industryId)
        {

            IList<AnalyticsStandardMinMaxAvg> myrval = null;
            this.LoadStoredProc("analytics_Compute_standard_all")
                .WithSqlParam("assessment_id", assessmentId)
                .WithSqlParam("set_name", setname)
                .WithSqlParam("sector_id", sectorId == null ? DBNull.Value : sectorId)
                .WithSqlParam("industry_id", industryId == null ? DBNull.Value : industryId)
                // .WithSqlParam("industry_id",industryId ==null?DBNull.Value:industryId)
                .ExecuteStoredProc((handler) =>
                {
                    myrval = handler.ReadToList<AnalyticsStandardMinMaxAvg>();
                });
            return myrval;
        }
        public virtual IList<standardAnalyticsgetMedianOverall> analytics_compute_single_averages_standard(int assessmentId, string setname)
        {

            IList<standardAnalyticsgetMedianOverall> myrval = null;
            this.LoadStoredProc("analytics_compute_single_averages_standard")
                .WithSqlParam("assessment_id", assessmentId)
                .WithSqlParam("set_name", setname)
                .ExecuteStoredProc((handler) =>
                {
                    myrval = handler.ReadToList<standardAnalyticsgetMedianOverall>();
                });
            return myrval;
        }

        public virtual IList<AnalyticsMinMaxAvgMedianByGroup> analytics_Compute_MaturityAll(int model_id, int? sectorId, int? industryId)
        {
            IList<AnalyticsMinMaxAvgMedianByGroup> myrval = null;
            this.LoadStoredProc("analytics_Compute_MaturityAll")
                 .WithSqlParam("maturity_model_id", model_id)
                 .WithSqlParam("sector_id", sectorId == null ? DBNull.Value : sectorId)
                 .WithSqlParam("industry_id", industryId == null ? DBNull.Value : industryId)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AnalyticsMinMaxAvgMedianByGroup>();
                     });
            return myrval;
        }
        public virtual IList<AnalyticsMinMaxAvgMedianByGroup> analytics_Compute_MaturityAll_Median(int model_id)
        {
            IList<AnalyticsMinMaxAvgMedianByGroup> myrval = null;
            this.LoadStoredProc("analytics_Compute_MaturityAll_Median")
                 .WithSqlParam("maturity_model_id", model_id)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AnalyticsMinMaxAvgMedianByGroup>();
                     });
            return myrval;
        }


        public virtual void usp_CopyIntoSet(string sourcesetName, string destinationSetName)
        {
            this.LoadStoredProc("usp_CopyIntoSet")
                     .WithSqlParam("SourceSetName", sourcesetName)
                     .WithSqlParam("DestinationSetName", destinationSetName)
                     .ExecuteStoredProc((handler) =>
                     {

                     });

        }

        public virtual void usp_CopyIntoSet_Delete(string setName)
        {
            this.LoadStoredProc("usp_CopyIntoSet_Delete")
                     .WithSqlParam("DestinationSetName", setName)
                     .ExecuteStoredProc((handler) =>
                     {

                     });
        }


        /// <summary>
        /// Inserts missing skeleton ANSWER records for an assessment based on 
        /// its standard selection and SAL.  
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Insert empty questions for Maturity model questions based on the maturity models
        /// selected on the assessment
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
        public virtual int FillEmptyMaturityQuestionsForAnalysis(Nullable<int> assessment_Id)
        {
            if (!assessment_Id.HasValue)
                throw new ApplicationException("parameters may not be null");

            int myrval = 0;
            this.LoadStoredProc("FillEmptyMaturityQuestionsForAnalysis")
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
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
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
        /// Executes stored procedure usp_GetOverallRankedCategoriesPage.
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


        /// <summary>
        /// Executes stored procedure usp_getFinancialQuestions.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Executes stored procedure usp_GetRankedQuestions.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Executes stored procedure usp_GetQuestionsWithFeedbacks.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Executes stored procedure usp_MaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Executes stored procedure GetMaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<GetMaturityDetailsCalculations_Result> GetMaturityDetailsCalculations(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<GetMaturityDetailsCalculations_Result> myrval = null;
            this.LoadStoredProc("GetMaturityDetailsCalculations")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<GetMaturityDetailsCalculations_Result>();
                     });
            return myrval;
        }


        /// <summary>
        /// Executes stored procedure GetMaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<AcetAnswerDistribution_Result> AcetAnswerDistribution(Nullable<int> assessment_id, Nullable<int> targetLevel)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<AcetAnswerDistribution_Result> myrval = null;
            this.LoadStoredProc("AcetAnswerDistribution")
                     .WithSqlParam("assessment_id", assessment_id)
                     .WithSqlParam("targetLevel", targetLevel)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AcetAnswerDistribution_Result>();
                     });
            return myrval;
        }

        /// <summary>
        /// Executes stored procedure GetMaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<AcetAnswerDistribution_Result> IseAnswerDistribution(Nullable<int> assessment_id, Nullable<int> targetLevel)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var matLevel = 0;

            switch (targetLevel)
            {
                case 1:
                    matLevel = 17; // SCUEP
                    break;
                case 2:
                    matLevel = 18; // CORE
                    break;
                case 3:
                    matLevel = 19; // CORE+
                    break;
            }

            IList<AcetAnswerDistribution_Result> myrval = null;
            this.LoadStoredProc("IseAnswerDistribution")
                     .WithSqlParam("assessment_id", assessment_id)
                     .WithSqlParam("targetLevel", matLevel)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<AcetAnswerDistribution_Result>();
                     });
            return myrval;
        }


        /// <summary>
        /// Executes stored procedure usp_StatementsReviewed.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Executes stored procedure usp_StatementsReviewedTabTotals.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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





        /// <summary>
        /// Executes stored procedure usp_financial_attributes.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Executes stored procedure usp_GetTop5Areas.
        /// </summary>
        /// <param name="aggregation_id"></param>
        /// <returns></returns>
        public virtual IList<usp_GetTop5Areas_result> usp_GetTop5Areas(Nullable<int> aggregation_id)
        {
            if (!aggregation_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<usp_GetTop5Areas_result> myrval = null;
            this.LoadStoredProc("usp_GetTop5Areas")
                     .WithSqlParam("aggregation_id", aggregation_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<usp_GetTop5Areas_result>();
                     });
            return myrval;
        }


        /// <summary>
        /// Returns a list of Question IDs that are 'in scope' or applicable
        /// to the specified assessment.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<int> InScopeQuestions(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<int> myrval = null;
            this.LoadStoredProc("InScopeQuestions")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         var myrval2 = handler.ReadToList<Question_Id_result>();
                         myrval = myrval2.Select(x => x.Question_Id).ToList();
                     });
            return myrval;
        }


        /// <summary>
        /// Returns a list of Requirement IDs that are 'in scope' or applicable
        /// to the specified assessment.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual IList<int> InScopeRequirements(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<int> myrval = null;
            this.LoadStoredProc("InScopeRequirements")
                     .WithSqlParam("assessment_id", assessment_id)

                     .ExecuteStoredProc((handler) =>
                     {
                         var myrval2 = handler.ReadToList<Requirement_Id_result>();
                         myrval = myrval2.Select(x => x.Requirement_Id).ToList();
                     });
            return myrval;
        }

        public virtual IList<Get_Merge_ConflictsResult> Get_Merge_Conflicts(Nullable<int> assessmentId1, Nullable<int> assessmentId2,
                                                                            int assessmentId3, int assessmentId4, int assessmentId5, int assessmentId6,
                                                                            int assessmentId7, int assessmentId8, int assessmentId9, int assessmentId10)
        {
            if (!assessmentId1.HasValue || !assessmentId2.HasValue)
                throw new ApplicationException("first two parameters may not be null");
            IList<Get_Merge_ConflictsResult> myrval = null;
            this.LoadStoredProc("Get_Merge_Conflicts")
                     .WithSqlParam("@id1", assessmentId1)
                     .WithSqlParam("@id2", assessmentId2)
                     .WithSqlParam("@id3", assessmentId3)
                     .WithSqlParam("@id4", assessmentId4)
                     .WithSqlParam("@id5", assessmentId5)
                     .WithSqlParam("@id6", assessmentId6)
                     .WithSqlParam("@id7", assessmentId7)
                     .WithSqlParam("@id8", assessmentId8)
                     .WithSqlParam("@id9", assessmentId9)
                     .WithSqlParam("@id10", assessmentId10)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<Get_Merge_ConflictsResult>();
                     });
            return myrval;
        }

        public virtual IList<Get_Merge_ConflictsResult> Get_Cie_Merge_Conflicts(Nullable<int> assessmentId1, Nullable<int> assessmentId2,
                                                                            int assessmentId3, int assessmentId4, int assessmentId5, int assessmentId6,
                                                                            int assessmentId7, int assessmentId8, int assessmentId9, int assessmentId10)
        {
            if (!assessmentId1.HasValue || !assessmentId2.HasValue)
                throw new ApplicationException("first two parameters may not be null");
            IList<Get_Merge_ConflictsResult> myrval = null;
            this.LoadStoredProc("Get_Cie_Merge_Conflicts")
                     .WithSqlParam("@id1", assessmentId1)
                     .WithSqlParam("@id2", assessmentId2)
                     .WithSqlParam("@id3", assessmentId3)
                     .WithSqlParam("@id4", assessmentId4)
                     .WithSqlParam("@id5", assessmentId5)
                     .WithSqlParam("@id6", assessmentId6)
                     .WithSqlParam("@id7", assessmentId7)
                     .WithSqlParam("@id8", assessmentId8)
                     .WithSqlParam("@id9", assessmentId9)
                     .WithSqlParam("@id10", assessmentId10)
                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<Get_Merge_ConflictsResult>();
                     });
            return myrval;
        }

        public virtual IList<Get_Assess_Detail_Filter_DataResult> Get_Assess_Detail_Filters(string model)
        {
            IList<Get_Assess_Detail_Filter_DataResult> myrval = null;
            this.LoadStoredProc("Get_Assess_Detail_Filter_Data")
                .WithSqlParam("@model", model)
                .ExecuteStoredProc((handler) =>
                {
                    myrval = handler.ReadToList<Get_Assess_Detail_Filter_DataResult>();
                });
            return myrval.OrderBy(x => x.Detail_Id).ToList();
        }

        public virtual IList<GetChildrenAnswersResult> Get_Children_Answers(int parentId, int assessId)
        {
            IList<GetChildrenAnswersResult> myrval = null;
            this.LoadStoredProc("GetChildrenAnswers")
                .WithSqlParam("@Parent_Id", parentId)
                .WithSqlParam("@Assess_Id", assessId)
                .ExecuteStoredProc((handler) =>
                {
                    myrval = handler.ReadToList<GetChildrenAnswersResult>();
                });

            return myrval;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public virtual IList<GetAnswerDistribGroupingsResult> GetAnswerDistribGroupings(int assessmentId, int? modelId = null)
        {
            // use the supplied modelId or if null, the proc will default to the principal model of the assessment
            object m = modelId;
            if (modelId == null)
            {
                m = DBNull.Value;
            }


            var parms = new IDbDataParameter[]
            {
                 new SqlParameter("@assessmentId", assessmentId),
                 new SqlParameter("@modelId", m),
            };


            IList<GetAnswerDistribGroupingsResult> myrval = null;
            this.LoadStoredProc("GetAnswerDistribGroupings")
                .WithSqlParams(parms)
                .ExecuteStoredProc((handler) =>
                {
                    myrval = handler.ReadToList<GetAnswerDistribGroupingsResult>();
                });

            return myrval;
        }
    }
}