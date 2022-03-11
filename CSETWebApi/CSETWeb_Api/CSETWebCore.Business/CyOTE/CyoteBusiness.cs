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
        /// <returns></returns>
        public CyoteDetail GetCyoteAssessmentDetail(int assessmentId)
        {
            var detail = new CyoteDetail();

            var obsList = _context.CYOTE_OBSERVABLES.Where(x => x.Assessment_Id == assessmentId).OrderBy(x => x.Sequence).ToList();

            obsList.ForEach(x => {
                var o1 = new Observable()
                {
                    Title = x.Title,
                    Reporter = x.Reporter,
                    ObservableId = x.Observable_Id,
                    Sequence = x.Sequence,
                    Description = x.Description
                };

                x.CYOTE_OBSV_OPTIONS_SELECTED.ToList().ForEach(o =>
                {

                });

                detail.Observables.Add(o1);
            });

            //var o1 = new Observable();
            //o1.Title = "Coworker blew up";
            //o1.Reporter = "Clark Kent";
            //o1.ObservableId = 1;
            //o1.Sequence = 1;
            //o1.Options.Add(new ObservableOption() { Name = "Physical Category", Value = "true" });
            //o1.Description = "My coworker blew up in front of me.  I was not looking at him with my x-ray vision, so it must have been something else that caused it.";
            //detail.Observables.Add(o1);


            //var o2 = new Observable();
            //o2.Title = "Breakroom has unusual smell";
            //o2.Reporter = "Perry White";
            //o2.ObservableId = 2;
            //o2.Sequence = 2;
            //o2.Options.Add(new ObservableOption() { Name = "Physical Category", Value = "true" });
            //o2.Options.Add(new ObservableOption() { Name = "Network Category", Value = "true" });
            //o2.Description = "Either somone left some uneaten fish in the trash over the weekend or it's a bio-chemical attack of some kind.";
            //detail.Observables.Add(o2);


            return detail;
        }
    }
}
