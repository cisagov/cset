//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Constants
{
    public static class Constants
    {
        public static string AssessmentAdmin = "ASSESS_ADMIN";
        public static int AssessmentAdminId = 2;

        public static string AssesmentUser = "ASSESS_USER";

        public static string Token_TimezoneOffsetKey = "tzoffset";
        public static string Token_UserId = "userid";
        public static string Token_AccessKey = "acckey";
        public static string Token_AssessmentId = "assess";
        public static string Token_AggregationId = "aggreg";
        public static string Token_Scope = "scope";

        public const string API_KEY_CONFIG_NAME = "ApiKey";
        public const string API_KEY_HEADER_NAME = "X-API-KEY";

        public const string UNIVERSAL_DB = "Universal";
        public const string KEY_DB = "Key";
        public const string CFATS_DB = "Cfats";
        public const string INGAA_DB = "INGAA";
        public const string NEI_0809_DB = "NEI_0809";
        public const string C2M2 = "C2M2_V11";
        public const string CNSSI_1253_DB = "Cnssi_1253";
        public const string CNSSI_1253_V2_DB = "Cnssi_1253_V2";
        public const string CNSSI_ICS_PIT_DB = "Cnssi_Ics_Pit";
        public const string CNSSI_ICS_V1_DB = "Cnssi_Ics_V1";
        public const string DOD_DB = "Dod";
        public const string NIST_FRAMEWORK_DB = "NCSF_V1";
        public const string DOD8510 = "DODI_8510";
        public const string NERC5 = "Nerc_Cip_R5";
        public const string CSC = "CSC_V6";
        // Application Name/Version
        // *************************************************************************************************************************
        public const String APPLICATION_NAME = "CSET";
        public const Decimal APPLICATION_VERSION_90D = 9.0m;
        public const Decimal APPLICATION_VERSION_81D = 8.1m;
        public const Decimal APPLICATION_VERSION_80D = 8.0m;
        public const Decimal APPLICATION_VERSION_71D = 7.1m;
        public const Decimal APPLICATION_VERSION_70D = 7.0m;
        public const Decimal APPLICATION_VERSION_62D = 6.2m;
        public const Decimal APPLICATION_VERSION_61D = 6.1m;
        public const Decimal APPLICATION_VERSION_60D = 6.0m;
        public const Decimal APPLICATION_VERSION_51D = 5.1m;
        public const Decimal APPLICATION_VERSION_50D = 5.0m;
        public const String CSET_ASSESSMENT_FILE_FILTER = "CSET Assessment Files (*" + ASSESSMENT_APPLICATION_EXTENSION + ")|*" + ASSESSMENT_APPLICATION_EXTENSION;
        public const String CSET_AGGREGATON_FILE_FILTER = "CSET Aggrregation Files (*" + AGGREGATION_APPLICATION_EXTENSION + ")|*" + AGGREGATION_APPLICATION_EXTENSION;
        public const String CSET_CUSTOMSTANDARD_FILE_FILTER = "CSET CustomStandard Files (*" + CUSTOM_STANDARD_EXTENSION + ")|*" + CUSTOM_STANDARD_EXTENSION;
        public const String CSET_ASSESSMENT_AGGREGATION_FILE_FILTER = "CSET Files(*" + ASSESSMENT_APPLICATION_EXTENSION + ", *" + AGGREGATION_APPLICATION_EXTENSION + ")|*"
            + ASSESSMENT_APPLICATION_EXTENSION + ";*" + AGGREGATION_APPLICATION_EXTENSION;
        public const String ASSESSMENT_APPLICATION_EXTENSION = ".cset";
        public const String AGGREGATION_APPLICATION_EXTENSION = ".cseta";
        public const String CUSTOM_STANDARD_EXTENSION = ".csetc";
        public const String DB_SQL_COMPACT_EXTENSION = ".sdf";
        public const string DB_EXTENSION = ".mdf";
        public const string DB_LOG_EXTENSION = ".ldf";
        public static string DB_BAK_EXTENSION = ".bak";
        public const string LOCALDB_2022_CUSTOM_INSTANCE_NAME = "INLLocalDb2022";
        public const string LOCALDB_2019_DEFAULT_INSTANCE_NAME = "MSSQLLocalDB";
        public const string LOCALDB_2012_DEFAULT_INSTANCE_NAME = "v11.0";
        public const string LOCALDB_2022_REGISTRY_DISPLAY_NAME = "Microsoft SQL Server 2022 LocalDB ";
        public const string LOCALDB_2019_REGISTRY_DISPLAY_NAME = "Microsoft SQL Server 2019 LocalDB ";
        public const string LOCALDB_2012_REGISTRY_DISPLAY_NAME = "Microsoft SQL Server 2012 Express LocalDB ";
        public const String CSET_FONTFAMILY = "Segoe UI"; //"/CSET_Main;multiServiceComponent/Fonts/#Arial"
        public const String OLD_ASSESSMENT_FILENAME = "assessment.xml";
        public const String AGGREGATION_FILE_NAME = "CSET_AggregationFile.mdf";
        public const String ASSESSMENT_FILE_NAME = "CSET_AssessmentFile.mdf";
        public const String ASSESSMENT_FILE_NAME_LOG = "CSET_AssessmentFile_log.ldf";
        public const String CONTROL_DB_FILE_NAME = "CSET_Control.mdf";
        public const String CONTROL_DB_LOG_FILE_NAME = "CSET_Control_log.ldf";
        public static string DOCUMENT_PATH = "Documents\\";
        public static string XLSX_DOCUMENT_PATH = "Documents\\XLSX\\";
        public static string XPS_DOCUMENT_PATH = "Documents\\XPS\\";
        // *************************************************************************************************************************

        public const int MIN_WIDTH_QUESTION_LISTVIEW = 500;
        public const string VISIO_STENCIL_NAME = "CSET_81.vss";

        // SALs
        // *************************************************************************************************************************
        public const String SAL_NONE = "None";
        public const String SAL_LOW = "Low";
        public const String SAL_MODERATE = "Moderate";
        public const String SAL_HIGH = "High";
        public const String SAL_VERY_HIGH = "Very High";
        // *************************************************************************************************************************

        // Question Answers (Make enumeration?) Note: Strings correspond to the Answer_Text column in the Answer_Lookup table of the assessment database
        // *************************************************************************************************************************
        public const String YES = "Y";
        public const String YESFull = "Yes";
        public const String NO = "N";
        public const String NOFull = "No";
        public const String NA = "NA";
        public const String ALTERNATE = "A";
        public const String UNANSWERED = "U";
        // *************************************************************************************************************************

        public const int FONT_SIZE_LOADING = 25;

        // Header and Forward Next Text 
        //***************************************************************************************************************************
        public const String INFORMATION_CONTACTS_NAVIGATION_BUTTON_TEXT = "Contacts";
        public const String MAIN_SCREEN_AGGREGATION_TAB_NAME = "Add Assessments";
        public const String INFORMATION_SCREEN_AGGREGATION_TAB_NAME = "Information";
        public const String TREND_ANALYTICS_SCREEN_AGGREGATION_TAB_NAME = "Summary Analytics";
        public const String COMPARE_ANALYTICS_SCREEN_AGGREGATION_TAB_NAME = "Summary Analytics";
        public const String MERGE_CREATE_ASSESSMENT_AGGREGATION_TAB_NAME = "Create Assessment";
        public const String MERGE_DIFFERENCES_AGGREGATION_TAB_NAME = "Merge Differences";
        public const String REPORTS_AGGREGATION_TAB_NAME = "Reports";
        public const String ASSESSMENT_DATABASE_ZIP_ENTRY_COMMENT = "CSET Assessment";
        public const String AGGREGATION_DATABASE_ZIP_ENTRY_COMMENT = "CSET Aggregation";
        public const String DIAGRAM_DATABASE_ZIP_ENTRY_COMMENT = "CSET Additional file such as diagram";
        public const String NO_STANDARD_ANALYSIS = "There are no standards selected.";
        public const String NO_COMPONENTS_ANALYSIS = "There are no components on the diagram.";
        public const String NO_STANDARDS_COMPONENTS_ANALYSIS = "There are no standards selected or no components on the diagram.";
        public const String ANALYSIS_NO_QUESTIONS_PASSED = "No questions passed";


        public const String HOME_HEADER_TEXT = "Home";
        public const String HOME_AGGREGATION_ID = "HomeAgg";
        public const String INFORMATION_HEADER_TEXT = "Information";
        public const String INFORMATION_DESCRIPTION_NAVIGATION_BUTTON_TEXT = "Description/Comments";
        public const String INFORMATION_EXECUTIVE_SUMMARY_NAVIGATION_BUTTON_TEXT = "Executive Summary";
        public const String INFORMATION_FACILITY_NAVIGATION_BUTTON_TEXT = "Facility Information";
        public const String INFORMATION_FACILITY_TEXT_NAVIGATION_BUTTON_AGGREGATION_ID = "Facility Information Trend, Compare, Merge";
        public const String INFORMATION_EXECUTIVE_SUMMARY_NAVIGATION_BUTTON_AGGREGATION_ID = "Executive Summary Information Trend, Compare, Merge";
        public const String TREND_HEADER_TEXT = "Trend";
        public const String COMPARE_HEADER_TEXT = "Compare";
        public const String MERGE_HEADER_TEXT = "Merge";
        public const String INFORMATION_AGGREGATION_HEADER_TEXT_ID = "InformationAgg";
        public const String INFORMATION_AGGREGATION_HEADER_TEXT = "Information";
        public const String LOAD_AGGREGATION_HEADER_TEXT = "Load Assessments";
        public const String STANDARDS_HEADER_TEXT = "Standards";
        public const String SAL_HEADER_TEXT = "SAL";
        public const String QUESTIONS_HEADER_TEXT = "Questions";
        public const String REQUIREMENTS_HEADER_TEXT = "Requirements";
        public const String FRAMEWORK_HEADER_TEXT = "Framework";
        public const String DIAGRAM_HEADER_TEXT = "Diagram";
        public const String REPORTS_HEADER_TEXT = "Reports";
        public const String ANALYSIS_HEADER_TEXT = "Analysis";
        // *************************************************************************************************************************

        // Other Names
        public const String VISIBLE_DEFAULT_LAYER_MSG = "Can not add items to the diagram because the default layer is not visible.";

        // Document Locations
        // *************************************************************************************************************************
        public const String USER_GUIDE_PATH = "cdDocs/User Guide.pdf";
        public const String NIST_DOCUMENT_PATH = "FIPS199Language.xps";
        public const String ACCESSKEY_DOCUMENT_PATH = "AccessibilityFeatures.xps";
        public const String ADVISORY_DOCUMENT_PATH = "Advisory.xps";
        public const String FIPS199_DOCUMENT_PATH = "FIPS 199.pdf";
        public const String SP800_60_1_DOCUMENT_PATH = "NIST SP800-60 V1.pdf";
        public const String SP800_60_2_DOCUMENT_PATH = "SP800-60_Vol2-Rev1.pdf";

        public const String HELP_DOCUMENT_PATH = @"Documents\help\CSETHelp.chm";


        // 8.0 HELP Titles / htm files to bookmark into CHM
        // *************************************************************************************************************************

        // DIAGRAM
        // *******************************************************
        public const String HELP_DIAGRAM_HOME_TAB_WINDOW = "diagram_home_tab_screen.htm";
        public const String HELP_DIAGRAM_FORMAT_TAB_WINDOW = "diagram_format_tab_screen.htm";
        public const String HELP_DIAGRAM_INVENTORY_WINDOW = "diagram_inventory_window.htm";
        public const String HELP_DIAGRAM_LAYER_MANAGER_WINDOW = "diagram_layer_manager_window.htm";
        public const String HELP_DIAGRAM_TEMPLATE_MANAGER_WINDOW = "diagram_template_manager_window.htm";
        public const String HELP_DIAGRAM_PRINT_PREVIEW_WINDOW = "diagram_print_preview_window.htm";
        public const String HELP_DIAGRAM_EXPORT_IMAGE_WINDOW = "diagram_export_image_window.htm";
        public const String HELP_DIAGRAM_IMPORT_VISIO_WINDOW = "diagram_import_visio_window.htm";
        public const String HELP_DIAGRAM_ANALYSIS_WINDOW = "diagram_analysis_window.htm";
        public const String HELP_DIAGRAM_SERVICE_DETAILS_WINDOW = "diagram_service_details_window.htm";

        // PREPARE
        // *******************************************************
        public const String HELP_PREPARE_START_NEW_ASSESSMENT = "prepare_start_new_assessment.htm";
        public const String HELP_PREPARE_PREVIOUS_ASSESSMENT = "prepare_previous_assessment.htm";
        public const String HELP_PREPARE_RESUME_ASSESSMENT = "prepare_resume_assessment.htm";
        public const String HELP_PREPARE_ASSESSMENT_INFO = "prepare_assessment_info.htm";
        public const String HELP_PREPARE_DIAGRAM_COMPONENTS = "prepare_diagram_components.htm";
        public const String HELP_PREPARE_MODE_SELECTION = "prepare_mode_selection.htm";
        public const String HELP_PREPARE_SAL_SELECTION = "prepare_sal_selection.htm";
        public const String HELP_PREPARE_DEMOGRAPHICS_SELECTION = "prepare_demographics_selection.htm";
        public const String HELP_PREPARE_STANDARD_SELECTION = "prepare_standard_selection.htm";
        public const String HELP_PREPARE_DOD_8500_MAC_SELECTION = "prepare_dod_8500_mac_selection.htm";

        // SAL WINDOWS
        // *******************************************************
        public const String HELP_SAL_WINDOW_SIMPLE_SELECTION = "sal_window_simple_selection.htm";
        public const String HELP_SAL_WINDOW_GENERAL_SELECTION = "sal_window_general_selection.htm";
        public const String HELP_SAL_WINDOW_FIPS_SELECTION = "sal_window_fips_selection.htm";

        // QUESTIONS
        // *******************************************************
        public const String HELP_QUESTIONS_SCREEN = "questions_screen.htm";
        public const String HELP_CONTACT_MANAGER_SCREEN = "contact_manager.htm";
        public const String HELP_QUESTIONS_DISCOVERIES_WINDOW = "questions_discoveries_window.htm";
        public const String HELP_QUESTIONS_COMPONENT_OVERRIDES_WINDOW = "questions_component_overrides_window.htm";
        public const String HELP_QUESTIONS_LANDING_SCREEN = "questions_landing_screen.htm";

        // RESULTS
        // *******************************************************
        public const String HELP_RESULTS_LANDING_SCREEN = "results_landing_screen.htm";
        public const String HELP_RESULTS_DASHBOARD_SCREEN = "results_dashboard_screen.htm";
        public const String HELP_RESULTS_RANKED_QUESTIONS_SCREEN = "results_ranked_questions_screen.htm";
        public const String HELP_RESULTS_OVERALL_RANKED_CATEGORIES_SCREEN = "results_overall_ranked_categories_screen.htm";
        public const String HELP_RESULTS_STANDARDS_SUMMARY_SCREEN = "results_standards_summary_screen.htm";
        public const String HELP_RESULTS_STANDARDS_RANKED_CATEGORIES_SCREEN = "results_standards_ranked_categories_screen.htm";
        public const String HELP_RESULTS_STANDARDS_RESULTS_BY_CATEGORY_SCREEN = "results_standards_results_by_category_screen.htm";
        public const String HELP_RESULTS_COMPONENTS_SUMMARY_SCREEN = "results_components_summary_screen.htm";
        public const String HELP_RESULTS_COMPONENTS_RANKED_CATEGORIES_SCREEN = "results_components_ranked_categories_screen.htm";
        public const String HELP_RESULTS_COMPONENTS_RESULTS_BY_CATEGORY_SCREEN = "results_components_results_by_category_screen.htm";
        public const String HELP_RESULTS_COMPONENTS_COMPONENT_TYPES_SCREEN = "results_components_component_types_screen.htm";
        public const String HELP_RESULTS_COMPONENTS_NETWORK_WARNINGS_SCREEN = "results_components_network_warnings_screen.htm";
        public const String HELP_RESULTS_FRAMEWORK_SUMMARY_SCREEN = "results_framework_summary_screen.htm";
        public const String HELP_RESULTS_FRAMEWORK_BY_FUNCTION_SCREEN = "results_framework_by_function_screen.htm";
        public const String HELP_RESULTS_FRAMEWORK_RANKED_CATEGORIES_SCREEN = "results_framework_ranked_categories_screen.htm";
        public const String HELP_RESULTS_FRAMEWORK_RESULTS_BY_CATEGORY_SCREEN = "results_framework_results_by_category_screen.htm";
        public const String HELP_RESULTS_NERC5_RANKED_CATEGORIES_SCREEN = "results_nerc5_ranked_categories_screen.htm";
        public const String HELP_RESULTS_NERC5_QUESTIONS_SCREEN = "results_nerc5_questions_screen.htm";
        public const String HELP_RESULTS_REPORTS_SCREEN = "reports_screen.htm";


        // AGGREGATION
        // *******************************************************
        public const String HELP_AGGREGATION_LOAD_SCREEN = "aggregation_load_screen.htm";
        public const String HELP_AGGREGATION_TREND_SCREEN = "aggregation_trend_screen.htm";
        public const String HELP_AGGREGATION_COMPARE_SCREEN = "aggregation_compare_screen.htm";
        public const String HELP_AGGREGATION_MERGE_SCREEN = "aggregation_merge_screen.htm";
        public const String HELP_AGGREGATION_MERGE_QUESTION_DETAIL_SCREEN = "aggregation_merge_question_detail_screen.htm";
        public const String HELP_AGGREGATION_INFORMATION_SCREEN = "aggregation_assessment_information.htm";

        // CUSTOM QUESTIONNAIRE
        // *******************************************************
        public const String HELP_CUSTOM_QUESTIONNAIRE_MANAGER_SCREEN = "custom_questionnaire_manager.htm";
        public const String HELP_CUSTOM_SELECT_QUESTIONS_SCREEN = "custom_select_questions.htm";
        public const String HELP_CUSTOM_QUESTIONNAIRE_FINISH_SCREEN = "custom_questionnaire_finish.htm";
        public const String HELP_CUSTOM_STANDARD_SELECTION = "custom_standard_selection.htm";

        // CYBERSECURITY FRAMEWORK
        // *******************************************************
        public const String HELP_FRAMEWORK_OVERVIEW = "framework_overview.htm";
        public const String HELP_FRAMEWORK_PROFILE_MANAGER = "framework_profile_manager.htm";
        public const String HELP_FRAMEWORK_PROFILE_IMPORT_QUESTIONS_WINDOW = "framework_profile_import_questions_window.htm";
        public const String HELP_FRAMEWORK_PROFILE_CATEGORY_WINDOW = "framework_profile_category_window.htm";
        public const String HELP_FRAMEWORK_PROFILE_QUESTION_WINDOW = "framework_profile_question_window.htm";

        // OTHER
        // *******************************************************
        public const String HELP_ASSESSMENT_RECOVERY = "assessment_recovery.htm";
        public const String HELP_PARAMETER_EDITOR_WINDOW = "parameter_editor_window.htm";
        public const String HELP_PARAMETER_WINDOW = "parameter_window.htm";
        public const String HELP_RESOURCE_LIBRARY_WINDOW = "resource_library_window.htm";
        public const String HELP_PROTECTED_FEATURES_WINDOW = "protected_features_window.htm";
        public const String HELP_DOCUMENT_MANAGER_WINDOW = "document_manager_window.htm";
        public const String HELP_DOCUMENT_QUESTIONS_LIST_WINDOW = "document_questions_list_window.htm";

        // ENCRYPTION
        // *******************************************************
        public const String HELP_ENCRYPTION_WINDOW = "encryption_window.htm";

        // *************************************************************************************************************************

        public const string TOP_QUESTIONS_OF_CONCERN = "Top Questions of Concern";


        // Style CSET Theme
        public const String CSET_THEME = "/CSETStyles;component/ColorTheme.xaml"; //Themes/ColorTheme.xaml
        public const String HIGH_CONTRAST_THEME = "/CSETStyles;component/HighContrastTheme.xaml";

        // Report Images for reports
        public const String FOOTER_LOGO = @"Images\ReportImages\footer logo.jpg";
        public const String EXEC_REPORT_PG3 = @"Images\ReportImages\exec report pg3.jpg";
        public const String EXEC_REPORT_PG4 = @"Images\ReportImages\exec report pg4.jpg";
        public const String CHART_BACKGROUND = @"Images\ReportImages\chart_background.jpg";
        public const String OVERALL_SUMMARY_REPORT = @"Images\ReportImages\OverallSummaryBackground.jpg";
        public const String SITE_SUMMARY_BACKGROUND = @"Images\ReportImages\Site Summary bg.jpg";
        public const String GRADIENT_BACKGROUND = @"Images\ReportImages\grad-bg.jpg";
        public const String AREAS_OF_CONCERNS = @"Images\ReportImages\AreasOfConcern.jpg";
        public const String AREAS_OF_CONCERN_QUESTIONS = @"Images\ReportImages\AreasOfConcernQuestions.jpg";
        public const String PLACE_HOLDER_COMPONENT_SUMMARY = @"Images\ReportImages\placeholder_SS_ComponentSummary.png";
        public const String PLACE_HOLDER_COMPONENT_DIAGRAM = @"Images\ReportImages\placeholder_Diagram.png";
        public const String PLACE_HOLDER_RANKED_SUBJECT_AREAS = @"Images\ReportImages\placeholder_SS_RankedSubjectAreas.png";
        public const String PLACE_HOLDER_NERC_RANKED_SUBJECT_AREAS = @"Images\ReportImages\placeholder_SS_NERCRankedSubjectAreas.png";
        public const String AGGREGATION_COMPARISION_OVERALL_STACKED_BAR = @"Images\ReportImages\Aggregation\comp_OverallStackedBar.png";
        public const String AGGREGATION_COMPARISION_SUBJECT_AREAS_OVERALL = @"Images\ReportImages\Aggregation\Comp_SubjectAreasOverall.png";
        public const String AGGREGATION_COMPARISION_SUBJECT_AREAS_BY_SITE = @"Images\ReportImages\Aggregation\Comp_SubjectAreasBySite.png";
        public const String AGGREGATION_BEST_TO_WORST_COLUMN = @"Images\ReportImages\Aggregation\BestToWorstColumn.png";
        public const String AGGREGATION_OVERALL_TREND = @"Images\ReportImages\Aggregation\OverallTrend.png";
        public const String AGGREGATION_TOP5_IMPROVE = @"Images\ReportImages\Aggregation\Top5Improve.png";
        public const String AGGREGATION_BOTTOM5DECLINE = @"Images\ReportImages\Aggregation\Bottom5Decline.png";
        public const String REPORTS_NO_DIAGRAM_PATH = @"Images\ReportImages\NoDiagram.jpg";
        public const String PLACE_HOLDER_TOP10 = @"Images\ReportImages\placeholder_Top10.jpg";

        // Aggregation
        public const String DELETE_MERGE_MESSAGE = "Deleting this assessment will wipe merge conflicts. Are you sure you want to delete this assessment?";
        public const String ADD_MERGE_MESSAGE = "Adding an assessment will wipe merge conflicts.  Are you sure you want to continue in adding an assessment?";
        public const String CHANGE_PRIORITY_MERGE_MESSAGE = "Changing the priority of assessments will wipe merge conflicts. Are you sure you want to change the priority of assessments?";
        public const String MERGE_CONFLICTS_MESSAGE_TEXT = "The selected assessments have conflicting answers. Expand the tables below to review and resolve these conflicts. The answers from the default assessment have been preselected.";
        public const String NO_MERGE_CONFLICTS_MESSAGE_TEXT = "No conflicting answers were found between the selected assessments. Select an answer below to continue.";
        public const String LOADING_AGGREGATION_TEXT = "Loading assessment files may take a few minutes.";
        public const String RESULTS = "Results";
        // *************************************************************************************************************************


        // Common Colors
        // *************************************************************************************************************************
        public const String CSET_GREEN = "#FF6FA459"; // Yes
        public const String CSET_BLUE = "#FF084D6D"; // Unanswered
        public const String CSET_OLIVE = "#FFBAC833"; //  Alternate 
        public const String CSET_TAN = "#FFF5DEB3"; // NA
        public const String CSET_RED = "#FF8D2123"; // Red
                                                    // *************************************************************************************************************************


        // Diagram Stuff
        // *************************************************************************************************************************
        public const String DIAGRAM_FILE_NAME = "Diagram.csetd";
        public const String UNIDIRECTIONAL_TYPE = "Unidirectional Device";
        public const String FIREWALL_TYPE = "Firewall";
        public const int CONNECTOR_TYPE = 4;//"Connector";
        public const int VLAN_ROUTER = 32; //"VLAN Router";
        public const int VLAN_SWITTCH = 33;//"VLAN Switch";
        public const int IDS_TYPE = 12;//"IDS";
        public const int IPS_TYPE = 14;//"IPS";
        public const int WEB_TYPE = 35;//"Web";
        public const int VENDOR_TYPE = 31; //"Vendor";
        public const int PARTNER_TYPE = 20; //"Partner";
        public const int LINK_ENCRYPTION = 15;//"Link Encryption";
        public const int SERIAL_RADIO = 25; //"Serial Radio";
        public const int SERIAL_SWITCH = 26;// "Serial Switch";
        public const int UNKNOWN_TYPE = 30; //"Unknown";
        public const int HUB_TYPE = 11;//"Hub";
        public const int MULTIPLESERVICESCOMPONENT_TYPE = 49;// "Multiple Services Component";
        // *************************************************************************************************************************

        // Error Messages
        // *************************************************************************************************************************
        public const String FATAL_OPEN_EXISTING_ASSEMENT_MESSAGE = "The application failed to open an existing assessment. Please try again.";
        public const String FAILED_TO_LOAD_SOME_COMPONENTS = "Some of the components in the diagram failed to load.";
        public const String FAILED_TO_LOAD_SOME_LINKS = "Some of the links in the diagram failed to load.";
        public const String FAILED_TO_LOAD_SOME_ZONES = "Some of the zones in the diagram failed to load.";
        public const String FAILED_TO_LOAD_SOME_SHAPES = "Some of the shapes in the diagram failed to load.";
        public const String FAILED_TO_LOAD_SOME_TEXT_NODES = "Some of the text labels failed to load.";
        public const String FAILED_TO_LOAD_DIAGRAM_NO_DIAGRAM = "No Diagram in assessment file.";
        public const String FAILED_TO_EXPORT_DIAGRAM = "Failed to export diagram to a file.";
        public const String FAILED_TO_SAVE_DIAGRAM = "Failed to save diagram.";
        public const String FAILED_TO_CREATE_TEXT_NODE = "Failed to create text box on diagram.";
        public const String FAILED_TO_LOAD_RECOVERY_FILE = "Failed to load recovery file.";
        public const String FAILED_TO_LOAD_DATABASE = "Microsoft SQL Server LocalDB 2012 could not be found on this system.  Please install this product and try again.";
        // *************************************************************************************************************************

        public const string QUESTIONS = "Questions";
        public const string REQUIREMENT = "Requirement";
        //DANG IT.  I HAVE DUN GONE AND MIXED THE MAGIC STRINGS  CRAP
        public const string REQUIREMENTS = "Requirements";
        public const string COMPONENT_DEFAULTS = "Component Defaults";
        public const string COMPONENTS = "Components";
        public const string STANDARDS = "Standards";
        public const string OVERALL = "Overall";
        public const string FRAMEWORK = "Framework";
        public const string NERC_V5 = "Nerc_Cip_R5";


        // ZONE Type
        public const String ZONE_OTHER_TYPE = "Other";

        public static string RANKED_SUBJECT_AREAS_TITLE = "Ranked Subject Areas";
        public static string RANKED_CYBERSECURITY_CATEGORIES_TITLE = "Ranked Cybersecurity Framework Categories";
        public const string GENERAL_SAL_LEVEL_NAME = "Selected_Sal_Level";
        public const string LEFT_MULTI_CONNECTOR = "LeftMulti";
        public const string RIGHT_MULTI_CONNECTOR = "RightMulti";
        public const string TOP_MULTI_CONNECTOR = "TopMulti";
        public const string BOTTOM_MULTI_CONNECTOR = "BottomMulti";
        public const string LEFT_CONNECTOR = "Left";
        public const string RIGHT_CONNECTOR = "Right";
        public const string TOP_CONNECTOR = "Top";
        public const string BOTTOM_CONNECTOR = "Bottom";
        public const string AUTO_CONNECTOR = "Auto";
        public const string CENTER_CONNECTOR = "Center";
        public const string CENTER_CON_CONNECTOR = "CenterCon";
        public const string LEFT_UNI_CONNECTOR = "UniDirectionalLeft";
        public const string RIGHT_UNI_CONNECTOR = "UniDirectionalRight";
        public const string BEZIER_CONNECTION_TYPE = "Bezier";
        public const string POLY_LINE_CONNECTION_TYPE = "Orthogonal";
        public static string BuildFileName = "BuildNumber.txt";
        public static string AssessmentFileBuildFileName = "BuildNumberDatabase.txt";
        public static string ASSESSMENT_FILE_LOG = "_log";
        public const int ZONE = 121;
        public const int UNIDIRECTIONAL_DEVICE = 29;
        public const string UnTrusted = "Untrusted";
        public const string Trusted = "Trusted";
        public const string Availabilty = "Availability";
        public const string Confidentiality = "Confidentiality";
        public const string Integrity = "Integrity";

        public const string SIMPLE_SAL = "Simple";

        //Question Types
        public const string QuestionTypeMaturity = "Maturity";
        public const string QuestionTypeComponent = "Component";

        //Maturity Levels
        public const string MaturityLevel = "Maturity_Level";
        public const string IncompleteMaturity = "Incomplete";
        public const string SubBaselineMaturity = "Sub-Baseline";
        public const string BaselineMaturity = "Baseline";
        public const string EvolvingMaturity = "Evolving";
        public const string IntermediateMaturity = "Intermediate";
        public const string AdvancedMaturity = "Advanced";
        public const string InnovativeMaturity = "Innovative";

        public const string ScuepMaturity = "SCUEP";
        public const string CoreMaturity = "CORE";
        public const string CorePlusMaturity = "CORE+";

        //IRP Levels
        public const string LeastIrp = "Least";
        public const string MinimalIrp = "Minimal";
        public const string ModerateIrp = "Moderate";
        public const string SignificantIrp = "Significant";
        public const string MostIrp = "Most";


        public const string DEFAULT_LAYER_NAME = "Background";

        public const int FIREWALL = 8;
    }
}
