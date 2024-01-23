//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Sal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;


namespace CSETWebCore.Business.Sal
{
    public class GeneralSalBusiness
    {
        private readonly CSETContext _context;
        private readonly ITokenManager _token;
        private readonly IAssessmentUtil _assessmentUtil;

        private Dictionary<double, string> SALThresholdDictionary { get; set; }


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context"></param>
        public GeneralSalBusiness(CSETContext context, ITokenManager token, IAssessmentUtil assessmentUtil)
        {
            InitializeSALThresholds();
            _context = context;
            _token = token;
            _assessmentUtil = assessmentUtil;
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

            var weights = from a in _context.GENERAL_SAL
                          join b in _context.GEN_SAL_WEIGHTS on new { a.Sal_Name, a.Slider_Value } equals new { b.Sal_Name, b.Slider_Value }
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
            this.SALThresholdDictionary.Add(1, Constants.Constants.SAL_LOW);
            this.SALThresholdDictionary.Add(255, Constants.Constants.SAL_MODERATE);
            this.SALThresholdDictionary.Add(1000, Constants.Constants.SAL_HIGH);
            this.SALThresholdDictionary.Add(20000, Constants.Constants.SAL_VERY_HIGH);
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
            {
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
            string SALToReturn = Constants.Constants.SAL_LOW;
            foreach (double thresholdValue in this.SALThresholdDictionary.Keys)
            {
                if (weight >= thresholdValue)
                {
                    SALToReturn = SALThresholdDictionary[thresholdValue];
                }
            }

            // Persist the overall SAL to the database
            int assessmentId = _token.AssessmentForUser();
            STANDARD_SELECTION ss = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            ss.Selected_Sal_Level = SALToReturn;
            _context.SaveChanges();

            return SALToReturn;
        }


        public string SaveWeightAndCalculate(SaveWeight ws)
        {
            //look up the weight id and save it to the db                
            var gensal = _context.GENERAL_SAL.Where(x => x.Sal_Name == ws.slidername && x.Assessment_Id == ws.assessmentid).FirstOrDefault();
            if (gensal == null)
                _context.GENERAL_SAL.Add(new GENERAL_SAL() { Assessment_Id = ws.assessmentid, Sal_Name = ws.slidername, Slider_Value = ws.Slider_Value });
            else
                gensal.Slider_Value = ws.Slider_Value;

            _context.SaveChanges();
            _assessmentUtil.TouchAssessment(ws.assessmentid);
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
            STANDARD_SELECTION sal = _context.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == assessmentid).FirstOrDefault();
            if (sal == null)
            {
                // default to Low if we don't yet have a record
                return "Low";
            }

            return sal.Selected_Sal_Level;
        }
    }
}
