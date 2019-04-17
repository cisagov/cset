//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
//using CSET_Main.ReportEngine.Builder;
//using System;
//using System.Collections;
//using System.Collections.Generic;
//using System.Data;
//using System.Linq;
//using DataLayerCore.Model;
//using CSETWeb_Api.BusinessLogic;
//using CSETWeb_Api.BusinessManagers;
//using CSETWeb_Api.Models;

//namespace CSET_Main.ReportEngine.SecurityPlan
//{
//    public class SecurityPlanDataBuilder
//    {
//        private DataHandling cb = new DataHandling();


//        private static Dictionary<int, String> level_To_Full_Name = null;
//        private Dictionary<string, string> entity_to_set_full_name;
//        private CSET_Context context; 

//        public SecurityPlanDataBuilder()
//        {
//            this.context = new CSET_Context();
//        }


//        internal Tuple<DataSet, ArrayList> GetData(int assessmentId)
//        {
//            if (level_To_Full_Name == null)
//                createLevelLookup();

//            //get the requirements for any selected standards
//            //merge in the requirements for any components
//            //need the components list then get the associated requirements for those components
//            //see if we already have those requirements if we do then nothing else If we don't add them
//            //once we have the requirements list then we need to get the questions for each requirement 
//            //and the #Yes/#total questions for each requirement
//            //for each requirement get a table of the components
//            //for each requirement get a table of the zones

//            string applicationMode = GetApplicationMode(assessmentId);


//            if (applicationMode.ToLower().StartsWith("questions"))
//            {
//                QuestionsManager qm = new QuestionsManager(assessmentId);
//                QuestionResponse resp = qm.GetQuestionList();
//            }
//            else
//            {
//                RequirementsManager rm = new RequirementsManager(assessmentId);
//                QuestionResponse resp = rm.GetRequirementsList();                
//            }
//            return null;

//        }

//        private void createLevelLookup()
//        {

//            level_To_Full_Name= context.UNIVERSAL_SAL_LEVEL.ToDictionary(t => t.Sal_Level_Order, t=> t.Full_Name_Sal);
//            entity_to_set_full_name = (from x in context.SETS
//                                       where x.Set_Name != null
//                                       select new { Set_Name = x.Set_Name, Full_Name = x.Short_Name }).Distinct().ToDictionary(t => t.Set_Name, t => t.Full_Name);
//        }


//        //DoD 8510.01 is bassed on other standards, append this name to the front
//        private string addDoDtoName(string standardShortName, string setName)
//        {
//            string StandardName = "";
//            if (setName == "DODI_8510")
//            {
//                StandardName = "DoD 8510.01\n";
//            }
//            StandardName += standardShortName;
//            return StandardName;
//        }

//        /// <summary>
//        /// build the table for the security plan
//        /// </summary>
//        /// <param name="componentQuestions"></param>
//        /// <returns></returns>
//        private Tuple<DataSet, ArrayList> BuildControlsList(SecurityPlanData spd)
//        {
//            DataSet ds = new DataSet();

//            String Control_Table_Name = "ControlList";
//            String Questions_Table_Name = "Control_Questions";

//            DataTable table = new DataTable();
//            table.TableName = Control_Table_Name;

//            // Create Columns
//            table.Columns.Add(cb.BuildTableColumn("Requirement_ID"));
//            table.Columns.Add(cb.BuildTableColumn("Rank"));
//            table.Columns.Add(cb.BuildTableColumn("RequirementTitle"));
//            table.Columns.Add(cb.BuildTableColumn("Standard_Category"));
//            table.Columns.Add(cb.BuildTableColumn("SubCategory"));
//            table.Columns.Add(cb.BuildTableColumn("StandardShortName"));
//            table.Columns.Add(cb.BuildTableColumn("ImplementationStatus"));
//            table.Columns.Add(cb.BuildTableColumn("Level"));
//            table.Columns.Add(cb.BuildTableColumn("ZonesList"));
//            table.Columns.Add(cb.BuildTableColumn("ImplementationRecommendations"));
//            table.Columns.Add(cb.BuildTableColumn("ComponentsList"));
//            table.Columns.Add(cb.BuildTableColumn("ControlDescription"));
//            table.Columns.Add(cb.BuildTableColumn("Control_Questions"));
//            table.Columns.Add(cb.BuildTableColumn("Answer"));
//            table.Columns.Add(cb.BuildTableColumn("Comment"));

