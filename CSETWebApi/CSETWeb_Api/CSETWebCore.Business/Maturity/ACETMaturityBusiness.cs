using CSETWebCore.Business.Acet;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    public class ACETMaturityBusiness : MaturityBusiness
    {
        private CSETContext _context;
        public ACETMaturityBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness) : base(context, assessmentUtil, adminTabBusiness)
        {
            this._context = context;
        }

        public AVAILABLE_MATURITY_MODELS ProcessModelDefaults(int assessmentId, string installationMode)
        {
            //if the available maturity model is not selected and the application is CSET
            //the default is EDM
            //if the application is ACET the default is ACET

            return base.ProcessModelDefaults(assessmentId, installationMode, 1);
        }

        // -- 

        public MaturityResponse GetMaturityQuestions(int assessmentId, int? userId, string accessKey, bool fill, int groupingId, string installationMode)
        {
            var response = new MaturityResponse();
            var myModel = ProcessModelDefaults(assessmentId, installationMode, 1);

            var myModelDefinition = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == myModel.model_id).FirstOrDefault();

            if (myModelDefinition == null)
            {
                return response;
            }

            response.ModelId = myModelDefinition.Maturity_Model_Id;
            response.ModelName = myModelDefinition.Model_Name;

            if (response.ModelName == "ACET")
            {
                response.OverallIRP = GetOverallIrpNumber(assessmentId);
                response.MaturityTargetLevel = response.OverallIRP;
            }

            response = base.GetMaturityQuestions(assessmentId, userId, accessKey, fill, groupingId, installationMode);

            return response;
        }



        /// <summary>
        /// Returns the percentage of maturity questions that have been answered for the 
        /// current maturity level (IRP).
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public double GetAnswerCompletionRate(int assessmentId)
        {
            var irp = GetOverallIrpNumber(assessmentId);

            // get the highest maturity level for the risk level (use the stairstep model)
            var topMatLevel = GetTopMatLevelForRisk(irp);

            var answerDistribution = _context.AcetAnswerDistribution(assessmentId, topMatLevel).ToList();

            var answeredCount = 0;
            var totalCount = 0;
            foreach (var d in answerDistribution)
            {
                if (d.Answer_Text != "U")
                {
                    answeredCount += d.Count;
                }
                totalCount += d.Count;
            }

            return ((double)answeredCount / (double)totalCount) * 100d;
        }


        /// <summary>
        /// Returns the percentage of maturity questions that have been answered for the 
        /// current maturity level (IRP).
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public double GetIseAnswerCompletionRate(int assessmentId)
        {
            var irp = GetOverallIseIrpNumber(assessmentId);

            // get the highest maturity level for the risk level (use the stairstep model)
            var topMatLevel = GetIseTopMatLevelForRisk(irp);

            var answerDistribution = _context.IseAnswerDistribution(assessmentId, topMatLevel).ToList();

            var answeredCount = 0;
            var totalCount = 0;
            foreach (var d in answerDistribution)
            {
                if (d.Answer_Text != "U")
                {
                    answeredCount += d.Count;
                }
                totalCount += d.Count;
            }

            return ((double)answeredCount / (double)totalCount) * 100d;
        }



        /// <summary>
        /// Using the 'stairstep' model, determines the highest maturity level
        /// that corresponds to the specified IRP/risk.  
        /// 
        /// This stairstep model must match the stairstep defined in the UI -- getStairstepRequired(),
        /// though this method only returns the top level.
        /// </summary>
        /// <param name="irp"></param>
        /// <returns></returns>
        private int GetTopMatLevelForRisk(int irp)
        {
            switch (irp)
            {
                case 1:
                case 2:
                    return 1; // Baseline
                case 3:
                    return 2; // Evolving
                case 4:
                    return 3; // Intermediate
                case 5:
                    return 4; // Advanced
            }

            return 0;
        }


        /// <summary>
        /// Using the 'stairstep' model, determines the highest maturity level
        /// that corresponds to the specified IRP/risk.  
        /// 
        /// This stairstep model must match the stairstep defined in the UI -- getStairstepRequired(),
        /// though this method only returns the top level.
        /// </summary>
        /// <param name="irp"></param>
        /// <returns></returns>
        private int GetIseTopMatLevelForRisk(int irp)
        {
            switch (irp)
            {
                case 1:
                    return 1; // SCUEP
                case 2:
                    return 2; // CORE
                case 3:
                    return 3; // CORE+
            }

            return 0;
        }



    }
}
