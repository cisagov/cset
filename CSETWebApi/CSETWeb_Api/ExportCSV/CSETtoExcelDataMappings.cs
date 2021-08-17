//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.ReportEngine.Builder;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

namespace ExportCSV
{
    /// <summary>
    /// Responsible for defining the data mappings that will be exported to excel  
    /// Note that to complete writing to the excel file the 
    /// final call to write must be called after all the data
    /// is added to the file
    /// </summary>
    /// 
    public class CSETtoExcelDataMappings
    {
        private CSET_Context assessmentEntity;
        private int assessment_id;

        public CSETtoExcelDataMappings(int assessment_id, CSET_Context assessmentEntity)
        {
            this.assessmentEntity = assessmentEntity;
            this.assessment_id = assessment_id;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="stream"></param>
        public void ProcessTables(MemoryStream stream)
        {
            CSETtoExcelDocument doc = new CSETtoExcelDocument();
            IEnumerable<QuestionExport> list;

            List<ANSWER> answers = assessmentEntity.ANSWER.ToList<ANSWER>();

            // Determine whether the assessment is questions based or requirements based
            var applicationMode = assessmentEntity.STANDARD_SELECTION.Where(a => a.Assessment_Id == this.assessment_id).FirstOrDefault().Application_Mode;


            // Questions worksheet
            if (applicationMode.ToLower().Contains("questions"))
            {
                list = from a in answers
                       join q in assessmentEntity.NEW_QUESTION on a.Question_Or_Requirement_Id equals q.Question_Id
                       join h in assessmentEntity.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                       where a.Is_Requirement == false && a.Assessment_Id == assessment_id
                       select new QuestionExport()
                       {
                           Question_Id = q.Question_Id,
                           Question_Group_Heading = h.Question_Group_Heading,
                           Simple_Question = q.Simple_Question,
                           Answer_Text = a.Answer_Text,
                           Mark_For_Review = a.Mark_For_Review,
                           Reviewed = a.Reviewed,
                           Is_Requirement = a.Is_Requirement,
                           Is_Component = a.Is_Component,
                           Is_Framework = a.Is_Framework,
                           Comment = a.Comment,
                           Alternate_Justification = a.Alternate_Justification,
                           Component_Guid = a.Component_Guid,                           
                           Answer_Id = a.Answer_Id
                       };

                doc.AddList<QuestionExport>(list.ToList<QuestionExport>(), "Questions", QuestionExport.Headings);
            }


            // Requirements worksheet
            if (applicationMode.ToLower().Contains("requirements"))
            {
                list = from a in answers
                       join q in assessmentEntity.NEW_REQUIREMENT on a.Question_Or_Requirement_Id equals q.Requirement_Id
                       join h in assessmentEntity.QUESTION_GROUP_HEADING on q.Question_Group_Heading_Id equals h.Question_Group_Heading_Id
                       where a.Is_Requirement == true && a.Assessment_Id == assessment_id
                       select new QuestionExport()
                       {
                           Question_Id = q.Requirement_Id,
                           Question_Group_Heading = h.Question_Group_Heading1,
                           Simple_Question = q.Requirement_Text,
                           Requirement_Title = q.Requirement_Title,
                           Answer_Text = a.Answer_Text,
                           Mark_For_Review = a.Mark_For_Review,
                           Reviewed = a.Reviewed,
                           Is_Requirement = a.Is_Requirement,
                           Is_Component = a.Is_Component,
                           Is_Framework = a.Is_Framework,
                           Comment = a.Comment,
                           Alternate_Justification = a.Alternate_Justification,
                           Component_Guid = a.Component_Guid,                           
                           Answer_Id = a.Answer_Id
                       };

                doc.AddList<QuestionExport>(list.ToList<QuestionExport>(), "Requirements", QuestionExport.Headings);
            }

            
            // Framework worksheet
            var qlist = from a in answers
                        join q in assessmentEntity.NEW_QUESTION on a.Question_Or_Requirement_Id equals q.Question_Id
                        join h in assessmentEntity.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                        where a.Is_Framework == true && a.Assessment_Id == assessment_id
                        select new QuestionExport()
                        {
                            Question_Id = q.Question_Id,
                            Question_Group_Heading = h.Question_Group_Heading,
                            Simple_Question = q.Simple_Question,
                            Answer_Text = a.Answer_Text,
                            Mark_For_Review = a.Mark_For_Review,
                            Reviewed = a.Reviewed,
                            Is_Requirement = a.Is_Requirement,
                            Is_Component = a.Is_Component,
                            Is_Framework = a.Is_Framework,
                            Comment = a.Comment,
                            Alternate_Justification = a.Alternate_Justification,
                            Component_Guid = a.Component_Guid,
                            Answer_Id = a.Answer_Id
                        };
            doc.AddList<QuestionExport>(qlist.ToList<QuestionExport>(), "Framework", QuestionExport.Headings);

            // Add maturity pages            
            var mlist = from a in assessmentEntity.ANSWER
                        join q in assessmentEntity.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                        join b in assessmentEntity.MATURITY_GROUPINGS on q.Grouping_Id equals b.Grouping_Id
                        join c in assessmentEntity.MATURITY_GROUPINGS on b.Parent_Id equals c.Grouping_Id
                        join d in assessmentEntity.MATURITY_GROUPINGS on c.Parent_Id equals d.Grouping_Id                        
                        where a.Assessment_Id == assessment_id && a.Is_Maturity==true
                        select new MaturityExport()
                        {
                            Mat_Question_Id = q.Mat_Question_Id,
                            Question_Title = q.Question_Title,
                            Question_Text = q.Question_Text,
                            Supplemental_Info = q.Supplemental_Info,                            
                            Maturity_Level = q.Maturity_Level,
                            Sequence = q.Sequence,                            
                            Maturity_Model_Id = q.Maturity_Model_Id,
                            Parent_Question_Id = q.Parent_Question_Id,                                                        
                            Examination_Approach = q.Examination_Approach,
                            Title1 = d.Title,
                            Title2 = c.Title,
                            Title3 = b.Title,
                            Answer_Text = a.Answer_Text,
                            Mark_For_Review = a.Mark_For_Review,
                            Reviewed = a.Reviewed,                            
                            Comment = a.Comment,
                            Alternate_Justification = a.Alternate_Justification,                            
                            Answer_Id = a.Answer_Id
                        };
            doc.AddList<MaturityExport>(mlist.ToList<MaturityExport>(), "Maturity", MaturityExport.Headings);




            // Add a worksheet with the product version
            List<VersionExport> versionList = new List<VersionExport>();
            VersionExport v = new VersionExport
            {
                Version = assessmentEntity.CSET_VERSION.FirstOrDefault().Cset_Version1
            };
            versionList.Add(v);
            doc.AddList<VersionExport>(versionList, "Version", null);


            List<DataMap> maps = new List<DataMap>();
            doc.WriteExcelFile(stream, maps);
        }


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

            IDataHandling cb = new DataHandling();
            // Create Columns
            foreach (Header heading in headers.HeaderList)
            {
                table.Columns.Add(cb.BuildTableColumn(heading.DisplayName));
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
        public Boolean? Is_Question { get { return !Is_Requirement; } }
        public Boolean? Is_Requirement { get; set; }
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