//            DataTable questions = new DataTable();
//            questions.TableName = Questions_Table_Name;
//            questions.Columns.Add(cb.BuildTableColumn("Requirement_Id"));
//            questions.Columns.Add(cb.BuildTableColumn("Simple_Question"));
//            questions.Columns.Add(cb.BuildTableColumn("Answer"));
//            questions.Columns.Add(cb.BuildTableColumn("Comment"));


//            /**
//             * go through the questions that were asked or the requirements that were given and determine all the associated controls and questions
//             * Notice that this is only applicable to the multiServiceComponent questions and it does not matter what mode is selected or other standards answered.
//             * I'm not positive that is correct just yet.
//             */

//            if (spd.Requirements.Count <= 0)
//            {
//                DataRow row = table.NewRow();
//                row["RequirementTitle"] = "No Data to display. Select a standard to generate a full plan.";                
//                table.Rows.Add(row);
//            }
//            else
//            {

//                foreach (KeyValuePair<int, Requirement_And_Set> rs in spd.Requirements)
//                {
//                    DataRow row = table.NewRow();
//                    row["Requirement_id"] = rs.Key;
//                    row["RequirementTitle"] = rs.Value.NewRequirement.Requirement_Title;
//                    row["Standard_Category"] = rs.Value.NewRequirement.Standard_Category;
//                    row["SubCategory"] = rs.Value.NewRequirement.Question_Group_Heading;
//                    //this should have a status that 
//                    SecurityPlanStats stat;
//                    if (spd.ReqID_to_Stats.TryGetValue(rs.Key, out stat))
//                    {
//                        row["ImplementationStatus"] = spd.ReqID_to_Stats[rs.Key].Implemented;
//                    }
//                    else
//                    {
//                        row["ImplementationStatus"] = "0%";
//                    }
//                    row["Level"] = level_To_Full_Name[rs.Value.NewRequirement.Default_Standard_Level];
//                    row["StandardShortName"] = addDoDtoName(entity_to_set_full_name[rs.Value.NewRequirement.Original_Set_Name],
//                        rs.Value.Set.Set_Name);


//                    row["ZonesList"] = getListIfExists(rs.Key, spd.ReqID_to_Zone);
//                    row["Answer"] = answers.GetRequirementAnswer(rs.Key);
//                    //row["ImplementationRecommendations"] = question.ImplementationRecommendations;


//                    row["ComponentsList"] = getListIfExists(rs.Key, spd.ReqID_To_Component);
//                    row["ControlDescription"] = spd.GetTextForRequirement(rs.Value.NewRequirement);
//                    String com = answers.GetRequirementAnswerComments(rs.Key);
//                    if (!String.IsNullOrWhiteSpace(com))
//                        row["Comment"] = "\nCOMMENTS: " + com;
//                    table.Rows.Add(row);

//                    foreach (QuestionPoco qp in spd.ReqID_to_Poco[rs.Key])
//                    {
//                        DataRow question_row = questions.NewRow();
//                        question_row["Requirement_Id"] = rs.Key;
//                        question_row["Simple_Question"] = qp.Text;
//                        question_row["Answer"] = qp.Answer.Answer_Text;
//                        com = qp.Comment;
//                        if (!String.IsNullOrWhiteSpace(com))
//                            question_row["Comment"] = "\nCOMMENTS: " + com;
//                        questions.Rows.Add(question_row);
//                    }
//                }
//            }
//            table.DefaultView.Sort = "RequirementTitle";
//            ds.Tables.Add(table);
//            ds.Tables.Add(questions);

//            ArrayList SetPrintCommand = new ArrayList();
//            DictionaryEntry entry;
//            entry = new DictionaryEntry(Control_Table_Name, String.Empty);
//            SetPrintCommand.Add(entry);

//            entry = new DictionaryEntry(Questions_Table_Name, "Requirement_Id = %" + Control_Table_Name + ".Requirement_Id%");
//            SetPrintCommand.Add(entry);

