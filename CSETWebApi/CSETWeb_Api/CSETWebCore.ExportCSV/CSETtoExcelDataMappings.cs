//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.ReportEngine;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.ReportEngine;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace CSETWebCore.ExportCSV
{
    public class CSETtoExcelDataMappings
    {
        private CSETContext _context;

        private int _assessmentId;

        private readonly IDataHandling _dataHandling;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="context"></param>
        /// <param name="dataHandling"></param>
        public CSETtoExcelDataMappings(int assessmentId, CSETContext context, IDataHandling dataHandling)
        {
            _context = context;
            _assessmentId = assessmentId;
            _dataHandling = dataHandling;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="stream"></param>
        public void ProcessTables(MemoryStream stream)
        {
            CSETtoExcelDocument doc = new CSETtoExcelDocument();

            ASSESSMENTS assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();


            if (assessment.UseStandard)
            {
                CreateWorksheetPageStandardAnswers(ref doc);
            }

            if (assessment.UseMaturity)
            {
                CreateWorksheetPageMaturityAnswers(ref doc);
            }

            if (assessment.UseDiagram)
            {
                CreateWorksheetPageDiagramAnswers(ref doc);
            }


            CreateWorksheetPageFrameworkAnswers(ref doc);



            // Add a worksheet with the product version
            List<VersionExport> versionList = new List<VersionExport>();
            VersionExport v = new VersionExport
            {
                Version = _context.CSET_VERSION.FirstOrDefault().Cset_Version1
            };
            versionList.Add(v);
            doc.AddList<VersionExport>(versionList, "Version", null);


            List<DataMap> maps = new List<DataMap>();
            doc.WriteExcelFile(stream, maps);
        }


        /// <summary>
        /// Get Standards answers for the assessment.
        /// </summary>
        /// <param name="doc"></param>
        private void CreateWorksheetPageStandardAnswers(ref CSETtoExcelDocument doc)
        {
            IEnumerable<QuestionExport> list;

            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            // Determine whether the assessment is questions based or requirements based
            var applicationMode = _context.STANDARD_SELECTION.Where(a => a.Assessment_Id == _assessmentId).FirstOrDefault().Application_Mode;


            // Questions worksheet
            if (applicationMode.ToLower().Contains("questions"))
            {
                var questionIds = _context.InScopeQuestions(_assessmentId);
                var answers = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Question" && questionIds.Contains(x.Question_Or_Requirement_Id)).ToList();

                list = from a in answers
                       join q in _context.NEW_QUESTION on a.Question_Or_Requirement_Id equals q.Question_Id
                       join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                       select new QuestionExport()
                       {
                           Question_Id = q.Question_Id,
                           Question_Group_Heading = h.Question_Group_Heading,
                           Simple_Question = q.Simple_Question,
                           Answer_Text = a.Answer_Text,
                           Mark_For_Review = a.Mark_For_Review ?? false,
                           Reviewed = a.Reviewed,
                           Is_Requirement = a.Is_Requirement ?? false,
                           Is_Maturity = a.Is_Maturity ?? false,
                           Is_Component = a.Is_Component ?? false,
                           Is_Framework = a.Is_Framework ?? false,
                           Comment = a.Comment,
                           Alternate_Justification = a.Alternate_Justification,
                           Component_Guid = a.Component_Guid,
                           Answer_Id = a.Answer_Id
                       };

                var rows = list.ToList<QuestionExport>();
                rows.ForEach(q =>
                {
                    q.Is_Question = !((q.Is_Requirement ?? false) || (q.Is_Component ?? false) || (q.Is_Maturity ?? false) || (q.Is_Framework ?? false));
                });

                doc.AddList<QuestionExport>(rows, "Standard Questions", QuestionExport.Headings);
            }


            // Requirements worksheet
            if (applicationMode.ToLower().Contains("requirements"))
            {
                var questionIds = _context.InScopeRequirements(_assessmentId);
                var answers = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Requirement" && questionIds.Contains(x.Question_Or_Requirement_Id)).ToList();

                list = from a in answers
                       join q in _context.NEW_REQUIREMENT on a.Question_Or_Requirement_Id equals q.Requirement_Id
                       join h in _context.QUESTION_GROUP_HEADING on q.Question_Group_Heading_Id equals h.Question_Group_Heading_Id
                       select new QuestionExport()
                       {
                           Question_Id = q.Requirement_Id,
                           Question_Group_Heading = h.Question_Group_Heading1,
                           Simple_Question = q.Requirement_Text,
                           Requirement_Title = q.Requirement_Title,
                           Answer_Text = a.Answer_Text,
                           Mark_For_Review = a.Mark_For_Review ?? false,
                           Reviewed = a.Reviewed,
                           Is_Requirement = a.Is_Requirement ?? false,
                           Is_Maturity = a.Is_Maturity ?? false,
                           Is_Component = a.Is_Component ?? false,
                           Is_Framework = a.Is_Framework ?? false,
                           Comment = a.Comment,
                           Alternate_Justification = a.Alternate_Justification,
                           Component_Guid = a.Component_Guid,
                           Answer_Id = a.Answer_Id
                       };

                var rows = list.ToList<QuestionExport>();
                rows.ForEach(q =>
                {
                    q.Is_Question = !((q.Is_Requirement ?? false) || (q.Is_Component ?? false) || (q.Is_Maturity ?? false) || (q.Is_Framework ?? false));
                });

                doc.AddList<QuestionExport>(rows, "Standard Requirements", QuestionExport.Headings);
            }
        }


        /// <summary>
        /// Get Maturity answers for the assessment.
        /// </summary>
        /// <param name="doc"></param>
        private void CreateWorksheetPageMaturityAnswers(ref CSETtoExcelDocument doc)
        {
            _context.FillEmptyMaturityQuestionsForAnalysis(_assessmentId);

            var mm = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == _assessmentId && x.Selected).FirstOrDefault();
            if (mm == null)
            {
                return;
            }

            var questionIds = _context.MATURITY_QUESTIONS.Where(x => x.Maturity_Model_Id == mm.model_id).ToList().Select(x => x.Mat_Question_Id);

            var answers = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity" && questionIds.Contains(x.Question_Or_Requirement_Id)).ToList();

            IEnumerable<QuestionExport> list = from a in answers
                                               join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                                               select new QuestionExport()
                                               {
                                                   Question_Id = q.Mat_Question_Id,
                                                   Simple_Question = q.Question_Text,
                                                   Answer_Text = a.Answer_Text,
                                                   Mark_For_Review = a.Mark_For_Review ?? false,
                                                   Reviewed = a.Reviewed,
                                                   Is_Requirement = a.Is_Requirement ?? false,
                                                   Is_Maturity = a.Is_Maturity ?? false,
                                                   Is_Component = a.Is_Component ?? false,
                                                   Is_Framework = a.Is_Framework ?? false,
                                                   Comment = a.Comment,
                                                   Alternate_Justification = a.Alternate_Justification,
                                                   Answer_Id = a.Answer_Id
                                               };

            var rows = list.ToList<QuestionExport>();
            rows.ForEach(q =>
            {
                q.Is_Question = !((q.Is_Requirement ?? false) || (q.Is_Component ?? false) || (q.Is_Maturity ?? false) || (q.Is_Framework ?? false));
            });

            doc.AddList<QuestionExport>(rows, "Maturity Questions", QuestionExport.Headings);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="doc"></param>
        private void CreateWorksheetPageDiagramAnswers(ref CSETtoExcelDocument doc)
        {
            IEnumerable<QuestionExport> list;

            _context.FillNetworkDiagramQuestions(_assessmentId);


            // Components worksheet

            var answers = _context.usp_Answer_Components_Default(_assessmentId);

            // var answer2 = _context.Answer_Components_Exploded

            list = from a in answers
                   join q in _context.NEW_QUESTION on a.Question_Id equals q.Question_Id
                   join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                   select new QuestionExport()
                   {
                       Question_Id = q.Question_Id,
                       Question_Group_Heading = h.Question_Group_Heading,
                       Simple_Question = q.Simple_Question,
                       Answer_Text = a.Answer_Text,
                       Mark_For_Review = a.Mark_For_Review ?? false,
                       Reviewed = a.Reviewed,
                       Is_Requirement = a.Is_Requirement,
                       Is_Component = a.Is_Component,
                       Is_Maturity = false,
                       Is_Framework = a.Is_Framework,
                       Comment = a.Comment,
                       Alternate_Justification = a.Alternate_Justification,
                       Component_Guid = (Guid)a.Component_Guid,
                       Answer_Id = a.Answer_Id
                   };

            var rows = list.ToList<QuestionExport>();
            rows.ForEach(q =>
            {
                q.Is_Question = !((q.Is_Requirement ?? false) || (q.Is_Component ?? false) || (q.Is_Maturity ?? false) || (q.Is_Framework ?? false));
            });

            doc.AddList<QuestionExport>(rows, "Component Questions", QuestionExport.Headings);
        }


        /// <summary>
        /// Get Framework answers for the assessment.
        /// NOTE:  Framework answers are not currently administered this way in CSET.  
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="answers"></param>
        private void CreateWorksheetPageFrameworkAnswers(ref CSETtoExcelDocument doc)
        {
            List<ANSWER> answers = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId).ToList<ANSWER>();

            // Framework worksheet
            var qlist = from a in answers
                        join q in _context.NEW_QUESTION on a.Question_Or_Requirement_Id equals q.Question_Id
                        join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                        where a.Is_Framework == true && a.Assessment_Id == _assessmentId
                        select new QuestionExport()
                        {
                            Question_Id = q.Question_Id,
                            Question_Group_Heading = h.Question_Group_Heading,
                            Simple_Question = q.Simple_Question,
                            Answer_Text = a.Answer_Text,
                            Mark_For_Review = a.Mark_For_Review,
                            Reviewed = a.Reviewed,
                            Is_Requirement = a.Is_Requirement,
                            Is_Maturity = a.Is_Maturity,
                            Is_Component = a.Is_Component,
                            Is_Framework = a.Is_Framework,
                            Comment = a.Comment,
                            Alternate_Justification = a.Alternate_Justification,
                            Component_Guid = a.Component_Guid,
                            Answer_Id = a.Answer_Id
                        };
            doc.AddList<QuestionExport>(qlist.ToList<QuestionExport>(), "Framework", QuestionExport.Headings);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="TableName"></param>
        /// <param name="headers"></param>
        /// <returns></returns>
        private DataMap SetupForTableBuild(String TableName, Headers headers)
        {
            DataTable table = new DataTable();
            table.TableName = TableName;

            DataMap map = new DataMap()
            {
                Name = TableName,
                Table = table,
                Headers = headers
            };

            // Create Columns
            foreach (Header heading in headers.HeaderList)
            {
                table.Columns.Add(_dataHandling.BuildTableColumn(heading.DisplayName));
            }

            return map;
        }

        //private DataMap BuildNetworkComponents(List<NetworkComponent> list, DataMap map)
        //{
        //    DataTable table = map.Table;

        //    foreach (NetworkComponent c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.TextNodeLabel;
        //        row[1] = c.HasUniqueQuestion;
        //        row[2] = c.SAL.Selected_Sal_Level;
        //        row[3] = c.Criticality.ToString();
        //        row[4] = c.Layer.LayerName;
        //        row[5] = c.IPAddress;
        //        row[6] = c.ComponentTypeDisplayName;
        //        row[7] = c.ComponentZoneLabel;
        //        row[8] = c.SubnetsDelimited;
        //        row[9] = c.Description;
        //        row[10] = c.HostName;
        //        row[11] = c.IsVisible;
        //        table.Rows.Add(row);
        //    }
        //    return map;
        //}

        //private void BuildMultipleServiceComponentDataSet(IOrderedEnumerable<MultiServiceComponent> list, DataMap map)
        //{

        //    DataTable table = map.Table;

        //    foreach (MultiServiceComponent c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.TextNodeLabel;
        //        row[1] = c.SAL.Selected_Sal_Level;
        //        row[3] = c.Layer.LayerName;
        //        row[4] = c.ServiceNamesDelimited;
        //        row[5] = c.Zone?.TextNodeLabel;
        //        row[9] = c.IsVisible;
        //        table.Rows.Add(row);
        //    }
        //}

        //private void BuildZoneDataSet(IOrderedEnumerable<NetworkZone> list, DataMap map)
        //{
        //    DataTable table = map.Table;

        //    foreach (NetworkZone c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.ZoneType.ZoneTypeDisplayName;
        //        row[1] = c.TextNodeLabel;
        //        row[2] = c.ZoneSAL.Selected_Sal_Level;
        //        row[3] = c.Layer.LayerName;
        //        row[4] = c.Person;
        //        row[5] = c.IsVisible;
        //        table.Rows.Add(row);
        //    }
        //}

        //private void BuildNetworkLinkDataSet(IOrderedEnumerable<NetworkLink> list, DataMap map)
        //{

        //    DataTable table = map.Table;

        //    foreach (NetworkLink c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.Text;
        //        row[1] = c.SubNet;
        //        row[2] = c.Security.ToString();
        //        row[3] = c.Layer.LayerName;
        //        row[4] = c.TargetCapType.ToString();
        //        row[5] = c.SourceCapType.ToString();
        //        row[6] = c.ConnectionType.ToString();
        //        row[7] = c.StrokeThickness;
        //        row[8] = c.SelectedColor.ToString();
        //        row[9] = c.LinkType;
        //        row[10] = c.IsVisible;
        //        table.Rows.Add(row);
        //    }
        //}

        //private void BuildShapeDataSet(IOrderedEnumerable<NetworkShape> list, DataMap map)
        //{

        //    DataTable table = map.Table;
        //    foreach (NetworkShape c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.TextNode.TextNodeLabel;
        //        row[1] = c.SelectedColor.ToString();
        //        row[2] = c.Layer.LayerName;
        //        row[3] = c.IsVisible;
        //        table.Rows.Add(row);
        //    }
        //}

        //private void BuildTextDataSet(IOrderedEnumerable<NetworkText> list, DataMap map)
        //{

        //    DataTable table = map.Table;
        //    foreach (NetworkText c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.TextNodeLabel;
        //        row[1] = c.Layer.LayerName;
        //        table.Rows.Add(row);
        //    }
        //}

        //private void BuildNetworkWarningDataSet(IOrderedEnumerable<IDiagramAnalysisNodeMessage> list, DataMap map)
        //{
        //    DataTable table = map.Table;
        //    foreach (NetworkAnalysisMessage c in list)
        //    {
        //        DataRow row = table.NewRow();
        //        row[0] = c.MessageIdentifier;
        //        row[1] = c.Message;
        //        table.Rows.Add(row);
        //    }
        //}
    }


    public class QuestionExport
    {
        private static string[] headings = new String[] { "Question_Id",
            "Question_Group_Heading",
            "Simple_Question",
            "Requirement_Title",
            "Answer_Text",
            "Mark_For_Review",
            "Is_Question",
            "Is_Requirement",
            "Is_Maturity",
            "Is_Component",
            "Is_Framework",
            "Answer_Id",
            "Comment",
            "Alternate_Justification",
            "Component_Guid"};



        public static String[] Headings
        {
            get { return headings; }
            private set { headings = value; }
        }
        public int Question_Id { get; set; }
        public String Question_Group_Heading { get; set; }
        public String Simple_Question { get; set; }
        public String Requirement_Title { get; set; }
        public String Answer_Text { get; set; }
        public Boolean? Mark_For_Review { get; set; }
        public Boolean? Reviewed { get; set; }
        public Boolean? Is_Question { get; set; }
        public Boolean? Is_Requirement { get; set; }
        public Boolean? Is_Maturity { get; set; }
        public Boolean? Is_Component { get; set; }
        public Boolean? Is_Framework { get; set; }
        public int Answer_Id { get; set; }
        public string Comment { get; set; }
        public string Alternate_Justification { get; set; }
        public Guid Component_Guid { get; set; }

    }

    public class CompQuestionExport : QuestionExport
    {
        private static string[] compheadings = new String[] { "Question_Id",
            "Question_Group_Heading",
            "Simple_Question",
            "Answer_Text",
            "Related_Components",
            "Mark_For_Review",
            "Is_Question",
            "Is_Requirement",
            "Is_Component",
            "Is_Framework",
            "Answer_Id",
            "Comment",
            "Alternate_Justification",
            "Component_Guid"};

        public static String[] CompHeadings
        {
            get { return compheadings; }
            private set { compheadings = value; }
        }
        public string Related_Components { get; internal set; }
    }

    public class VersionExport
    {
        private static string[] headings = new string[] { "Version" };

        public static string[] Headings
        {
            get { return headings; }
            set { headings = value; }
        }

        public string Version { get; set; }
    }
}