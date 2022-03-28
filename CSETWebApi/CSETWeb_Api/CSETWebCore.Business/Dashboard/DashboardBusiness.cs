using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Interfaces.Dashboard;
using CSETWebCore.Model.Dashboard;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSETWebCore.Business.Dashboard
{


    public class DashboardBusiness : IDashboardBusiness
    {

        private const string IndustryAverageName = "Industry Average";
        private const string SectorAverageName = "Sector Average";
        private const string MyAssesmentAverageName = "Assessment Average";
        public  int sectorId;
        private readonly CSETContext _context;

        public DashboardBusiness(CSETContext context)
        {
            _context = context;
        }

        private Series GetSectorAnalytics(int sector_id)
        {
            var assessments = (from a in _context.ASSESSMENTS.AsQueryable()
                               join  dd in _context.DEMOGRAPHICS.AsQueryable() on a.Assessment_Id equals dd.Assessment_Id
                               where dd.SectorId == sector_id
                               select a).ToList();
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

            return new Series() { name = SectorAverageName, value = average * 100 };
        }

        private Series GetMyAnalytics(string myAssessment_Id)
        {
            var assessments = (from a in _context.ASSESSMENTS.AsQueryable()
                               where a.Assessment_Id.ToString() == myAssessment_Id
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

            return new Series() { name = MyAssesmentAverageName, value = average * 100 };
        }

        //public async Task<List<AssessmentData>> GetUserAssessments(string userId)
        //{
        //    var assessments = await _context.ASSESSMENTS.Find(a => a.AssessmentCreatorId == userId).ToListAsync();
        //    return assessments;
        //}

        public async Task<List<SectorIndustryVM>> GetSectors()
        {

           

            var List = new List<SectorIndustryVM>();
            var result = await _context.SECTOR.ToListAsync();
            //var query = from sector in _context.SECTOR
            //            select sector;

            foreach(var sector in result)
            {
                var sectorindustryList = new SectorIndustryVM();
                //this.sectorId = sector.SectorId;
                if (result != null)
                {

                    sectorindustryList.SectorId = sector.SectorId;
                    sectorindustryList.SectorName = sector.SectorName;
                    sectorindustryList.Industries = new List<string>();
                    GetSelectedIndustryList(ref sectorindustryList);
                }
                List.Add(sectorindustryList);
            }
           

            return List;
        }
         
        public void GetSelectedIndustryList(ref SectorIndustryVM sectorindustryList)
        {
            var id = sectorindustryList.SectorId;
           var industryList = _context.SECTOR_INDUSTRY.Where(x => x.SectorId == id).ToList();
          
            foreach (var s in industryList)
            {
                sectorindustryList.Industries.Add(s.IndustryName);
            }
        }








        public async Task<DashboardGraphData> GetDashboardData(string industry, string assessmentId)
        {
            var sectorIndustry = industry.Split('|');
            var graphData = new DashboardGraphData();
            var statistics = new List<CategoryStatistics>();
            var categoryList = new List<string>();
            //var myQuestions = await _context.ANSWER.Where(x=>x.Assessment_Id==int.Parse(assessmentId)).ToListAsync();

            var myQuestions = (from answer in _context.ANSWER
                         join demo in _context.DEMOGRAPHICS on answer.Assessment_Id equals demo.Assessment_Id
                         where answer.Assessment_Id == int.Parse(assessmentId)
                         select new { answer, demo });




            var questions = await _context.ANSWER.ToListAsync();
            //if (sectorIndustry.Length > 1 && sectorIndustry[1] != "All Sectors")
            //    questions = questions.Where(x => (x.Sector == sectorIndustry[0] && x.Industry == sectorIndustry[1]) || x.AssessmentId == assessmentId).ToList();
            var assessments = from q in questions
                              group q by q.Assessment_Id
                into assessmentGroup
                              from categoryGroup in
                                  (from a in assessmentGroup
                                   group a by a.Assessment_Id
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
                        CategoryName = category.Key.ToString(),
                        AnsweredYes = questionList.Count(x => x.Answer_Text == "Y"),
                        NormalizedYes = Math.Round(((double)questionList.Count(x => x.Answer_Text == "Y") / questionList.Count()) * 100, 1),
                        Total = questionList.Count()
                    });
                }
            }
            categoryList = myQuestions.Select(x => x.answer.Answer_Text).Distinct().ToList();
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
                    var min = statByCat.MinBy(x => x.NormalizedYes).Take(1);
                    graphData.Min.Add(item: new ScatterPlot { x = (double)min, y = c });
                    var max = statByCat.MaxBy(x => x.NormalizedYes).Take(1);
                    graphData.Max.Add(new ScatterPlot { x = (double)max, y = c });
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