//            //System.IO.StreamWriter xmlSW = new System.IO.StreamWriter("Requirements_Questions.xml");
//            //ds.WriteXml(xmlSW, XmlWriteMode.WriteSchema);
//            //xmlSW.Close();

//            return new Tuple<DataSet, ArrayList>(ds, SetPrintCommand);
//        }

//        /// <summary>
//        /// build the table for the security plan
//        /// </summary>
//        /// <param name="componentQuestions"></param>
//        /// <returns></returns>
//        private Tuple<DataSet, ArrayList> BuildFrameworkControlsList(SecurityPlanData spd)
//        {
//            DataSet ds = new DataSet();

//            String Control_Table_Name = "FrameworkControlList";


//            DataTable table = new DataTable();
//            table.TableName = Control_Table_Name;

//            // Create Columns
//            table.Columns.Add(cb.BuildTableColumn("Requirement_ID"));            
//            table.Columns.Add(cb.BuildTableColumn("RequirementTitle"));
//            table.Columns.Add(cb.BuildTableColumn("Standard_Category"));
//            table.Columns.Add(cb.BuildTableColumn("SubCategory"));
//            table.Columns.Add(cb.BuildTableColumn("StandardShortName"));
//            table.Columns.Add(cb.BuildTableColumn("ImplementationStatus"));
//            table.Columns.Add(cb.BuildTableColumn("ControlDescription"));
//            table.Columns.Add(cb.BuildTableColumn("Comment"));

//            /**
//             * go through the questions that were asked or the requirements that were given and determine all the associated controls and questions
//             * Notice that this is only applicable to the multiServiceComponent questions and it does not matter what mode is selected or other standards answered.
//             * I'm not positive that is correct just yet.
//             */

//            if (spd.Requirements.Count <= 0)
//            {
//                DataRow row = table.NewRow();
//                row["RequirementTitle"] = "No Data to display. Select a standard to generate a full plan.";
//                table.Rows.Add(row);
//            }
//            else
//            {

//                foreach (KeyValuePair<int, Requirement_And_Set> rs in spd.Requirements)
//                {
//                    DataRow row = table.NewRow();
//                    row["Requirement_id"] = rs.Key;
//                    row["RequirementTitle"] = rs.Value.Question.ProfileCategory.SubFunCatLabel;
//                    row["Standard_Category"] = rs.Value.Question.ProfileCategory.Heading;
//                    row["SubCategory"] = rs.Value.Question.ProfileCategory.FunctionName;
//                    //this should have a status that 
//                    SecurityPlanStats stat;
//                    if (spd.ReqID_to_Stats.TryGetValue(rs.Key, out stat))
//                    {
//                        row["ImplementationStatus"] = spd.ReqID_to_Stats[rs.Key].Implemented;
//                    }
//                    else
//                    {
//                        row["ImplementationStatus"] = "0%";
//                    }

//                    row["StandardShortName"] = entity_to_set_full_name[Constants.NIST_FRAMEWORK_DB];

//                    row["ControlDescription"] = rs.Value.Question.Text;

//                    if(!String.IsNullOrWhiteSpace(rs.Value.Question.Comment ))
//                        row["Comment"] = "\nCOMMENTS: " + rs.Value.Question.Comment;

//                    table.Rows.Add(row);

//                }
//            }
//            table.DefaultView.Sort = "RequirementTitle";
//            ds.Tables.Add(table);


//            ArrayList SetPrintCommand = new ArrayList();
//            DictionaryEntry entry;
//            entry = new DictionaryEntry(Control_Table_Name, String.Empty);
//            SetPrintCommand.Add(entry);

//            return new Tuple<DataSet, ArrayList>(ds, SetPrintCommand);
//        }


//        private String getListIfExists(int key, Dictionary<int, HashSet<String>> ReqID_to_Zone){

//            HashSet<String> zoneList;
//            String zones = "";
//            if (ReqID_to_Zone.TryGetValue(key, out zoneList))
//            {
//                zones = String.Join(",", zoneList);
//            }
//            return zones;
//        }


//    }
//}


