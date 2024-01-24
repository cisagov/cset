//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using System.Globalization;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Model.Sal;
using CSETWebCore.DataLayer.Model;
using Nelibur.ObjectMapper;
using CSETWebCore.Business.Standards;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Standards;

namespace CSETWebCore.Business.Sal
{
    public class SalBusiness : ISalBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentModeData _assessmentModeData;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IStandardsBusiness _standard;
        private readonly IStandardSpecficLevelRepository _standardRepo;

        /// <summary>
        /// TSA's default level
        /// </summary>
        public static readonly string DefaultSalTsa = "Low";


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentModeData"></param>
        public SalBusiness(CSETContext context, IAssessmentModeData assessmentModeData, IAssessmentUtil assessmentUtil,
            IStandardsBusiness standard, IStandardSpecficLevelRepository standardRepo)
        {
            _context = context;
            _assessmentModeData = assessmentModeData;
            _assessmentUtil = assessmentUtil;
            _standard = standard;
            _standardRepo = standardRepo;
        }


        /// <summary>
        /// Returns the currently-selected SAL answers.
        /// </summary>
        /// <returns></returns>
        public Sals GetSals(int assessmentId)
        {
            TinyMapper.Bind<STANDARD_SELECTION, Sals>();
            TinyMapper.Bind<Sals, STANDARD_SELECTION>();

            STANDARD_SELECTION dbStandardSelection = _context.STANDARD_SELECTION.Find(assessmentId);

            Sals rsal;
            if (dbStandardSelection == null)
            {
                rsal = new Sals()
                {
                    Selected_Sal_Level = "Low",
                    Methodology = "Simple",
                    CLevel = "Low",
                    ALevel = "Low",
                    ILevel = "Low"
                };
                dbStandardSelection = TinyMapper.Map<STANDARD_SELECTION>(rsal);
                dbStandardSelection.Last_Sal_Determination_Type = rsal.Methodology;
                dbStandardSelection.Assessment_Id = assessmentId;
                dbStandardSelection.Application_Mode = _assessmentModeData.DetermineDefaultApplicationMode();
                _context.STANDARD_SELECTION.Add(dbStandardSelection);
                _context.SaveChanges();
            }
            else
            {
                rsal = TinyMapper.Map<Sals>(dbStandardSelection);
                rsal.Methodology = dbStandardSelection.Last_Sal_Determination_Type;
            }

            LevelManager lm = new LevelManager(assessmentId, _context);
            lm.RetrieveOtherLevels(rsal);

            StandardRepository sr = new StandardRepository(_standard, _assessmentModeData, _context, _assessmentUtil, _standardRepo);
            sr.InitializeStandardRepository(assessmentId);
            sr.Confidence_Level = rsal.CLevel;
            sr.Integrity_Level = rsal.ILevel;
            sr.Availability_Level = rsal.ALevel;

            return rsal;
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
        public void SetDefault(int assessmentId, string level = "Low")
        {
            TextInfo ti = new CultureInfo("en-US", false).TextInfo;
            level = ti.ToTitleCase(level);

            TinyMapper.Bind<STANDARD_SELECTION, Sals>();
            TinyMapper.Bind<Sals, STANDARD_SELECTION>();

            //STANDARD_SELECTION standardSelection = _context.STANDARD_SELECTION.Find(assessmentId);

            Sals sals = new Sals()
            {
                Selected_Sal_Level = level,
                Methodology = "Simple",
                CLevel = level,
                ALevel = level,
                ILevel = level
            };

            STANDARD_SELECTION standardSelection;
            standardSelection = TinyMapper.Map<STANDARD_SELECTION>(sals);
            standardSelection.Assessment_Id = assessmentId;
            standardSelection.Application_Mode = _assessmentModeData.DetermineDefaultApplicationMode();

            _context.STANDARD_SELECTION.Add(standardSelection);
            _context.SaveChanges();
        }
    }
}