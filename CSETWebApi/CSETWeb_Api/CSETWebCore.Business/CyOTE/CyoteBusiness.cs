using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System.Xml.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.CyOTE;



namespace CSETWebCore.Business.CyOTE
{
    /// <summary>
    /// The main home for all CyOTE functionality.
    /// </summary>
    public class CyoteBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        /// <param name="adminTabBusiness"></param>
        public CyoteBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// 
        /// </summary>
        public int SaveCyoteObservable(Observable o)
        {
            // Add or update the CYOTE_OBSERVABLES record
            CYOTE_OBSERVABLE dbObservable = null;
            if (o == null)
            {
                throw new ApplicationException("Observable is required to save.  May not be null");     
            }
            else
            {
                dbObservable = _context.CYOTE_OBSERVABLEs.Where(x => x.Observable_Id == o.ObservableId).FirstOrDefault();
            }
            if (dbObservable == null)
            {
                dbObservable = new CYOTE_OBSERVABLE();
                dbObservable.Assessment_Id = o.AssessmentId;
                _context.CYOTE_OBSERVABLEs.Add(dbObservable);
                _context.SaveChanges();
                o.ObservableId = dbObservable.Observable_Id;
            }

            dbObservable.Observable_Id = o.ObservableId;
            dbObservable.Title = o.Title;
            dbObservable.Description = o.Description;
            //dbObservable.Approximate_Start = o.
            //dbObservable.Approximate_End = o.app
            dbObservable.Sequence = o.Sequence;
            dbObservable.Reporter = o.Reporter;

            // TODO:  save the optionmap

            _context.CYOTE_OBSERVABLEs.Update(dbObservable);
            _context.SaveChanges();

            return o.ObservableId;
        }

        public void DeleteObservable(int observable_id)
        {
            // Add or update the CYOTE_OBSERVABLES record
            var dbObservable = _context.CYOTE_OBSERVABLEs.Where(x => x.Observable_Id == observable_id).FirstOrDefault();
            _context.CYOTE_OBSERVABLEs.Remove(dbObservable);
            _context.SaveChanges();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public CyoteDetail GetCyoteAssessmentDetail(int assessmentId)
        {
            var detail = new CyoteDetail();

            var obsList = _context.CYOTE_OBSERVABLEs                
                .Where(x => x.Assessment_Id == assessmentId).OrderBy(x => x.Sequence).ToList();

            obsList.ForEach(x =>
            {
                var o1 = new Observable()
                {
                    AssessmentId = x.Assessment_Id,
                    Title = x.Title,
                    Reporter = x.Reporter,
                    ObservableId = x.Observable_Id,
                    Sequence = x.Sequence,
                    Description = x.Description
                };

                detail.Observables.Add(o1);
            });

            return detail;
        }
    }
}
