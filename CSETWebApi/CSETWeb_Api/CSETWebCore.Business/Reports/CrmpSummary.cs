using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using log4net.Core;
using Snickler.EFCore;

namespace CSETWebCore.Business.Reports;

public class CrmpSummary
{
     private readonly CSETContext _context;


        /// <summary>
        /// modeled from RRA
        /// </summary>
        /// <param name="context"></param>
        public CrmpSummary(CSETContext context)
        {
            this._context = context;
        }
        //Currently throwing exception because of second arg for group score logic
        //public List<CrmpStoredProcModels.usp_getCrmpSummary> GetCrmpSummary(int assessmentId, MaturityReportData.MaturityModel model)
        public List<CrmpStoredProcModels.usp_getCrmpSummary> GetCrmpSummary(int assessmentId)
        {
            List<CrmpStoredProcModels.usp_getCrmpSummary> results = null;
            
            _context.LoadStoredProc("[usp_getCrmpSummary]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                 results = handler.ReadToList<CrmpStoredProcModels.usp_getCrmpSummary>().ToList();
            });
            return results;
            // int MatLevel = levels[0];
            //TODO          Place Scoring Logic  
            
            //var maturity_levels = model.MaturityQuestions.
                //Select(mq => mq.Maturity_Level).
                //Distinct();
            //List<CrmpStoredProcModels.usp_getCrmpSummary> MatScore = new List<CrmpStoredProcModels.usp_getCrmpSummary>(maturity_levels.Min());
            //return MatScore;
            
        }
        
        // 
        // public List<CrmpStoredProcModels.usp_getCrmpSummary> GetCrmpSummary(int assessmentId)
        // {
        //     throw new System.NotImplementedException();
        // }
}