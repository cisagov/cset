//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.ReportEngine.Contract;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using DataLayerCore.Model;
using CSET_Main.Questions.POCO;

namespace CSET_Main.ReportEngine.Builder
{

    /**
     * NOTE when debugging this with CSET_ReportBuilder set as the default start project
     * the Control database will often get cleaned up by the build process. 
     * You will want to check to see that the database is in the local apps folder and if it is not 
     * copy it there before running. 
     */
    public class ReportDataBuilder
    {
        public String Name { get; set; }

        private DataHandling cb = new DataHandling();
        


        public ReportConfig Config { get; set; }

        
        public ReportDataBuilder()
        {

        }


        /// <summary>
        /// takes the report config from the client and returns 
        /// the requested data.
        /// </summary>
        /// <param name="Config"></param>
        /// <returns></returns>
        //public ReportData BuildReport(ReportConfig Config, int assessment_id)
        //{
        //    ReportData reportData = new ReportData();
        //    using (CSET_Context context = new CSET_Context())
        //    {
        //        reportData.Config = Config;
        //        // Data for Reports

        //        INFORMATION info = context.INFORMATION.Where(x => x.Id == assessment_id).FirstOrDefault();
        //        String assessmentName = info == null ? "" : info.Assessment_Name;
        //        reportData.AssessmentName = assessmentName;
        //        reportData.StandardMode = standard.StandardMode;

        //        List<DOCUMENT_FILE> documents = context.DOCUMENT_FILE.ToList();
        //        List<StandardColor> standardsList = analysisCollection.Standards as List<StandardColor>;


        //        AnalysisResult rankedQuestions = analysisCollection.RankedQuestionsResultsRed;
        //        AnalysisResult nercRankedQuestions = analysisCollection.NercRankedQuestionsResults;
        //        List<GEN_SAL_WEIGHTS> genSalDataList = context.STANDARD_SELECTION.FirstOrDefault().GEN_SAL_WEIGHTS.ToList();
        //        nistSALData.Init();
        //        DataTable nistTable = this.BuildNISTSalTable(nistSALData);
        //        reportData.MailMerges.Add(nistTable);
        //        DataTable cnssTable = this.BuildCNSSSalTable(context, nistSALData);
        //        reportData.MailMerges.Add(cnssTable);
        //        DataTable cnssJustificationTable = this.BuildCNSSSALJustificationTable(context);
        //        reportData.MailMerges.Add(cnssJustificationTable);

        //        STANDARD_SELECTION standsel = context.STANDARD_SELECTION.FirstOrDefault();

        //        if (standsel.Last_Sal_Determination_Type == "GENERAL")
        //            reportData.IsGenSAL = true;

        //        OverallSalObject sals = new OverallSalObject(standsel.ASSESSMENT_SELECTED_LEVELS, standsel);
        //        DataTable dodTable = BuildDODSalTable(sals);
        //        reportData.MailMerges.Add(dodTable);

        //        var dodrec = context.AVAILABLE_STANDARDS.Where(x => x.Entity_Name.ToLower() == "dod").FirstOrDefault();
        //        reportData.DODSelected = dodrec == null ? false : dodrec.Selected;

        //        var nerc5rec = context.AVAILABLE_STANDARDS.Where(x => x.Entity_Name.ToLower() == "Nerc_Cip_R5").FirstOrDefault();
        //        reportData.Nerc5Selected = nerc5rec == null ? false : nerc5rec.Selected;


        //        List<IQuestionPoco> commentMFRQuestions = analysisCollection.QuestionsWithCommentsOrMarkedForReview;
        //        List<IQuestionPoco> alternateJustificationQuestions = analysisCollection.QuestionsWithAlternateJustification;
        //        List<MainAnalysisDataObject> componentSummaryList = analysisCollection.ComponentResultsByCategoryGreenCollection.DataItemsDescending;
        //        List<MainAnalysisDataObject> rankedSubjectAreaList = analysisCollection.StandardsByCategoryRedCollection.DataItemsDescending;
        //        List<MainAnalysisDataObject> nercRankedSubjectAreaList = analysisCollection.NercRankedCategories.DataItemsDescending;
        //        List<QuestionPocoAndComponent> componentQuestions = analysisCollection.ComponentResultsSummaryCollection.ComponentStat.Totalq;



        //        reportData.HasComponentData = componentQuestions.Count > 0;

        //        Image diagramImage = diagramImageFactory.GetReportImage();

        //        if ((reportModel.AssessmentModel.NetworkModel != null))
        //        {
        //            reportData.DiagramHasItems = reportModel.AssessmentModel.NetworkModel.NetworkData.HasItems;
        //        }
        //        else
        //        {
        //            reportData.DiagramHasItems = false;
        //        }

        //        if (diagramImage == null)
        //        { // If no diagram then display No Diagram Image
        //            diagramImage = Image.FromFile(Path.Combine(globalProperties.Application_Path, Constants.REPORTS_NO_DIAGRAM_PATH));
        //        }
        //        diagramImage.RotateFlip(RotateFlipType.Rotate90FlipNone);

        //        foreach (INetworkAnalysisMessage m in reportModel.AssessmentModel.NetworkModel.UpdateAndGetDiagramAnalysisMessages())
        //        {
        //            reportData.NetworkWarnings.Add(new NetworkWarning()
        //            {
        //                Message = m.Message,
        //                MessageIdentifier = m.MessageIdentifier
        //            });
        //        }
        //        Dictionary<string, List<IQuestionPoco>> standardQuestions = analysisCollection.TopRankedStandardsResults.CategoryDictionary;

        //        StandardImageBuilder newpages = new StandardImageBuilder();

