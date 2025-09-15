using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Edm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Generates structures for heatmap display.  
    /// Started with EDM and CRR.  
    /// </summary>
    public class HeatmapGenerator
    {
        private readonly CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public HeatmapGenerator(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Get edm scoring
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public object GetEdmScores(int assessmentId, string section)
        {
            var scoring = new ModelScoring(_context, 21);
            scoring.LoadDataStructure();
            scoring.SetAnswers(assessmentId);
            var scores = scoring.GetScores().Where(x => x.Title_Id.Contains(section.ToUpper()));

            var parents = (from s in scores
                           where !s.Title_Id.Contains('.')
                           select new EdmScoreParent
                           {
                               parent = new EDMscore
                               {
                                   Title_Id = s.Title_Id.Contains('G') ? "Goal " + s.Title_Id.Split(':')[1][1] : s.Title_Id,
                                   Color = s.Color

                               },
                               children = (from s2 in scores
                                           where s2.Title_Id.Contains(s.Title_Id)
                                              && s2.Title_Id.Contains('.') && !s2.Title_Id.Contains('-')
                                           select new EDMscore
                                           {
                                               Title_Id = s2.Title_Id.Contains('-') ? s2.Title_Id.Split('-')[0].Split('.')[1] : s2.Title_Id.Split('.')[1],
                                               Color = s2.Color,
                                               children = (from s3 in scores
                                                           where s3.Title_Id.Contains(s2.Title_Id) &&
                                                                 s3.Title_Id.Contains('-')
                                                           select new EDMscore
                                                           {
                                                               Title_Id = s3.Title_Id.Split('-')[1],
                                                               Color = s3.Color
                                                           }).ToList()
                                           }).ToList()
                           }).ToList();

            for (int p = 0; p < parents.Count(); p++)
            {
                var parent = parents[p];
                for (int c = 0; c < parent.children.Count(); c++)
                {
                    var children = parent.children[c];
                    if (children.children.Any())
                    {
                        parents[p].children[c].Color = ScoreStatus.LightGray.ToString();
                    }
                }
            }

            return parents;
        }


    }
}
