using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using SixLabors.ImageSharp.ColorSpaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    public class CpgBusiness
    {
        private readonly CSETContext _context;
        private readonly TranslationOverlay _overlay;
        private readonly string _lang;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public CpgBusiness(CSETContext context, string lang)
        {
            _context = context;

            _overlay = new TranslationOverlay();
            _lang = lang;
        }


        /// <summary>
        /// Returns the answer percentage distributions for each of the
        /// 8 CPG domains.
        /// 
        /// If an SSG question set is applicable, those questions are included
        /// in the distributions.
        /// </summary>
        /// <returns></returns>
        public List<AnswerDistribDomain> GetAnswerDistribForDomains(int assessmentId)
        {
            var resp = new List<AnswerDistribDomain>();

            // get the CPG question distribution
            var dbListCpg = _context.GetAnswerDistribGroupings(assessmentId, null);


            // see if an SSG is applicable and combine the results with the CPG questions
            var ssgModelId = DetermineSsgModel(assessmentId);
            if (ssgModelId != null)
            {
                var dbListSsg = _context.GetAnswerDistribGroupings(assessmentId, ssgModelId);
                foreach (var ssg in dbListSsg)
                {
                    var target = dbListCpg.Where(x => x.title == ssg.title && x.answer_text == ssg.answer_text).FirstOrDefault();
                    if (target != null)
                    {
                        target.answer_count += ssg.answer_count;
                    }
                    else
                    {
                        dbListCpg.Add(ssg);
                    }
                }
            }


            foreach (var item in dbListCpg)
            {
                // translate if necessary
                item.title = _overlay.GetMaturityGrouping(item.grouping_id, _lang)?.Title ?? item.title;
                if (!resp.Exists(x => x.Name == item.title))
                {
                    var domain = new AnswerDistribDomain()
                    {
                        Name = item.title,
                        Series = InitializeSeries()
                    };

                    resp.Add(domain);
                }
            }

            // determine percentages for each answer count in the distribution
            resp.ForEach(domain =>
            {
                domain.Series.ForEach(y =>
                {
                    double percent = CalculatePercent(dbListCpg.Where(g => g.title == domain.Name).ToList(), y.Name);
                    y.Value = percent;

                });
            });

            return resp;
        }


        /// <summary>
        /// Calculates the percentage based on all answer values for the domain
        /// </summary>
        /// <returns></returns>
        private double CalculatePercent(List<GetAnswerDistribGroupingsResult> r, string ansName)
        {
            var target = r.FirstOrDefault(x => x.answer_text == ansName)?.answer_count ?? 0;
            var total = r.Select(x => x.answer_count).Sum();

            return ((double)target * 100d / (double)total);
        }


        /// <summary>
        /// Initializes 'empty' percentge slots for potential CPG answers.
        /// </summary>
        /// <returns></returns>
        private List<Series> InitializeSeries()
        {
            var list = new List<Series>();

            var values = new List<string>() { "Y", "I", "S", "N", "U" };
            foreach (string s in values)
            {
                list.Add(new Series()
                {
                    Name = s,
                    Value = 0
                });
            }

            return list;
        }


        /// <summary>
        /// Figures out if an SSG model is applicable as a bonus.
        /// The SSG is based on the assessment's sector.
        /// Returns null if no SSG is applicable.
        /// </summary>
        /// <returns></returns>
        public int? DetermineSsgModel(int assessmentId)
        {
            var demographics = _context.DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            var ddSector = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "SECTOR").FirstOrDefault();



            // CHEMICAL
            var chemicalSectors = new List<int>() { 1, 19 };
            if ((chemicalSectors.Contains(demographics?.SectorId ?? -1))
                || chemicalSectors.Contains(ddSector?.IntValue ?? -1))
            {
                return 18;
            }


            return null;
        }
    }
}