        //        reportData.StandardImages = newpages.AddStandardImages(
        //            analysisCollection.CategoryResultsWithStandardsForSeriesCollection.StandardsDictionary);
        //        // 
        //        //***********************************************************************************************************************************
        //        // Merge the Information Data
        //        reportData.MailMerges.Add(this.BuildInformationTable(assessmentContextHolder));
        //        // Document Library. Table: DocumentLibraryTable
        //        reportData.MailMerges.Add(this.BuildDocumentLibraryTable(documents));
        //        // Selected Standard Names. Table: StandardsTable
        //        reportData.MailMerges.Add(this.BuildStandardsTable(standardsList));
        //        // Security Assurance Level data. Table: OverallSALTable
        //        reportData.MailMerges.Add(this.BuildOverallSalTable(sals));
        //        //ReportsProgressBar.UpdateProgress("Creating Tables");
        //        // NIST SAL Data. Table: NISTSalTable
        //        reportData.MailMerges.Add(nistTable);

        //        NISTFrameworkTiers tiers = new NISTFrameworkTiers();
        //        reportData.MailMerges.AddRange(tiers.GetNistTables(assessmentContextHolder));
        //        //ReportsProgressBar.UpdateProgress("Creating Tables");
        //        // GEN SAL Data. Table: GENSalTable
        //        reportData.MailMerges.Add(this.BuildGenSalTable(genSalDataList));
        //        // For Marked for Review and Comments. Table: QuestionsWithCommentsTable
        //        DataTable comments = this.BuildCommentMFRQuestionsTable(commentMFRQuestions);
        //        WorkAroundSyncfusionMergeBug(comments);
        //        reportData.MailMerges.Add(comments);
        //        // Alternate Justification questions. Table: QuestionsWithAlternateJustificationsTable
        //        reportData.MailMerges.Add(this.BuildAlternateJustificationQuestionsTable(alternateJustificationQuestions));
        //        // Ranked Questions table. Table: RankedQuestionsTable
        //        if (reportModel.ActiveQuestionsManager.IsQuestionsMode)
        //        {
        //            rankedQuestions.WorkingQuestionPocoList = reportModel.ActiveQuestionsManager.SetRequirementForQuestions(rankedQuestions.WorkingQuestionPocoList).ToList();
        //        }
        //        DataTable rq = this.BuildRankedQuestionsTable(rankedQuestions);
        //        WorkAroundSyncfusionMergeBug(rq);
        //        reportData.MailMerges.Add(rq);
        //        DataTable nrq = this.BuildRankedNercQuestionsTable(nercRankedQuestions);
        //        WorkAroundSyncfusionMergeBug(nrq);
        //        reportData.MailMerges.Add(nrq);

        //        // Top Areas

        //        // Top requirments
        //        reportData.MailMerges.Add(this.GetDataTopRequirements(rankedQuestions, reportModel.AssessmentModel.StandardRepository.IsRequirementsMode));

        //        //ReportsProgressBar.UpdateProgress("Creating Tables");
        //        // Network Warnings                
        //        reportData.MailMerges.Add(this.GetNetworkWarningDetails(reportModel.AssessmentModel.NetworkModel.UpdateAndGetDiagramAnalysisMessages()));
        //        //ReportsProgressBar.UpdateProgress("Creating Tables");
        //        var selectedSets = context.REPORT_STANDARDS_SELECTION.Where(s => s.Is_Selected).Select(s => s.Report_Set_Entity_Name).ToList();
        //        standardQuestions = standardQuestions.Where(s => selectedSets.Contains(s.Key)).ToDictionary(s => s.Key, s => s.Value);
        //        // Create Standard Questions Data for Detail Report
        //        Dictionary<String, SETS> sets = setRepository.SetsDictionary;
        //        // Add standard document sections for each standard.
        //        if (standardQuestions != null)
        //        {
        //            var ds = new DataSet();

        //            DataTable standardsTable = new DataTable();
        //            standardsTable.TableName = "Standards";
        //            standardsTable.Columns.Add(cb.BuildTableColumn("StandardFullName"));
        //            standardsTable.Columns.Add(cb.BuildTableColumn("IsLast"));
        //            standardsTable.Columns.Add(cb.BuildTableColumn("SetName"));
        //            DataTable questionsTable = new DataTable();
        //            questionsTable.TableName = "Questions";

        //            // Create Columns
        //            questionsTable.Columns.Add(cb.BuildTableColumn("QNum"));
        //            questionsTable.Columns.Add(cb.BuildTableColumn("Question"));
        //            questionsTable.Columns.Add(cb.BuildTableColumn("Answer"));
        //            questionsTable.Columns.Add(cb.BuildTableColumn("SetName"));                // Iterate over the list of standard mappings and create tables for all the data
        //                                                                                       //ReportsProgressBar.AddToTotal(standardQuestions.Count);
        //            var isLast = 1;
        //            foreach (KeyValuePair<string, List<IQuestionPoco>> pair in standardQuestions)
        //            {
        //                if (standardQuestions.First().Key == pair.Key)
        //                {
        //                    isLast = 1;
        //                }
        //                else
        //                {
        //                    isLast = 0;
        //                }
        //                var row = standardsTable.NewRow();
        //                SETS set = sets[pair.Key];
        //                string standardFullName = set.Full_Name;
        //                row["StandardFullName"] = standardFullName;
        //                string setName = set.Set_Name.Replace(' ', '_');
        //                row["IsLast"] = isLast;

        //                row["SetName"] = setName;
        //                List<IQuestionPoco> questionList = pair.Value;
        //                this.BuildStandardQuestionsTable(setName, questionList, questionsTable);
        //                //ReportsProgressBar.UpdateProgress("Creating Charts"); 
        //                standardsTable.Rows.Add(row);
        //            }
        //            ds.Tables.Add(standardsTable);
        //            ds.Tables.Add(questionsTable);

        //            ArrayList SetPrintCommand = new ArrayList();
        //            DictionaryEntry entry;
        //            entry = new DictionaryEntry("Standards", String.Empty);
        //            SetPrintCommand.Add(entry);

        //            entry = new DictionaryEntry("Questions", "SetName = %Standards.SetName%");
        //            SetPrintCommand.Add(entry);
        //            reportData.NestedMailMerges.Add(new Tuple<DataSet, ArrayList>(ds, SetPrintCommand));
        //        }


