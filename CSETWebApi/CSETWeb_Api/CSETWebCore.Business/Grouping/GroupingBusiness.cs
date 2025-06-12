using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using System;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Business.AdminTab;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Observations;
using CSETWebCore.Model.Question;
using LogicExtensions;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


namespace CSETWebCore.Business.Grouping
{
    public class GroupingBusiness
    {
        private int _assessment_Id;
        private GroupSelectionRequest _request;
        private CsetwebContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="req"></param>
        public GroupingBusiness(int assessmentId, GroupSelectionRequest req, CsetwebContext context)
        {
            _assessment_Id = assessmentId;
            _request = req;
            _context = context;
        }


        /// <summary>
        /// Saves the goruping selection status
        /// </summary>
        public void PersistSelection()
        {
            Console.WriteLine($"{_request.GroupingId}, {_request.Selected}");

            var gs = _context.GROUPING_SELECTION
                .Where(x => x.Assessment_Id == _assessment_Id).FirstOrDefault();

            if (_request.Selected)
            {
                // Insert a new record
                if (gs == null)
                {
                    var sss = new GROUPING_SELECTION
                    {
                        Assessment_Id = _assessment_Id,
                        Grouping_Id = _request.GroupingId
                    };

                    _context.GROUPING_SELECTION.Add(sss);
                    _context.SaveChanges();
                }
            }
            else
            {
                if (gs != null)
                {
                    _context.GROUPING_SELECTION.Remove(gs);
                    _context.SaveChanges();
                }
            }
        }
    }
}
