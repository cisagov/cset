using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using System;


namespace CSETWebCore.Business.Grouping
{
    public class GroupingBusiness
    {
        private GGG _x1;
        private CsetwebContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="x"></param>
        public GroupingBusiness(GGG x, CsetwebContext context)
        {
            _x1 = x;
            _context = context;
        }


        /// <summary>
        /// Saves the goruping selection status
        /// </summary>
        public void Persist()
        {
            Console.WriteLine($"{_x1.GroupingId}, {_x1.Selected}");

        }
    }
}
