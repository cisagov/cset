using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using System.Collections.Generic;
using System.Linq;


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
        /// Saves the goruping selection status for a list of groups
        /// </summary>
        public void PersistSelections(GroupSelectionRequest req)
        {
            foreach (var g in req.Groups)
            {
                var dbGS = _context.GROUPING_SELECTION
                    .Where(x => x.Assessment_Id == _assessment_Id && x.Grouping_Id == g.GroupingId)
                    .FirstOrDefault();

                if (g.Selected)
                {
                    // Insert a new record
                    if (dbGS == null)
                    {
                        dbGS = new GROUPING_SELECTION
                        {
                            Assessment_Id = _assessment_Id,
                            Grouping_Id = g.GroupingId
                        };

                        _context.GROUPING_SELECTION.Add(dbGS);
                        _context.SaveChanges();
                    }
                }
                else
                {
                    if (dbGS != null)
                    {
                        _context.GROUPING_SELECTION.Remove(dbGS);
                        _context.SaveChanges();
                    }
                }
            }
        }
    }
}
