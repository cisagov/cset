//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CSETWebCore.DataLayer.Model
{
    public class CSETContext : CsetwebContext
    {
        private string _connectionString = null;


        public CSETContext()
        {
        }

        [ActivatorUtilitiesConstructor]
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
                optionsBuilder.UseNpgsql(_connectionString);
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

                entity.Property(e => e.Text_Hash).HasComputedColumnSql("digest(\"Question_Text\", 'sha1')::bytea", stored: true);
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
        public virtual async Task<IList<Answer_Components_Default>> usp_Answer_Components_Default(Nullable<int> assessment_id)
        {

            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_Answer_Components_DefaultAsync(assessment_id);
            return result.Cast<Answer_Components_Default>().ToList();

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
        public virtual async Task<IList<usp_Assessments_For_UserResult>> usp_AssessmentsForUser(Nullable<int> userId)
        {
            if (!userId.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_Assessments_For_UserAsync(userId);
            return result.ToList();
        }


        /// <summary>
        /// Executes stored procedure usp_Assesments_Completion_For_User.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns>Total number of answered questions over total number of available questions for each assessment</returns>
        public virtual async Task<IList<usp_countsForLevelsByGroupMaturityModelResults>> usp_countsForLevelsByGroupMaturityModel(Nullable<int> assessment_id, Nullable<int> mat_model_id)
        {
            var result = await this.Procedures.usp_countsForLevelsByGroupMaturityModelAsync(assessment_id, mat_model_id);
            return result.Cast<usp_countsForLevelsByGroupMaturityModelResults>().ToList();
        }

        /// <summary>
        ///
        /// </summary>
        /// <param name="originalEmail"></param>
        /// <param name="newEmail"></param>
        /// <returns></returns>
        public async Task<int> ChangeEmail(string originalEmail, string newEmail)
        {

            if ((originalEmail == null) || (newEmail != null))
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.changeEmailAsync(originalEmail, newEmail);
            return result;
        }

        public virtual async Task<IList<RawCountsForEachAssessment_Standards>> usp_GetRawCountsForEachAssessment_Standards()
        {
            var result = await this.Procedures.usp_GetRawCountsForEachAssessment_StandardsAsync();
            return result.Cast<RawCountsForEachAssessment_Standards>().ToList();
        }

        public virtual async Task<IList<AnalyticsgetMedianOverall>> analytics_compute_single_averages_maturity(int assessmentId, int maturity_model_id)
        {
            var result = await this.Procedures.analytics_compute_single_averages_maturityAsync(assessmentId, maturity_model_id);
            return result.Cast<AnalyticsgetMedianOverall>().ToList();
        }
        public virtual async Task<IList<SetStandard>> analytics_selectedStandardList(int assessmentId)
        {
            var result = await this.Procedures.analytics_selectedStandardListAsync(assessmentId);
            return result.Cast<SetStandard>().ToList();
        }


        public virtual async Task<IList<AnalyticsgetMedianOverall>> analytics_getMedianOverall()
        {
            var result = await this.Procedures.usp_getMedianOverallAsync();
            return result.Cast<AnalyticsgetMedianOverall>().ToList();
        }
        public virtual async Task<IList<AnalyticsgetMinMaxAverForSectorIndustryGroup>> analytics_getMinMaxAverageForSectorIndustryGroup(int sectorId, int industryId)
        {
            var result = await this.Procedures.usp_getMinMaxAverageForSectorIndustryAsync(sectorId, industryId);
            return result.Cast<AnalyticsgetMinMaxAverForSectorIndustryGroup>().ToList();
        }
        public virtual async Task<IList<AnalyticsStandardMinMaxAvg>> analytics_Compute_standard_all(int assessmentId, string setname, int? sectorId,
            int? industryId)
        {
            var result = await this.Procedures.analytics_Compute_standard_allAsync(assessmentId, setname, sectorId, industryId);
            return result.Cast<AnalyticsStandardMinMaxAvg>().ToList();
        }
        public virtual async Task<IList<standardAnalyticsgetMedianOverall>> analytics_compute_single_averages_standard(int assessmentId, string setname)
        {
            var result = await this.Procedures.analytics_compute_single_averages_standardAsync(assessmentId, setname);
            return result.Cast<standardAnalyticsgetMedianOverall>().ToList();
        }

        public virtual async Task<IList<AnalyticsMinMaxAvgMedianByGroup>> analytics_Compute_MaturityAll(int model_id, int? sectorId, int? industryId)
        {
            var result = await this.Procedures.analytics_Compute_MaturityAllAsync(model_id, sectorId, industryId);
            return result.Cast<AnalyticsMinMaxAvgMedianByGroup>().ToList();
        }
        // TODO: No async wrapper exists for analytics_Compute_MaturityAll_Median in CsetwebContextProcedures.cs
        // This method needs an async wrapper to be created or may be obsolete
        // Commented out to allow build to succeed - needs to be refactored or wrapper created
        /*
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
        */


        public virtual async Task usp_CopyIntoSet(string sourcesetName, string destinationSetName)
        {
            await this.Procedures.usp_CopyIntoSetAsync(sourcesetName, destinationSetName);
        }

        public virtual async Task usp_CopyIntoSet_Delete(string setName)
        {
            await this.Procedures.usp_CopyIntoSet_DeleteAsync(setName);
        }


        /// <summary>
        /// Inserts missing skeleton ANSWER records for an assessment based on
        /// its standard selection and SAL.
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
        public virtual async Task<int> FillEmptyQuestionsForAnalysis(Nullable<int> assessment_Id)
        {
            if (!assessment_Id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.FillEmptyQuestionsForAnalysisAsync(assessment_Id);
            return result;
        }

        /// <summary>
        /// Insert empty questions for Maturity model questions based on the maturity models
        /// selected on the assessment
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
        public virtual async Task<int> FillEmptyMaturityQuestionsForAnalysis(Nullable<int> assessment_Id)
        {
            if (!assessment_Id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.FillEmptyMaturityQuestionsForAnalysisAsync(assessment_Id);
            return result;
        }


        /// <summary>
        /// Insert empty questions for Maturity model questions for a specified model.
        /// This is designed for use with SSG questions.
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
        public virtual async Task<int> FillEmptyMaturityQuestionsForModel(Nullable<int> assessmentId, int modelId)
        {
            if (!assessmentId.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.FillEmptyMaturityQuestionsForModelAsync(assessmentId, modelId);
            return result;
        }


        /// <summary>
        ///
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
        public virtual async Task<int> FillNetworkDiagramQuestions(Nullable<int> assessment_Id)
        {
            if (!assessment_Id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.FillNetworkDiagramQuestionsAsync(assessment_Id);
            return result;
        }


        /// <summary>
        /// Executes stored procedure usp_GetOverallRankedCategoriesPage.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_GetOverallRankedCategoriesPage_Result>> usp_GetOverallRankedCategoriesPage(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_GetOverallRankedCategoriesPageAsync(assessment_id);
            return result.Cast<usp_GetOverallRankedCategoriesPage_Result>().ToList();
        }
        

        /// <summary>
        /// Executes stored procedure usp_GetRankedQuestions.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_GetRankedQuestions_Result>> usp_GetRankedQuestions(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_GetRankedQuestionsAsync(assessment_id);
            return result.Cast<usp_GetRankedQuestions_Result>().ToList();
        }


        /// <summary>
        /// Executes stored procedure usp_GetQuestionsWithFeedbacks.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_GetQuestionsWithFeedback>> usp_GetQuestionsWithFeedbacks(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("sql parameters may not be null");

            var result = await this.Procedures.usp_GetQuestionsWithFeedBackAsync(assessment_id);
            return result.Cast<usp_GetQuestionsWithFeedback>().ToList();
        }


        /// <summary>
        /// Executes stored procedure usp_MaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_MaturityDetailsCalculations_Result>> usp_MaturityDetailsCalculations(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_MaturityDetailsCalculationsAsync(assessment_id);
            return result.Cast<usp_MaturityDetailsCalculations_Result>().ToList();
        }


        /// <summary>
        /// Executes stored procedure GetMaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<GetMaturityDetailsCalculations_Result>> GetMaturityDetailsCalculations(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.GetMaturityDetailsCalculationsAsync(assessment_id);
            return result.Cast<GetMaturityDetailsCalculations_Result>().ToList();
        }


        /// <summary>
        /// Executes stored procedure GetMaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<AcetAnswerDistribution_Result>> AcetAnswerDistribution(Nullable<int> assessment_id, Nullable<int> targetLevel)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.AcetAnswerDistributionAsync(assessment_id, targetLevel);
            return result.Cast<AcetAnswerDistribution_Result>().ToList();
        }

        /// <summary>
        /// Executes stored procedure GetMaturityDetailsCalculations.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<AcetAnswerDistribution_Result>> IseAnswerDistribution(Nullable<int> assessment_id, Nullable<int> targetLevel)
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

            var result = await this.Procedures.IseAnswerDistributionAsync(assessment_id, matLevel);
            return result.Cast<AcetAnswerDistribution_Result>().ToList();
        }


        /// <summary>
        /// Executes stored procedure usp_StatementsReviewed.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_StatementsReviewed_Result>> usp_StatementsReviewed(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_StatementsReviewedAsync(assessment_id);
            return result.Cast<usp_StatementsReviewed_Result>().ToList();
        }


        /// <summary>
        /// Executes stored procedure usp_StatementsReviewedTabTotals.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_StatementsReviewedTabTotals_Result>> usp_StatementsReviewedTabTotals(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_StatementsReviewedTabTotalsAsync(assessment_id);
            return result.Cast<usp_StatementsReviewedTabTotals_Result>().ToList();
        }
        

        /// <summary>
        /// Executes stored procedure usp_GetTop5Areas.
        /// </summary>
        /// <param name="aggregation_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<usp_GetTop5Areas_result>> usp_GetTop5Areas(Nullable<int> aggregation_id)
        {
            if (!aggregation_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.usp_GetTop5AreasAsync(aggregation_id);
            return result.Cast<usp_GetTop5Areas_result>().ToList();
        }


        /// <summary>
        /// Returns a list of Question IDs that are 'in scope' or applicable
        /// to the specified assessment.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<int>> InScopeQuestions(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.InScopeQuestionsAsync(assessment_id);
            return result.Select(x => x.Question_Id).ToList();
        }


        /// <summary>
        /// Returns a list of Requirement IDs that are 'in scope' or applicable
        /// to the specified assessment.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public virtual async Task<IList<int>> InScopeRequirements(Nullable<int> assessment_id)
        {
            if (!assessment_id.HasValue)
                throw new ApplicationException("parameters may not be null");

            var result = await this.Procedures.InScopeRequirementsAsync(assessment_id);
            return result.Select(x => x.Requirement_Id).ToList();
        }

        public virtual async Task<IList<Get_Merge_ConflictsResult>> Get_Merge_Conflicts(Nullable<int> assessmentId1, Nullable<int> assessmentId2,
                                                                            int assessmentId3, int assessmentId4, int assessmentId5, int assessmentId6,
                                                                            int assessmentId7, int assessmentId8, int assessmentId9, int assessmentId10)
        {
            if (!assessmentId1.HasValue || !assessmentId2.HasValue)
                throw new ApplicationException("first two parameters may not be null");
            var result = await this.Procedures.Get_Merge_ConflictsAsync(assessmentId1, assessmentId2, assessmentId3, assessmentId4, assessmentId5, assessmentId6, assessmentId7, assessmentId8, assessmentId9, assessmentId10);
            return result.ToList();
        }

        public virtual async Task<IList<Get_Cie_Merge_ConflictsResult>> Get_Cie_Merge_Conflicts(Nullable<int> assessmentId1, Nullable<int> assessmentId2,
                                                                            int assessmentId3, int assessmentId4, int assessmentId5, int assessmentId6,
                                                                            int assessmentId7, int assessmentId8, int assessmentId9, int assessmentId10)
        {
            if (!assessmentId1.HasValue || !assessmentId2.HasValue)
                throw new ApplicationException("first two parameters may not be null");
            var result = await this.Procedures.Get_Cie_Merge_ConflictsAsync(assessmentId1, assessmentId2, assessmentId3, assessmentId4, assessmentId5, assessmentId6, assessmentId7, assessmentId8, assessmentId9, assessmentId10);
            return result.ToList();
        }

        public virtual async Task<IList<Get_Assess_Detail_Filter_DataResult>> Get_Assess_Detail_Filters(string model)
        {
            var result = await this.Procedures.Get_Assess_Detail_Filter_DataAsync(model);
            return result.OrderBy(x => x.Detail_Id).ToList();
        }

        public virtual async Task<IList<GetChildrenAnswersResult>> Get_Children_Answers(int parentId, int assessId)
        {
            var result = await this.Procedures.GetChildrenAnswersAsync(parentId, assessId);
            return result.ToList();
        }
    }
}