        //        //build list of controls for security plan
        //        SecurityPlanDataBuilder builder = unityContainer.Resolve<SecurityPlanDataBuilder>();

        //        Tuple<DataSet, ArrayList> mergeset = builder.GetData();

        //        //create the zones list            
        //        reportData.MailMerges.Add(new ZoneListDataBuilder().BuildZoneList(reportModel));

        //        reportData.MailMerges.Add(this.BuildComponentQuestionsTable(componentQuestions));

        //        foreach (DataTable t in mergeset.Item1.Tables)
        //        {
        //            WorkAroundSyncfusionMergeBug(t);
        //        }
        //        reportData.NestedMailMerges.Add(mergeset);

        //        //build inventory of components list
        //        InventoryDataBuilder idb = new InventoryDataBuilder();
        //        Tuple<DataSet, ArrayList> inventory = idb.BuildInventoryList(reportModel.AssessmentModel);
        //        reportData.NestedMailMerges.Add(inventory);
        //        //build list of controls for security plan
        //        var componentFindingsBuilder = unityContainer.Resolve<ComponentsGapAnalysisDataBuilder>();

        //        Tuple<DataSet, ArrayList> componentFindingsSet = componentFindingsBuilder.GetData(componentQuestions.Where(s => s.QuestionPoco.IsAnswerFailed).ToList());
        //        reportData.NestedMailMerges.Add(componentFindingsSet);
        //        DiscoveriesTearoutSheetsDataBuilder findingsBuilder = unityContainer.Resolve<DiscoveriesTearoutSheetsDataBuilder>();

        //        Tuple<DataSet, ArrayList> findingsSet = findingsBuilder.GetData();
        //        reportData.NestedMailMerges.Add(findingsSet);

        //        //ReportsProgressBar.UpdateProgress("Creating Charts");

        //        // Create and replace the chart images
        //        // Chart images get created then after creating chart image, add it to the Report Image list
        //        //***************************************************************************************************************

        //        foreach (INoScreenRenderDataUpdate controlToUpdate in updateableControlsList)
        //        {
        //            controlToUpdate.updateDataOnControl(reportModel, analysisCollection);
        //        }

        //        List<ReportImage> reportImageList = new List<ReportImage>();
        //        ReportImageStateEnum topFive = ReportImageStateEnum.Executive;
        //        reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.PLACE_HOLDER_TOP10), topFiveConcerns, topFive));

        //        //NOTE THIS IMAGE REFERENCE IS THE SAME FOR BOTH SIDES OF THE REPORT (Questions and Requirments)
        //        //The last two pages in the template must refere to the same source image. 
        //        reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.AREAS_OF_CONCERN_QUESTIONS), areasOfConcern, ReportImageStateEnum.Executive));
        //        ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Charts Next");
        //        ReportImageStateEnum supportedReports = ReportImageStateEnum.Detail | ReportImageStateEnum.Executive
        //            | ReportImageStateEnum.SiteSummary | ReportImageStateEnum.Compare;
        //        ReportImageStateEnum page3Supported = ReportImageStateEnum.Executive | ReportImageStateEnum.SiteSummary | ReportImageStateEnum.Detail;
        //        reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.EXEC_REPORT_PG3)
        //     , evaluationAgainstStandardsAndQuestionSets, page3Supported));
        //        ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Charts");

        //        reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.OVERALL_SUMMARY_REPORT)
        //            , assessementcompliancebarchart, supportedReports));

        //        if (reportData.DiagramHasItems)
        //        {
        //            ReportImageStateEnum diagramSupported = ReportImageStateEnum.Executive | ReportImageStateEnum.SiteSummary | ReportImageStateEnum.Detail;
        //            ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Component Charts");
        //            reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.EXEC_REPORT_PG4),
        //         analysisOfNetworkComponents, diagramSupported));
        //        }
        //        ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Charts");


        //        // Component Compliance Chart
        //        if (reportData.DiagramHasItems)
        //        {
        //            componentsSummaryListControl.updateCSETData(componentSummaryList);
        //            ReportImageStateEnum compSummarySupported = ReportImageStateEnum.SiteSummary | ReportImageStateEnum.Detail;
        //            reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.PLACE_HOLDER_COMPONENT_SUMMARY)
        //         , componentsSummaryListControl, compSummarySupported));
        //            ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Charts Components Summary");
        //            ReportImageStateEnum diaSupported = ReportImageStateEnum.Detail | ReportImageStateEnum.SiteSummary | ReportImageStateEnum.SecurityPlan;
        //            //Diagram Chart
        //            reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.PLACE_HOLDER_COMPONENT_DIAGRAM), diagramImage, diaSupported));
        //            ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Diagram Image");
        //        }
        //        // Ranked Subject Areas chart   


        //        rankedSubjectAresControl.updateCSETData(rankedSubjectAreaList);
        //        StandardModeEnum reportMode = (StandardModeEnum)Enum.Parse(typeof(StandardModeEnum), "NISTFramework", true);
        //        if (reportData.StandardMode == reportMode)
        //        {
        //            rankedSubjectAresControl.TitleText.Text = Constants.RANKED_CYBERSECURITY_CATEGORIES_TITLE;
        //        }
        //        ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Ranked Subject Areas Chart");
        //        reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.PLACE_HOLDER_RANKED_SUBJECT_AREAS), rankedSubjectAresControl, ReportImageStateEnum.SiteSummary | ReportImageStateEnum.Detail));

        //        ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Nerc Ranked Subject Areas Chart");
        //        rankedNercSubjectAreasControl.updateCSETData(nercRankedSubjectAreaList);
        //        reportImageList.Add(new ReportImage(Path.Combine(reportData.ApplicationPath, Constants.PLACE_HOLDER_NERC_RANKED_SUBJECT_AREAS), rankedNercSubjectAreasControl, ReportImageStateEnum.SiteSummary | ReportImageStateEnum.Detail));

