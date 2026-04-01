//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CSETWebCore.DataLayer.Manual;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;

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

                entity.Property(e => e.Text_Hash).HasComputedColumnSql("digest(\"Question_Text\", 'sha1')");
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

            return this.Database.SqlQueryRaw<usp_Assessments_For_UserResult>(
                "SELECT * FROM usp_Assessments_For_User(@user_id)",
                new NpgsqlParameter("user_id", userId)).ToList();
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

            this.Database.ExecuteSqlRaw(
                "CALL changeEmail(@originalEmail, @newEmail)",
                new NpgsqlParameter("originalEmail", originalEmail),
                new NpgsqlParameter("newEmail", newEmail));
            return 0;
        }

        public virtual IList<AnalyticsgetMedianOverall> analytics_compute_single_averages_maturity(int assessmentId, int maturity_model_id)
        {
            return this.Database.SqlQueryRaw<AnalyticsgetMedianOverall>(
                "SELECT * FROM analytics_compute_single_averages_maturity(@assessment_id, @maturity_model_id)",
                new NpgsqlParameter("assessment_id", assessmentId),
                new NpgsqlParameter("maturity_model_id", maturity_model_id)).ToList();
        }
        public virtual IList<SetStandard> analytics_selectedStandardList(int assessmentId)
        {
            return this.Database.SqlQueryRaw<SetStandard>(
                "SELECT * FROM analytics_selectedStandardList(@standard_assessment_id)",
                new NpgsqlParameter("standard_assessment_id", assessmentId)).ToList();
        }


        public virtual IList<AnalyticsgetMedianOverall> analytics_getMedianOverall()
        {
            return this.Database.SqlQueryRaw<AnalyticsgetMedianOverall>(
                "SELECT * FROM analytics_getMedianOverall()").ToList();
        }
        public virtual IList<AnalyticsgetMinMaxAverForSectorIndustryGroup> analytics_getMinMaxAverageForSectorIndustryGroup(int sectorId, int industryId)
        {
            return this.Database.SqlQueryRaw<AnalyticsgetMinMaxAverForSectorIndustryGroup>(
                "SELECT * FROM analytics_getMinMaxAverageForSectorIndustryGroup(@sector_id, @industry_id)",
                new NpgsqlParameter("sector_id", sectorId),
                new NpgsqlParameter("industry_id", industryId)).ToList();
        }
        public virtual IList<AnalyticsStandardMinMaxAvg> analytics_Compute_standard_all(int assessmentId, string setname, int? sectorId,
            int? industryId)
        {
            return this.Database.SqlQueryRaw<AnalyticsStandardMinMaxAvg>(
                "SELECT * FROM analytics_Compute_standard_all(@assessment_id, @set_name, @sector_id, @industry_id)",
                new NpgsqlParameter("assessment_id", assessmentId),
                new NpgsqlParameter("set_name", setname),
                new NpgsqlParameter("sector_id", (object)sectorId ?? DBNull.Value),
                new NpgsqlParameter("industry_id", (object)industryId ?? DBNull.Value)).ToList();
        }
        public virtual IList<standardAnalyticsgetMedianOverall> analytics_compute_single_averages_standard(int assessmentId, string setname)
        {
            return this.Database.SqlQueryRaw<standardAnalyticsgetMedianOverall>(
                "SELECT * FROM analytics_compute_single_averages_standard(@assessment_id, @set_name)",
                new NpgsqlParameter("assessment_id", assessmentId),
                new NpgsqlParameter("set_name", setname)).ToList();
        }

        public virtual IList<AnalyticsMinMaxAvgMedianByGroup> analytics_Compute_MaturityAll(int model_id, int? sectorId, int? industryId)
        {
            return this.Database.SqlQueryRaw<AnalyticsMinMaxAvgMedianByGroup>(
                "SELECT * FROM analytics_Compute_MaturityAll(@maturity_model_id, @sector_id, @industry_id)",
                new NpgsqlParameter("maturity_model_id", model_id),
                new NpgsqlParameter("sector_id", (object)sectorId ?? DBNull.Value),
                new NpgsqlParameter("industry_id", (object)industryId ?? DBNull.Value)).ToList();
        }
        public virtual IList<AnalyticsMinMaxAvgMedianByGroup> analytics_Compute_MaturityAll_Median(int model_id)
        {
            return this.Database.SqlQueryRaw<AnalyticsMinMaxAvgMedianByGroup>(
                "SELECT * FROM analytics_Compute_MaturityAll_Median(@maturity_model_id)",
                new NpgsqlParameter("maturity_model_id", model_id)).ToList();
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

            this.Database.ExecuteSqlRaw(
                "CALL FillEmptyQuestionsForAnalysis(@Assessment_Id)",
                new NpgsqlParameter("Assessment_Id", assessment_Id));
            return 0;
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

            this.Database.ExecuteSqlRaw(
                "CALL FillEmptyMaturityQuestionsForAnalysis(@Assessment_Id)",
                new NpgsqlParameter("Assessment_Id", assessment_Id));
            return 0;
        }


        /// <summary>
        /// Insert empty questions for Maturity model questions for a specified model.
        /// This is designed for use with SSG questions.
        /// </summary>
        /// <param name="assessment_Id"></param>
        /// <returns></returns>
        public virtual int FillEmptyMaturityQuestionsForModel(Nullable<int> assessmentId, int modelId)
        {
            if (!assessmentId.HasValue)
                throw new ApplicationException("parameters may not be null");

            this.Database.ExecuteSqlRaw(
                "CALL FillEmptyMaturityQuestionsForModel(@Assessment_Id, @Model_Id)",
                new NpgsqlParameter("Assessment_Id", assessmentId),
                new NpgsqlParameter("Model_Id", modelId));
            return 0;
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

            this.Database.ExecuteSqlRaw(
                "CALL FillNetworkDiagramQuestions(@Assessment_Id)",
                new NpgsqlParameter("Assessment_Id", assessment_Id));
            return 0;
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

            return this.Database.SqlQueryRaw<usp_GetTop5Areas_result>(
                "SELECT * FROM usp_GetTop5Areas(@aggregation_id)",
                new NpgsqlParameter("aggregation_id", aggregation_id)).ToList();
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

            return this.Database.SqlQueryRaw<Question_Id_result>(
                "SELECT * FROM InScopeQuestions(@assessment_id)",
                new NpgsqlParameter("assessment_id", assessment_id))
                .Select(x => x.Question_Id).ToList();
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

            return this.Database.SqlQueryRaw<Requirement_Id_result>(
                "SELECT * FROM InScopeRequirements(@assessment_id)",
                new NpgsqlParameter("assessment_id", assessment_id))
                .Select(x => x.Requirement_Id).ToList();
        }


        public virtual IList<GetChildrenAnswersResult> Get_Children_Answers(int parentId, int assessId)
        {
            return this.Database.SqlQueryRaw<GetChildrenAnswersResult>(
                "SELECT * FROM GetChildrenAnswers(@Parent_Id, @Assess_Id)",
                new NpgsqlParameter("Parent_Id", parentId),
                new NpgsqlParameter("Assess_Id", assessId)).ToList();
        }
    }
}