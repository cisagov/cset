using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Helpers
{
    /// <summary>
    /// The idea is a lightweight XDocument based 
    /// representation of any maturity model's questions
    /// in their grouping structure.
    /// 
    /// </summary>
    public class MaturityStructureForModel
    {
        private readonly CSETContext _context;

        private readonly int _modelId;

        public ModelStructure Model;



        /// <summary>
        /// The consumer can optionally suppress 
        /// grouping descriptions, question text and supplemental info
        /// if they want a smaller response object.
        /// </summary>
        private bool _includeText = true;


        /// <summary>
        /// Returns a populated instance of the maturity grouping
        /// and question structure for a maturity model.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityStructureForModel(int modelId, CSETContext context, bool includeText = true)
        {
            this._modelId = modelId;
            this._context = context;
            this._includeText = includeText;

            LoadStructure();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy in an XDocument.
        /// </summary>
        private void LoadStructure()
        {
            Model = new ModelStructure();


            var mm = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == _modelId).FirstOrDefault();
            if (mm == null)
            {
                return;
            }

            Model.ModelName = mm.Model_Name;
            Model.ModelId = _modelId;


            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var allQuestions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_LevelNavigation)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                _modelId == q.Maturity_Model_Id).ToList();



            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == _modelId).ToList();



            GetSubgroups(Model, null, allGroupings, allQuestions);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        private void GetSubgroups(object oParent, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
           List<MATURITY_QUESTIONS> allQuestions
            )
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var nodeName = System.Text.RegularExpressions
                    .Regex.Replace(sg.Type.Grouping_Type_Name, " ", "_");

                var grouping = new Grouping()
                {
                    GroupType = nodeName,
                    Abbreviation = sg.Abbreviation,
                    GroupingId = sg.Grouping_Id,
                    Title = sg.Title
                };

                if (_includeText)
                {
                    grouping.Description = sg.Description;
                }

                if (oParent is ModelStructure)
                {
                    ((ModelStructure)oParent).Groupings.Add(grouping);
                }

                if (oParent is Grouping)
                {
                    ((Grouping)oParent).Groupings.Add(grouping);
                }



                // are there any questions that belong to this grouping?
                var myQuestions = allQuestions.Where(x => x.Grouping_Id == sg.Grouping_Id && x.Parent_Question_Id == null).ToList();

                foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
                {
                    var question = new Question()
                    {
                        QuestionId = myQ.Mat_Question_Id,
                        Sequence = myQ.Sequence,
                        DisplayNumber = myQ.Question_Title,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        QuestionType = myQ.Mat_Question_Type,
                        Options = GetOptions(myQ.Mat_Question_Id)
                    };

                    if (_includeText)
                    {
                        question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                        question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;
                    }

                    grouping.Questions.Add(question);

                    var followups = GetFollowupQuestions(allQuestions, myQ.Mat_Question_Id);
                    question.Followups.AddRange(followups);
                }


                // Recurse down to build subgroupings
                GetSubgroups(grouping, sg.Grouping_Id, allGroupings, allQuestions);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="allQuestions"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        private List<Question> GetFollowupQuestions(List<MATURITY_QUESTIONS> allQuestions, int parentId)
        {
            var qList = new List<Question>();

            var myQuestions = allQuestions.Where(x => x.Parent_Question_Id == parentId).ToList();

            foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            {
                var question = new Question()
                {
                    QuestionId = myQ.Mat_Question_Id,
                    Sequence = myQ.Sequence,
                    DisplayNumber = myQ.Question_Title,
                    ParentQuestionId = myQ.Parent_Question_Id,
                    QuestionType = myQ.Mat_Question_Type,
                    Options = GetOptions(myQ.Mat_Question_Id)
                };


                if (_includeText)
                {
                    question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                    question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;
                }

                qList.Add(question);

                var followups = GetFollowupQuestions(allQuestions, myQ.Mat_Question_Id);
                question.Followups.AddRange(followups);
            }

            return qList;
        }


        private List<Option> GetOptions(int questionId)
        {
            var opts = _context.MATURITY_ANSWER_OPTIONS.Where(x => x.Mat_Question_Id == questionId)
                .OrderBy(x => x.Answer_Sequence)
                .ToList();

            var list = new List<Option>();

            foreach (var o in opts)
            {
                list.Add(
                    new Option()
                    {
                        OptionText = o.Answer_Text,
                        OptionId = o.Mat_Option_Id,
                        Sequence = o.Answer_Sequence
                    });
            }

            return list;
        }


        /// <summary>
        /// Bool-to-string
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
        public static string B2S(bool b)
        {
            return b ? "true" : "false";
        }
    }

    public class ModelStructure
    {
        public string ModelName { get; set; }
        public int ModelId { get; set; }
        public List<Grouping> Groupings { get; set; } = new List<Grouping>();
    }

    public class Grouping
    {
        public string GroupType { get; set; }
        public string Description { get; set; }
        public string Abbreviation { get; set; }
        public int GroupingId { get; set; }
        public string Title { get; set; }
        public List<Grouping> Groupings { get; set; } = new List<Grouping>();
        public List<Question> Questions { get; set; } = new List<Question>();
    }

    public class Question
    {
        public int QuestionId { get; set; }
        public string QuestionType { get; set; }
        public int Sequence { get; set; }
        public string DisplayNumber { get; set; }
        public string QuestionText { get; set; }
        public string ReferenceText { get; set; }
        //public bool IsParentQuestion { get; set; }
        public int? ParentQuestionId { get; set; }
        public List<Option> Options { get; set; } = new List<Option>();
        public List<Question> Followups { get; set; } = new List<Question>();

    }

    public class Option
    {
        public int OptionId { get; set; }
        public string OptionText { get; set; }
        public int Sequence { get; set; }
    }
}
