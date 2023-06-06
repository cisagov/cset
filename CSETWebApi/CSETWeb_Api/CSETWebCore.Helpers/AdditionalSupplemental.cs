using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Encapsulates logic to handle additional fields
    /// like TTPs, CSF Mappings, Scope, Recommended Action,
    /// Risk Addressed and Services.
    /// </summary>
    public class AdditionalSupplemental
    {
        private CSETContext _context;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public AdditionalSupplemental(CSETContext context)
        {
            this._context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        public List<TTPReference> GetTTPReferenceList(int questionId)
        {
            var xx = _context.TTP_MAT_QUESTION
                .Include(x => x.TTP_CodeNavigation).Where(x => x.Mat_Question_Id == questionId).ToList();

            var resp = new List<TTPReference>();
            foreach (var y in xx)
            {
                resp.Add(new TTPReference()
                {
                    Code = y.TTP_Code,
                    Description = y.TTP_CodeNavigation.Description,
                    ReferenceUrl = y.TTP_CodeNavigation.URL
                });
            }

            return resp;
        }


        /// <summary>
        /// Returns a list of CSF references that are mapped to the question
        /// defined by the question ID and the question type (Maturity or Standard).
        /// </summary>
        /// <param name="questionId"></param>
        /// <param name="questionType"></param>
        /// <returns></returns>
        public List<string> GetCsfMappings(int questionId, string questionType)
        {
            var xx = _context.CSF_MAPPING.Where(x => x.Question_Id == questionId && x.Question_Type == questionType).ToList();

            var resp = new List<string>();
            foreach (var y in xx)
            {
                resp.Add(y.CSF_Code);
            }

            return resp;
        }
    }
}
