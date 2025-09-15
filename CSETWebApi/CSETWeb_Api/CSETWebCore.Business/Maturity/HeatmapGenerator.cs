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
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        private List<string> unansweredColors = [ "red", "lightgray" ];


        /// <summary>
        /// CTOR
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
            _context.FillEmptyMaturityQuestionsForModel(assessmentId, modelId);

            var biz = new MaturityBusiness(_context, _assessmentUtil);
            var x = biz.GetMaturityStructureForModel(modelId, assessmentId);

            var resp = new List<HeatmapNode>();

            foreach (var j in x.Model.Groupings)
            {
                var n = ConvertToHeatmapNode(j);
                resp.Add(n);
            }

            return resp;
        }


        /// <summary>
        /// Converts a Grouping to a node.  It colors the
        /// node depending on the child Question scoring.
        /// </summary>
        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Grouping source)
        {
            if (source == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = source.Title,
                GroupingId = source.GroupingId,
                Color = "red",
                Children = []
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


        /// <summary>
        /// Converts a Question to a node
        /// </summary>
        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Question source)
        {
            if (source == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = "Q",
                QuestionId = source.QuestionId,
                Children = []
            };

            // customize the question title 
            heatmapNode.Title = CustomizeTitle(source);

            // color the question segment based on answer value
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


        /// <summary>
        /// Builds a "Q1" type label to keep the heatmap
        /// segments short.  
        /// 
        /// This may need to be expanded if used for other
        /// models with different question namging conventions.
        /// </summary>
        private string CustomizeTitle(Model.Nested.Question q)
        {
            int dotIdx = q.DisplayNumber.LastIndexOf(".") + 1;
            return "Q" + q.DisplayNumber.Substring(dotIdx);
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
