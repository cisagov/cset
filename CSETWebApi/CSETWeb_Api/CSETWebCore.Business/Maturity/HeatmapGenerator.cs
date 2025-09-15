using CSETWebCore.Business.Aggregation;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Edm;
using DocumentFormat.OpenXml.Bibliography;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Generates structures for heatmap display.  
    /// Started with EDM and CRR.  
    /// </summary>
    public class HeatmapGenerator
    {
        private readonly int _assessmentId;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        private List<string> unansweredColors = [ "red", "lightgray" ];

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public HeatmapGenerator(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// 
        /// </summary>
        public object GetHeatmap(int assessmentId, int modelId)
        {
            var biz = new MaturityBusiness(_context, _assessmentUtil);
            var x = biz.GetMaturityStructureForModel(modelId, assessmentId);

            var resp = new List<HeatmapNode>();

            foreach (var j in x.Model.Groupings)
            {
                var n = ConvertToHeatmapNode(j);
                resp.Add(n);
            }

            // score 

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Grouping source)
        {
            if (source == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = source.GroupingId.ToString(),
                Color = "red",
                Children = new List<HeatmapNode>()
            };

            if (source.Questions != null && source.Questions.Any())
            {
                foreach (var question in source.Questions)
                {
                    var childNode = ConvertToHeatmapNode(question);
                    if (childNode != null)
                    {
                        heatmapNode.Children.Add(childNode);
                    }
                }
            }

            // Recursively convert all groupings to children
            if (source.Groupings != null && source.Groupings.Any())
            {
                foreach (var grouping in source.Groupings)
                {
                    var childNode = ConvertToHeatmapNode(grouping);
                    if (childNode != null)
                    {
                        heatmapNode.Children.Add(childNode);
                    }
                }
            }

            if (heatmapNode.Children.Count > 0)
            {
                // if not all red or unanswered, promote to yellow
                if (heatmapNode.Children.Any(x => !unansweredColors.Contains(x.Color)))
                {
                    heatmapNode.Color = "yellow";
                }
                // if all green, promote to green
                if (heatmapNode.Children.All(x => x.Color == "green"))
                {
                    heatmapNode.Color = "green";
                }
            }
            
            return heatmapNode;
        }


        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Question source)
        {
            if (source == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = "Q",
                Children = new List<HeatmapNode>()
            };

            switch (source.AnswerText)
            {
                case "Y":
                    heatmapNode.Color = "green";
                    break;
                case "N":
                    heatmapNode.Color = "red";
                    break;
                case "I":
                    heatmapNode.Color = "blue";
                    break;
                case "S":
                    heatmapNode.Color = "gold";
                    break;
                case "U":
                    heatmapNode.Color = "lightgray";
                    break;
            }

            return heatmapNode;
        }
    }


    public class HeatmapNode
    {
        public int GroupingId { get; set; }
        public int QuestionId { get; set; }
        public string Title { get; set; }
        public string Color { get; set; }
        public List<HeatmapNode> Children { get; set; } = [];
    }
}
