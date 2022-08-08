using System;
using System.Linq;
using System.Globalization;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Model.Sal;
using CSETWebCore.DataLayer.Model;
using Nelibur.ObjectMapper;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.Sal
{
    public class SalBusiness : ISalBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentModeData _assessmentModeData;

        /// <summary>
        /// TSA's default level
        /// </summary>
        public static readonly string DefaultSalTsa = "Low";


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentModeData"></param>
        public SalBusiness(CSETContext context, IAssessmentModeData assessmentModeData)
        {
            _context = context;
            _assessmentModeData = assessmentModeData;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void SetDefaultSAL_IfNotSet(int assessmentId)
        {
            if (_context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault() == null)
            {
                SetDefault(assessmentId);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void SetDefaultSALs(int assessmentId, string level = "Low")
        {
            SetDefault(assessmentId, level);
        }


        /// <summary>
        /// Sets the SAL to Simple Low.  The level can be overridden.
        /// </summary>
        /// <param name="assessmentId"></param>
        public async Task SetDefault(int assessmentId, string level = "Low")
        {
            TextInfo ti = new CultureInfo("en-US", false).TextInfo;
            level = ti.ToTitleCase(level);

            TinyMapper.Bind<STANDARD_SELECTION, Sals>();
            TinyMapper.Bind<Sals, STANDARD_SELECTION>();

            STANDARD_SELECTION standardSelection = await _context.STANDARD_SELECTION.FindAsync(assessmentId);

            Sals sals = new Sals()
            {
                Selected_Sal_Level = level,
                Last_Sal_Determination_Type = "Simple",
                CLevel = level,
                ALevel = level,
                ILevel = level
            };

            standardSelection = TinyMapper.Map<STANDARD_SELECTION>(sals);
            standardSelection.Assessment_Id = assessmentId;
            standardSelection.Application_Mode = _assessmentModeData.DetermineDefaultApplicationMode();

            _context.STANDARD_SELECTION.Add(standardSelection);
            await _context.SaveChangesAsync();
        }
    }
}