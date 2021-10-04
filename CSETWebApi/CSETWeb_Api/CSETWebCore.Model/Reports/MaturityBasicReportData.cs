//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Maturity;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Reports
{
    public class MaturityBasicReportData
    {
        public List<MatRelevantAnswers> DeficienciesList { get; set; }
        public BasicReportData.INFORMATION Information { get; set; }
        public List<MatRelevantAnswers> AlternateList { get; set; }
        public List<MatRelevantAnswers> Comments { get; set; }
        public List<MatRelevantAnswers> MarkedForReviewList { get; set; }
        public List<MatRelevantAnswers> QuestionsList { get; set; }
        public List<MatAnsweredQuestionDomain> MatAnsweredQuestions { get; set; }

        /// <summary>
        /// Gets the parent questions missing from the given list. Requires the QuestionsList
        /// value be non-null.
        /// </summary>
        /// <param name="from"></param>
        /// <returns></returns>
        public IEnumerable<MatRelevantAnswers> GetMissingParents(IEnumerable<MatRelevantAnswers> from)
        {
            var parentsPresent = new HashSet<int>();
            var parentsRequired = new HashSet<int>();

            foreach (var matAnswer in from)
            {
                if (matAnswer.Mat.Parent_Question_Id is null)
                {
                    parentsPresent.Add(matAnswer.Mat.Mat_Question_Id);
                }
                else
                {
                    parentsRequired.Add((int)(matAnswer.Mat.Parent_Question_Id));
                }
            }

            var missingIds = parentsRequired.Except(parentsPresent);
            return QuestionsList.Where(q => missingIds.Contains(q.Mat.Mat_Question_Id));
        }

        public IEnumerable<MatRelevantAnswers> GetCombinedList(List<MatRelevantAnswers> from)
        {
            return from
                .Concat(GetMissingParents(from))
                .OrderBy(m => m.Mat.Question_Title.Split('-')[0])
                .ThenBy(m => m.Mat.Question_Text);
        }
    }
}