        //        //}
        //        //***************************************************************************************************************
        //        ProgressBarControl.getInstance(ProgressBars.Reports).SetTotal(reportImageList.Count);
        //        foreach (ReportImage i in reportImageList)
        //        {
        //            reportData.ReplacementImages.Add(i.GetImageHash());
        //            ProgressBarControl.getInstance(ProgressBars.Reports).UpdateProgress("Creating Images");
        //        }

        //        reportData.HasStandards = standardsList.Count > 0;
        //    }
        //    return reportData;
        //}

        /// <summary>
        /// Populates a datatable with the INFORMATION data
        /// </summary>
        /// <returns></returns>
        protected DataTable BuildInformationTable(CSET_Context context)
        {

            int indexCtr = 0;
            DataTable table = new DataTable();
            table.Columns.Add(cb.BuildTableColumn("Assessment_Name"));
            table.Columns.Add(cb.BuildTableColumn("Assessment_Date"));
            table.Columns.Add(cb.BuildTableColumn("Facility_Name"));
            table.Columns.Add(cb.BuildTableColumn("City_Or_Site_Name"));
            table.Columns.Add(cb.BuildTableColumn("State_Province_Or_Region"));
            table.Columns.Add(cb.BuildTableColumn("Assessor_Name"));
            table.Columns.Add(cb.BuildTableColumn("Assessor_Email"));
            table.Columns.Add(cb.BuildTableColumn("Assessor_Phone"));
            table.Columns.Add(cb.BuildTableColumn("Assessment_Description"));
            table.Columns.Add(cb.BuildTableColumn("Additional_Notes_And_Comments"));
            table.Columns.Add(cb.BuildTableColumn("Additional_Contacts"));
            table.Columns.Add(cb.BuildTableColumn("Executive_Summary"));
            table.Columns.Add(cb.BuildTableColumn("Enterprise_Evaluation_Summary"));
            table.Columns.Add(cb.BuildTableColumn("Real_Property_Unique_Id"));
            table.Columns.Add(cb.BuildTableColumn("eMass_Document_Path"));
            table.Columns.Add(cb.BuildTableColumn("eMass_Document_Title"));
            table.TableName = "INFORMATION";
            foreach (INFORMATION info in context.INFORMATION)
            {
                DataRow row = table.NewRow();
                row["Assessment_Name"] = info.Assessment_Name;
                //row["Assessment_Date"] = info.Assessment_Date == null ? "" : ((DateTime)info.Assessment_Date).ToString("d");
                row["Facility_Name"] = info.Facility_Name;
                row["City_Or_Site_Name"] = info.City_Or_Site_Name;
                row["State_Province_Or_Region"] = info.State_Province_Or_Region;
                row["Assessor_Name"] = info.Assessor_Name;
                row["Assessor_Email"] = info.Assessor_Email;
                row["Assessor_Phone"] = info.Assessor_Phone;
                row["Assessment_Description"] = info.Assessment_Description;
                row["Additional_Notes_And_Comments"] = info.Additional_Notes_And_Comments;
                row["Additional_Contacts"] = info.Additional_Contacts;
                row["Executive_Summary"] = info.Executive_Summary;
                row["Enterprise_Evaluation_Summary"] = info.Enterprise_Evaluation_Summary;
                row["Real_Property_Unique_Id"] = info.Real_Property_Unique_Id;
                if (info.eMass_Document_Id.HasValue)
                {
                    indexCtr = info.eMass_Document_.Path.LastIndexOf("\\");
                    if (indexCtr < 0)
                    {
                        row["eMass_Document_Path"] = info.eMass_Document_.Path;
                    }
                    else
                    {
                        row["eMass_Document_Path"] = info.eMass_Document_.Path.Substring(indexCtr + 1);
                    }
                    row["eMass_Document_Title"] = info.eMass_Document_.Title;
                }
                else
                {
                    row["eMass_Document_Path"] = "";
                    row["eMass_Document_Title"] = "";
                }
                //var contacts = context.CONTACTs.OrderBy(s=>s.LastName).ThenBy(s=>s.FirstName).Select(s=>new { s.FirstName,s.LastName,s.JobTitle,s.Organization,s.PrimaryEmail, OfficePhone=s.OfficePhone??s.CellPhone  }).ToList();
                //if(contacts.Any())
                //{
                //    var crlf = System.Environment.NewLine;
                //    row["Additional_Contacts"] = string.Join(crlf + crlf, contacts.Select(s => 
                //    string.Format("{0} {1}{2}{3}{4}{5}{6}{7}{8}{9}", s.FirstName?.Trim(), s.LastName?.Trim(), 
                //    String.IsNullOrWhiteSpace(s.JobTitle)?String.Empty:crlf, s.JobTitle?.Trim(), 
                //    String.IsNullOrWhiteSpace(s.Organization) ? String.Empty : crlf, s?.Organization, 
                //    String.IsNullOrWhiteSpace(s.OfficePhone) ? String.Empty : crlf, s?.OfficePhone,
                //    String.IsNullOrWhiteSpace(s.PrimaryEmail) ? String.Empty : crlf, s?.PrimaryEmail)));
                //}
                table.Rows.Add(row);
            }

            WorkAroundSyncfusionMergeBug(table);
            if (table.Rows.Count > 0)
            {
                if (!table.Rows[0]["Executive_Summary"].ToString().StartsWith("\r\n"))
                    table.Rows[0]["Executive_Summary"] = "\r\n" + table.Rows[0]["Executive_Summary"];
                if (!table.Rows[0]["Assessment_Description"].ToString().StartsWith("\r\n"))
                    table.Rows[0]["Assessment_Description"] = "\r\n" + table.Rows[0]["Assessment_Description"];
            }

            return table;
        }

        protected void WorkAroundSyncfusionMergeBug(DataTable t)
        {
            foreach (DataColumn c in t.Columns)
            {
                if (c.DataType == System.Type.GetType("System.String"))
                    foreach (DataRow r in t.Rows)
                    {
                        if (r[c] != System.DBNull.Value)
                            if (((String)r[c]).Contains("\r\n"))
                                r[c] = "\r\n" + r[c];
                    }
            }

        }

