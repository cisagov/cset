using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using System.Collections.Generic;
using System.Linq;

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
                var n = ConvertToHeatmapNode(j, modelId);
                resp.Add(n);
            }

            // exclude any top-level groupings without children
            resp.RemoveAll(x => x.Children.Count == 0);

            return resp;
        }


        /// <summary>
        /// Converts a Grouping to a node.  It colors the
        /// node depending on the child Question scoring.
        /// </summary>
        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Grouping source, int modelId)
        {
            if (source == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = source.Title,
                FullTitle = source.Title,
                GroupingId = source.GroupingId,
                Color = "red",
                Children = []
            };

            if (source.Questions != null && source.Questions.Any())
            {
                foreach (var question in source.Questions)
                {
                    var childNode = ConvertToHeatmapNode(question, modelId);
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
                    var childNode = ConvertToHeatmapNode(grouping, modelId);
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
        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Question source, int modelId)
        {
            if (source == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = "Q",
                FullTitle = source.DisplayNumber,
                QuestionId = source.QuestionId,
                Children = []
            };

            // customize the question title 
            heatmapNode.Title = CustomizeTitle(source, modelId);

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
        private string CustomizeTitle(Model.Nested.Question q, int modelId)
        {
            if (modelId == Constants.Constants.Model_CPG2)
            {
                // 5.A
                return q.DisplayNumber;
            }


            // default "Qn"
            int dotIdx = q.DisplayNumber.LastIndexOf(".") + 1;
            return "Q" + q.DisplayNumber.Substring(dotIdx);
        }
    }


    public class HeatmapNode
    {
        public int GroupingId { get; set; }
        public int QuestionId { get; set; }
        public string Title { get; set; }
        /// <summary>
        /// The question's title as defined with no formatting
        /// </summary>
        public string FullTitle { get; set; }
        public string Color { get; set; }
        public List<HeatmapNode> Children { get; set; } = [];
    }
}
