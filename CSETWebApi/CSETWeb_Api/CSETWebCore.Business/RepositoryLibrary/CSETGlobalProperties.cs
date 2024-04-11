//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using CSETWebCore.Api.Interfaces;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Api.Models
{
    public class CSETGlobalProperties : ICSETGlobalProperties
    {
        private CSETContext _context;

        public string Main_Executive_Summary_Template
        {
            get { return GetProperty("MainExecutiveSummary"); }
        }

        public string Trend_Executive_Summary_Template
        {
            get { return GetProperty("TrendExecutiveSummary"); }
        }

        public string Compare_Executive_Summary_Template
        {
            get { return GetProperty("CompareExecutiveSummary"); }
        }

        public int DiagramAutoSaveTimeInterval
        {
            get
            {
                string stringDiagramAutoSaveTimeInterval = GetProperty("DiagramAutoSaveTimeInterval");
                return string.IsNullOrWhiteSpace(stringDiagramAutoSaveTimeInterval) ? 1 : int.Parse(stringDiagramAutoSaveTimeInterval);
            }
            set
            {
                SetProperty("DiagramAutoSaveTimeInterval", value.ToString());
            }
        }

        public static string Static_Application_Path
        {
            get
            {
                return AppDomain.CurrentDomain.BaseDirectory;
            }
        }

        public string Application_Path
        {
            get
            {
                return Static_Application_Path;
            }
        }

        public String DataDirectoryPath
        {
            get;
            set;
        }


        public bool IsUnsupported
        {
            get;
            set;
        }

        public String AssessmentTemplateFilePath
        {
            get { return System.IO.Path.Combine(Application_Path, "Data\\" + Constants.Constants.ASSESSMENT_FILE_NAME); }
        }
        public String AssessmentTemplateLogFilePath
        {
            get { return System.IO.Path.Combine(Application_Path, "Data\\" + Constants.Constants.ASSESSMENT_FILE_NAME_LOG); }
        }

        public String ReportsTempTopDirectory
        {
            get { return System.IO.Path.Combine(DataDirectoryPath, "Reports\\"); }

        }

        public String ReportsAggregationTempDirectory
        {
            get { return System.IO.Path.Combine(DataDirectoryPath, "Reports\\AggregationTemp\\"); }

        }

        public String AggregationDataDirectoryPath
        {
            get { return Path.Combine(DataDirectoryPath, "Aggregation"); }
        }

        public String AggregationAssessmentMergePath
        {
            get { return Path.Combine(AggregationDataDirectoryPath, "MergedAssessment"); }
        }

        public String ExtractedAssessmentMergePath
        {
            get { return Path.Combine(AggregationAssessmentMergePath, "ExtractedAssessments"); }
        }

        public String AggregationAssessmentPath
        {
            get { return Path.Combine(AggregationDataDirectoryPath, "Assessments"); }
        }

        public String AggregationTemplateFilePath
        {
            get { return Path.Combine(Application_Path, "Data\\" + Constants.Constants.AGGREGATION_FILE_NAME); }
        }

        public String ControlDatabaseFilePath
        {
            get { return Path.Combine(ControlDatabaseTempDirectory, Constants.Constants.CONTROL_DB_FILE_NAME); }
        }
        public String ControlDatabaseLogFilePath
        {
            get { return Path.Combine(ControlDatabaseTempDirectory, Constants.Constants.CONTROL_DB_LOG_FILE_NAME); }
        }

        public String ControlDatabaseTempDirectory
        {
            get { return Path.Combine(DataDirectoryPath, "Control"); }
        }

        public double FontSize
        {
            get
            {
                double? fontSizeProperty = GetDoubleProperty("QuestionFontSize");
                if (fontSizeProperty == null)
                    return 12.0;
                else
                {

                    double fontSize = double.Parse(GetProperty("QuestionFontSize"));

                    return fontSize;
                }


            }
            set
            {
                SetProperty("QuestionFontSize", value.ToString());
            }
        }

        public double ScreenSize
        {
            get
            {
                double? screenSizeProperty = GetDoubleProperty("ScreenSize");
                if (screenSizeProperty == null)
                {
                    ScreenSize = 1.00;
                    screenSizeProperty = GetDoubleProperty("ScreenSize");
                }
                return screenSizeProperty.Value;
            }
            set
            {
                SetProperty("ScreenSize", value.ToString());
            }
        }


        public bool InternalPDF
        {
            get
            {
                return GetBoolProperty("InternalPDF") ?? false;
            }
            set
            {
                SetProperty("InternalPDF", value.ToString());
            }
        }

        public String Last_Assessment_Name
        {
            get
            {
                return GetProperty("LastAssessmentName");
            }
            set
            {
                SetProperty("LastAssessmentName", value);
            }
        }

        public String Last_Assessment_File_Path
        {
            get
            {
                return GetProperty("LastFilePath");
            }
            set
            {
                SetProperty("LastFilePath", value);
            }
        }

        public String Last_Aggregation_Name
        {
            get
            {
                return GetProperty("LastAggregationName");
            }
            set
            {
                SetProperty("LastAggregationName", value);
            }
        }
        public String Last_Aggregation_File_Path
        {
            get
            {
                return GetProperty("LastAggregationFilePath");
            }
            set
            {
                SetProperty("LastAggregationFilePath", value);
            }
        }
        private Dictionary<String, String> propertiesDictionary = new Dictionary<string, string>();

        public string CSETFolder { get; set; }
        public string MyAssessmentsFolder { get { return System.IO.Path.Combine(CSETFolder, "My Assessments"); } }
        public string ProfileFolder { get { return System.IO.Path.Combine(CSETFolder, "Profiles"); } }
        public string ReportsFolder { get { return System.IO.Path.Combine(CSETFolder, "Reports"); } }


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        public CSETGlobalProperties(CSETContext context)
        {
            this._context = context;
        }


        /// <summary>
        /// Sets the named property to the specified string value.
        /// </summary>
        /// <param name="name"></param>
        /// <param name="value"></param>
        public void SetProperty(String name, String value)
        {
            try
            {
                /**
                 * performance on this pair of requests is really bad.
                 * putting this into a dictionary to reduce the footprint.
                 */
                IQueryable<GLOBAL_PROPERTIES> query = _context.GLOBAL_PROPERTIES.Where(x => x.Property == name);

                if (query.ToList().Count > 0)
                {
                    query.ToList()[0].Property_Value = value;
                }
                else
                {
                    GLOBAL_PROPERTIES gp = new GLOBAL_PROPERTIES();
                    gp.Property = name;
                    gp.Property_Value = value;
                    _context.GLOBAL_PROPERTIES.Add(gp);
                }

                _context.SaveChanges();

                if (propertiesDictionary.ContainsKey(name))
                {
                    propertiesDictionary[name] = value;
                }
                else
                {
                    propertiesDictionary.Add(name, value);
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

        }


        /// <summary>
        /// Gets the named property as a double.  Returns null if not found.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public double? GetDoubleProperty(String name)
        {
            try
            {
                String sPropertyValue = GetProperty(name);
                if (sPropertyValue == null)
                {
                    return null;
                }
                else
                {
                    return Double.Parse(sPropertyValue);
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return null;
            }
        }


        /// <summary>
        /// Gets the named property as a bool.  Returns null if not found.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public bool? GetBoolProperty(String name)
        {
            try
            {
                String sPropertyValue = GetProperty(name);
                if (sPropertyValue == null)
                {
                    return null;
                }
                else
                {
                    bool bValue;
                    if (bool.TryParse(sPropertyValue, out bValue))
                    {
                        return bValue;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return null;
            }
        }


        /// <summary>
        /// Gets the named property as a string.  Returns null if not found.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public String GetProperty(String name)
        {
            try
            {
                if (propertiesDictionary.ContainsKey(name))
                {
                    return propertiesDictionary[name];
                }
                else
                {
                    IQueryable<GLOBAL_PROPERTIES> query = _context.GLOBAL_PROPERTIES.Where(x => x.Property == name);
                    if (query.ToList().Count > 0)
                    {
                        string rval = query.First().Property_Value;
                        propertiesDictionary.Add(name, rval);
                        return rval; //ToList()[0].Property_Value
                    }
                }

                return null;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return null;
            }
        }



        public const string PROFILE_EXTENSION = ".csetp";
        public const string PROFILE_NONE = "None";


        public string GetProfileFullPath(string profileFileName)
        {
            return Path.Combine(ProfileFolder, profileFileName) + PROFILE_EXTENSION;
        }
    }
}