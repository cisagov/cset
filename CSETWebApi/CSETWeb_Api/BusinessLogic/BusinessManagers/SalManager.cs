//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.AssessmentData;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWebCore.DataLayer;
using Nelibur.ObjectMapper;
using System;
using System.Linq;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    class SalManager
    {
        public void SetDefaultSAL_IfNotSet(int assessmentId)
        {
            try
            {
                using (CSET_Context db = new CSET_Context())
                {
                    if (db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault() == null)
                    {
                        setdefault(db, assessmentId);
                    }
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
                using (CSET_Context db = new CSET_Context())
                {
                    setdefault(db, assessmentId);
                }
            }
            catch (Exception e)
            {
                throw (e);
            }
        }

        private void setdefault(CSET_Context db, int assessmentId)
        {
                    TinyMapper.Bind<STANDARD_SELECTION, Sals>();
                    TinyMapper.Bind<Sals, STANDARD_SELECTION>();

                    STANDARD_SELECTION standardSelection = db.STANDARD_SELECTION.Find(assessmentId);

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
                    standardSelection.Application_Mode = AssessmentModeData.DetermineDefaultApplicationMode();

                    db.STANDARD_SELECTION.Add(standardSelection);
                    db.SaveChanges();            
        }
    }
}