        /// <summary>
        /// Builds the data table for the reports that contain all user documents
        /// </summary>
        /// <param name="documents"></param>
        /// <returns></returns>
        protected DataTable BuildDocumentLibraryTable(List<DOCUMENT_FILE> documents)
        {
            DataTable table = new DataTable();
            table.TableName = "DocumentLibraryTable";

            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("FileName"));
            table.Columns.Add(cb.BuildTableColumn("DocumentTitle"));

            if (documents != null)
            {
                if (documents.Count > 0)
                {
                    foreach (DOCUMENT_FILE document in documents)
                    {
                        DataRow row = table.NewRow();
                        String fileName = Path.GetFileName(document.Path);
                        row["FileName"] = fileName;
                        row["DocumentTitle"] = document.Title;
                        table.Rows.Add(row);
                    }
                }
                else
                {
                    cb.WriteEmptyMessage(table, "FileName", "There are no documents to display.");
                }
            }
            else
            {
                cb.WriteEmptyMessage(table, "FileName", "There are no documents to display.");
            }
            return table;
        }

        /// <summary>
        /// Builds the standard questions data table for the Detail report
        /// </summary>
        /// <param name="standardsList"></param>
        /// <returns></returns>
        protected DataTable BuildStandardQuestionsTable(string setName, List<IQuestionPoco> questionsByStandardList, DataTable table)
        {
            
            foreach (QuestionPoco question in questionsByStandardList)
            {
                DataRow row = table.NewRow();
                row["QNum"] = question.CategoryAndQuestionNumber;
                row["Question"] = question.TextWithParameters;
                row["Answer"] = this.GetFullAnswer(question.QuestionAnswer);
                row["SetName"] = setName;
                table.Rows.Add(row);
            }
            return table;
        }

        //protected DataTable BuildComponentQuestionsTable(List<QuestionPocoAndComponent> componentQuestionsList)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "Components";


        //    // Create Columns
        //    table.Columns.Add(cb.BuildTableColumn("CName"));
        //    table.Columns.Add(cb.BuildTableColumn("Question"));
        //    table.Columns.Add(cb.BuildTableColumn("Answer"));
        //    table.Columns.Add(cb.BuildTableColumn("SAL"));
        //    table.Columns.Add(cb.BuildTableColumn("Zone"));
        //    List<QuestionPocoAndComponent> ordered = componentQuestionsList.OrderBy(a => a.Component.ComponentTypeDisplayName).ThenBy(x => x.Component.TextNodeLabel).ThenBy(y => y.QuestionPoco.RankNumber).ToList();
        //    foreach (QuestionPocoAndComponent question in ordered)
        //    {
        //        DataRow row = table.NewRow();
        //        int rank = question.QuestionPoco.RankNumber;
        //        row["CName"] = question.Component.TextNodeLabel + " - " + question.Component.ComponentTypeDisplayName;
        //        row["Question"] = question.QuestionPoco.Text;
        //        row["SAL"] = question.Component.SAL.Selected_Sal_Level;
        //        row["Zone"] = question.Component.ComponentZoneLabel;
        //        row["Answer"] = this.GetFullAnswer(question.QuestionPoco.QuestionAnswer);
        //        table.Rows.Add(row);
        //    }
        //    return table;
        //}


        /// <summary>
        /// Builds the data table for the reports that contain all the selected standard names
        /// </summary>
        /// <param name="standardsList"></param>
        /// <returns></returns>
        //protected DataTable BuildStandardsTable(List<StandardColor> standardsList)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "StandardsTable";

        //    // Create Columns
        //    table.Columns.Add(cb.BuildTableColumn("StandardName"));

        //    foreach (StandardColor standard in standardsList)
        //    {
        //        DataRow row = table.NewRow();
        //        row["StandardName"] = standard.StandardName;
        //        table.Rows.Add(row);
        //    }
        //    return table;
        //}

        /// <summary>
        /// Builds the data table for the reports that contain the overall SAL.
        /// </summary>
        /// <param name="sal"></param>
        /// <returns></returns>
        protected DataTable BuildOverallSalTable(OverallSalObject salData)
        {
            DataTable table = new DataTable();
            table.TableName = "OverallSALTable";

            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("OSV"));
            table.Columns.Add(cb.BuildTableColumn("Q_AV"));
            table.Columns.Add(cb.BuildTableColumn("Q_CV"));
            table.Columns.Add(cb.BuildTableColumn("Q_IV"));

