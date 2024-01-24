//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Nested;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Maturity
{
    public class CisNavStructure
    {
        private readonly CSETContext _context;

        /// <summary>
        /// The internal ID for the CIS model
        /// </summary>
        private readonly int _cisModelId = 8;


        /// <summary>
        /// Constructor.
        /// </summary>
        public CisNavStructure(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Builds a list of all navigation nodes subordinate to the CIS parent node.
        /// </summary>
        /// <returns></returns>
        public List<NavNode> GetNavStructure()
        {
            var cisGroupings = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == _cisModelId).ToList();

            var list = new List<NavNode>();

            var topNode = new NavNode()
            {
                Id = null,
                Title = "CIS Questions",
                Level = 1
            };

            GetSubnodes(topNode, ref list, ref cisGroupings);

            return list;
        }


        /// <summary>
        /// 
        /// </summary>
        private int GetSubnodes(NavNode parent, ref List<NavNode> list, ref List<MATURITY_GROUPINGS> cisGroupings)
        {
            var kids = cisGroupings.Where(x => x.Parent_Id == parent.Id).ToList();
            foreach (var kid in kids)
            {
                var prefix = "";
                if (!String.IsNullOrEmpty(kid.Title_Prefix))
                {
                    prefix = $"{kid.Title_Prefix}.";
                }

                var sub = new NavNode()
                {
                    Id = kid.Grouping_Id,
                    Title = $"{prefix} {kid.Title}".Trim(),
                    Level = parent.Level + 1
                };

                list.Add(sub);
                var childCount = GetSubnodes(sub, ref list, ref cisGroupings);

                if (childCount > 0)
                {
                    sub.HasChildren = true;
                }
            }

            return kids.Count;
        }
    }
}
