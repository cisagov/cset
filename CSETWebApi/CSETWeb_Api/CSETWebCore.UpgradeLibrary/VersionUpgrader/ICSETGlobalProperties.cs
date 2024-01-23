//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpgradeLibrary.Upgrade
{
    /// <summary>
    /// 
    /// </summary>
    public interface ICSETGlobalProperties
    {
        string Application_Accept_Path { get; }
        string CSETFolder { get; }
        string MyAssessmentsFolder { get; }
        string ProfileFolder { get; }
        string ReportsFolder { get; }
        string DataDirectoryPath { set; get; }
        string ReportsTempTopDirectory { get; }
        string AssessmentTemplateLogFilePath { get; }
        string AssessmentTemplateFilePath { get; }
        string AggregationDataDirectoryPath { get; }
        string AggregationAssessmentPath { get; }
        string AggregationAssessmentMergePath { get; }
        string AggregationTemplateFilePath { get; }
        string Compare_Executive_Summary_Template { get; }
        string Trend_Executive_Summary_Template { get; }
        string Main_Executive_Summary_Template { get; }
        string Last_Aggregation_Name { get; set; }
        string Last_Aggregation_File_Path { get; set; }
        string Last_Assessment_File_Path { get; set; }
        string Last_Assessment_Name { get; set; }
        string ControlDatabaseFilePath { get; }
        string ControlDatabaseTempDirectory { get; }
        string ControlDatabaseLogFilePath { get; }
        string ExtractedAssessmentMergePath { get; }
        string Application_Path { get; }
        string ReportsAggregationTempDirectory { get; }
        string CSETVersionString { get; }
        int DiagramAutoSaveTimeInterval { get; }
        string BuildNumber { get; }
        string AssessmentFileBuildNumber { get; }
        bool IsUnsupported { get; set; }
        string FullVersion { get; }
        double FontSize { get; set; }
        bool InternalPDF { get; set; }

        void CreateCSETMyDocumentFolders();
        string GetFullVersion();
        string GetProfileFullPath(String profileFileName);
        void AddRecentFile(string path, string lastAssessmentName);
    }
}
