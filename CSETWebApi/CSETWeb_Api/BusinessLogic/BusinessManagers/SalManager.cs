//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.AssessmentData;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using Nelibur.ObjectMapper;
using System;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    class SalManager
    {
        public void SetDefaultSALs(int assessmentId)
        {
            try
            {
                using (CSET_Context db = new CSET_Context())
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
                    standardSelection.Application_Mode = AssessmentModeData.QUESTIONS_BASED_APPLICATION_MODE;

                    db.STANDARD_SELECTION.Add(standardSelection);
                    db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                throw (e);
            }
        }
    }
}


