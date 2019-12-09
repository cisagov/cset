using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace DataLayerCore.Model
{
    public partial class CsetwebContext : DbContext
    {
        public CsetwebContext()
        {
        }

        public CsetwebContext(DbContextOptions<CsetwebContext> options)
            : base(options)
        {
        }

        public virtual DbSet<ADDRESS> ADDRESS { get; set; }
        public virtual DbSet<ANSWER> ANSWER { get; set; }
        public virtual DbSet<ANSWER_LOOKUP> ANSWER_LOOKUP { get; set; }
        public virtual DbSet<APP_CODE> APP_CODE { get; set; }
        public virtual DbSet<ASSESSMENTS> ASSESSMENTS { get; set; }
        public virtual DbSet<ASSESSMENTS_REQUIRED_DOCUMENTATION> ASSESSMENTS_REQUIRED_DOCUMENTATION { get; set; }
        public virtual DbSet<ASSESSMENT_CONTACTS> ASSESSMENT_CONTACTS { get; set; }
        public virtual DbSet<ASSESSMENT_DIAGRAM_COMPONENTS> ASSESSMENT_DIAGRAM_COMPONENTS { get; set; }
        public virtual DbSet<ASSESSMENT_IRP> ASSESSMENT_IRP { get; set; }
        public virtual DbSet<ASSESSMENT_IRP_HEADER> ASSESSMENT_IRP_HEADER { get; set; }
        public virtual DbSet<ASSESSMENT_ROLES> ASSESSMENT_ROLES { get; set; }
        public virtual DbSet<ASSESSMENT_SELECTED_LEVELS> ASSESSMENT_SELECTED_LEVELS { get; set; }
        public virtual DbSet<AVAILABLE_STANDARDS> AVAILABLE_STANDARDS { get; set; }
        public virtual DbSet<CATALOG_RECOMMENDATIONS_DATA> CATALOG_RECOMMENDATIONS_DATA { get; set; }
        public virtual DbSet<CATALOG_RECOMMENDATIONS_HEADINGS> CATALOG_RECOMMENDATIONS_HEADINGS { get; set; }
        public virtual DbSet<CNSS_CIA_JUSTIFICATIONS> CNSS_CIA_JUSTIFICATIONS { get; set; }
        public virtual DbSet<CNSS_CIA_TYPES> CNSS_CIA_TYPES { get; set; }
        public virtual DbSet<COMPONENT_FAMILY> COMPONENT_FAMILY { get; set; }
        public virtual DbSet<COMPONENT_NAMES_LEGACY> COMPONENT_NAMES_LEGACY { get; set; }
        public virtual DbSet<COMPONENT_QUESTIONS> COMPONENT_QUESTIONS { get; set; }
        public virtual DbSet<COMPONENT_SYMBOLS> COMPONENT_SYMBOLS { get; set; }
        public virtual DbSet<COMPONENT_SYMBOLS_GM_TO_CSET> COMPONENT_SYMBOLS_GM_TO_CSET { get; set; }
        public virtual DbSet<COUNTRIES> COUNTRIES { get; set; }
        public virtual DbSet<CSET_VERSION> CSET_VERSION { get; set; }
        public virtual DbSet<CUSTOM_BASE_STANDARDS> CUSTOM_BASE_STANDARDS { get; set; }
        public virtual DbSet<CUSTOM_QUESTIONAIRES> CUSTOM_QUESTIONAIRES { get; set; }
        public virtual DbSet<CUSTOM_QUESTIONAIRE_QUESTIONS> CUSTOM_QUESTIONAIRE_QUESTIONS { get; set; }
        public virtual DbSet<CUSTOM_STANDARD_BASE_STANDARD> CUSTOM_STANDARD_BASE_STANDARD { get; set; }
        public virtual DbSet<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
        public virtual DbSet<DEMOGRAPHICS_ASSET_VALUES> DEMOGRAPHICS_ASSET_VALUES { get; set; }
        public virtual DbSet<DEMOGRAPHICS_SIZE> DEMOGRAPHICS_SIZE { get; set; }
        public virtual DbSet<DIAGRAM_CONTAINER> DIAGRAM_CONTAINER { get; set; }
        public virtual DbSet<DIAGRAM_CONTAINER_TYPES> DIAGRAM_CONTAINER_TYPES { get; set; }
        public virtual DbSet<DIAGRAM_OBJECT_TYPES> DIAGRAM_OBJECT_TYPES { get; set; }
        public virtual DbSet<DIAGRAM_TEMPLATES> DIAGRAM_TEMPLATES { get; set; }
        public virtual DbSet<DIAGRAM_TYPES> DIAGRAM_TYPES { get; set; }
        public virtual DbSet<DOCUMENT_ANSWERS> DOCUMENT_ANSWERS { get; set; }
        public virtual DbSet<DOCUMENT_FILE> DOCUMENT_FILE { get; set; }
        public virtual DbSet<EXTRA_ACET_MAPPING> EXTRA_ACET_MAPPING { get; set; }
        public virtual DbSet<FILE_KEYWORDS> FILE_KEYWORDS { get; set; }
        public virtual DbSet<FILE_REF_KEYS> FILE_REF_KEYS { get; set; }
        public virtual DbSet<FILE_TYPE> FILE_TYPE { get; set; }
        public virtual DbSet<FINANCIAL_ASSESSMENT_FACTORS> FINANCIAL_ASSESSMENT_FACTORS { get; set; }
        public virtual DbSet<FINANCIAL_ASSESSMENT_VALUES> FINANCIAL_ASSESSMENT_VALUES { get; set; }
        public virtual DbSet<FINANCIAL_ATTRIBUTES> FINANCIAL_ATTRIBUTES { get; set; }
        public virtual DbSet<FINANCIAL_COMPONENTS> FINANCIAL_COMPONENTS { get; set; }
        public virtual DbSet<FINANCIAL_DETAILS> FINANCIAL_DETAILS { get; set; }
        public virtual DbSet<FINANCIAL_DOMAINS> FINANCIAL_DOMAINS { get; set; }
        public virtual DbSet<FINANCIAL_DOMAIN_FILTERS> FINANCIAL_DOMAIN_FILTERS { get; set; }
        public virtual DbSet<FINANCIAL_FFIEC_MAPPINGS> FINANCIAL_FFIEC_MAPPINGS { get; set; }
        public virtual DbSet<FINANCIAL_GROUPS> FINANCIAL_GROUPS { get; set; }
        public virtual DbSet<FINANCIAL_HOURS> FINANCIAL_HOURS { get; set; }
        public virtual DbSet<FINANCIAL_HOURS_COMPONENT> FINANCIAL_HOURS_COMPONENT { get; set; }
        public virtual DbSet<FINANCIAL_MATURITY> FINANCIAL_MATURITY { get; set; }
        public virtual DbSet<FINANCIAL_QUESTIONS> FINANCIAL_QUESTIONS { get; set; }
        public virtual DbSet<FINANCIAL_REQUIREMENTS> FINANCIAL_REQUIREMENTS { get; set; }
        public virtual DbSet<FINANCIAL_REVIEWTYPE> FINANCIAL_REVIEWTYPE { get; set; }
        public virtual DbSet<FINANCIAL_TIERS> FINANCIAL_TIERS { get; set; }
        public virtual DbSet<FINDING> FINDING { get; set; }
        public virtual DbSet<FINDING_CONTACT> FINDING_CONTACT { get; set; }
        public virtual DbSet<FRAMEWORK_TIERS> FRAMEWORK_TIERS { get; set; }
        public virtual DbSet<FRAMEWORK_TIER_DEFINITIONS> FRAMEWORK_TIER_DEFINITIONS { get; set; }
        public virtual DbSet<FRAMEWORK_TIER_TYPE> FRAMEWORK_TIER_TYPE { get; set; }
        public virtual DbSet<FRAMEWORK_TIER_TYPE_ANSWER> FRAMEWORK_TIER_TYPE_ANSWER { get; set; }
        public virtual DbSet<GENERAL_SAL> GENERAL_SAL { get; set; }
        public virtual DbSet<GENERAL_SAL_DESCRIPTIONS> GENERAL_SAL_DESCRIPTIONS { get; set; }
        public virtual DbSet<GEN_FILE> GEN_FILE { get; set; }
        public virtual DbSet<GEN_FILE_LIB_PATH_CORL> GEN_FILE_LIB_PATH_CORL { get; set; }
        public virtual DbSet<GEN_SAL_NAMES> GEN_SAL_NAMES { get; set; }
        public virtual DbSet<GEN_SAL_WEIGHTS> GEN_SAL_WEIGHTS { get; set; }
        public virtual DbSet<GLOBAL_PROPERTIES> GLOBAL_PROPERTIES { get; set; }
        public virtual DbSet<IMPORTANCE> IMPORTANCE { get; set; }
        public virtual DbSet<INFORMATION> INFORMATION { get; set; }
        public virtual DbSet<IRP> IRP { get; set; }
        public virtual DbSet<IRP_HEADER> IRP_HEADER { get; set; }
        public virtual DbSet<INSTALLATION> INSTALLATION { get; set; }
        public virtual DbSet<LEVEL_NAMES> LEVEL_NAMES { get; set; }
        public virtual DbSet<NAVIGATION_STATE> NAVIGATION_STATE { get; set; }
        public virtual DbSet<NCSF_CATEGORY> NCSF_CATEGORY { get; set; }
        public virtual DbSet<NCSF_FUNCTIONS> NCSF_FUNCTIONS { get; set; }
        public virtual DbSet<NERC_RISK_RANKING> NERC_RISK_RANKING { get; set; }
        public virtual DbSet<NETWORK_WARNINGS> NETWORK_WARNINGS { get; set; }
        public virtual DbSet<NEW_QUESTION> NEW_QUESTION { get; set; }
        public virtual DbSet<NEW_QUESTION_LEVELS> NEW_QUESTION_LEVELS { get; set; }
        public virtual DbSet<NEW_QUESTION_SETS> NEW_QUESTION_SETS { get; set; }
        public virtual DbSet<NEW_REQUIREMENT> NEW_REQUIREMENT { get; set; }
        public virtual DbSet<NIST_SAL_INFO_TYPES> NIST_SAL_INFO_TYPES { get; set; }
        public virtual DbSet<NIST_SAL_INFO_TYPES_DEFAULTS> NIST_SAL_INFO_TYPES_DEFAULTS { get; set; }
        public virtual DbSet<NIST_SAL_QUESTIONS> NIST_SAL_QUESTIONS { get; set; }
        public virtual DbSet<NIST_SAL_QUESTION_ANSWERS> NIST_SAL_QUESTION_ANSWERS { get; set; }
        public virtual DbSet<PARAMETERS> PARAMETERS { get; set; }
        public virtual DbSet<PARAMETER_ASSESSMENT> PARAMETER_ASSESSMENT { get; set; }
        public virtual DbSet<PARAMETER_REQUIREMENTS> PARAMETER_REQUIREMENTS { get; set; }
        public virtual DbSet<PARAMETER_VALUES> PARAMETER_VALUES { get; set; }
        public virtual DbSet<PROCUREMENT_DEPENDENCY> PROCUREMENT_DEPENDENCY { get; set; }
        public virtual DbSet<PROCUREMENT_LANGUAGE_DATA> PROCUREMENT_LANGUAGE_DATA { get; set; }
        public virtual DbSet<PROCUREMENT_LANGUAGE_HEADINGS> PROCUREMENT_LANGUAGE_HEADINGS { get; set; }
        public virtual DbSet<PROCUREMENT_REFERENCES> PROCUREMENT_REFERENCES { get; set; }
        public virtual DbSet<QUESTION_GROUP_HEADING> QUESTION_GROUP_HEADING { get; set; }
        public virtual DbSet<QUESTION_GROUP_TYPE> QUESTION_GROUP_TYPE { get; set; }
        public virtual DbSet<RECENT_FILES> RECENT_FILES { get; set; }
        public virtual DbSet<RECOMMENDATIONS_REFERENCES> RECOMMENDATIONS_REFERENCES { get; set; }
        public virtual DbSet<REFERENCES_DATA> REFERENCES_DATA { get; set; }
        public virtual DbSet<REFERENCE_DOCS> REFERENCE_DOCS { get; set; }
        public virtual DbSet<REF_LIBRARY_PATH> REF_LIBRARY_PATH { get; set; }
        public virtual DbSet<REPORT_DETAIL_SECTIONS> REPORT_DETAIL_SECTIONS { get; set; }
        public virtual DbSet<REPORT_DETAIL_SECTION_SELECTION> REPORT_DETAIL_SECTION_SELECTION { get; set; }
        public virtual DbSet<REPORT_OPTIONS> REPORT_OPTIONS { get; set; }
        public virtual DbSet<REPORT_OPTIONS_SELECTION> REPORT_OPTIONS_SELECTION { get; set; }
        public virtual DbSet<REPORT_STANDARDS_SELECTION> REPORT_STANDARDS_SELECTION { get; set; }
        public virtual DbSet<REQUIRED_DOCUMENTATION> REQUIRED_DOCUMENTATION { get; set; }
        public virtual DbSet<REQUIRED_DOCUMENTATION_HEADERS> REQUIRED_DOCUMENTATION_HEADERS { get; set; }
        public virtual DbSet<REQUIREMENT_LEVELS> REQUIREMENT_LEVELS { get; set; }
        public virtual DbSet<REQUIREMENT_LEVEL_TYPE> REQUIREMENT_LEVEL_TYPE { get; set; }
        public virtual DbSet<REQUIREMENT_QUESTIONS> REQUIREMENT_QUESTIONS { get; set; }
        public virtual DbSet<REQUIREMENT_QUESTIONS_SETS> REQUIREMENT_QUESTIONS_SETS { get; set; }
        public virtual DbSet<REQUIREMENT_REFERENCES> REQUIREMENT_REFERENCES { get; set; }
        public virtual DbSet<REQUIREMENT_SETS> REQUIREMENT_SETS { get; set; }
        public virtual DbSet<REQUIREMENT_SOURCE_FILES> REQUIREMENT_SOURCE_FILES { get; set; }
        public virtual DbSet<SAL_DETERMINATION_TYPES> SAL_DETERMINATION_TYPES { get; set; }
        public virtual DbSet<SECTOR> SECTOR { get; set; }
        public virtual DbSet<SECTOR_INDUSTRY> SECTOR_INDUSTRY { get; set; }
        public virtual DbSet<SECTOR_STANDARD_RECOMMENDATIONS> SECTOR_STANDARD_RECOMMENDATIONS { get; set; }
        public virtual DbSet<SECURITY_QUESTION> SECURITY_QUESTION { get; set; }
        public virtual DbSet<SETS> SETS { get; set; }
        public virtual DbSet<SETS_CATEGORY> SETS_CATEGORY { get; set; }
        public virtual DbSet<SET_FILES> SET_FILES { get; set; }
        public virtual DbSet<SHAPE_TYPES> SHAPE_TYPES { get; set; }
        public virtual DbSet<SP80053_FAMILY_ABBREVIATIONS> SP80053_FAMILY_ABBREVIATIONS { get; set; }
        public virtual DbSet<STANDARD_CATEGORY> STANDARD_CATEGORY { get; set; }
        public virtual DbSet<STANDARD_CATEGORY_SEQUENCE> STANDARD_CATEGORY_SEQUENCE { get; set; }
        public virtual DbSet<STANDARD_SELECTION> STANDARD_SELECTION { get; set; }
        public virtual DbSet<STANDARD_SOURCE_FILE> STANDARD_SOURCE_FILE { get; set; }
        public virtual DbSet<STANDARD_SPECIFIC_LEVEL> STANDARD_SPECIFIC_LEVEL { get; set; }
        public virtual DbSet<STANDARD_TO_UNIVERSAL_MAP> STANDARD_TO_UNIVERSAL_MAP { get; set; }
        public virtual DbSet<STATES_AND_PROVINCES> STATES_AND_PROVINCES { get; set; }
        public virtual DbSet<SUB_CATEGORY_ANSWERS> SUB_CATEGORY_ANSWERS { get; set; }
        public virtual DbSet<SYMBOL_GROUPS> SYMBOL_GROUPS { get; set; }
        public virtual DbSet<UNIVERSAL_AREA> UNIVERSAL_AREA { get; set; }
        public virtual DbSet<UNIVERSAL_SAL_LEVEL> UNIVERSAL_SAL_LEVEL { get; set; }
        public virtual DbSet<UNIVERSAL_SUB_CATEGORIES> UNIVERSAL_SUB_CATEGORIES { get; set; }
        public virtual DbSet<UNIVERSAL_SUB_CATEGORY_HEADINGS> UNIVERSAL_SUB_CATEGORY_HEADINGS { get; set; }
        public virtual DbSet<USERS> USERS { get; set; }
        public virtual DbSet<USER_DETAIL_INFORMATION> USER_DETAIL_INFORMATION { get; set; }
        public virtual DbSet<USER_SECURITY_QUESTIONS> USER_SECURITY_QUESTIONS { get; set; }
        public virtual DbSet<VISIO_MAPPING> VISIO_MAPPING { get; set; }
        public virtual DbSet<WEIGHT> WEIGHT { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.0-rtm-35687");

            modelBuilder.Entity<ADDRESS>(entity =>
            {
                entity.HasKey(e => new { e.AddressType, e.Id })
                    .HasName("PK_ADDRESS_1");

                entity.Property(e => e.AddressType).IsUnicode(false);

                entity.Property(e => e.City).IsUnicode(false);

                entity.Property(e => e.Country).IsUnicode(false);

                entity.Property(e => e.Line1).IsUnicode(false);

                entity.Property(e => e.Line2).IsUnicode(false);

                entity.Property(e => e.PrimaryEmail).IsUnicode(false);

                entity.Property(e => e.State).IsUnicode(false);

                entity.Property(e => e.Zip).IsUnicode(false);

                entity.HasOne(d => d.IdNavigation)
                    .WithMany(p => p.ADDRESS)
                    .HasForeignKey(d => d.Id)
                    .HasConstraintName("FK_ADDRESS_USER_DETAIL_INFORMATION1");
            });

            modelBuilder.Entity<ANSWER>(entity =>
            {
                entity.HasKey(e => e.Answer_Id)
                    .HasName("PK_ANSWER_1");

                entity.HasIndex(e => new { e.Assessment_Id, e.Question_Or_Requirement_Id, e.Component_Guid, e.Is_Requirement })
                    .HasName("IX_ANSWER_1")
                    .IsUnique();

                entity.Property(e => e.Alternate_Justification).IsUnicode(false);

                entity.Property(e => e.Answer_Text)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('U')");

                entity.Property(e => e.Comment).IsUnicode(false);

                entity.Property(e => e.Custom_Question_Guid).IsUnicode(false);

                entity.Property(e => e.Feedback).IsUnicode(false);

                entity.HasOne(d => d.Answer_TextNavigation)
                    .WithMany(p => p.ANSWER)
                    .HasForeignKey(d => d.Answer_Text)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ANSWER_Answer_Lookup");

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.ANSWER)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_ANSWER_ASSESSMENTS");
            });

            modelBuilder.Entity<ANSWER_LOOKUP>(entity =>
            {
                entity.HasKey(e => e.Answer_Text)
                    .HasName("PK_Answer_Lookup");

                entity.Property(e => e.Answer_Text)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Answer_Full_Name).IsUnicode(false);
            });

            modelBuilder.Entity<APP_CODE>(entity =>
            {
                entity.Property(e => e.AppCode)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Description).IsUnicode(false);
            });

            modelBuilder.Entity<ASSESSMENTS>(entity =>
            {
                entity.HasKey(e => e.Assessment_Id)
                    .HasName("PK_Aggregation_1");

                entity.Property(e => e.Alias).IsUnicode(false);

                entity.Property(e => e.AssessmentCreatedDate).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Assessment_Date).HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Assessment_GUID).HasDefaultValueSql("(newid())");

                entity.Property(e => e.Assets).IsUnicode(false);

                entity.Property(e => e.Charter).IsUnicode(false);

                entity.Property(e => e.CreditUnionName).IsUnicode(false);

                entity.Property(e => e.Diagram_Image).IsUnicode(false);

                entity.Property(e => e.IRPTotalOverrideReason).IsUnicode(false);

                entity.Property(e => e.MatDetail_targetBandOnly).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.AssessmentCreator)
                    .WithMany(p => p.ASSESSMENTS)
                    .HasForeignKey(d => d.AssessmentCreatorId)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("FK_ASSESSMENTS_USERS");
            });

            modelBuilder.Entity<ASSESSMENTS_REQUIRED_DOCUMENTATION>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Documentation_Id });

                entity.Property(e => e.Answer)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('U')");

                entity.Property(e => e.Comment).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.ASSESSMENTS_REQUIRED_DOCUMENTATION)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_ASSESSMENTS_REQUIRED_DOCUMENTATION_ASSESSMENTS");

                entity.HasOne(d => d.Documentation_)
                    .WithMany(p => p.ASSESSMENTS_REQUIRED_DOCUMENTATION)
                    .HasForeignKey(d => d.Documentation_Id)
                    .HasConstraintName("FK_ASSESSMENTS_REQUIRED_DOCUMENTATION_REQUIRED_DOCUMENTATION");
            });

            modelBuilder.Entity<ASSESSMENT_CONTACTS>(entity =>
            {
                entity.Property(e => e.FirstName).IsUnicode(false);

                entity.Property(e => e.LastName).IsUnicode(false);

                entity.Property(e => e.PrimaryEmail).IsUnicode(false);

                entity.HasOne(d => d.AssessmentRole)
                    .WithMany(p => p.ASSESSMENT_CONTACTS)
                    .HasForeignKey(d => d.AssessmentRoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ASSESSMENT_CONTACTS_ASSESSMENT_ROLES");

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.ASSESSMENT_CONTACTS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_ASSESSMENT_CONTACTS_ASSESSMENTS");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.ASSESSMENT_CONTACTS)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_ASSESSMENT_CONTACTS_USERS");
            });

            modelBuilder.Entity<ASSESSMENT_DIAGRAM_COMPONENTS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Component_Guid })
                    .HasName("PK_ASSESSMENT_DIAGRAM_COMPONENTS_1");

                entity.Property(e => e.DrawIO_id).IsUnicode(false);

                entity.Property(e => e.Parent_DrawIO_Id).IsUnicode(false);

                entity.Property(e => e.label).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.ASSESSMENT_DIAGRAM_COMPONENTS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_ASSESSMENT_DIAGRAM_COMPONENTS_ASSESSMENTS");

                entity.HasOne(d => d.Component_Symbol_)
                    .WithMany(p => p.ASSESSMENT_DIAGRAM_COMPONENTS)
                    .HasForeignKey(d => d.Component_Symbol_Id)
                    .HasConstraintName("FK_ASSESSMENT_DIAGRAM_COMPONENTS_COMPONENT_SYMBOLS1");

                entity.HasOne(d => d.Layer_)
                    .WithMany(p => p.ASSESSMENT_DIAGRAM_COMPONENTSLayer_)
                    .HasForeignKey(d => d.Layer_Id)
                    .HasConstraintName("FK_ASSESSMENT_DIAGRAM_COMPONENTS_DIAGRAM_CONTAINER");

                entity.HasOne(d => d.Zone_)
                    .WithMany(p => p.ASSESSMENT_DIAGRAM_COMPONENTSZone_)
                    .HasForeignKey(d => d.Zone_Id)
                    .HasConstraintName("FK_ASSESSMENT_DIAGRAM_COMPONENTS_DIAGRAM_CONTAINER1");
            });

            modelBuilder.Entity<ASSESSMENT_IRP>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.IRP_Id })
                    .HasName("PK_Assessment_IRP");

                entity.Property(e => e.Answer_Id).ValueGeneratedOnAdd();

                entity.Property(e => e.Comment).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.ASSESSMENT_IRP)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK__Assessmen__Asses__5DEAEAF5");

                entity.HasOne(d => d.IRP_)
                    .WithMany(p => p.ASSESSMENT_IRP)
                    .HasForeignKey(d => d.IRP_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Assessmen__IRP_I__5EDF0F2E");
            });

            modelBuilder.Entity<ASSESSMENT_IRP_HEADER>(entity =>
            {
                entity.HasKey(e => new { e.ASSESSMENT_ID, e.IRP_HEADER_ID });

                entity.Property(e => e.COMMENT).IsUnicode(false);

                entity.HasOne(d => d.ASSESSMENT_)
                    .WithMany(p => p.ASSESSMENT_IRP_HEADER)
                    .HasForeignKey(d => d.ASSESSMENT_ID)
                    .HasConstraintName("FK__ASSESSMEN__ASSES__658C0CBD");

                entity.HasOne(d => d.IRP_HEADER_)
                    .WithMany(p => p.ASSESSMENT_IRP_HEADER)
                    .HasForeignKey(d => d.IRP_HEADER_ID)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__ASSESSMEN__IRP_H__668030F6");
            });

            modelBuilder.Entity<ASSESSMENT_ROLES>(entity =>
            {
                entity.HasKey(e => e.AssessmentRoleId)
                    .HasName("PK_ASSESSMENT_ROLES_1");

                entity.Property(e => e.AssessmentRole).IsUnicode(false);
            });

            modelBuilder.Entity<ASSESSMENT_SELECTED_LEVELS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Level_Name });

                entity.Property(e => e.Level_Name).IsUnicode(false);

                entity.Property(e => e.Standard_Specific_Sal_Level).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.ASSESSMENT_SELECTED_LEVELS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_ASSESSMENT_SELECTED_LEVELS_STANDARD_SELECTION");

                entity.HasOne(d => d.Level_NameNavigation)
                    .WithMany(p => p.ASSESSMENT_SELECTED_LEVELS)
                    .HasForeignKey(d => d.Level_Name)
                    .HasConstraintName("FK_ASSESSMENT_SELECTED_LEVELS_LEVEL_NAMES");
            });

            modelBuilder.Entity<AVAILABLE_STANDARDS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Set_Name });

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.AVAILABLE_STANDARDS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_AVAILABLE_STANDARDS_ASSESSMENTS");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.AVAILABLE_STANDARDS)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_AVAILABLE_STANDARDS_SETS");
            });

            modelBuilder.Entity<CATALOG_RECOMMENDATIONS_DATA>(entity =>
            {
                entity.HasKey(e => e.Data_Id)
                    .HasName("PK_Catalog_Recommendations_Data");

                entity.HasOne(d => d.Parent_Heading_)
                    .WithMany(p => p.CATALOG_RECOMMENDATIONS_DATA)
                    .HasForeignKey(d => d.Parent_Heading_Id)
                    .HasConstraintName("FK_CATALOG_RECOMMENDATIONS_DATA_CATALOG_RECOMMENDATIONS_HEADINGS");
            });

            modelBuilder.Entity<CATALOG_RECOMMENDATIONS_HEADINGS>(entity =>
            {
                entity.Property(e => e.Heading_Name).IsUnicode(false);
            });

            modelBuilder.Entity<CNSS_CIA_JUSTIFICATIONS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.CIA_Type });

                entity.Property(e => e.CIA_Type).IsUnicode(false);

                entity.Property(e => e.DropDownValueLevel).IsUnicode(false);

                entity.Property(e => e.Justification).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.CNSS_CIA_JUSTIFICATIONS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_CNSS_CIA_JUSTIFICATIONS_ASSESSMENTS");

                entity.HasOne(d => d.CIA_TypeNavigation)
                    .WithMany(p => p.CNSS_CIA_JUSTIFICATIONS)
                    .HasForeignKey(d => d.CIA_Type)
                    .HasConstraintName("FK_CNSS_CIA_JUSTIFICATIONS_CNSS_CIA_TYPES");
            });

            modelBuilder.Entity<CNSS_CIA_TYPES>(entity =>
            {
                entity.Property(e => e.CIA_Type)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<COMPONENT_FAMILY>(entity =>
            {
                entity.HasKey(e => e.Component_Family_Name)
                    .HasName("PK_ComponentFamily");

                entity.Property(e => e.Component_Family_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<COMPONENT_NAMES_LEGACY>(entity =>
            {
                entity.Property(e => e.Old_Symbol_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.HasOne(d => d.Component_Symbol_)
                    .WithMany(p => p.COMPONENT_NAMES_LEGACY)
                    .HasForeignKey(d => d.Component_Symbol_id)
                    .HasConstraintName("FK_COMPONENT_NAMES_LEGACY_COMPONENT_SYMBOLS");
            });

            modelBuilder.Entity<COMPONENT_QUESTIONS>(entity =>
            {
                entity.HasKey(e => new { e.Question_Id, e.Component_Symbol_Id });

                entity.Property(e => e.Seq).IsUnicode(false);

                entity.HasOne(d => d.Component_Symbol_)
                    .WithMany(p => p.COMPONENT_QUESTIONS)
                    .HasForeignKey(d => d.Component_Symbol_Id)
                    .HasConstraintName("FK_COMPONENT_QUESTIONS_COMPONENT_SYMBOLS");

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.COMPONENT_QUESTIONS)
                    .HasForeignKey(d => d.Question_Id)
                    .HasConstraintName("FK_Component_Questions_NEW_QUESTION");
            });

            modelBuilder.Entity<COMPONENT_SYMBOLS>(entity =>
            {
                entity.HasIndex(e => e.Abbreviation)
                    .HasName("IX_COMPONENT_SYMBOLS_1")
                    .IsUnique();

                entity.HasIndex(e => e.File_Name)
                    .HasName("IX_COMPONENT_SYMBOLS")
                    .IsUnique();

                entity.Property(e => e.Abbreviation).IsUnicode(false);

                entity.Property(e => e.Component_Family_Name).IsUnicode(false);

                entity.Property(e => e.File_Name).IsUnicode(false);

                entity.Property(e => e.Height).HasDefaultValueSql("((60))");

                entity.Property(e => e.Search_Tags).IsUnicode(false);

                entity.Property(e => e.Symbol_Name)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('')");

                entity.Property(e => e.Width).HasDefaultValueSql("((60))");

                entity.HasOne(d => d.Component_Family_NameNavigation)
                    .WithMany(p => p.COMPONENT_SYMBOLS)
                    .HasForeignKey(d => d.Component_Family_Name)
                    .HasConstraintName("FK_COMPONENT_SYMBOLS_COMPONENT_FAMILY");

                entity.HasOne(d => d.Symbol_Group_)
                    .WithMany(p => p.COMPONENT_SYMBOLS)
                    .HasForeignKey(d => d.Symbol_Group_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_COMPONENT_SYMBOLS_SYMBOL_GROUPS");
            });

            modelBuilder.Entity<COMPONENT_SYMBOLS_GM_TO_CSET>(entity =>
            {
                entity.Property(e => e.GM_FingerType)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<COUNTRIES>(entity =>
            {
                entity.HasIndex(e => e.ISO_code)
                    .HasName("IX_COUNTRIES")
                    .IsUnique();
            });

            modelBuilder.Entity<CSET_VERSION>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Build_Number).IsUnicode(false);

                entity.Property(e => e.Cset_Version1).IsUnicode(false);
            });

            modelBuilder.Entity<CUSTOM_BASE_STANDARDS>(entity =>
            {
                entity.HasKey(e => new { e.Custom_Questionaire_Name, e.Base_Standard })
                    .HasName("PK_CUSTOM_BASE_STANDARDS_1");

                entity.Property(e => e.Custom_Questionaire_Name).IsUnicode(false);

                entity.Property(e => e.Base_Standard).IsUnicode(false);

                entity.HasOne(d => d.Custom_Questionaire_NameNavigation)
                    .WithMany(p => p.CUSTOM_BASE_STANDARDS)
                    .HasForeignKey(d => d.Custom_Questionaire_Name)
                    .HasConstraintName("FK_CUSTOM_BASE_STANDARD_CUSTOM_QUESTIONAIRES");
            });

            modelBuilder.Entity<CUSTOM_QUESTIONAIRES>(entity =>
            {
                entity.Property(e => e.Custom_Questionaire_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Description).IsUnicode(false);

                entity.Property(e => e.Set_Name).IsUnicode(false);
            });

            modelBuilder.Entity<CUSTOM_QUESTIONAIRE_QUESTIONS>(entity =>
            {
                entity.HasKey(e => new { e.Custom_Questionaire_Name, e.Question_Id });

                entity.Property(e => e.Custom_Questionaire_Name).IsUnicode(false);

                entity.HasOne(d => d.Custom_Questionaire_NameNavigation)
                    .WithMany(p => p.CUSTOM_QUESTIONAIRE_QUESTIONS)
                    .HasForeignKey(d => d.Custom_Questionaire_Name)
                    .HasConstraintName("FK_CUSTON_QUESTIONAIRE_QUESTIONS_CUSTOM_QUESTIONAIRES");
            });

            modelBuilder.Entity<CUSTOM_STANDARD_BASE_STANDARD>(entity =>
            {
                entity.Property(e => e.Base_Standard).IsUnicode(false);

                entity.Property(e => e.Custom_Questionaire_Name).IsUnicode(false);

                entity.HasOne(d => d.Base_StandardNavigation)
                    .WithMany(p => p.CUSTOM_STANDARD_BASE_STANDARDBase_StandardNavigation)
                    .HasForeignKey(d => d.Base_Standard)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CUSTOM_STANDARD_BASE_STANDARD_SETS");

                entity.HasOne(d => d.Custom_Questionaire_NameNavigation)
                    .WithMany(p => p.CUSTOM_STANDARD_BASE_STANDARDCustom_Questionaire_NameNavigation)
                    .HasForeignKey(d => d.Custom_Questionaire_Name)
                    .HasConstraintName("FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1");
            });

            modelBuilder.Entity<DEMOGRAPHICS>(entity =>
            {
                entity.Property(e => e.Assessment_Id).ValueGeneratedNever();

                entity.Property(e => e.AssetValue).IsUnicode(false);

                entity.Property(e => e.Size).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithOne(p => p.DEMOGRAPHICS)
                    .HasForeignKey<DEMOGRAPHICS>(d => d.Assessment_Id)
                    .HasConstraintName("FK_DEMOGRAPHICS_ASSESSMENTS");

                entity.HasOne(d => d.AssetValueNavigation)
                    .WithMany(p => p.DEMOGRAPHICS)
                    .HasForeignKey(d => d.AssetValue)
                    .HasConstraintName("FK_DEMOGRAPHICS_DEMOGRAPHICS_ASSET_VALUES");

                entity.HasOne(d => d.Industry)
                    .WithMany(p => p.DEMOGRAPHICS)
                    .HasPrincipalKey(p => p.IndustryId)
                    .HasForeignKey(d => d.IndustryId)
                    .HasConstraintName("FK_DEMOGRAPHICS_SECTOR_INDUSTRY");

                entity.HasOne(d => d.Sector)
                    .WithMany(p => p.DEMOGRAPHICS)
                    .HasForeignKey(d => d.SectorId)
                    .HasConstraintName("FK_DEMOGRAPHICS_SECTOR");

                entity.HasOne(d => d.SizeNavigation)
                    .WithMany(p => p.DEMOGRAPHICS)
                    .HasForeignKey(d => d.Size)
                    .HasConstraintName("FK_DEMOGRAPHICS_DEMOGRAPHICS_SIZE");
            });

            modelBuilder.Entity<DEMOGRAPHICS_ASSET_VALUES>(entity =>
            {
                entity.Property(e => e.AssetValue)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.AppCode)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('CSET')");

                entity.Property(e => e.DemographicsAssetId).ValueGeneratedOnAdd();

                entity.HasOne(d => d.AppCodeNavigation)
                    .WithMany(p => p.DEMOGRAPHICS_ASSET_VALUES)
                    .HasForeignKey(d => d.AppCode)
                    .HasConstraintName("FK_DEMOGRAPHICS_ASSET_VALUES_APP_CODE");
            });

            modelBuilder.Entity<DEMOGRAPHICS_SIZE>(entity =>
            {
                entity.HasKey(e => e.Size)
                    .HasName("PK_DemographicsSize");

                entity.Property(e => e.Size)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.DemographicId).ValueGeneratedOnAdd();

                entity.Property(e => e.Description).IsUnicode(false);
            });

            modelBuilder.Entity<DIAGRAM_CONTAINER>(entity =>
            {
                entity.Property(e => e.ContainerType).IsUnicode(false);

                entity.Property(e => e.DrawIO_id).IsUnicode(false);

                entity.Property(e => e.Name).IsUnicode(false);

                entity.Property(e => e.Parent_Draw_IO_Id).IsUnicode(false);

                entity.Property(e => e.Universal_Sal_Level)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('L')");

                entity.Property(e => e.Visible).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.ContainerTypeNavigation)
                    .WithMany(p => p.DIAGRAM_CONTAINER)
                    .HasForeignKey(d => d.ContainerType)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER_TYPES");

                entity.HasOne(d => d.Parent_)
                    .WithMany(p => p.InverseParent_)
                    .HasForeignKey(d => d.Parent_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER");
            });

            modelBuilder.Entity<DIAGRAM_CONTAINER_TYPES>(entity =>
            {
                entity.Property(e => e.ContainerType)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<DIAGRAM_OBJECT_TYPES>(entity =>
            {
                entity.Property(e => e.Object_Type)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<DIAGRAM_TEMPLATES>(entity =>
            {
                entity.Property(e => e.Diagram_Markup).IsUnicode(false);

                entity.Property(e => e.Is_Read_Only).HasDefaultValueSql("((1))");

                entity.Property(e => e.Is_Visible).HasDefaultValueSql("((1))");
            });

            modelBuilder.Entity<DIAGRAM_TYPES>(entity =>
            {
                entity.Property(e => e.Specific_Type)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Diagram_Type_XML).IsUnicode(false);

                entity.Property(e => e.Object_Type).IsUnicode(false);

                entity.HasOne(d => d.Object_TypeNavigation)
                    .WithMany(p => p.DIAGRAM_TYPES)
                    .HasForeignKey(d => d.Object_Type)
                    .HasConstraintName("FK_DIAGRAM_TYPES_DIAGRAM_OBJECT_TYPES");
            });

            modelBuilder.Entity<DOCUMENT_ANSWERS>(entity =>
            {
                entity.HasKey(e => new { e.Document_Id, e.Answer_Id });

                entity.HasOne(d => d.Answer_)
                    .WithMany(p => p.DOCUMENT_ANSWERS)
                    .HasForeignKey(d => d.Answer_Id)
                    .HasConstraintName("FK_DOCUMENT_ANSWERS_ANSWER");

                entity.HasOne(d => d.Document_)
                    .WithMany(p => p.DOCUMENT_ANSWERS)
                    .HasForeignKey(d => d.Document_Id)
                    .HasConstraintName("FK_Document_Answers_DOCUMENT_FILE");
            });

            modelBuilder.Entity<DOCUMENT_FILE>(entity =>
            {
                entity.HasKey(e => e.Document_Id)
                    .HasName("PK__document_file__00000000000001C8");

                entity.Property(e => e.ContentType).IsUnicode(false);

                entity.Property(e => e.FileMd5).IsUnicode(false);

                entity.Property(e => e.Name).IsUnicode(false);

                entity.Property(e => e.Path).IsUnicode(false);

                entity.Property(e => e.Title).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.DOCUMENT_FILE)
                    .HasForeignKey(d => d.Assessment_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_DOCUMENT_FILE_ASSESSMENTS");

                entity.HasOne(d => d.Assessment_Navigation)
                    .WithMany(p => p.DOCUMENT_FILE)
                    .HasForeignKey(d => d.Assessment_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_DOCUMENT_FILE_DEMOGRAPHICS");
            });

            modelBuilder.Entity<EXTRA_ACET_MAPPING>(entity =>
            {
                entity.HasKey(e => new { e.Set_Name, e.Question_Id });

                entity.Property(e => e.Set_Name).IsUnicode(false);
            });

            modelBuilder.Entity<FILE_KEYWORDS>(entity =>
            {
                entity.HasKey(e => new { e.Gen_File_Id, e.Keyword })
                    .HasName("FILE_KEYWORDS_PK");

                entity.Property(e => e.Keyword).IsUnicode(false);

                entity.HasOne(d => d.Gen_File_)
                    .WithMany(p => p.FILE_KEYWORDS)
                    .HasForeignKey(d => d.Gen_File_Id)
                    .HasConstraintName("FILE_KEYWORDS_GEN_FILE_FK");
            });

            modelBuilder.Entity<FILE_REF_KEYS>(entity =>
            {
                entity.Property(e => e.Doc_Num)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<FILE_TYPE>(entity =>
            {
                entity.HasKey(e => e.File_Type_Id)
                    .HasName("SYS_C0014416");

                entity.Property(e => e.Description).IsUnicode(false);

                entity.Property(e => e.File_Type1).IsUnicode(false);

                entity.Property(e => e.Mime_Type).IsUnicode(false);
            });

            modelBuilder.Entity<FINANCIAL_ASSESSMENT_FACTORS>(entity =>
            {
                entity.HasIndex(e => e.AssessmentFactor)
                    .HasName("IX_FINANCIAL_ASSESSMENT_FACTORS")
                    .IsUnique();

                entity.Property(e => e.AssessmentFactorId).ValueGeneratedNever();

                entity.Property(e => e.Acronym).IsUnicode(false);
            });

            modelBuilder.Entity<FINANCIAL_ASSESSMENT_VALUES>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.AttributeName });

                entity.Property(e => e.AttributeName).IsUnicode(false);

                entity.Property(e => e.AttributeValue).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.FINANCIAL_ASSESSMENT_VALUES)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_FINANCIAL_ASSESSMENT_VALUES_ASSESSMENTS");

                entity.HasOne(d => d.AttributeNameNavigation)
                    .WithMany(p => p.FINANCIAL_ASSESSMENT_VALUES)
                    .HasForeignKey(d => d.AttributeName)
                    .HasConstraintName("FK_FINANCIAL_ASSESSMENT_VALUES_FINANCIAL_ATTRIBUTES");
            });

            modelBuilder.Entity<FINANCIAL_ATTRIBUTES>(entity =>
            {
                entity.Property(e => e.AttributeName)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<FINANCIAL_COMPONENTS>(entity =>
            {
                entity.HasIndex(e => e.FinComponent)
                    .HasName("IX_FINANCIAL_COMPONENTS")
                    .IsUnique();

                entity.Property(e => e.FinComponentId).ValueGeneratedNever();

                entity.Property(e => e.Acronym).IsUnicode(false);
            });

            modelBuilder.Entity<FINANCIAL_DETAILS>(entity =>
            {
                entity.HasKey(e => e.StmtNumber)
                    .HasName("PK_FINANCIAL_TIERS");

                entity.Property(e => e.StmtNumber).ValueGeneratedNever();

                entity.HasOne(d => d.FinancialGroup)
                    .WithMany(p => p.FINANCIAL_DETAILS)
                    .HasForeignKey(d => d.FinancialGroupId)
                    .HasConstraintName("FK_FINANCIAL_DETAILS_FINANCIAL_GROUPS");
            });

            modelBuilder.Entity<FINANCIAL_DOMAINS>(entity =>
            {
                entity.HasIndex(e => e.Domain)
                    .HasName("IX_FINANCIAL_DOMAINS")
                    .IsUnique();

                entity.Property(e => e.DomainId).ValueGeneratedNever();

                entity.Property(e => e.Acronym).IsUnicode(false);
            });

            modelBuilder.Entity<FINANCIAL_DOMAIN_FILTERS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.DomainId });

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.FINANCIAL_DOMAIN_FILTERS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_FINANCIAL_DOMAIN_FILTERS_ASSESSMENTS");

                entity.HasOne(d => d.Domain)
                    .WithMany(p => p.FINANCIAL_DOMAIN_FILTERS)
                    .HasForeignKey(d => d.DomainId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FINANCIAL_DOMAIN_FILTERS_FINANCIAL_DOMAINS");
            });

            modelBuilder.Entity<FINANCIAL_FFIEC_MAPPINGS>(entity =>
            {
                entity.HasKey(e => new { e.StmtNumber, e.FFIECBookletsMapping })
                    .HasName("PK_FINANCIAL_FFIEC_MAPPINGS_1");

                entity.HasOne(d => d.StmtNumberNavigation)
                    .WithMany(p => p.FINANCIAL_FFIEC_MAPPINGS)
                    .HasForeignKey(d => d.StmtNumber)
                    .HasConstraintName("FK_FINANCIAL_FFIEC_MAPPINGS_FINANCIAL_DETAILS");
            });

            modelBuilder.Entity<FINANCIAL_GROUPS>(entity =>
            {
                entity.HasIndex(e => new { e.DomainId, e.AssessmentFactorId, e.FinComponentId, e.MaturityId })
                    .HasName("IX_FINANCIAL_GROUPS")
                    .IsUnique();

                entity.HasOne(d => d.AssessmentFactor)
                    .WithMany(p => p.FINANCIAL_GROUPS)
                    .HasForeignKey(d => d.AssessmentFactorId)
                    .HasConstraintName("FK_FINANCIAL_GROUPS_FINANCIAL_ASSESSMENT_FACTORS");

                entity.HasOne(d => d.Domain)
                    .WithMany(p => p.FINANCIAL_GROUPS)
                    .HasForeignKey(d => d.DomainId)
                    .HasConstraintName("FK_FINANCIAL_GROUPS_FINANCIAL_DOMAINS");

                entity.HasOne(d => d.FinComponent)
                    .WithMany(p => p.FINANCIAL_GROUPS)
                    .HasForeignKey(d => d.FinComponentId)
                    .HasConstraintName("FK_FINANCIAL_GROUPS_FINANCIAL_COMPONENTS");

                entity.HasOne(d => d.Maturity)
                    .WithMany(p => p.FINANCIAL_GROUPS)
                    .HasForeignKey(d => d.MaturityId)
                    .HasConstraintName("FK_FINANCIAL_GROUPS_FINANCIAL_MATURITY");
            });

            modelBuilder.Entity<FINANCIAL_HOURS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Component, e.ReviewType })
                    .HasName("PK_FINANCIAL_ASSESSMENT_HOURS");

                entity.Property(e => e.Component).IsUnicode(false);

                entity.Property(e => e.ReviewType).IsUnicode(false);

                entity.Property(e => e.OtherSpecifyValue).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.FINANCIAL_HOURS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_FINANCIAL_HOURS_ASSESSMENTS");

                entity.HasOne(d => d.ComponentNavigation)
                    .WithMany(p => p.FINANCIAL_HOURS)
                    .HasForeignKey(d => d.Component)
                    .HasConstraintName("FK_FINANCIAL_HOURS_FINANCIAL_HOURS_COMPONENT");

                entity.HasOne(d => d.ReviewTypeNavigation)
                    .WithMany(p => p.FINANCIAL_HOURS)
                    .HasForeignKey(d => d.ReviewType)
                    .HasConstraintName("FK_FINANCIAL_HOURS_FINANCIAL_REVIEWTYPE");
            });

            modelBuilder.Entity<FINANCIAL_HOURS_COMPONENT>(entity =>
            {
                entity.Property(e => e.Component)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.HasOne(d => d.Domain)
                    .WithMany(p => p.FINANCIAL_HOURS_COMPONENT)
                    .HasForeignKey(d => d.DomainId)
                    .HasConstraintName("FK_FINANCIAL_HOURS_COMPONENT_FINANCIAL_DOMAINS");
            });

            modelBuilder.Entity<FINANCIAL_MATURITY>(entity =>
            {
                entity.HasIndex(e => e.MaturityLevel)
                    .HasName("IX_FINANCIAL_MATURITY")
                    .IsUnique();

                entity.Property(e => e.MaturityId).ValueGeneratedNever();

                entity.Property(e => e.Acronym).IsUnicode(false);
            });

            modelBuilder.Entity<FINANCIAL_QUESTIONS>(entity =>
            {
                entity.HasKey(e => new { e.StmtNumber, e.Question_Id })
                    .HasName("PK_FINANCIAL_QUESTIONS_1");

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.FINANCIAL_QUESTIONS)
                    .HasForeignKey(d => d.Question_Id)
                    .HasConstraintName("FK_FINANCIAL_QUESTIONS_NEW_QUESTION");

                entity.HasOne(d => d.StmtNumberNavigation)
                    .WithMany(p => p.FINANCIAL_QUESTIONS)
                    .HasForeignKey(d => d.StmtNumber)
                    .HasConstraintName("FK_FINANCIAL_QUESTIONS_FINANCIAL_DETAILS");
            });

            modelBuilder.Entity<FINANCIAL_REQUIREMENTS>(entity =>
            {
                entity.HasKey(e => new { e.StmtNumber, e.Requirement_Id });

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.FINANCIAL_REQUIREMENTS)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT");

                entity.HasOne(d => d.StmtNumberNavigation)
                    .WithMany(p => p.FINANCIAL_REQUIREMENTS)
                    .HasForeignKey(d => d.StmtNumber)
                    .HasConstraintName("FK_FINANCIAL_REQUIREMENTS_FINANCIAL_DETAILS");
            });

            modelBuilder.Entity<FINANCIAL_REVIEWTYPE>(entity =>
            {
                entity.Property(e => e.ReviewType)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<FINANCIAL_TIERS>(entity =>
            {
                entity.HasKey(e => new { e.StmtNumber, e.Label })
                    .HasName("PK_FINANCIAL_TIERS_1");

                entity.HasOne(d => d.StmtNumberNavigation)
                    .WithMany(p => p.FINANCIAL_TIERS)
                    .HasForeignKey(d => d.StmtNumber)
                    .HasConstraintName("FK_FINANCIAL_TIERS_FINANCIAL_DETAILS");
            });

            modelBuilder.Entity<FINDING>(entity =>
            {
                entity.Property(e => e.Impact).IsUnicode(false);

                entity.Property(e => e.Issue).IsUnicode(false);

                entity.Property(e => e.Recommendations).IsUnicode(false);

                entity.Property(e => e.Summary).IsUnicode(false);

                entity.Property(e => e.Vulnerabilities).IsUnicode(false);

                entity.HasOne(d => d.Answer_)
                    .WithMany(p => p.FINDING)
                    .HasForeignKey(d => d.Answer_Id)
                    .HasConstraintName("FK_FINDING_ANSWER");

                entity.HasOne(d => d.Importance_)
                    .WithMany(p => p.FINDING)
                    .HasForeignKey(d => d.Importance_Id)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("FK_FINDING_IMPORTANCE1");
            });

            modelBuilder.Entity<FINDING_CONTACT>(entity =>
            {
                entity.HasKey(e => new { e.Finding_Id, e.Assessment_Contact_Id })
                    .HasName("PK_FINDING_CONTACT_1");

                entity.HasOne(d => d.Assessment_Contact_)
                    .WithMany(p => p.FINDING_CONTACT)
                    .HasForeignKey(d => d.Assessment_Contact_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FINDING_CONTACT_ASSESSMENT_CONTACTS");

                entity.HasOne(d => d.Finding_)
                    .WithMany(p => p.FINDING_CONTACT)
                    .HasForeignKey(d => d.Finding_Id)
                    .HasConstraintName("FK_FINDING_INDIVIDUAL_FINDING1");
            });

            modelBuilder.Entity<FRAMEWORK_TIERS>(entity =>
            {
                entity.Property(e => e.Tier)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.FullName).IsUnicode(false);
            });

            modelBuilder.Entity<FRAMEWORK_TIER_DEFINITIONS>(entity =>
            {
                entity.HasKey(e => new { e.Tier, e.TierType });

                entity.Property(e => e.Tier).IsUnicode(false);

                entity.Property(e => e.TierType).IsUnicode(false);

                entity.Property(e => e.TierQuestion).IsUnicode(false);

                entity.HasOne(d => d.TierNavigation)
                    .WithMany(p => p.FRAMEWORK_TIER_DEFINITIONS)
                    .HasForeignKey(d => d.Tier)
                    .HasConstraintName("FK_FRAMEWORK_TIER_DEFINITIONS_FRAMEWORK_TIERS");
            });

            modelBuilder.Entity<FRAMEWORK_TIER_TYPE>(entity =>
            {
                entity.Property(e => e.TierType)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<FRAMEWORK_TIER_TYPE_ANSWER>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.TierType });

                entity.Property(e => e.TierType).IsUnicode(false);

                entity.Property(e => e.Tier).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.FRAMEWORK_TIER_TYPE_ANSWER)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_FRAMEWORK_TIER_TYPE_ANSWER_ASSESSMENTS");

                entity.HasOne(d => d.TierNavigation)
                    .WithMany(p => p.FRAMEWORK_TIER_TYPE_ANSWER)
                    .HasForeignKey(d => d.Tier)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIERS");

                entity.HasOne(d => d.TierTypeNavigation)
                    .WithMany(p => p.FRAMEWORK_TIER_TYPE_ANSWER)
                    .HasForeignKey(d => d.TierType)
                    .HasConstraintName("FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIER_TYPE");
            });

            modelBuilder.Entity<GENERAL_SAL>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Sal_Name })
                    .HasName("PK_GENERAL_SAL_1");

                entity.Property(e => e.Sal_Name).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.GENERAL_SAL)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_GENERAL_SAL_ASSESSMENTS");

                entity.HasOne(d => d.Sal_NameNavigation)
                    .WithMany(p => p.GENERAL_SAL)
                    .HasForeignKey(d => d.Sal_Name)
                    .HasConstraintName("FK_GENERAL_SAL_GEN_SAL_NAMES");
            });

            modelBuilder.Entity<GENERAL_SAL_DESCRIPTIONS>(entity =>
            {
                entity.Property(e => e.Sal_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Sal_Description).IsUnicode(false);

                entity.Property(e => e.postfix).IsUnicode(false);

                entity.Property(e => e.prefix).IsUnicode(false);
            });

            modelBuilder.Entity<GEN_FILE>(entity =>
            {
                entity.HasKey(e => e.Gen_File_Id)
                    .HasName("SYS_C0014438");

                entity.Property(e => e.Comments).IsUnicode(false);

                entity.Property(e => e.Description).IsUnicode(false);

                entity.Property(e => e.Doc_Num)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('NONE')");

                entity.Property(e => e.Doc_Version).IsUnicode(false);

                entity.Property(e => e.File_Name).IsUnicode(false);

                entity.Property(e => e.Is_Uploaded).HasDefaultValueSql("((1))");

                entity.Property(e => e.Name).IsUnicode(false);

                entity.Property(e => e.Short_Name).IsUnicode(false);

                entity.Property(e => e.Source_Type).IsUnicode(false);

                entity.Property(e => e.Summary).IsUnicode(false);

                entity.Property(e => e.Title).IsUnicode(false);

                entity.HasOne(d => d.Doc_NumNavigation)
                    .WithMany(p => p.GEN_FILE)
                    .HasForeignKey(d => d.Doc_Num)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GEN_FILE_FILE_REF_KEYS");

                entity.HasOne(d => d.File_Type_)
                    .WithMany(p => p.GEN_FILE)
                    .HasForeignKey(d => d.File_Type_Id)
                    .HasConstraintName("FK_GEN_FILE_FILE_TYPE");
            });

            modelBuilder.Entity<GEN_FILE_LIB_PATH_CORL>(entity =>
            {
                entity.HasKey(e => new { e.Gen_File_Id, e.Lib_Path_Id })
                    .HasName("TABLE3_PK");

                entity.HasOne(d => d.Gen_File_)
                    .WithMany(p => p.GEN_FILE_LIB_PATH_CORL)
                    .HasForeignKey(d => d.Gen_File_Id)
                    .HasConstraintName("FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE");

                entity.HasOne(d => d.Lib_Path_)
                    .WithMany(p => p.GEN_FILE_LIB_PATH_CORL)
                    .HasForeignKey(d => d.Lib_Path_Id)
                    .HasConstraintName("FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH");
            });

            modelBuilder.Entity<GEN_SAL_NAMES>(entity =>
            {
                entity.Property(e => e.Sal_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<GEN_SAL_WEIGHTS>(entity =>
            {
                entity.HasKey(e => new { e.Sal_Name, e.Slider_Value });

                entity.HasIndex(e => new { e.Sal_Name, e.Slider_Value })
                    .HasName("IX_GEN_SAL_WEIGHTS")
                    .IsUnique();

                entity.Property(e => e.Sal_Name).IsUnicode(false);

                entity.Property(e => e.Display).IsUnicode(false);

                entity.HasOne(d => d.Sal_NameNavigation)
                    .WithMany(p => p.GEN_SAL_WEIGHTS)
                    .HasForeignKey(d => d.Sal_Name)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GEN_SAL_WEIGHTS_GENERAL_SAL_DESCRIPTIONS");

                entity.HasOne(d => d.Sal_Name1)
                    .WithMany(p => p.GEN_SAL_WEIGHTS)
                    .HasForeignKey(d => d.Sal_Name)
                    .HasConstraintName("FK_GEN_SAL_WEIGHTS_GEN_SAL_NAMES");
            });

            modelBuilder.Entity<GLOBAL_PROPERTIES>(entity =>
            {
                entity.HasKey(e => e.Property)
                    .HasName("PK_GlobalProperties");

                entity.Property(e => e.Property)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Property_Value).IsUnicode(false);
            });

            modelBuilder.Entity<IMPORTANCE>(entity =>
            {
                entity.HasKey(e => e.Importance_Id)
                    .HasName("PK_IMPORTANCE_1");

                entity.Property(e => e.Value).IsUnicode(false);
            });

            modelBuilder.Entity<INFORMATION>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.IsAcetOnly).HasDefaultValueSql("((0))");

                entity.HasOne(d => d.IdNavigation)
                    .WithOne(p => p.INFORMATION)
                    .HasForeignKey<INFORMATION>(d => d.Id)
                    .HasConstraintName("FK_INFORMATION_ASSESSMENTS");

                entity.HasOne(d => d.eMass_Document_)
                    .WithMany(p => p.INFORMATION)
                    .HasForeignKey(d => d.eMass_Document_Id)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("FK_INFORMATION_DOCUMENT_FILE1");
            });

            modelBuilder.Entity<IRP>(entity =>
            {
                entity.Property(e => e.IRP_ID).ValueGeneratedNever();

                entity.Property(e => e.Description).IsUnicode(false);

                entity.Property(e => e.DescriptionComment).IsUnicode(false);

                entity.Property(e => e.Risk_1_Description).IsUnicode(false);

                entity.Property(e => e.Risk_2_Description).IsUnicode(false);

                entity.Property(e => e.Risk_3_Description).IsUnicode(false);

                entity.Property(e => e.Risk_4_Description).IsUnicode(false);

                entity.Property(e => e.Risk_5_Description).IsUnicode(false);

                entity.Property(e => e.Validation_Approach).IsUnicode(false);

                entity.HasOne(d => d.Header_)
                    .WithMany(p => p.IRP)
                    .HasForeignKey(d => d.Header_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_IRP_IRP_HEADER");
            });

            modelBuilder.Entity<IRP_HEADER>(entity =>
            {
                entity.Property(e => e.IRP_Header_Id).ValueGeneratedNever();

                entity.Property(e => e.Header).IsUnicode(false);
            });

            modelBuilder.Entity<LEVEL_NAMES>(entity =>
            {
                entity.HasKey(e => e.Level_Name)
                    .HasName("PK_Level_Names");

                entity.Property(e => e.Level_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<NAVIGATION_STATE>(entity =>
            {
                entity.Property(e => e.Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.IsAvailable).HasDefaultValueSql("((1))");
            });

            modelBuilder.Entity<NCSF_CATEGORY>(entity =>
            {
                entity.HasKey(e => e.NCSF_Cat_Id)
                    .HasName("PK_NCSF_Category");

                entity.HasIndex(e => new { e.NCSF_Function_Id, e.NCSF_Category_Id })
                    .HasName("IX_NCSF_Category")
                    .IsUnique();

                entity.Property(e => e.NCSF_Category_Description).IsUnicode(false);

                entity.Property(e => e.NCSF_Category_Id).IsUnicode(false);

                entity.Property(e => e.NCSF_Category_Name).IsUnicode(false);

                entity.Property(e => e.NCSF_Function_Id).IsUnicode(false);

                entity.Property(e => e.Question_Group_Heading_Id).HasDefaultValueSql("((50))");

                entity.HasOne(d => d.NCSF_Function_)
                    .WithMany(p => p.NCSF_CATEGORY)
                    .HasForeignKey(d => d.NCSF_Function_Id)
                    .HasConstraintName("FK_NCSF_Category_NCSF_FUNCTIONS");
            });

            modelBuilder.Entity<NCSF_FUNCTIONS>(entity =>
            {
                entity.Property(e => e.NCSF_Function_ID)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.NCSF_Function_Name).IsUnicode(false);
            });

            modelBuilder.Entity<NERC_RISK_RANKING>(entity =>
            {
                entity.Property(e => e.Compliance_Risk_Rank).ValueGeneratedNever();

                entity.Property(e => e.Violation_Risk_Factor).IsUnicode(false);

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.NERC_RISK_RANKING)
                    .HasForeignKey(d => d.Question_id)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_NERC_RISK_RANKING_NEW_QUESTION");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.NERC_RISK_RANKING)
                    .HasForeignKey(d => d.Requirement_Id)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_NERC_RISK_RANKING_NEW_REQUIREMENT");
            });

            modelBuilder.Entity<NETWORK_WARNINGS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Id })
                    .HasName("PK__network_warnings_001");

                entity.Property(e => e.WarningText).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.NETWORK_WARNINGS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_NETWORK_WARNING_ASSESSMENTS");
            });

            modelBuilder.Entity<NEW_QUESTION>(entity =>
            {
                entity.HasKey(e => e.Question_Id)
                    .HasName("PK_All_Question_TEMP");

                entity.HasIndex(e => e.Question_Hash)
                    .HasName("IX_NEW_QUESTION_1")
                    .IsUnique();

                entity.HasIndex(e => new { e.Std_Ref, e.Std_Ref_Number })
                    .HasName("IX_NEW_QUESTION")
                    .IsUnique();

                entity.Property(e => e.Original_Set_Name).IsUnicode(false);

                entity.Property(e => e.Question_Hash).HasComputedColumnSql("(CONVERT([varbinary](32),hashbytes('SHA1',left([Simple_Question],(8000))),(0)))");

                entity.Property(e => e.Simple_Question).IsUnicode(false);

                entity.Property(e => e.Std_Ref).IsUnicode(false);

                entity.Property(e => e.Std_Ref_Id)
                    .IsUnicode(false)
                    .HasComputedColumnSql("(case when [std_ref]=NULL then NULL else ([Std_Ref]+'.')+CONVERT([varchar](50),[Std_Ref_Number],(0)) end)");

                entity.Property(e => e.Universal_Sal_Level)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('none')");

                entity.HasOne(d => d.Heading_Pair_)
                    .WithMany(p => p.NEW_QUESTION)
                    .HasPrincipalKey(p => p.Heading_Pair_Id)
                    .HasForeignKey(d => d.Heading_Pair_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NEW_QUESTION_UNIVERSAL_SUB_CATEGORY_HEADINGS");

                entity.HasOne(d => d.Original_Set_NameNavigation)
                    .WithMany(p => p.NEW_QUESTION)
                    .HasForeignKey(d => d.Original_Set_Name)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NEW_QUESTION_SETS");

                entity.HasOne(d => d.Universal_Sal_LevelNavigation)
                    .WithMany(p => p.NEW_QUESTION)
                    .HasForeignKey(d => d.Universal_Sal_Level)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NEW_QUESTION_UNIVERSAL_SAL_LEVEL");
            });

            modelBuilder.Entity<NEW_QUESTION_LEVELS>(entity =>
            {
                entity.HasKey(e => new { e.Universal_Sal_Level, e.New_Question_Set_Id })
                    .HasName("PK_NEW_QUESTION_LEVELS_1");

                entity.Property(e => e.Universal_Sal_Level).IsUnicode(false);

                entity.HasOne(d => d.New_Question_Set_)
                    .WithMany(p => p.NEW_QUESTION_LEVELS)
                    .HasForeignKey(d => d.New_Question_Set_Id)
                    .HasConstraintName("FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS");

                entity.HasOne(d => d.Universal_Sal_LevelNavigation)
                    .WithMany(p => p.NEW_QUESTION_LEVELS)
                    .HasForeignKey(d => d.Universal_Sal_Level)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NEW_QUESTION_LEVELS_UNIVERSAL_SAL_LEVEL");
            });

            modelBuilder.Entity<NEW_QUESTION_SETS>(entity =>
            {
                entity.HasKey(e => e.New_Question_Set_Id)
                    .HasName("PK_NEW_QUESTION_SETS_1");

                entity.HasIndex(e => new { e.Question_Id, e.Set_Name })
                    .HasName("IX_NEW_QUESTION_SETS")
                    .IsUnique();

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.NEW_QUESTION_SETS)
                    .HasForeignKey(d => d.Question_Id)
                    .HasConstraintName("FK_NEW_QUESTION_SETS_NEW_QUESTION");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.NEW_QUESTION_SETS)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_NEW_QUESTION_SETS_SETS");
            });

            modelBuilder.Entity<NEW_REQUIREMENT>(entity =>
            {
                entity.Property(e => e.ExaminationApproach).IsUnicode(false);

                entity.Property(e => e.Implementation_Recommendations).IsUnicode(false);

                entity.Property(e => e.Original_Set_Name).IsUnicode(false);

                entity.Property(e => e.Requirement_Text).IsUnicode(false);

                entity.Property(e => e.Requirement_Title).IsUnicode(false);

                entity.Property(e => e.Standard_Category).IsUnicode(false);

                entity.Property(e => e.Standard_Sub_Category).IsUnicode(false);

                entity.Property(e => e.Supp_Hash).HasComputedColumnSql("(CONVERT([varbinary](32),hashbytes('SHA1',left([Supplemental_Info],(8000))),(0)))");

                entity.Property(e => e.Supplemental_Info).IsUnicode(false);

                entity.Property(e => e.Text_Hash).HasComputedColumnSql("(CONVERT([varbinary](20),hashbytes('SHA1',[Requirement_Text]),(0)))");

                entity.HasOne(d => d.NCSF_Cat_)
                    .WithMany(p => p.NEW_REQUIREMENT)
                    .HasForeignKey(d => d.NCSF_Cat_Id)
                    .HasConstraintName("FK_NEW_REQUIREMENT_NCSF_Category");

                entity.HasOne(d => d.Original_Set_NameNavigation)
                    .WithMany(p => p.NEW_REQUIREMENT)
                    .HasForeignKey(d => d.Original_Set_Name)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NEW_REQUIREMENT_SETS");

                entity.HasOne(d => d.Question_Group_Heading_)
                    .WithMany(p => p.NEW_REQUIREMENT)
                    .HasPrincipalKey(p => p.Question_Group_Heading_Id)
                    .HasForeignKey(d => d.Question_Group_Heading_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING");

                entity.HasOne(d => d.Standard_CategoryNavigation)
                    .WithMany(p => p.NEW_REQUIREMENT)
                    .HasForeignKey(d => d.Standard_Category)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_NEW_REQUIREMENT_STANDARD_CATEGORY");
            });

            modelBuilder.Entity<NIST_SAL_INFO_TYPES>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Type_Value })
                    .HasName("PK_NIST_SAL");

                entity.Property(e => e.Type_Value).IsUnicode(false);

                entity.Property(e => e.Area).IsUnicode(false);

                entity.Property(e => e.Availability_Special_Factor).IsUnicode(false);

                entity.Property(e => e.Availability_Value).IsUnicode(false);

                entity.Property(e => e.Confidentiality_Special_Factor).IsUnicode(false);

                entity.Property(e => e.Confidentiality_Value).IsUnicode(false);

                entity.Property(e => e.Integrity_Special_Factor).IsUnicode(false);

                entity.Property(e => e.Integrity_Value).IsUnicode(false);

                entity.Property(e => e.NIST_Number).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.NIST_SAL_INFO_TYPES)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_NIST_SAL_STANDARD_SELECTION");
            });

            modelBuilder.Entity<NIST_SAL_INFO_TYPES_DEFAULTS>(entity =>
            {
                entity.Property(e => e.Type_Value)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Area).IsUnicode(false);

                entity.Property(e => e.Availability_Special_Factor).IsUnicode(false);

                entity.Property(e => e.Availability_Value).IsUnicode(false);

                entity.Property(e => e.Confidentiality_Special_Factor).IsUnicode(false);

                entity.Property(e => e.Confidentiality_Value).IsUnicode(false);

                entity.Property(e => e.Integrity_Special_Factor).IsUnicode(false);

                entity.Property(e => e.Integrity_Value).IsUnicode(false);

                entity.Property(e => e.NIST_Number).IsUnicode(false);
            });

            modelBuilder.Entity<NIST_SAL_QUESTIONS>(entity =>
            {
                entity.HasKey(e => e.Question_Id)
                    .HasName("PK_NIST_SAL_QUESTIONS_1");

                entity.Property(e => e.Question_Id).ValueGeneratedNever();

                entity.Property(e => e.Question_Text).IsUnicode(false);
            });

            modelBuilder.Entity<NIST_SAL_QUESTION_ANSWERS>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Question_Id });

                entity.Property(e => e.Question_Answer)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('No')");

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.NIST_SAL_QUESTION_ANSWERS)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_NIST_SAL_QUESTION_ANSWERS_STANDARD_SELECTION");

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.NIST_SAL_QUESTION_ANSWERS)
                    .HasForeignKey(d => d.Question_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_NIST_SAL_QUESTION_ANSWERS_NIST_SAL_QUESTIONS");
            });

            modelBuilder.Entity<PARAMETERS>(entity =>
            {
                entity.HasKey(e => e.Parameter_ID)
                    .HasName("PK_Parameters");

                entity.HasIndex(e => e.Parameter_Name)
                    .HasName("IX_Parameters")
                    .IsUnique();

                entity.Property(e => e.Parameter_Name).IsUnicode(false);
            });

            modelBuilder.Entity<PARAMETER_ASSESSMENT>(entity =>
            {
                entity.HasKey(e => new { e.Parameter_ID, e.Assessment_ID })
                    .HasName("PK_ASSESSMENT_PARAMETERS");

                entity.Property(e => e.Parameter_Value_Assessment).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.PARAMETER_ASSESSMENT)
                    .HasForeignKey(d => d.Assessment_ID)
                    .HasConstraintName("FK_ASSESSMENT_PARAMETERS_ASSESSMENTS");

                entity.HasOne(d => d.Parameter_)
                    .WithMany(p => p.PARAMETER_ASSESSMENT)
                    .HasForeignKey(d => d.Parameter_ID)
                    .HasConstraintName("FK_ASSESSMENT_PARAMETERS_PARAMETERS");
            });

            modelBuilder.Entity<PARAMETER_REQUIREMENTS>(entity =>
            {
                entity.HasKey(e => new { e.Requirement_Id, e.Parameter_Id })
                    .HasName("PK_Parameter_Requirements");

                entity.HasOne(d => d.Parameter_)
                    .WithMany(p => p.PARAMETER_REQUIREMENTS)
                    .HasForeignKey(d => d.Parameter_Id)
                    .HasConstraintName("FK_Parameter_Requirements_Parameters");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.PARAMETER_REQUIREMENTS)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_Parameter_Requirements_NEW_REQUIREMENT");
            });

            modelBuilder.Entity<PARAMETER_VALUES>(entity =>
            {
                entity.HasKey(e => new { e.Answer_Id, e.Parameter_Id });

                entity.Property(e => e.Parameter_Value).IsUnicode(false);

                entity.HasOne(d => d.Answer_)
                    .WithMany(p => p.PARAMETER_VALUES)
                    .HasForeignKey(d => d.Answer_Id)
                    .HasConstraintName("FK_PARAMETER_VALUES_ANSWER");

                entity.HasOne(d => d.Parameter_)
                    .WithMany(p => p.PARAMETER_VALUES)
                    .HasForeignKey(d => d.Parameter_Id)
                    .HasConstraintName("FK_PARAMETER_VALUES_PARAMETERS");
            });

            modelBuilder.Entity<PROCUREMENT_DEPENDENCY>(entity =>
            {
                entity.HasKey(e => new { e.Procurement_Id, e.Dependencies_Id });

                entity.HasOne(d => d.Dependencies_)
                    .WithMany(p => p.PROCUREMENT_DEPENDENCYDependencies_)
                    .HasForeignKey(d => d.Dependencies_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PROCUREMENT_DEPENDENCY_PROCUREMENT_LANGUAGE_DATA1");

                entity.HasOne(d => d.Procurement_)
                    .WithMany(p => p.PROCUREMENT_DEPENDENCYProcurement_)
                    .HasForeignKey(d => d.Procurement_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PROCUREMENT_DEPENDENCY_PROCUREMENT_LANGUAGE_DATA");
            });

            modelBuilder.Entity<PROCUREMENT_LANGUAGE_DATA>(entity =>
            {
                entity.HasKey(e => e.Procurement_Id)
                    .HasName("PK_Procurement_Language_Data");

                entity.Property(e => e.Section_Number).IsUnicode(false);

                entity.HasOne(d => d.Parent_Heading_)
                    .WithMany(p => p.PROCUREMENT_LANGUAGE_DATA)
                    .HasForeignKey(d => d.Parent_Heading_Id)
                    .HasConstraintName("FK_PROCUREMENT_LANGUAGE_DATA_PROCUREMENT_LANGUAGE_HEADINGS");
            });

            modelBuilder.Entity<PROCUREMENT_LANGUAGE_HEADINGS>(entity =>
            {
                entity.Property(e => e.Heading_Name).IsUnicode(false);
            });

            modelBuilder.Entity<PROCUREMENT_REFERENCES>(entity =>
            {
                entity.HasKey(e => new { e.Procurement_Id, e.Reference_Id })
                    .HasName("PK_Procurement_References");

                entity.HasOne(d => d.Procurement_)
                    .WithMany(p => p.PROCUREMENT_REFERENCES)
                    .HasForeignKey(d => d.Procurement_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Procurement_References_Procurement_Language_Data");

                entity.HasOne(d => d.Reference_)
                    .WithMany(p => p.PROCUREMENT_REFERENCES)
                    .HasForeignKey(d => d.Reference_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Procurement_References_References_Data");
            });

            modelBuilder.Entity<QUESTION_GROUP_HEADING>(entity =>
            {
                entity.HasIndex(e => e.Question_Group_Heading1)
                    .HasName("IX_Question_Group_Heading")
                    .IsUnique();

                entity.HasIndex(e => e.Question_Group_Heading_Id)
                    .HasName("IX_QUESTION_GROUP_HEADING_1")
                    .IsUnique();

                entity.Property(e => e.Question_Group_Heading1).ValueGeneratedNever();

                entity.Property(e => e.Question_Group_Heading_Id).ValueGeneratedOnAdd();

                entity.Property(e => e.Std_Ref).IsUnicode(false);
            });

            modelBuilder.Entity<QUESTION_GROUP_TYPE>(entity =>
            {
                entity.HasKey(e => e.Question_Group_Id)
                    .HasName("PK_Question_Group_Type");

                entity.HasIndex(e => e.Group_Name)
                    .HasName("IX_QUESTION_GROUP_TYPE")
                    .IsUnique();

                entity.Property(e => e.Group_Header).IsUnicode(false);

                entity.Property(e => e.Group_Name).IsUnicode(false);

                entity.Property(e => e.Scoring_Group).IsUnicode(false);

                entity.Property(e => e.Scoring_Type).IsUnicode(false);
            });

            modelBuilder.Entity<RECENT_FILES>(entity =>
            {
                entity.HasKey(e => e.RecentFileId)
                    .HasName("PK_RECENT_FILES_1");

                entity.Property(e => e.AssessmentName).IsUnicode(false);

                entity.Property(e => e.FilePath).IsUnicode(false);

                entity.Property(e => e.Filename).IsUnicode(false);
            });

            modelBuilder.Entity<RECOMMENDATIONS_REFERENCES>(entity =>
            {
                entity.HasKey(e => new { e.Data_Id, e.Reference_Id })
                    .HasName("PK_Recommendations_References");

                entity.HasOne(d => d.Data_)
                    .WithMany(p => p.RECOMMENDATIONS_REFERENCES)
                    .HasForeignKey(d => d.Data_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Recommendations_References_Catalog_Recommendations_Data");

                entity.HasOne(d => d.Reference_)
                    .WithMany(p => p.RECOMMENDATIONS_REFERENCES)
                    .HasForeignKey(d => d.Reference_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Recommendations_References_References_Data");
            });

            modelBuilder.Entity<REFERENCES_DATA>(entity =>
            {
                entity.HasKey(e => e.Reference_Id)
                    .HasName("PK_References_Data");

                entity.HasOne(d => d.Reference_Doc_)
                    .WithMany(p => p.REFERENCES_DATA)
                    .HasForeignKey(d => d.Reference_Doc_Id)
                    .HasConstraintName("FK_References_Data_Reference_Docs");
            });

            modelBuilder.Entity<REFERENCE_DOCS>(entity =>
            {
                entity.HasKey(e => e.Reference_Doc_Id)
                    .HasName("PK_Reference_Docs");

                entity.Property(e => e.Doc_Short).IsUnicode(false);
            });

            modelBuilder.Entity<REF_LIBRARY_PATH>(entity =>
            {
                entity.HasKey(e => e.Lib_Path_Id)
                    .HasName("REF_LIBRARY_PATH_PK");

                entity.Property(e => e.Path_Name).IsUnicode(false);

                entity.HasOne(d => d.Parent_Path_)
                    .WithMany(p => p.InverseParent_Path_)
                    .HasForeignKey(d => d.Parent_Path_Id)
                    .HasConstraintName("FK_REF_LIBRARY_PATH_REF_LIBRARY_PATH");
            });

            modelBuilder.Entity<REPORT_DETAIL_SECTIONS>(entity =>
            {
                entity.Property(e => e.Report_Section_Id).ValueGeneratedNever();

                entity.Property(e => e.Display_Name).IsUnicode(false);

                entity.Property(e => e.Tool_Tip).IsUnicode(false);
            });

            modelBuilder.Entity<REPORT_DETAIL_SECTION_SELECTION>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Report_Section_Id });

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.REPORT_DETAIL_SECTION_SELECTION)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_REPORT_DETAIL_SECTION_SELECTION_ASSESSMENTS");

                entity.HasOne(d => d.Report_Section_)
                    .WithMany(p => p.REPORT_DETAIL_SECTION_SELECTION)
                    .HasForeignKey(d => d.Report_Section_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_REPORT_DETAIL_SECTION_SELECTION_REPORT_DETAIL_SECTIONS");
            });

            modelBuilder.Entity<REPORT_OPTIONS>(entity =>
            {
                entity.Property(e => e.Report_Option_Id).ValueGeneratedNever();

                entity.Property(e => e.Display_Name).IsUnicode(false);
            });

            modelBuilder.Entity<REPORT_OPTIONS_SELECTION>(entity =>
            {
                entity.HasKey(e => new { e.Assessment_Id, e.Report_Option_Id });

                entity.HasOne(d => d.Assessment_)
                    .WithMany(p => p.REPORT_OPTIONS_SELECTION)
                    .HasForeignKey(d => d.Assessment_Id)
                    .HasConstraintName("FK_REPORT_OPTIONS_SELECTION_ASSESSMENTS");

                entity.HasOne(d => d.Report_Option_)
                    .WithMany(p => p.REPORT_OPTIONS_SELECTION)
                    .HasForeignKey(d => d.Report_Option_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_REPORT_OPTIONS_SELECTION_REPORT_OPTIONS");
            });

            modelBuilder.Entity<REPORT_STANDARDS_SELECTION>(entity =>
            {
                entity.HasKey(e => new { e.Assesment_Id, e.Report_Set_Entity_Name });

                entity.Property(e => e.Report_Set_Entity_Name).IsUnicode(false);

                entity.HasOne(d => d.Assesment_)
                    .WithMany(p => p.REPORT_STANDARDS_SELECTION)
                    .HasForeignKey(d => d.Assesment_Id)
                    .HasConstraintName("FK_REPORT_STANDARDS_SELECTION_ASSESSMENTS");

                entity.HasOne(d => d.Report_Set_Entity_NameNavigation)
                    .WithMany(p => p.REPORT_STANDARDS_SELECTION)
                    .HasForeignKey(d => d.Report_Set_Entity_Name)
                    .HasConstraintName("FK_REPORT_STANDARDS_SELECTION_SETS");
            });

            modelBuilder.Entity<REQUIRED_DOCUMENTATION>(entity =>
            {
                entity.Property(e => e.Document_Description).IsUnicode(false);

                entity.Property(e => e.Number).IsUnicode(false);

                entity.HasOne(d => d.RDH_)
                    .WithMany(p => p.REQUIRED_DOCUMENTATION)
                    .HasForeignKey(d => d.RDH_Id)
                    .HasConstraintName("FK_REQUIRED_DOCUMENTATION_REQUIRED_DOCUMENTATION_HEADERS");
            });

            modelBuilder.Entity<REQUIRED_DOCUMENTATION_HEADERS>(entity =>
            {
                entity.HasIndex(e => e.Requirement_Documentation_Header)
                    .HasName("IX_REQUIRED_DOCUMENTATION_HEADERS")
                    .IsUnique();

                entity.Property(e => e.Requirement_Documentation_Header).IsUnicode(false);
            });

            modelBuilder.Entity<REQUIREMENT_LEVELS>(entity =>
            {
                entity.HasKey(e => new { e.Requirement_Id, e.Standard_Level, e.Level_Type });

                entity.Property(e => e.Standard_Level).IsUnicode(false);

                entity.Property(e => e.Level_Type).IsUnicode(false);

                entity.HasOne(d => d.Level_TypeNavigation)
                    .WithMany(p => p.REQUIREMENT_LEVELS)
                    .HasForeignKey(d => d.Level_Type)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.REQUIREMENT_LEVELS)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT");

                entity.HasOne(d => d.Standard_LevelNavigation)
                    .WithMany(p => p.REQUIREMENT_LEVELS)
                    .HasForeignKey(d => d.Standard_Level)
                    .HasConstraintName("FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL");
            });

            modelBuilder.Entity<REQUIREMENT_LEVEL_TYPE>(entity =>
            {
                entity.Property(e => e.Level_Type)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Level_Type_Full_Name).IsUnicode(false);
            });

            modelBuilder.Entity<REQUIREMENT_QUESTIONS>(entity =>
            {
                entity.HasKey(e => new { e.Question_Id, e.Requirement_Id })
                    .HasName("PK_REQUIREMENT_QUESTIONS_1");

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.REQUIREMENT_QUESTIONS)
                    .HasForeignKey(d => d.Question_Id)
                    .HasConstraintName("FK_REQUIREMENT_QUESTIONS_NEW_QUESTION1");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.REQUIREMENT_QUESTIONS)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT");
            });

            modelBuilder.Entity<REQUIREMENT_QUESTIONS_SETS>(entity =>
            {
                entity.HasKey(e => new { e.Question_Id, e.Set_Name })
                    .HasName("PK_REQUIREMENT_QUESTIONS_SETS_1");

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Question_)
                    .WithMany(p => p.REQUIREMENT_QUESTIONS_SETS)
                    .HasForeignKey(d => d.Question_Id)
                    .HasConstraintName("FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.REQUIREMENT_QUESTIONS_SETS)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.REQUIREMENT_QUESTIONS_SETS)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_REQUIREMENT_QUESTIONS_SETS_SETS");
            });

            modelBuilder.Entity<REQUIREMENT_REFERENCES>(entity =>
            {
                entity.HasKey(e => new { e.Requirement_Id, e.Gen_File_Id, e.Section_Ref });

                entity.Property(e => e.Section_Ref).IsUnicode(false);

                entity.Property(e => e.Destination_String).IsUnicode(false);

                entity.HasOne(d => d.Gen_File_)
                    .WithMany(p => p.REQUIREMENT_REFERENCES)
                    .HasForeignKey(d => d.Gen_File_Id)
                    .HasConstraintName("FK_REQUIREMENT_REFERENCES_GEN_FILE");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.REQUIREMENT_REFERENCES)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT");
            });

            modelBuilder.Entity<REQUIREMENT_SETS>(entity =>
            {
                entity.HasKey(e => new { e.Requirement_Id, e.Set_Name })
                    .HasName("PK_QUESTION_SETS");

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.REQUIREMENT_SETS)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_REQUIREMENT_SETS_NEW_REQUIREMENT");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.REQUIREMENT_SETS)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_QUESTION_SETS_SETS");
            });

            modelBuilder.Entity<REQUIREMENT_SOURCE_FILES>(entity =>
            {
                entity.HasKey(e => new { e.Requirement_Id, e.Gen_File_Id, e.Section_Ref });

                entity.Property(e => e.Section_Ref).IsUnicode(false);

                entity.Property(e => e.Destination_String).IsUnicode(false);

                entity.HasOne(d => d.Gen_File_)
                    .WithMany(p => p.REQUIREMENT_SOURCE_FILES)
                    .HasForeignKey(d => d.Gen_File_Id)
                    .HasConstraintName("FK_REQUIREMENT_SOURCE_FILES_GEN_FILE");

                entity.HasOne(d => d.Requirement_)
                    .WithMany(p => p.REQUIREMENT_SOURCE_FILES)
                    .HasForeignKey(d => d.Requirement_Id)
                    .HasConstraintName("FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT");
            });

            modelBuilder.Entity<SAL_DETERMINATION_TYPES>(entity =>
            {
                entity.HasKey(e => e.Sal_Determination_Type)
                    .HasName("PK_SAL_DETERMINATION_TYPES_1");

                entity.Property(e => e.Sal_Determination_Type)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<SECTOR>(entity =>
            {
                entity.HasIndex(e => e.SectorName)
                    .HasName("IX_SECTOR")
                    .IsUnique();

                entity.Property(e => e.SectorName).IsUnicode(false);
            });

            modelBuilder.Entity<SECTOR_INDUSTRY>(entity =>
            {
                entity.HasKey(e => new { e.SectorId, e.IndustryId });

                entity.HasIndex(e => e.IndustryId)
                    .HasName("IX_SECTOR_INDUSTRY")
                    .IsUnique();

                entity.Property(e => e.IndustryName).IsUnicode(false);

                entity.HasOne(d => d.Sector)
                    .WithMany(p => p.SECTOR_INDUSTRY)
                    .HasForeignKey(d => d.SectorId)
                    .HasConstraintName("FK_SECTOR_INDUSTRY_SECTOR");
            });

            modelBuilder.Entity<SECTOR_STANDARD_RECOMMENDATIONS>(entity =>
            {
                entity.HasKey(e => new { e.Sector_Id, e.Industry_Id, e.Organization_Size, e.Asset_Value, e.Set_Name });

                entity.Property(e => e.Organization_Size).IsUnicode(false);

                entity.Property(e => e.Asset_Value).IsUnicode(false);

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Sector_)
                    .WithMany(p => p.SECTOR_STANDARD_RECOMMENDATIONS)
                    .HasForeignKey(d => d.Sector_Id)
                    .HasConstraintName("FK_SECTOR_STANDARD_RECOMMENDATIONS_SECTOR");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.SECTOR_STANDARD_RECOMMENDATIONS)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS");
            });

            modelBuilder.Entity<SECURITY_QUESTION>(entity =>
            {
                entity.Property(e => e.IsCustomQuestion).HasDefaultValueSql("((1))");

                entity.Property(e => e.SecurityQuestion).IsUnicode(false);
            });

            modelBuilder.Entity<SETS>(entity =>
            {
                entity.Property(e => e.Set_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Full_Name).IsUnicode(false);

                entity.Property(e => e.IsEncryptedModuleOpen).HasDefaultValueSql("((1))");

                entity.Property(e => e.Is_Displayed).HasDefaultValueSql("((1))");

                entity.Property(e => e.Old_Std_Name).IsUnicode(false);

                entity.Property(e => e.Short_Name)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('NO SHORT NAME')");

                entity.Property(e => e.Standard_ToolTip).IsUnicode(false);

                entity.Property(e => e.Upgrade_Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Set_Category_)
                    .WithMany(p => p.SETS)
                    .HasForeignKey(d => d.Set_Category_Id)
                    .HasConstraintName("FK_SETS_Sets_Category");
            });

            modelBuilder.Entity<SETS_CATEGORY>(entity =>
            {
                entity.HasKey(e => e.Set_Category_Id)
                    .HasName("PK_Sets_Category");

                entity.Property(e => e.Set_Category_Id).ValueGeneratedNever();

                entity.Property(e => e.Set_Category_Name).IsUnicode(false);
            });

            modelBuilder.Entity<SET_FILES>(entity =>
            {
                entity.HasKey(e => new { e.SetName, e.Gen_File_Id });

                entity.Property(e => e.SetName).IsUnicode(false);

                entity.Property(e => e.Comment).IsUnicode(false);

                entity.HasOne(d => d.Gen_File_)
                    .WithMany(p => p.SET_FILES)
                    .HasForeignKey(d => d.Gen_File_Id)
                    .HasConstraintName("FK_SET_FILES_GEN_FILE");

                entity.HasOne(d => d.SetNameNavigation)
                    .WithMany(p => p.SET_FILES)
                    .HasForeignKey(d => d.SetName)
                    .HasConstraintName("FK_SET_FILES_SETS");
            });

            modelBuilder.Entity<SHAPE_TYPES>(entity =>
            {
                entity.HasKey(e => e.Diagram_Type_XML)
                    .HasName("PK_Shape_Types");

                entity.Property(e => e.Diagram_Type_XML)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.DisplayName).IsUnicode(false);

                entity.Property(e => e.Telerik_Shape_Type).IsUnicode(false);

                entity.Property(e => e.Visio_Shape_Type).IsUnicode(false);
            });

            modelBuilder.Entity<SP80053_FAMILY_ABBREVIATIONS>(entity =>
            {
                entity.Property(e => e.ID)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<STANDARD_CATEGORY>(entity =>
            {
                entity.Property(e => e.Standard_Category1)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });

            modelBuilder.Entity<STANDARD_CATEGORY_SEQUENCE>(entity =>
            {
                entity.HasKey(e => new { e.Standard_Category, e.Set_Name });

                entity.Property(e => e.Standard_Category).IsUnicode(false);

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.STANDARD_CATEGORY_SEQUENCE)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_STANDARD_CATEGORY_SEQUENCE_SETS");

                entity.HasOne(d => d.Standard_CategoryNavigation)
                    .WithMany(p => p.STANDARD_CATEGORY_SEQUENCE)
                    .HasForeignKey(d => d.Standard_Category)
                    .HasConstraintName("FK_STANDARD_CATEGORY_SEQUENCE_STANDARD_CATEGORY");
            });

            modelBuilder.Entity<STANDARD_SELECTION>(entity =>
            {
                entity.Property(e => e.Assessment_Id).ValueGeneratedNever();

                entity.Property(e => e.Application_Mode)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Questions Based')");

                entity.Property(e => e.Last_Sal_Determination_Type).IsUnicode(false);

                entity.Property(e => e.Selected_Sal_Level)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Low')");

                entity.Property(e => e.Sort_Set_Name).IsUnicode(false);

                entity.HasOne(d => d.Assessment_)
                    .WithOne(p => p.STANDARD_SELECTION)
                    .HasForeignKey<STANDARD_SELECTION>(d => d.Assessment_Id)
                    .HasConstraintName("FK_STANDARD_SELECTION_ASSESSMENTS");

                entity.HasOne(d => d.Last_Sal_Determination_TypeNavigation)
                    .WithMany(p => p.STANDARD_SELECTION)
                    .HasForeignKey(d => d.Last_Sal_Determination_Type)
                    .HasConstraintName("FK_STANDARD_SELECTION_SAL_DETERMINATION_TYPES");

                entity.HasOne(d => d.Selected_Sal_LevelNavigation)
                    .WithMany(p => p.STANDARD_SELECTION)
                    .HasPrincipalKey(p => p.Full_Name_Sal)
                    .HasForeignKey(d => d.Selected_Sal_Level)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_STANDARD_SELECTION_UNIVERSAL_SAL_LEVEL");
            });

            modelBuilder.Entity<STANDARD_SOURCE_FILE>(entity =>
            {
                entity.HasKey(e => new { e.Set_Name, e.Doc_Num })
                    .HasName("PK_Standard_Source_File");

                entity.Property(e => e.Set_Name).IsUnicode(false);

                entity.Property(e => e.Doc_Num).IsUnicode(false);

                entity.HasOne(d => d.Doc_NumNavigation)
                    .WithMany(p => p.STANDARD_SOURCE_FILE)
                    .HasForeignKey(d => d.Doc_Num)
                    .HasConstraintName("FK_Standard_Source_File_FILE_REF_KEYS");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.STANDARD_SOURCE_FILE)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_Standard_Source_File_SETS");
            });

            modelBuilder.Entity<STANDARD_SPECIFIC_LEVEL>(entity =>
            {
                entity.Property(e => e.Standard_Level)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Display_Name)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('No Display Name')");

                entity.Property(e => e.Full_Name).IsUnicode(false);

                entity.Property(e => e.Standard)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('No Standard')");
            });

            modelBuilder.Entity<STANDARD_TO_UNIVERSAL_MAP>(entity =>
            {
                entity.HasKey(e => new { e.Universal_Sal_Level, e.Standard_Level });

                entity.Property(e => e.Universal_Sal_Level).IsUnicode(false);

                entity.Property(e => e.Standard_Level).IsUnicode(false);

                entity.HasOne(d => d.Standard_LevelNavigation)
                    .WithMany(p => p.STANDARD_TO_UNIVERSAL_MAP)
                    .HasForeignKey(d => d.Standard_Level)
                    .HasConstraintName("FK_STANDARD_TO_UNIVERSAL_MAP_STANDARD_SPECIFIC_LEVEL");

                entity.HasOne(d => d.Universal_Sal_LevelNavigation)
                    .WithMany(p => p.STANDARD_TO_UNIVERSAL_MAP)
                    .HasForeignKey(d => d.Universal_Sal_Level)
                    .HasConstraintName("FK_STANDARD_TO_UNIVERSAL_MAP_UNIVERSAL_SAL_LEVEL");
            });

            modelBuilder.Entity<STATES_AND_PROVINCES>(entity =>
            {
                entity.HasOne(d => d.Country_CodeNavigation)
                    .WithMany(p => p.STATES_AND_PROVINCES)
                    .HasPrincipalKey(p => p.ISO_code)
                    .HasForeignKey(d => d.Country_Code)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_STATES_AND_PROVINCES_COUNTRIES");
            });

            modelBuilder.Entity<SUB_CATEGORY_ANSWERS>(entity =>
            {
                entity.HasKey(e => new { e.Assessement_Id, e.Heading_Pair_Id, e.Component_Guid, e.Is_Component });

                entity.Property(e => e.Component_Guid)
                    .IsUnicode(false)
                    .HasDefaultValueSql("((0))");

                entity.Property(e => e.Answer_Text).IsUnicode(false);

                entity.HasOne(d => d.Answer_TextNavigation)
                    .WithMany(p => p.SUB_CATEGORY_ANSWERS)
                    .HasForeignKey(d => d.Answer_Text)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_SUB_CATEGORY_ANSWERS_Answer_Lookup");

                entity.HasOne(d => d.Assessement_)
                    .WithMany(p => p.SUB_CATEGORY_ANSWERS)
                    .HasForeignKey(d => d.Assessement_Id)
                    .HasConstraintName("FK_SUB_CATEGORY_ANSWERS_ASSESSMENTS");

                entity.HasOne(d => d.Heading_Pair_)
                    .WithMany(p => p.SUB_CATEGORY_ANSWERS)
                    .HasPrincipalKey(p => p.Heading_Pair_Id)
                    .HasForeignKey(d => d.Heading_Pair_Id)
                    .HasConstraintName("FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS");
            });

            modelBuilder.Entity<SYMBOL_GROUPS>(entity =>
            {
                entity.Property(e => e.Symbol_Group_Name).IsUnicode(false);

                entity.Property(e => e.Symbol_Group_Title).IsUnicode(false);
            });

            modelBuilder.Entity<UNIVERSAL_AREA>(entity =>
            {
                entity.HasKey(e => e.Universal_Area_Name)
                    .HasName("UNIVERSAL_AREA_PK");

                entity.Property(e => e.Universal_Area_Name)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Comments).IsUnicode(false);

                entity.Property(e => e.Universal_Area_Number).ValueGeneratedOnAdd();
            });

            modelBuilder.Entity<UNIVERSAL_SAL_LEVEL>(entity =>
            {
                entity.HasIndex(e => e.Full_Name_Sal)
                    .HasName("IX_UNIVERSAL_SAL_LEVEL")
                    .IsUnique();

                entity.Property(e => e.Universal_Sal_Level1)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Full_Name_Sal).IsUnicode(false);
            });

            modelBuilder.Entity<UNIVERSAL_SUB_CATEGORIES>(entity =>
            {
                entity.HasIndex(e => e.Universal_Sub_Category_Id)
                    .HasName("IX_UNIVERSAL_SUB_CATEGORIES")
                    .IsUnique();

                entity.Property(e => e.Universal_Sub_Category)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.Universal_Sub_Category_Id).ValueGeneratedOnAdd();
            });

            modelBuilder.Entity<UNIVERSAL_SUB_CATEGORY_HEADINGS>(entity =>
            {
                entity.HasKey(e => new { e.Question_Group_Heading_Id, e.Universal_Sub_Category_Id, e.Set_Name })
                    .HasName("PK_UNIVERSAL_SUB_CATEGORY_HEADINGS_1");

                entity.HasIndex(e => e.Heading_Pair_Id)
                    .HasName("IX_UNIVERSAL_SUB_CATEGORY_HEADINGS")
                    .IsUnique();

                entity.Property(e => e.Set_Name)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('Standards')");

                entity.Property(e => e.Display_Radio_Buttons).HasComputedColumnSql("(CONVERT([bit],case when [sub_heading_question_description] IS NULL OR len(rtrim(ltrim([sub_heading_question_description])))=(0) OR charindex('?',[sub_heading_question_description])=(0) then (0) else (1) end,(0)))");

                entity.Property(e => e.Heading_Pair_Id).ValueGeneratedOnAdd();

                entity.HasOne(d => d.Question_Group_Heading_)
                    .WithMany(p => p.UNIVERSAL_SUB_CATEGORY_HEADINGS)
                    .HasPrincipalKey(p => p.Question_Group_Heading_Id)
                    .HasForeignKey(d => d.Question_Group_Heading_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_QUESTION_GROUP_HEADING");

                entity.HasOne(d => d.Set_NameNavigation)
                    .WithMany(p => p.UNIVERSAL_SUB_CATEGORY_HEADINGS)
                    .HasForeignKey(d => d.Set_Name)
                    .HasConstraintName("FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS");

                entity.HasOne(d => d.Universal_Sub_Category_)
                    .WithMany(p => p.UNIVERSAL_SUB_CATEGORY_HEADINGS)
                    .HasPrincipalKey(p => p.Universal_Sub_Category_Id)
                    .HasForeignKey(d => d.Universal_Sub_Category_Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_UNIVERSAL_SUB_CATEGORIES");
            });

            modelBuilder.Entity<USERS>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PK_USERS_1");

                entity.HasIndex(e => e.PrimaryEmail)
                    .HasName("IX_USERS")
                    .IsUnique();

                entity.Property(e => e.FirstName).IsUnicode(false);

                entity.Property(e => e.LastName).IsUnicode(false);

                entity.Property(e => e.Password).IsUnicode(false);

                entity.Property(e => e.PasswordResetRequired).HasDefaultValueSql("((1))");

                entity.Property(e => e.PrimaryEmail).IsUnicode(false);

                entity.Property(e => e.Salt).IsUnicode(false);
            });

            modelBuilder.Entity<USER_DETAIL_INFORMATION>(entity =>
            {
                entity.HasIndex(e => e.Id)
                    .HasName("IX_USER_DETAIL_INFORMATION")
                    .IsUnique();

                entity.Property(e => e.Id).HasDefaultValueSql("(newid())");

                entity.Property(e => e.CellPhone).IsUnicode(false);

                entity.Property(e => e.FirstName).IsUnicode(false);

                entity.Property(e => e.HomePhone).IsUnicode(false);

                entity.Property(e => e.ImagePath).IsUnicode(false);

                entity.Property(e => e.JobTitle).IsUnicode(false);

                entity.Property(e => e.LastName).IsUnicode(false);

                entity.Property(e => e.OfficePhone).IsUnicode(false);

                entity.Property(e => e.Organization).IsUnicode(false);

                entity.Property(e => e.PrimaryEmail).IsUnicode(false);

                entity.Property(e => e.SecondaryEmail).IsUnicode(false);
            });

            modelBuilder.Entity<USER_SECURITY_QUESTIONS>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PK_USER_SECURITY_QUESTIONS_1");

                entity.Property(e => e.UserId).ValueGeneratedNever();

                entity.Property(e => e.SecurityAnswer1).IsUnicode(false);

                entity.Property(e => e.SecurityAnswer2).IsUnicode(false);

                entity.Property(e => e.SecurityQuestion1).IsUnicode(false);

                entity.Property(e => e.SecurityQuestion2).IsUnicode(false);

                entity.HasOne(d => d.User)
                    .WithOne(p => p.USER_SECURITY_QUESTIONS)
                    .HasForeignKey<USER_SECURITY_QUESTIONS>(d => d.UserId)
                    .HasConstraintName("FK_USER_SECURITY_QUESTIONS_USERS");
            });

            modelBuilder.Entity<VISIO_MAPPING>(entity =>
            {
                entity.HasKey(e => new { e.Specific_Type, e.Stencil_Name });

                entity.Property(e => e.Specific_Type).IsUnicode(false);

                entity.Property(e => e.Stencil_Name).IsUnicode(false);

                entity.HasOne(d => d.Specific_TypeNavigation)
                    .WithMany(p => p.VISIO_MAPPING)
                    .HasForeignKey(d => d.Specific_Type)
                    .HasConstraintName("FK_VISIO_MAPPING_DIAGRAM_TYPES");
            });

            modelBuilder.Entity<WEIGHT>(entity =>
            {
                entity.HasKey(e => e.Weight1)
                    .HasName("PK_QUESTION_WEIGHT");

                entity.Property(e => e.Weight1).ValueGeneratedNever();
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}