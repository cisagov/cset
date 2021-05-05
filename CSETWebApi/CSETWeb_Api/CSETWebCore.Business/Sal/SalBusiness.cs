using System;
using System.Linq;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Model.Sal;
using CSETWebCore.DataLayer;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.Sal
{
    public class SalBusiness : ISalBusiness
    {
        private CSET_Context _context;
        private readonly IAssessmentModeData _assessmentModeData;

        public SalBusiness(CSET_Context context, IAssessmentModeData assessmentModeData)
        {
            _context = context;
            _assessmentModeData = assessmentModeData;
        }

        public void SetDefaultSAL_IfNotSet(int assessmentId)
        {
            try
            {
                if (_context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault() == null)
                {
                    Setdefault(assessmentId);
                }
            }
            catch (Exception e)
            {
                throw (e);
            }
        }

        public void SetDefaultSALs(int assessmentId)
        {
            try
            {
               Setdefault(assessmentId);
            }
            catch (Exception e)
            {
                throw (e);
            }
        }

        public void Setdefault(int assessmentId)
        {
            TinyMapper.Bind<STANDARD_SELECTION, Sals>();
            TinyMapper.Bind<Sals, STANDARD_SELECTION>();

            STANDARD_SELECTION standardSelection = _context.STANDARD_SELECTION.Find(assessmentId);

            Sals sals = new Sals()
            {
                Selected_Sal_Level = "Low",
                Last_Sal_Determination_Type = "Simple",
                CLevel = "Low",
                ALevel = "Low",
                ILevel = "Low"
            };

            standardSelection = TinyMapper.Map<STANDARD_SELECTION>(sals);
            standardSelection.Assessment_Id = assessmentId;
            standardSelection.Application_Mode = _assessmentModeData.DetermineDefaultApplicationMode();

            _context.STANDARD_SELECTION.Add(standardSelection);
            _context.SaveChanges();
        }

    }
}