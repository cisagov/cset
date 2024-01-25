//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Interfaces.Dashboard;
using CSETWebCore.Model.Dashboard;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Manual;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model;
using CSETWebCore.Model.Aggregation;
using Snickler.EFCore;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSETWebCore.Business.Dashboard
{


    public class DashboardBusiness : IDashboardBusiness
    {

        private const string IndustryAverageName = "Industry Average";
        private const string SectorAverageName = "Sector Average";
        private const string MyAssesmentAverageName = "Assessment Average";
        public int sectorId;
        private readonly CSETContext _context;

        public DashboardBusiness(CSETContext context)
        {
            _context = context;
        }

        public List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData(int maturity_model_id, int? sectorId, int? industryId)
        {
            var minMax = _context.analytics_Compute_MaturityAll(maturity_model_id, sectorId, industryId);
            var median = from a in minMax
                         join b in _context.analytics_Compute_MaturityAll_Median(maturity_model_id)
                             on a.Question_Group_Heading equals b.Question_Group_Heading
                         select new AnalyticsMinMaxAvgMedianByGroup() { min = a.min, max = a.max, avg = a.avg, median = b.median, Question_Group_Heading = a.Question_Group_Heading };
            return median.ToList();



        }

        private Series GetSectorAnalytics(int sector_id)
        {
            var assessments = (from a in _context.ASSESSMENTS.AsQueryable()
                               join dd in _context.DEMOGRAPHICS.AsQueryable() on a.Assessment_Id equals dd.Assessment_Id
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

            foreach (var sector in result)
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

        public List<usp_getStandardsResultsByCategory> GetCategoryPercentagesTSA(int assessmentId)
        {
            List<usp_getStandardsResultsByCategory> response = null;

            _context.LoadStoredProc("[usp_getStandardsResultsByCategory]")
                        .WithSqlParam("assessment_Id", assessmentId)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                            var labels = (from usp_getStandardsResultsByCategory an in result
                                          orderby an.Question_Group_Heading
                                          select an.Question_Group_Heading).Distinct().ToList();


                            response = (List<usp_getStandardsResultsByCategory>)result;
                        });

            return response;
        }


        public DashboardGraphData GetDashboardData(string selectedSector)
        {
            var getMedian = _context.analytics_getMedianOverall().ToList();
            var sectorIndustryMinMax = _context.analytics_getMinMaxAverageForSectorIndustryGroup(15, 67);
            var rawdata = _context.usp_GetRawCountsForEachAssessment_Standards().ToList();
            //var myAssessmentsdata = rawdata.Find(x => x.Assessment_Id == int.Parse(assessmentId));
            var sectorIndustry = selectedSector.Split('|');
            var graphData = new DashboardGraphData();
            var statistics = new List<CategoryStatistics>();
            var categoryList = new List<string>();
            var assessments = new List<string>();
            graphData.BarData = new BarChart { Values = new List<double>(), Labels = new List<string>() };
            graphData.Min = new List<ScatterPlot>();
            graphData.Max = new List<ScatterPlot>();
            graphData.Median = new List<MedianScatterPlot>();

            foreach (var a in rawdata)
            {

                assessments.Add(a.Assessment_Id.ToString());
                categoryList.Add(a.Question_Group_Heading);
                statistics.Add(new CategoryStatistics
                {
                    AssessmentId = a.Assessment_Id.ToString(),
                    CategoryName = a.Question_Group_Heading,
                    AnsweredYes = a.Answer_Count,
                    NormalizedYes = a.Percentage,
                    Total = categoryList.Count()
                });

                graphData.BarData.Values.Add(a.Percentage);
                graphData.Max.Add(new ScatterPlot { x = 100, y = a.ToString() });
                graphData.Min.Add(new ScatterPlot { x = 0, y = a.Answer_Text.ToString() });
                //graphData.BarData.Labels.Add(a.Question_Group_Heading);
            }

            var organizelist = categoryList.Distinct();
            graphData.sampleSize = assessments.Distinct().Count();

            foreach (var c in organizelist)
            {
                graphData.BarData.Labels.Add(c);

                //var statByCat = statistics.Where(x => x.CategoryName == c).ToList();
                //var min = statByCat.MinBy(x => x.NormalizedYes).Take(1);
                ////graphData.Min.Add(new ScatterPlot { x = min.NormalizedYes, y = c });
                //graphData.Median.Add(new MedianScatterPlot
                //{ x = Math.Round(GetMedian(statByCat.Select(x => x.NormalizedYes).ToList()), 1), y = c });

            }
            foreach (var m in getMedian)
            {
                graphData.Median.Add(new MedianScatterPlot { x = m.Median, y = m.Percentage.ToString() });

                //graphData.BarData.Values.Add(new MedianScatterPlot { x = m.Mediam, y = m.Percentage.ToString() });
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
