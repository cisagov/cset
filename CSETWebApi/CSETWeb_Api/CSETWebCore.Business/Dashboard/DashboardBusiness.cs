
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
//using CSETWebCore.DomainModels;
using CSETWebCore.Interfaces.Dashboard;
using CSETWebCore.Model.Dashboard;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model.Demographic;
using CSETWebCore.Model;
//using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Business.Dashboard
{
    public class DashboardBusiness : IDashboardBussiness
    {
		private const string IndustryAverageName = "Industry Average";
		private const string SectorAverageName = "Sector Average";
		private const string MyAssesmentAverageName = "Assessment Average";

		private readonly CSETContext _context;

		public DashboardBusiness(CSETContext contex)
		{
			_context = contex;
		}
        private Model.Dashboard.Series GetSectorAnalytics(int sector_id)
        {
            //var assessments = (from a in _context.ASSESSMENTS.AsQueryable() join
            //                   where a.Assessment_Id == sector_id
            //                   select a).ToList();

            var assessments = from ddd in _context.DEMOGRAPHICS
                              from ds in _context.ASSESSMENTS.Where(x => x.Assessment_Id == ddd.Assessment_Id).DefaultIfEmpty()
                                  //from dav in _context.DEMOGRAPHICS_ASSET_VALUES.Where(x => x.AssetValue == ddd.AssetValue).DefaultIfEmpty()
                              where ddd.SectorId == sector_id
                              select ds;
            Console.WriteLine(assessments);

            var query = (from a in assessments.AsQueryable()
                         join q in _context.ANSWER.AsQueryable() on a.Assessment_Id equals q.Assessment_Id
                         //where a.SectorId == sector_id
                         select q).ToList();

            var tempQuery = (from q in query.AsQueryable()
                             group new { q.Assessment_Id, q.Answer_Text } by new
                             {
                                 q.Assessment_Id,
                                 q.Answer_Text
                             }
                into g
                             select new
                             {
                                 g.Key.Assessment_Id,
                                 g.Key.Answer_Text,
                                 Count = g.Count()
                             }).ToList();

            //go through get the sum total of all
            //get the sum of yes and alts
            //then calc the percent of each assessment and
            //sector average.

            Dictionary<string, QuickSum> sums = new Dictionary<string, QuickSum>();
            foreach (var a in tempQuery)
            {

                QuickSum quickSum;
                if (sums.TryGetValue(a.Assessment_Id.ToString(), out quickSum))
            {
                quickSum.TotalCount += a.Count;
                if (a.Answer_Text == "Y" || a.Answer_Text == "A")
                {
                    quickSum.YesAltCount += a.Count;
                }
            }
            else
            {
                int yaltCount = 0;
                if (a.Answer_Text == "Y" || a.Answer_Text == "A")
                {
                    yaltCount = a.Count;
                }
                sums.Add(a.Assessment_Id.ToString(), new QuickSum() { assesment_id = a.Assessment_Id.ToString(), TotalCount = a.Count, YesAltCount = yaltCount });

            }
        }

            //calculate the average percentage of all the assessments
            double average = 0;
            foreach (QuickSum s in sums.Values)
            {
                average += s.Percentage;
            }
            average = average / (sums.Values.Count() == 0 ? 1 : sums.Values.Count());

            return new Model.Dashboard.Series() { name = SectorAverageName, value = average * 100 };
        }

        private Model.Dashboard.Series GetMyAnalytics(string myAssessment_Id)
        {
            int assessmentId = Int32.Parse(myAssessment_Id);
            var assessments = (from a in _context.ASSESSMENTS.AsQueryable()
                               where a.Assessment_Id == assessmentId
                               select a).ToList();
            var questions = (from a in assessments.AsQueryable()
                             join q in _context.ANSWER.AsQueryable() on a.Assessment_Id equals q.Assessment_Id
                             select q).ToList();
            var query = (from q in questions.AsQueryable()
                         group new { q.Assessment_Id, q.Answer_Text } by new
                         {
                             q.Assessment_Id,
                             q.Answer_Text
                         }
                into g
                         select new
                         {
                             g.Key.Assessment_Id,
                             g.Key.Answer_Text,
                             Count = g.Count()
                         }).ToList();

            //go through get the sum total of all
            //get the sum of yes and alts
            //then calc the percent of each assessment and
            //sector average.

            Dictionary<string, QuickSum> sums = new Dictionary<string, QuickSum>();
            foreach (var a in query.ToList())
            {
                QuickSum quickSum;
                if (sums.TryGetValue(a.Assessment_Id.ToString(), out quickSum))
                {
                    quickSum.TotalCount += a.Count;
                    if (a.Answer_Text == "Y" || a.Answer_Text == "A")
                    {
                        quickSum.YesAltCount += a.Count;
                    }
                }
                else
                {
                    int yaltCount = 0;
                    if (a.Answer_Text == "Y" || a.Answer_Text == "A")
                    {
                        yaltCount = a.Count;
                    }
                    sums.Add(a.Assessment_Id.ToString(), new QuickSum() { assesment_id = a.Assessment_Id.ToString(), TotalCount = a.Count, YesAltCount = yaltCount });

                }
            }

            //calculate the average percentage of all the assessments
            double average = 0;
            foreach (QuickSum s in sums.Values)
            {
                average += s.Percentage;
            }
            average = average / (sums.Values.Count() == 0 ? 1 : sums.Values.Count());

            return new Model.Dashboard.Series() { name = MyAssesmentAverageName, value = average * 100 };
        }

        //public async Task<List<AssessmentData>> GetUserAssessments(string userId)
        //{
        //    var assessments = await _context.ASSESSMENTS.Find(a => a.AssessmentCreatorId == userId).ToListAsync();
        //    return assessments;
        //}

        //public async Task<List<Sector>> GetSectors()
        //{
        //    var sectors = await _context.SECTOR.ToListAsync();
        //    List<SECTOR_INDUSTRY> ListIndustry = new List<SECTOR_INDUSTRY>();

        //    //foreach (var a in sectors)
        //    //{

        //    //}
        //    return sectors;
        //}

        public async Task<DashboardGraphData> GetDashboardData(string industry, string assessmentId)
        {
            var sectorIndustry = industry.Split('|');
            var graphData = new DashboardGraphData();
            var statistics = new List<CategoryStatistics>();
            var categoryList = new List<string>();
            var myQuestions = await _context.ANSWER.Find(x => x.Assessment_id == assessmentId).ToListAsync();
            var questions = await _context.An.Find(x => true).ToListAsync();
            if (sectorIndustry.Length > 1 && sectorIndustry[1] != "All Sectors")
                questions = questions.Where(x => (x.Sector == sectorIndustry[0] && x.Industry == sectorIndustry[1]) || x.AssessmentId == assessmentId).ToList();
            var assessments = from q in questions
                              group q by q.AssessmentId
                into assessmentGroup
                              from categoryGroup in
                                  (from a in assessmentGroup
                                   group a by a.CategoryText
                                  )
                              group categoryGroup by assessmentGroup.Key;
            graphData.sampleSize = assessments.Select(x => x.Key).Count();
            foreach (var assessment in assessments)
            {
                foreach (var category in assessment)
                {
                    //categoryList.Add(category.Key);
                    var questionList = category.ToList();
                    statistics.Add(new CategoryStatistics
                    {
                        AssessmentId = assessment.Key.ToString(),
                        CategoryName = category.Key,
                        AnsweredYes = questionList.Count(x => x.AnswerText == "Y"),
                        NormalizedYes = Math.Round(((double)questionList.Count(x => x.AnswerText == "Y") / questionList.Count()) * 100, 1),
                        Total = questionList.Count()
                    });
                }
            }
            categoryList = myQuestions.Select(x => x.CategoryText).Distinct().ToList();
            categoryList.Sort();
            //categoryList = categoryList.Distinct().ToList();
            graphData.BarData = new BarChart { Values = new List<double>(), Labels = new List<string>() };
            graphData.Min = new List<ScatterPlot>();
            graphData.Max = new List<ScatterPlot>();
            graphData.Median = new List<MedianScatterPlot>();
            foreach (var c in categoryList)
            {
                var statByCat = statistics.Where(x => x.CategoryName == c).ToList();
                if (statByCat.Count() > 0)
                {
                    var min = statByCat.MinBy(x => x.NormalizedYes).Take(1).FirstOrDefault();
                    graphData.Min.Add(new ScatterPlot { x = min.NormalizedYes, y = c });
                    var max = statByCat.MaxBy(x => x.NormalizedYes).Take(1).FirstOrDefault();
                    graphData.Max.Add(new ScatterPlot { x = max.NormalizedYes, y = c });
                    graphData.Median.Add(new MedianScatterPlot
                    { x = Math.Round(GetMedian(statByCat.Select(x => x.NormalizedYes).ToList()), 1), y = c });
                    var answeredYes = statByCat.FirstOrDefault(x => x.AssessmentId == assessmentId);
                    graphData.BarData.Values.Add(answeredYes.NormalizedYes);
                    graphData.BarData.Labels.Add(c);
                }
            }
            return graphData;
        }

        public double GetMedian(List<double> answers)
        {
            if (answers == null || answers.Count == 0)
                return 0;
            var sortedNumbers = answers;
            answers.Sort();

            int size = sortedNumbers.Count();
            int mid = size / 2;
            double median = (size % 2 != 0) ? (double)sortedNumbers[mid] : ((double)sortedNumbers[mid] + (double)sortedNumbers[mid - 1]) / 2;
            return median;
        }

        public Task<List<AssessmentData>> GetUserAssessments(string userId)
        {
            throw new NotImplementedException();
        }

        Task<List<AssessmentData>> IDashboardBussiness.GetUserAssessments(string userId)
        {
            throw new NotImplementedException();
        }

        Task<List<Sector>> IDashboardBussiness.GetSectors()
        {
            throw new NotImplementedException();
        }

        Task<DashboardGraphData> IDashboardBussiness.GetDashboardData(string industry, string assessmentId)
        {
            throw new NotImplementedException();
        }
    }

    internal class QuickSum
    {
        public string assesment_id { get; set; }
        public int TotalCount { get; set; }
        public int YesAltCount { get; set; }
        public double Percentage
        {
            get
            {
                return (double)YesAltCount / (double)TotalCount;
            }
        }
    }
}

