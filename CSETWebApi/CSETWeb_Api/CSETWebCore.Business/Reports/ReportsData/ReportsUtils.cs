//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Reports;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Reports
{
    public partial class ReportsDataBusiness : IReportsDataBusiness
    {

        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void SetReportsAssessmentId(int assessmentId)
        {
            _assessmentId = assessmentId;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswers that have been answered "A".
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetAlternatesList()
        {
            var responseList = GetQuestionsList().Where(x => (x.ANSWER.Answer_Text == "A")).ToList();
            return responseList;
        }

        /// <summary>
        /// Returns a list of domains for the assessment.
        /// </summary>
        /// <returns></returns>
        public List<string> GetDomains()
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            // Get all domains for this maturity model
            var domains = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id && x.Type_Id == 1).ToList();

            return domains.Select(d => d.Title).ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControls(string applicationMode)
        {
            var lang = _tokenManager.GetCurrentLanguage();
            var rm = new Question.RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _tokenManager);

            _questionRequirement.InitializeManager(_assessmentId);

            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            string level = _questionRequirement.StandardLevel == null ? "L" : _questionRequirement.StandardLevel;

            List<ControlRow> controlRows = new List<ControlRow>();

            if (applicationMode == CSETWebCore.Business.Assessment.AssessmentMode.QUESTIONS_BASED_APPLICATION_MODE)
            {
                var qQ = (from rs in _context.REQUIREMENT_SETS
                          join r in _context.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                          join rl in _context.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                          join s in _context.SETS on rs.Set_Name equals s.Set_Name
                          join av in _context.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                          join rqs in _context.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                          join qu in _context.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                          join a in _context.Answer_Questions_No_Components on qu.Question_Id equals a.Question_Or_Requirement_Id
                          where rl.Standard_Level == level && av.Selected == true && rl.Level_Type == "NST"
                           && av.Assessment_Id == _assessmentId && a.Assessment_Id == _assessmentId
                          orderby r.Standard_Category, r.Standard_Sub_Category, rs.Requirement_Sequence
                          select new { r, rl, s, qu, a }).ToList();

                foreach (var q in qQ)
                {
                    controlRows.Add(new ControlRow()
                    {
                        Requirement_Id = q.r.Requirement_Id,
                        Requirement_Text = q.r.Requirement_Text,
                        Answer_Text = q.a.Answer_Text,
                        Comment = q.a.Comment,
                        Question_Id = q.qu.Question_Id,
                        Requirement_Title = q.r.Requirement_Title,
                        Short_Name = q.s.Short_Name,
                        Simple_Question = q.qu.Simple_Question,
                        Standard_Category = q.r.Standard_Category,
                        Standard_Sub_Category = q.r.Standard_Sub_Category,
                        Standard_Level = q.rl.Standard_Level
                    });
                }
            }
            else
            {
                var qR = (from rs in _context.REQUIREMENT_SETS
                          join r in _context.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                          join rl in _context.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                          join s in _context.SETS on rs.Set_Name equals s.Set_Name
                          join av in _context.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                          join rqs in _context.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                          join qu in _context.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                          join a in _context.Answer_Requirements on r.Requirement_Id equals a.Question_Or_Requirement_Id
                          where rl.Standard_Level == level && av.Selected == true && rl.Level_Type == "NST"
                           && av.Assessment_Id == _assessmentId && a.Assessment_Id == _assessmentId
                          orderby r.Standard_Category, r.Standard_Sub_Category, rs.Requirement_Sequence
                          select new { r, rl, s, qu, a }).ToList();

                foreach (var q in qR)
                {
                    controlRows.Add(new ControlRow()
                    {
                        Requirement_Id = q.a.Question_Or_Requirement_Id,
                        Requirement_Text = q.r.Requirement_Text,
                        Answer_Text = q.a.Answer_Text,
                        Comment = q.a.Comment,
                        Question_Id = q.qu.Question_Id,
                        Requirement_Title = q.r.Requirement_Title,
                        Short_Name = q.s.Short_Name,
                        Simple_Question = q.qu.Simple_Question,
                        Standard_Category = q.r.Standard_Category,
                        Standard_Sub_Category = q.r.Standard_Sub_Category,
                        Standard_Level = q.rl.Standard_Level,
                        Answer_Id = q.a.Answer_Id
                    });
                }
            }



            //get all the questions for this control 
            //determine the percent implemented.                 
            int prev_requirement_id = 0;
            int questionCount = 0;
            int questionsAnswered = 0;
            BasicReportData.RequirementControl control = null;
            List<BasicReportData.Control_Questions> questions = null;

            // The response
            List<BasicReportData.RequirementControl> controls = [];

            foreach (var a in controlRows)
            {
                if (prev_requirement_id != a.Requirement_Id)
                {
                    questionCount = 0;
                    questionsAnswered = 0;
                    questions = new List<BasicReportData.Control_Questions>();


                    // look for translations
                    var r = _overlay.GetRequirement(a.Requirement_Id, lang);
                    var c = _overlay.GetPropertyValue("STANDARD_CATEGORY", a.Standard_Category.ToLower(), lang);
                    var s = _overlay.GetPropertyValue("STANDARD_CATEGORY", a.Standard_Sub_Category.ToLower(), lang);


                    // Replace parameter in requirement text if custom parameter is found 
                    a.Requirement_Text = rm.ResolveParameters(a.Requirement_Id, a.Answer_Id, a.Requirement_Text);

                    control = new BasicReportData.RequirementControl()
                    {
                        ControlDescription = r?.RequirementText ?? a.Requirement_Text,
                        RequirementTitle = a.Requirement_Title,
                        Level = a.Standard_Level,
                        StandardShortName = a.Short_Name,
                        Standard_Category = c ?? a.Standard_Category,
                        SubCategory = s ?? a.Standard_Sub_Category,
                        Control_Questions = questions
                    };



                    controls.Add(control);
                }

                questionCount++;

                switch (a.Answer_Text)
                {
                    case Constants.Constants.ALTERNATE:
                    case Constants.Constants.YES:
                        questionsAnswered++;
                        break;
                }

                questions.Add(new BasicReportData.Control_Questions()
                {
                    Answer = a.Answer_Text,
                    Comment = a.Comment,
                    Simple_Question = a.Simple_Question
                });

                control.ImplementationStatus = StatUtils.Percentagize(questionsAnswered, questionCount, 2).ToString("##.##");
                prev_requirement_id = a.Requirement_Id;
            }

            return controls;
        }


        public List<DocumentLibraryTable> GetDocumentLibrary()
        {
            List<DocumentLibraryTable> list = new List<DocumentLibraryTable>();
            var docs = from a in _context.DOCUMENT_FILE
                       where a.Assessment_Id == _assessmentId
                       select a;
            foreach (var doc in docs)
            {
                var dlt = new DocumentLibraryTable()
                {
                    DocumentTitle = doc.Title,
                    FileName = doc.Path
                };

                if (dlt.DocumentTitle == "click to edit title")
                {
                    dlt.DocumentTitle = "(untitled)";
                }

                list.Add(dlt);
            }

            return list;
        }


        /// <summary>
        /// Formats an identifier for the corresponding question. 
        /// Also returns the question text with parameters applied, in the
        /// case of a requirement.
        /// 
        /// If the user's language is non-English, attempts to overlay the
        /// question text with the translated version.
        /// </summary>
        /// <returns></returns>
        private void GetQuestionTitleAndText(dynamic f,
            List<StandardQuestions> stdList, List<ComponentQuestion> compList,
            int answerId,
            out string identifier, out string questionText)
        {
            identifier = "";
            questionText = "";
            var lang = _tokenManager.GetCurrentLanguage();

            switch (f.c.Question_Type)
            {
                case "Question":
                    foreach (var s in stdList)
                    {
                        var q1 = s.Questions.FirstOrDefault(x => x.QuestionId == f.c.Question_Or_Requirement_Id);
                        if (q1 != null)
                        {
                            identifier = q1.CategoryAndNumber;
                            questionText = q1.Question;
                            return;
                        }
                    }

                    return;

                case "Component":
                    var q2 = compList.FirstOrDefault(x => x.QuestionId == f.c.Question_Or_Requirement_Id);
                    if (q2 != null)
                    {
                        identifier = q2.ComponentName;
                        questionText = q2.Question;
                    }

                    return;

                case "Requirement":
                    identifier = f.r.Requirement_Title;
                    var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _tokenManager);
                    questionText = rb.ResolveParameters(f.r.Requirement_Id, answerId, f.r.Requirement_Text);

                    // translate
                    questionText = _overlay.GetRequirement(f.r.Requirement_Id, lang)?.RequirementText ?? questionText;

                    return;

                case "Maturity":

                    identifier = f.mq.Question_Title;
                    questionText = f.mq.Question_Text;

                    // CPG is a special case
                    if (!String.IsNullOrEmpty(f.mq.Security_Practice))
                    {
                        questionText = f.mq.Security_Practice;
                    }

                    // overlay
                    MaturityQuestionOverlay o = _overlay.GetMaturityQuestion(f.mq.Mat_Question_Id, lang);
                    if (o != null)
                    {
                        identifier = o.QuestionTitle;
                        questionText = o.QuestionText;
                    }
                    return;

                default:
                    return;
            }
        }


        /// <summary>
        /// Formats first and last name.  If the name is believed to be a domain\userid, 
        /// the userid is returned with the domain removed.
        /// </summary>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <returns></returns>
        public string FormatName(string firstName, string lastName)
        {
            firstName = firstName.Trim();
            lastName = lastName.Trim();

            if (firstName.Length > 0 && lastName.Length > 0)
            {
                return string.Format("{0} {1}", firstName, lastName);
            }

            // if domain-qualified userid, remove domain
            if (firstName.IndexOf('\\') >= 0 && firstName.IndexOf(' ') < 0 && lastName.Length == 0)
            {
                return firstName.Substring(firstName.LastIndexOf('\\') + 1);
            }

            return string.Format("{0} {1}", firstName, lastName);
        }


        /// <summary>
        /// Gets all confidential types for report generation
        /// </summary>
        /// <returns></returns>
        public IEnumerable<CONFIDENTIAL_TYPE> GetConfidentialTypes()
        {
            return _context.CONFIDENTIAL_TYPE.OrderBy(x => x.ConfidentialTypeOrder);
        }

        private void NullOutNavigationPropeties(List<MatRelevantAnswers> list)
        {
            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            foreach (MatRelevantAnswers a in list)
            {
                a.ANSWER.Assessment = null;
                a.Mat.Maturity_Model = null;
                a.Mat.InverseParent_Question = null;
                a.Mat.Parent_Question = null;

                if (a.Mat.Grouping != null)
                {
                    a.Mat.Grouping.Maturity_Model = null;
                    a.Mat.Grouping.MATURITY_QUESTIONS = null;
                    a.Mat.Grouping.Type = null;
                }

                if (a.Mat.Maturity_Level != null)
                {
                    a.Mat.Maturity_Level.MATURITY_QUESTIONS = null;
                    a.Mat.Maturity_Level.Maturity_Model = null;
                }
            }
        }

        public string GetCsetVersion()
        {
            return _context.CSET_VERSION.Select(x => x.Cset_Version1).FirstOrDefault();
        }

        public string GetAssessmentGuid(int assessmentId)
        {
            return _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Assessment_GUID).FirstOrDefault().ToString();
        }
    }
}