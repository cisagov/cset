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
            CYOTE_OBSERVABLES dbObservable = null;
            if (o == null)
            {
                throw new ApplicationException("Observable is required to save.  May not be null");     
            }
            else
            {
                dbObservable = _context.CYOTE_OBSERVABLES.Where(x => x.Observable_Id == o.ObservableId).FirstOrDefault();
            }
            if (dbObservable == null)
            {
                dbObservable = new CYOTE_OBSERVABLES();
                dbObservable.Assessment_Id = o.AssessmentId;
                _context.CYOTE_OBSERVABLES.Add(dbObservable);
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

            dbObservable.DigitalCategory = o.DigitalCategory;
            dbObservable.PhysicalCategory = o.PhysicalCategory;
            dbObservable.NetworkCategory = o.NetworkCategory;


            dbObservable.IsFirstTimeSeen = o.IsFirstTimeSeen;

            dbObservable.IsAffectingProcesses = o.IsAffectingProcesses;
            dbObservable.AffectingProcessesText = o.AffectingProcessesText;

            dbObservable.IsAffectingOperations = o.IsAffectingOperations;
            dbObservable.AffectingOperationsText = o.AffectingOperationsText;

            dbObservable.IsMultipleDevices = o.IsMultipleDevices;
            dbObservable.MultipleDevicesText = o.MultipleDevicesText;

            dbObservable.IsMultipleNetworkLayers = o.IsMultipleNetworkLayers;
            dbObservable.MultipleNetworkLayersText = o.MultipleNetworkLayersText;

            dbObservable.ObservedShouldBeAndWas = o.ObservedShouldBeAndWas;
            dbObservable.ObservedShouldBeAndWasNot = o.ObservedShouldBeAndWasNot;
            dbObservable.ObservedShouldBeAndCantTell = o.ObservedShouldBeAndCantTell;
            dbObservable.ObservedShouldNotBeAndWas = o.ObservedShouldNotBeAndWas;
            dbObservable.ObservedShouldNotBeAndWasNot = o.ObservedShouldNotBeAndWasNot;
            dbObservable.ObservedShouldNotBeAndCantTell = o.ObservedShouldNotBeAndCantTell;


            _context.CYOTE_OBSERVABLES.Update(dbObservable);
            _context.SaveChanges();

            return o.ObservableId;
        }

        public void DeleteObservable(int observable_id)
        {
            // Add or update the CYOTE_OBSERVABLES record
            var dbObservable = _context.CYOTE_OBSERVABLES.Where(x => x.Observable_Id == observable_id).FirstOrDefault();
            _context.CYOTE_OBSERVABLES.Remove(dbObservable);
            _context.SaveChanges();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public CyoteDetail GetCyoteAssessmentDetail(int assessmentId)
        {
            var detail = new CyoteDetail();

            var obsList = _context.CYOTE_OBSERVABLES
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
                    Description = x.Description,

                    DigitalCategory = x.DigitalCategory,
                    NetworkCategory = x.NetworkCategory,
                    PhysicalCategory = x.PhysicalCategory,

                    IsFirstTimeSeen = x.IsFirstTimeSeen,

                    IsAffectingOperations = x.IsAffectingOperations,
                    AffectingOperationsText = x.AffectingOperationsText,

                    IsAffectingProcesses = x.IsAffectingProcesses,
                    AffectingProcessesText = x.AffectingProcessesText,

                    IsMultipleDevices = x.IsMultipleDevices,
                    MultipleDevicesText = x.MultipleDevicesText,

                    IsMultipleNetworkLayers = x.IsMultipleNetworkLayers,
                    MultipleNetworkLayersText = x.MultipleNetworkLayersText,

                    ObservedShouldBeAndWas = x.ObservedShouldBeAndWas,
                    ObservedShouldBeAndWasNot = x.ObservedShouldBeAndWasNot,
                    ObservedShouldBeAndCantTell = x.ObservedShouldBeAndCantTell,
                    ObservedShouldNotBeAndWas = x.ObservedShouldNotBeAndWas,
                    ObservedShouldNotBeAndWasNot = x.ObservedShouldNotBeAndWasNot,
                    ObservedShouldNotBeAndCantTell = x.ObservedShouldNotBeAndCantTell
                };

                detail.Observables.Add(o1);
            });

            return detail;
        }
    }
}
