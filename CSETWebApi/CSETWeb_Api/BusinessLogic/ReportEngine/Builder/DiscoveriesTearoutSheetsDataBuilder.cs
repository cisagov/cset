//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.ReportEngine.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;


namespace CSET_Main.ReportEngine.Builder
{
    public class DiscoveriesTearoutSheetsDataBuilder
    {
        //private DataHandling cb = new DataHandling();
        //private IEnumerable<IQuestionPoco> questions;
        //private IQueryable<FINDING_CONTACT> findingContacts;
        //private IQueryable<FINDING> findings;
       
        //public DiscoveriesTearoutSheetsDataBuilder(IReportModel reportModel, IAssessmentContextHolder assessmentContext):
        //    this(reportModel?.ActiveQuestionsManager?.ActiveQuestionData?.GetRootTree()?.QuestionList,assessmentContext?.AssessmentContext?.FINDING_CONTACT, assessmentContext?.AssessmentContext?.FINDING)
        //{
        //}
        //public DiscoveriesTearoutSheetsDataBuilder(IEnumerable<IQuestionPoco> questions, IQueryable<FINDING_CONTACT> findingContacts, IQueryable<FINDING> findings)
        //{
        //    this.findingContacts = findingContacts;
        //    this.questions = questions;
        //    this.findings = findings;
        //}


        //public Tuple<DataSet, ArrayList> GetData()
        //{
        //    String Individual_Table_Name = "Individuals";
        //    String Finding_Table_Name = "Findings";
        //    DataTable individualsTable = new DataTable();
        //    individualsTable.TableName = Individual_Table_Name;

        //    // Create Columns
        //    individualsTable.Columns.Add(cb.BuildTableColumn("IndividualFullName"));
        //    individualsTable.Columns.Add(cb.BuildTableColumn("IndividualLastFirst"));
        //    individualsTable.Columns.Add(cb.BuildTableColumn("IndividualId"));

        //    DataTable findingsTable = new DataTable();
        //    findingsTable.TableName = Finding_Table_Name;
        //    findingsTable.Columns.Add(cb.BuildTableColumn("IndividualId"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("Finding"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("Issue"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("Recommendations"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("ResolutionDate"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("OtherContacts"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("Importance"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("Vulnerabilities"));
        //    findingsTable.Columns.Add(cb.BuildTableColumn("Impact"));
        //    var answerIds=questions.Where(s => s.FindingCount > 0).Select(s=>s.Answer.Answer_Id).ToList();
        //    var individuals=findingContacts.Where(s => answerIds.Contains(s.FINDING.Answer_Id))
        //                                    .Select(s=>new
        //                                    {
        //                                        s.CONTACT.FirstName,
        //                                        s.CONTACT.LastName,
        //                                        IndividualId=s.Assessment_Contact_Id,
        //                                        Finding=s.FINDING.Summary,
        //                                        s.FINDING.Issue,
        //                                        s.FINDING.Recommendations,
        //                                        ResolutionDate=s.FINDING.Resolution_Date,
        //                                        OtherContacts=s.FINDING.FINDING_CONTACT.Select(sc=>sc.CONTACT).Where(c=>c.Id!=s.Assessment_Contact_Id).OrderBy(es=>es.LastName).ThenBy(es=>es.FirstName).Select(sc=>sc.FirstName+" "+sc.LastName),
        //                                        Importance=s.FINDING.IMPORTANCE.Value,
        //                                        s.FINDING.Vulnerabilities,
        //                                        s.FINDING.Impact}).GroupBy(s=>new { s.IndividualId, s.FirstName, s.LastName }).OrderBy(s=>s.Key.LastName).ThenBy(s=>s.Key.FirstName).ToList();

        //    var otherFindings = findings.Where(s => answerIds.Contains(s.Answer_Id) && !s.FINDING_CONTACT.Any()).Select(s => new
        //    {
        //        FirstName = "Unassigned",
        //        LastName = "",
        //        IndividualId = new Guid(),
        //        Finding = s.Summary,
        //        s.Issue,
        //        s.Recommendations,
        //        ResolutionDate = s.Resolution_Date,
        //        OtherContacts = s.FINDING_CONTACT.Select(sc => sc.CONTACT.FirstName + " " + sc.CONTACT.LastName),
        //        Importance = s.IMPORTANCE.Value,
        //        s.Vulnerabilities,
        //        s.Impact
        //    }).GroupBy(s => new { s.IndividualId, s.FirstName, s.LastName }).ToList();
        //    if(otherFindings.Any())
        //    {
        //        individuals.Add(otherFindings[0]);
        //    }
        //    var ds = new DataSet();
        //    var provider = new RtfFormatProvider();
        //    var docxProvider = new TxtFormatProvider();
        //    foreach (var individual in individuals)
        //    {
        //        var individualRow=individualsTable.NewRow();
        //        individualRow["IndividualFullName"] = individual.Key.FirstName+" "+individual.Key.LastName;
        //        individualRow["IndividualLastFirst"] = individual.Key.LastName + ", " + individual.Key.FirstName;
        //        individualRow["IndividualId"] = individual.Key.IndividualId;
        //        individualsTable.Rows.Add(individualRow);
        //        foreach(var finding in individual)
        //        {
        //            var findingsRow = findingsTable.NewRow();
        //            findingsRow["IndividualId"]=finding.IndividualId;
        //            findingsRow["Finding"]=finding.Finding;
        //            findingsRow["Issue"]= String.IsNullOrEmpty(finding.Issue) ? "" : docxProvider.Export(provider.Import(finding.Issue));
        //            findingsRow["Recommendations"]= String.IsNullOrEmpty(finding.Recommendations) ? "" : docxProvider.Export(provider.Import(finding.Recommendations));
        //            findingsRow["ResolutionDate"]=finding.ResolutionDate;
        //            findingsRow["OtherContacts"]=String.Join("\n",finding.OtherContacts);
        //            findingsRow["Importance"]=finding.Importance;
        //            findingsRow["Vulnerabilities"]= String.IsNullOrEmpty(finding.Vulnerabilities) ? "" : docxProvider.Export(provider.Import(finding.Vulnerabilities));
        //            findingsRow["Impact"]= String.IsNullOrEmpty(finding.Impact) ? "" : docxProvider.Export(provider.Import(finding.Impact));
        //            findingsTable.Rows.Add(findingsRow);
        //        }
        //    }
        //    individualsTable.DefaultView.Sort = "IndividualLastFirst";
        //    ds.Tables.Add(individualsTable);
        //    ds.Tables.Add(findingsTable);

        //    ArrayList SetPrintCommand = new ArrayList();
        //    DictionaryEntry entry;
        //    entry = new DictionaryEntry(Individual_Table_Name, String.Empty);
        //    SetPrintCommand.Add(entry);

        //    entry = new DictionaryEntry(Finding_Table_Name, "IndividualId = %" + Individual_Table_Name + ".IndividualId%");
        //    SetPrintCommand.Add(entry);
            
        //    return new Tuple<DataSet,ArrayList>(ds,SetPrintCommand);
        //}
    }
}


