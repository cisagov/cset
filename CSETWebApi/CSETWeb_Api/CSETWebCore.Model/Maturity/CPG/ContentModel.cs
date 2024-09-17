using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity.CPG
{
    public class ContentModel
    {
        public int AssessmentId { get; set; }
        public string ModelName { get; set; }
        public int ModelId { get; set; }

        public List<Domain> Domains { get; set; } = new List<Domain>();
    }

    public class Domain
    {
        public string Abbreviation { get; set; }
        public string Description { get; set; }
        public int GroupingId { get; set; }
        public string Title { get; set; }
        public string TitlePrefix { get; set; }
        public string Remarks { get; set; }
        public List<Domain> Groupings { get; set; }
        public List<Question> Questions { get; set; } = new List<Question>();
    }

    public class Question
    {
        public int QuestionId { get; set; }
		public int? ParentQuestionId { get; set; }
		public int Sequence { get; set; }
        public string DisplayNumber { get; set; }
        public string Answer { get; set; }
        public string Comment { get; set; }
        public bool IsParentQuestion { get; set; }
        public string QuestionText { get; set; }
		public string Supplemental { get; set; }
		public string Scope { get; set; }
		public string RecommendedAction { get; set; }
        public string RiskAddressed { get; set; }
		public string Services { get; set; }
		public string ReferenceText { get; set; }
        public string SecurityPractice { get; set; }
        public string Outcome { get; set; }
        public string ImplementationGuides { get; set; }

        public string Cost { get; set; }
        public string Impact { get; set; }
        public string Complexity { get; set; }

        public List<string> CsfMappings { get; set; } = [];
        public List<TTPReference> TTP { get; set; } = [];

        // may need to beef up CSF and TTP with more detail

        // may also want to include full Properties list at some point		
    }
}
