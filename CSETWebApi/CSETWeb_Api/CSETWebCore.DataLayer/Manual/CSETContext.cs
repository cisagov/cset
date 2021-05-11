//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Snickler.EFCore;

namespace CSETWebCore.DataLayer
{
    public class CSETContext : CsetwebContext
    {
        private string _connectionString;

        public CSETContext() { }
        /// <summary>
        /// Constructor
        /// </summary>
        public CSETContext(IConfiguration config)
        {
            this._connectionString = ConfigurationExtensions.GetConnectionString(config, "CSET_DB");
        }

        public CSETContext(DbContextOptions<CsetwebContext> options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
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
                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.AVAILABLE_MATURITY_MODELS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_AVAILABLE_MATURITY_MODELS_ASSESSMENTS");

                entity.HasOne(d => d.model_)
                    .WithMany(p => p.AVAILABLE_MATURITY_MODELS)
                    .HasForeignKey(d => d.model_id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__AVAILABLE__model__6F6A7CB2");
            });

            modelBuilder.Entity<MATURITY_LEVELS>(entity =>
            {
                entity.Property(e => e.Level_Name).IsUnicode(false);

                entity.HasOne(d => d.Maturity_Model_)
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

                entity.HasOne(d => d.Type_)
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

            modelBuilder.Entity<MATURITY_SOURCE_FILES>(entity =>
            {
                entity.HasKey(e => new { e.Mat_Question_Id, e.Gen_File_Id, e.Section_Ref });

                entity.Property(e => e.Section_Ref).IsUnicode(false);

                entity.Property(e => e.Destination_String).IsUnicode(false);

                entity.HasOne(d => d.Mat_Question_)
                    .WithMany(p => p.MATURITY_SOURCE_FILES)
                    .HasForeignKey(d => d.Mat_Question_Id)
                    .HasConstraintName("FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS");
            });

            modelBuilder.Entity<MATURITY_REFERENCES>(entity =>
            {
                entity.HasKey(e => new { e.Mat_Question_Id, e.Gen_File_Id, e.Section_Ref });

                entity.Property(e => e.Section_Ref).IsUnicode(false);

                entity.Property(e => e.Destination_String).IsUnicode(false);

                entity.HasOne(d => d.Mat_Question_)
                    .WithMany(p => p.MATURITY_REFERENCES)
                    .HasForeignKey(d => d.Mat_Question_Id)
                    .HasConstraintName("FK_MATURITY_REFERENCES_MATURITY_QUESTIONS");
            });

            modelBuilder.Entity<MATURITY_REFERENCE_TEXT>(entity =>
            {
                entity.HasKey(e => new { e.Mat_Question_Id, e.Sequence });

                entity.Property(e => e.Reference_Text).IsUnicode(false);
            });

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
        public virtual DbSet<Answer_Requirements> Answer_Requirements { get; set; }

        public virtual DbSet<Answer_Components> Answer_Components { get; set; }
        public virtual DbSet<Assessments_For_User> Assessments_For_User { get; set; }
        public virtual DbSet<Answer_Components_Default> Answer_Components_Default { get; set; }
        public virtual IList<Answer_Components_Default> usp_Answer_Components_Default(Nullable<int> assessment_id)
        {
            try
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
            }catch(Exception e)
            {
                throw e;
            }
        }

        public virtual DbSet<Answer_Components_Overrides> Answer_Components_Overrides { get; set; }
        public virtual DbSet<Answer_Standards_InScope> Answer_Standards_InScope { get; set; }


        // modelBuilder.Query<Answer_Questions_No_Components>().ToView("Answer_Questions_No_Components").Property(v => v.Answer_Id).HasColumnName("Answer_Id");
        public virtual DbSet<Answer_Questions_No_Components> Answer_Questions_No_Components { get; set; }

        public virtual DbSet<Answer_Maturity> Answer_Maturity { get; set; }
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
        public virtual IList<Assessments_For_User> usp_AssessmentsForUser(Nullable<int> userId)
        {
            if (!userId.HasValue)
                throw new ApplicationException("parameters may not be null");

            IList<Assessments_For_User> myrval = null;
            this.LoadStoredProc("usp_Assessments_For_User")
                     .WithSqlParam("user_id", userId)

                     .ExecuteStoredProc((handler) =>
                     {
                         myrval = handler.ReadToList<Assessments_For_User>();
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


        public virtual void usp_CopyIntoSet(string sourcesetName, string destinationSetName)
        {   
            this.LoadStoredProc("usp_CopyIntoSet")
                     .WithSqlParam("SourceSetName", sourcesetName)
                     .WithSqlParam("DestinationSetName",destinationSetName)
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
        public virtual IList<int> InScopeQuestions (Nullable<int> assessment_id)
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
    }
}