            if (!string.IsNullOrWhiteSpace(salData.Selected_Sal_Level))
            {
                DataRow row = table.NewRow();
                row["OSV"] = salData.Selected_Sal_Level;
                row["Q_AV"] = salData.Availability_Level;
                row["Q_CV"] = salData.Confidence_Level;
                row["Q_IV"] = salData.Integrity_Level;
                table.Rows.Add(row);
            }
            else
            {
                cb.WriteEmptyMessage(table, "OverallSALValue", "There is no SAL to display.");
            }
            return table;
        }

        /// <summary>
        /// Builds the data table for the reports that contain the data from the Gen Sal wizard
        /// </summary>
        /// <param name="genSalDataList"></param>
        /// <returns></returns>
        protected DataTable BuildGenSalTable(List<GEN_SAL_WEIGHTS> genSalDataList)
        {
            DataTable table = new DataTable();
            table.TableName = "GenSALTable";
            DataRow row = table.NewRow();
            foreach (GEN_SAL_WEIGHTS genSalDataObject in genSalDataList)
            {
                // Create Columns
                DataColumn column = cb.BuildTableColumn(genSalDataObject.Sal_Name);
                table.Columns.Add(column);

                row[genSalDataObject.Sal_Name] = genSalDataObject.Display;
            }
            table.Rows.Add(row);
            return table;
        }

        ///// <summary>
        ///// Builds the data table for the reports that contain the data from the NIST wizard
        ///// </summary>
        ///// <param name="nistSalDataList"></param>
        ///// <returns></returns>
        //protected DataTable BuildNISTSalTable(MainSalControlViewModel nistDataObject)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "NISTSALTable";

        //    // Create Columns
        //    table.Columns.Add(cb.BuildTableColumn("Q_AV"));
        //    table.Columns.Add(cb.BuildTableColumn("Q_CV"));
        //    table.Columns.Add(cb.BuildTableColumn("Q_IV"));
        //    table.Columns.Add(cb.BuildTableColumn("IT_AV"));
        //    table.Columns.Add(cb.BuildTableColumn("IT_CV"));
        //    table.Columns.Add(cb.BuildTableColumn("IT_IV"));

        //    DataRow row = table.NewRow();
        //    if (nistDataObject != null)
        //    {
        //        nistDataObject.SetSALLevels(); 
        //        row["Q_AV"] = (nistDataObject.QuestionsAvailabilityValue != null) ? nistDataObject.QuestionsAvailabilityValue : "Unavailable";
        //        row["Q_CV"] = (nistDataObject.QuestionsConfidentialityValue != null) ? nistDataObject.QuestionsConfidentialityValue : "Unavailable";
        //        row["Q_IV"] = (nistDataObject.QuestionsIntegrityValue != null) ? nistDataObject.QuestionsIntegrityValue : "Unavailable";
        //        row["IT_AV"] = (nistDataObject.InfoTypeAvailabilityValue != null) ? nistDataObject.InfoTypeAvailabilityValue : "Unavailable";
        //        row["IT_CV"] = (nistDataObject.InfoTypeConfidentialityValue != null) ? nistDataObject.InfoTypeConfidentialityValue : "Unavailable";
        //        row["IT_IV"] = (nistDataObject.InfoTypeIntegrityValue != null) ? nistDataObject.InfoTypeIntegrityValue : "Unavailable";
        //    }
        //    else
        //    {
        //        row["Q_AV"] = "Unavailable";
        //        row["Q_CV"] = "Unavailable";
        //        row["Q_IV"] = "Unavailable";
        //        row["IT_AV"] = "Unavailable";
        //        row["IT_CV"] = "Unavailable";
        //        row["IT_IV"] = "Unavailable";
        //    }
        //    table.Rows.Add(row);

        //    return table;
        //}

        /// <summary>
        /// Builds the data table for the reports that contain the data from the NIST wizard
        /// </summary>
        /// <param name="nistSalDataList"></param>
        /// <returns></returns>
        //private DataTable BuildCNSSSalTable(CSET_Context assessmentFileEntities, MainSalControlViewModel nistDataObject)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "CNSSSALTable";

        //    // Create Columns
        //    table.Columns.Add(cb.BuildTableColumn("Q_AV"));
        //    table.Columns.Add(cb.BuildTableColumn("Q_CV"));
        //    table.Columns.Add(cb.BuildTableColumn("Q_IV"));
        //    table.Columns.Add(cb.BuildTableColumn("IT_AV"));
        //    table.Columns.Add(cb.BuildTableColumn("IT_CV"));
        //    table.Columns.Add(cb.BuildTableColumn("IT_IV"));

        //    DataRow row = table.NewRow();
        //    if (nistDataObject != null)
        //    {
        //        nistDataObject.SetSALLevels(); // TODO: Want to get data from DB and calculate to get current levels
        //        row["Q_AV"] = assessmentFileEntities.CNSS_CIA_JUSTIFICATIONS.Where(x => x.CIA_Type == Constants.Availabilty).First().DropDownValue;
        //        row["Q_CV"] = assessmentFileEntities.CNSS_CIA_JUSTIFICATIONS.Where(x => x.CIA_Type == Constants.Confidentiality).First().DropDownValue;
        //        row["Q_IV"] = assessmentFileEntities.CNSS_CIA_JUSTIFICATIONS.Where(x => x.CIA_Type == Constants.Integrity).First().DropDownValue;
        //        row["IT_AV"] = (nistDataObject.InfoTypeAvailabilityValue != null) ? nistDataObject.InfoTypeAvailabilityValue : "Unavailable";
        //        row["IT_CV"] = (nistDataObject.InfoTypeConfidentialityValue != null) ? nistDataObject.InfoTypeConfidentialityValue : "Unavailable";
        //        row["IT_IV"] = (nistDataObject.InfoTypeIntegrityValue != null) ? nistDataObject.InfoTypeIntegrityValue : "Unavailable";
        //    }
        //    else
        //    {
        //        row["Q_AV"] = "Unavailable";
        //        row["Q_CV"] = "Unavailable";
        //        row["Q_IV"] = "Unavailable";
        //        row["IT_AV"] = "Unavailable";
        //        row["IT_CV"] = "Unavailable";
        //        row["IT_IV"] = "Unavailable";
        //    }
        //    table.Rows.Add(row);

        //    return table;
        //}

        private DataTable BuildCNSSSALJustificationTable(CSET_Context assessmentFileEntities)
        {
            DataTable table = new DataTable();
            table.TableName = "CNSSSALJustificationsTable";

            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("CIA_Type"));
            table.Columns.Add(cb.BuildTableColumn("Justification"));

            foreach (CNSS_CIA_JUSTIFICATIONS cia in assessmentFileEntities.CNSS_CIA_JUSTIFICATIONS)
            {
                DataRow row = table.NewRow();
                row["CIA_Type"] = cia.CIA_Type;
                row["Justification"] = cia.Justification;
                table.Rows.Add(row);
            }

            return table;
        }

        /// <summary>
        /// Builds the data table for the reports that contain the DOD Confidentiality Level and the MAC Level.
        /// </summary>
        /// <returns></returns>
        private DataTable BuildDODSalTable(OverallSalObject levelEntities)
        {
            DataTable table = new DataTable();
            table.TableName = "DODSALTable";

            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("DOD_Level"));
            table.Columns.Add(cb.BuildTableColumn("MAC_Level"));

            DataRow row = table.NewRow();
            String tmpLevel = levelEntities.Dod_Conf_Level;
            String dodCLevel = "Unavailable";
            if (tmpLevel != null && tmpLevel != "")
            {
                if (tmpLevel == "C")
                    dodCLevel = "Classified";
                if (tmpLevel == "S")
                    dodCLevel = "Sensitive";
                if (tmpLevel == "P")
                    dodCLevel = "Public";
            }

            row["DOD_Level"] = dodCLevel;
            row["MAC_Level"] = levelEntities.Dod_Mac_Level == null ? "Unavailable" : levelEntities.Dod_Mac_Level;
            table.Rows.Add(row);

            return table;
        }

        /// <summary>
        /// Builds the data table for the reports that contain the ranked questions
        /// </summary>
        /// <param name="rankedQuestions"></param>
        /// <returns></returns>
        //protected DataTable BuildRankedQuestionsTable(AnalysisResult rankedQuestions)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "RankedQuestionsTable";

        //    table.Columns.Add(cb.BuildTableColumn("Rank"));
        //    table.Columns.Add(cb.BuildTableColumn("CategoryAndNumber"));
        //    table.Columns.Add(cb.BuildTableColumn("Question"));
        //    table.Columns.Add(cb.BuildTableColumn("Answer"));
        //    table.Columns.Add(cb.BuildTableColumn("Level"));

        //    if (rankedQuestions.WorkingQuestionPocoList.Count > 0)
        //    {
        //        var v = rankedQuestions.WorkingQuestionPocoList.OrderBy(r => r.RankNumber);

        //        foreach (QuestionPoco question in v)
        //        {
        //            DataRow row = table.NewRow();
        //            bool isRequirementsMode = (question.IsRequirement && question.NEW_REQUIREMENT != null);
        //            string questionNumberWithStandard = question.CategoryAndQuestionNumberWithStandard;
        //            row["Rank"] = (question.RankNumber.ToString().Trim().Length > 0) ? question.RankNumber.ToString() : "--";

        //            String catNumber = (questionNumberWithStandard.ToString().Trim().Length > 0) ? questionNumberWithStandard : "--";
        //            if (question.IsFramework)
        //            {
        //                catNumber = question.ProfileCategory.FunctionName + " " + questionNumberWithStandard;
        //            }
        //            row["CategoryAndNumber"] = catNumber;
        //            row["Question"] = question.TextWithParameters;
        //            row["Answer"] = this.GetFullAnswer(question.QuestionAnswer);

                    
        //            string levels = "";
        //            if (isRequirementsMode)
        //            {
        //                List<REQUIREMENT_LEVELS> requirementsLevels = question.NEW_REQUIREMENT.REQUIREMENT_LEVELS.ToList();
        //                LevelsHandler lvl = new LevelsHandler();
        //                levels = lvl.ProcessLevelsList(requirementsLevels);

        //            }
        //            else
        //            {
        //                levels = question.Level;
        //            }

        //            row["Level"] = levels;
        //            table.Rows.Add(row);
        //        }
        //    }
        //    else
        //    {
        //        cb.WriteEmptyMessage(table, "Question", "There are no ranked questions to display.");
        //    }
        //    return table;
        //}
        //protected DataTable BuildRankedNercQuestionsTable(AnalysisResult rankedQuestions)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "NERCRankedQuestionsTable";

        //    table.Columns.Add(cb.BuildTableColumn("Rank"));
        //    table.Columns.Add(cb.BuildTableColumn("CategoryAndNumber"));
        //    table.Columns.Add(cb.BuildTableColumn("Question"));
        //    table.Columns.Add(cb.BuildTableColumn("Answer"));
        //    table.Columns.Add(cb.BuildTableColumn("Level"));

        //    if (rankedQuestions.WorkingQuestionPocoList.Count > 0)
        //    {
        //        var v = rankedQuestions.WorkingQuestionPocoList.OrderBy(r => r.NercRankNumber);
        //        foreach (QuestionPoco question in v)
        //        {
        //            DataRow row = table.NewRow();
        //            bool isRequirementsMode = (question.IsRequirement && question.NEW_REQUIREMENT != null);
        //            string questionNumberWithStandard = question.CategoryAndQuestionNumberWithStandard;
        //            row["Rank"] = (question.NercRankNumber.ToString().Trim().Length > 0) ? question.NercRankNumber.ToString() : "--";

        //            String catNumber = (questionNumberWithStandard.ToString().Trim().Length > 0) ? questionNumberWithStandard : "--";
        //            if (question.IsFramework)
        //            {
        //                catNumber = question.ProfileCategory.FunctionName + " " + questionNumberWithStandard;
        //            }
        //            row["CategoryAndNumber"] = catNumber;
        //            row["Question"] = question.TextWithParameters;
        //            row["Answer"] = this.GetFullAnswer(question.QuestionAnswer);
                                        
        //            string levels = "";
        //            if (isRequirementsMode)
        //            {
        //                List<REQUIREMENT_LEVELS> requirementsLevels = question.NEW_REQUIREMENT.REQUIREMENT_LEVELS.ToList();
        //                LevelsHandler lvl = new LevelsHandler();
        //                levels = lvl.ProcessLevelsList(requirementsLevels);

        //            }
        //            else
        //            {
        //                levels = question.Level;
        //            }

        //            row["Level"] = levels;
        //            table.Rows.Add(row);
        //        }
        //    }
        //    else
        //    {
        //        cb.WriteEmptyMessage(table, "Question", "There are no questions to display.");
        //    }
        //    return table;
        //}


        /// <summary>
        /// Builds the data table for the reports that contain all questions with alternate justifications
        /// </summary>
        /// <param name="alternateJustificationQuestions"></param>
        /// <returns></returns>
        protected DataTable BuildAlternateJustificationQuestionsTable(List<IQuestionPoco> alternateJustificationQuestions)
        {
            DataTable table = new DataTable();
            table.TableName = "QuestionsWithAlternateJustificationsTable";

            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("CategoryAndNumber"));
            table.Columns.Add(cb.BuildTableColumn("Question"));
            table.Columns.Add(cb.BuildTableColumn("Answer"));
            table.Columns.Add(cb.BuildTableColumn("AlternateJustification"));

            if (alternateJustificationQuestions.Count > 0)
            {
                foreach (QuestionPoco question in alternateJustificationQuestions)
                {
                    DataRow row = table.NewRow();
                    row["CategoryAndNumber"] = question.CategoryAndQuestionNumber;
                    row["Question"] = question.Text;
                    row["Answer"] = this.GetFullAnswer(question.QuestionAnswer);
                    row["AlternateJustification"] = question.Answer.Alternate_Justification;
                    table.Rows.Add(row);
                }
                WorkAroundSyncfusionMergeBug(table);
            }
            else
            {
                cb.WriteEmptyMessage(table, "Question", "There are no questions with alternate justifications to display.");
            }

            return table;
        }

        /// <summary>
        /// Builds the data table for the reports that contain all questions with comments and/or are marked for review
        /// </summary>
        /// <returns></returns>
        protected DataTable BuildCommentMFRQuestionsTable(List<IQuestionPoco> commentMFRQuestionData)
        {
            DataTable table = new DataTable();
            table.TableName = "QuestionsWithCommentsTable";

            // Create Columns
            table.Columns.Add(cb.BuildTableColumn("CategoryAndNumber"));
            table.Columns.Add(cb.BuildTableColumn("Question"));
            table.Columns.Add(cb.BuildTableColumn("Answer"));
            table.Columns.Add(cb.BuildTableColumn("Comment"));
            table.Columns.Add(cb.BuildTableColumn("MarkedForReview"));

            if (commentMFRQuestionData.Count > 0)
            {
                foreach (QuestionPoco question in commentMFRQuestionData)
                {
                    DataRow row = table.NewRow();
                    row["CategoryAndNumber"] = question.CategoryAndQuestionNumber;
                    row["Question"] = question.Text;
                    row["Answer"] = this.GetFullAnswer(question.QuestionAnswer);
                    row["Comment"] = question.Comment;
                    row["MarkedForReview"] = (question.Mark_For_Review == true) ? "-- MARKED FOR REVIEW" : "";
                    table.Rows.Add(row);
                }
            }
            else
            {
                cb.WriteEmptyMessage(table, "Question", "There are no questions with comments to display.");
            }
            return table;
        }
        //protected DataTable GetDataTopRequirements(AnalysisResult analysisResult, Boolean isRequriementMode)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "TopRequirements";

        //    table.Columns.Add(cb.BuildTableColumn("Title"));

        //    for (int i = 1; i < 6; i++)
        //    {
        //        table.Columns.Add(cb.BuildTableColumn("A" + i.ToString()));
        //    }

        //    List<QuestionPoco> topList = new List<QuestionPoco>();
        //    HashSet<int> seenIds = new HashSet<int>();
        //    foreach (QuestionPoco qp in analysisResult.WorkingQuestionPocoList)
        //    {
        //        if (!seenIds.Contains(qp.Question_or_Requirement_ID))
        //        {
        //            seenIds.Add(qp.Question_or_Requirement_ID);
        //            topList.Add(qp);
        //        }
        //        if (topList.Count >= 5)
        //            break;

        //    }

        //    topFiveConcerns = new TopFiveConcerns(topList);

        //    DataRow row = table.NewRow();
        //    int qnum = 1;
        //    foreach (QuestionPoco qp in topList)
        //    {
        //        String tstring = qp.Text;
        //        tstring = tstring.Replace("\r\n", "\n");
        //        tstring = tstring.Replace('\n', (char)141);
        //        row["A" + qnum] = tstring;
        //        qnum++;
        //    }
        //    if (isRequriementMode)
        //    {
        //        row["Title"] = "Top Requirements of Concern";
        //    }
        //    else
        //    {
        //        row["Title"] = "Top Questions of Concern";
        //    }

        //    table.Rows.Add(row);
        //    return table;
        //}

        ///// <summary>
        ///// Fills a data table with the network warning detail data if any.
        ///// </summary>
        ///// <param name="networkWarningObject"></param>
        ///// <returns></returns>
        //protected DataTable GetNetworkWarningDetails(List<INetworkAnalysisMessage> listDiagramAnalysiMessages)
        //{
        //    DataTable table = new DataTable();
        //    table.TableName = "NetworkWarningDetails";

        //    table.Columns.Add(cb.BuildTableColumn("NetworkWarningID"));
        //    table.Columns.Add(cb.BuildTableColumn("NetworkWarningMessage"));

        //    if (listDiagramAnalysiMessages.Count > 0)
        //    {
        //        foreach (INetworkAnalysisMessage message in listDiagramAnalysiMessages)
        //        {
        //            DataRow row = table.NewRow();
        //            row["NetworkWarningID"] = message.MessageIdentifier;
        //            row["NetworkWarningMessage"] = String.IsNullOrWhiteSpace(message.Message) ? "" : message.Message.Trim();
        //            table.Rows.Add(row);
        //        }
        //    }
        //    else
        //    {
        //        DataRow row = table.NewRow();
        //        row["NetworkWarningID"] = "";
        //        row["NetworkWarningMessage"] = "There are no findings or recommendations to display.";
        //        table.Rows.Add(row);
        //    }

        //    return table;
        //}

        protected string GetFullAnswer(AnswerEnum answer)
        {
            String answerString = "";
            switch (answer)
            {
                case AnswerEnum.YES:
                    answerString = "Yes";
                    break;
                case AnswerEnum.NO:
                    answerString = "No";
                    break;
                case AnswerEnum.NA:
                    answerString = "N/A";
                    break;
                case AnswerEnum.ALT:
                    answerString = "Alternate";
                    break;
                case AnswerEnum.UNANSWERED:
                    answerString = "Unanswered";
                    break;
                default:
                    answerString = "Unknown";
                    break;
            }
            return answerString;
        }

    }
}


