//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CSETWeb_Api.Controllers.sal
{
    public class GeneralSalManager
    {
        private CSET_Context db;

        private Dictionary<double, string> SALThresholdDictionary { get; set; }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="db"></param>
        public GeneralSalManager(CSET_Context db)
        {
            InitializeSALThresholds();
            this.db = db;
        }


        /// <summary>
        /// Gets the current saved slider weights from the database and 
        /// feeds them to the calculation.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public String GetCurrentSAL(int assessmentId)
        {
            //go to the database get the current list of selected weights 
            //pass that to the calculate 

            var weights = from a in db.GENERAL_SAL
                          join b in db.GEN_SAL_WEIGHTS on new { a.Sal_Name, a.Slider_Value } equals new { b.Sal_Name, b.Slider_Value }
                          where a.Assessment_Id == assessmentId
                          select b;
            List<GEN_SAL_WEIGHTS> materialized = weights.ToList();
            double weight = GetOverallSALWeight(materialized);
            return CalculateSAL(weight);
        }


        private void InitializeSALThresholds()
        {
            //going to make this a little less conservative
            this.SALThresholdDictionary = new Dictionary<double, string>();

            // RKW - Barry says NONE is no longer a valid SAL level ..... this.SALThresholdDictionary.Add(0, Constants.SAL_NONE);
            this.SALThresholdDictionary.Add(1, Constants.SAL_LOW);
            this.SALThresholdDictionary.Add(255, Constants.SAL_MODERATE);
            this.SALThresholdDictionary.Add(1000, Constants.SAL_HIGH);
            this.SALThresholdDictionary.Add(20000, Constants.SAL_VERY_HIGH);
        }


        /// <summary>
        /// calculates the overall GenSal weight
        /// (its is a simple sum of the current selected weight values)
        /// </summary>
        /// <returns></returns>
        private double GetOverallSALWeight(List<GEN_SAL_WEIGHTS> weights)
        {
            //need to pass in a list of the weights
            //currently selected items can be retrieved from the database
            double weight = 0;
            foreach (GEN_SAL_WEIGHTS mapping in weights)
            { // TODO: probably better to iterate through the children on the page but dictionary works for now.
                weight += (double)mapping.Weight;
            }

            return weight;
        }


        /// <summary>
        /// Calculates the SAL based on the value of the sliders.
        /// The new calculated level is saved to the database.
        /// </summary>
        private string CalculateSAL(double weight)
        {
            string SALToReturn = Constants.SAL_LOW;            
            foreach (double thresholdValue in this.SALThresholdDictionary.Keys)
            {
                if (weight >= thresholdValue)
                {
                    SALToReturn = SALThresholdDictionary[thresholdValue];
                }
            }

            // Persist the overall SAL to the database
            int assessmentId = Auth.AssessmentForUser();
            STANDARD_SELECTION ss = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            ss.Selected_Sal_Level = SALToReturn;
            db.SaveChanges();

            return SALToReturn;
        }


        public string SaveWeightAndCalculate(SaveWeight ws)
        {
            //look up the weight id and save it to the db                
            var gensal = db.GENERAL_SAL.Where(x => x.Sal_Name == ws.slidername && x.Assessment_Id == ws.assessmentid).FirstOrDefault();
            if (gensal == null)
                db.GENERAL_SAL.Add(new GENERAL_SAL() { Assessment_Id = ws.assessmentid, Sal_Name = ws.slidername, Slider_Value = ws.Slider_Value });
            else
                gensal.Slider_Value = ws.Slider_Value;

            db.SaveChanges();
            CSETWeb_Api.BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(ws.assessmentid);
            string rval = GetCurrentSAL(ws.assessmentid);
            return rval;
        }


        /// <summary>
        /// Get the currently saved value, without regard for the sliders.
        /// This is used for the initial display of the Gen SAL screen before the user starts 
        /// tweaking sliders.
        /// </summary>
        /// <param name="assessmentid"></param>
        /// <returns></returns>
        public string GetSavedSALValue(int assessmentid)
        {
            STANDARD_SELECTION sal = db.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == assessmentid).FirstOrDefault();
            if (sal == null)
            {
                // default to Low if we don't yet have a record
                return "Low";
            }

            return sal.Selected_Sal_Level;
        }
    }
}




