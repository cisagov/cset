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
        private CsetwebContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="req"></param>
        public GroupingBusiness(int assessmentId, CsetwebContext context)
        {
            _assessment_Id = assessmentId;
            _context = context;
        }


        /// <summary>
        /// Return a list of groupings selected
        /// </summary>
        /// <returns></returns>
        public List<int> GetSelections()
        {
            var gs = _context.GROUPING_SELECTION.Where(x => x.Assessment_Id == _assessment_Id);
            return gs.Select(x => x.Grouping_Id).ToList();
        }


        /// <summary>
        /// Saves the goruping selection status
        /// </summary>
        public void PersistSelection(GroupSelectionRequest req)
        {
            Console.WriteLine($"{req.GroupingId}, {req.Selected}");

            var gs = _context.GROUPING_SELECTION
                .Where(x => x.Assessment_Id == _assessment_Id && x.Grouping_Id == req.GroupingId)
                .FirstOrDefault();

            if (req.Selected)
            {
                // Insert a new record
                if (gs == null)
                {
                    var sss = new GROUPING_SELECTION
                    {
                        Assessment_Id = _assessment_Id,
                        Grouping_Id = req.GroupingId
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
