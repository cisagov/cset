////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Maturity;
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

        private List<string> unansweredColors = ["red", "lightgray"];


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
        public HeatmapNode ConvertToHeatmapNode(Model.Nested.Grouping grouping, int modelId)
        {
            if (grouping == null)
            {
                return null;
            }

            var heatmapNode = new HeatmapNode
            {
                Title = grouping.Title,
                FullTitle = grouping.Title,
                GroupingId = grouping.GroupingId,
                Color = "red",
                RollupColor = "red",
                Children = []
            };


            if (grouping.Questions != null && grouping.Questions.Any())
            {
                foreach (var question in grouping.Questions)
                {
                    var childNode = ConvertToHeatmapNode(question, modelId);
                    if (childNode != null)
                    {
                        heatmapNode.Children.Add(childNode);


                        // include followups
                        foreach (var followup in question.Followups)
                        {
                            var followupNode = ConvertToHeatmapNode(followup, modelId);
                            if (followupNode != null)
                            {
                                childNode.Children.Add(followupNode);
                            }
                        }


                        // if the question is not answerable, give it a color for rollup purposes.
                        if (!question.IsAnswerable)
                        {
                            if (childNode.Children.Any(x => !unansweredColors.Contains(x.Color)))
                            {
                                childNode.RollupColor = "yellow";
                            }

                            if (childNode.Children.All(x => x.Color == "green"))
                            {
                                childNode.RollupColor = "green";
                            }
                        }
                    }
                }
            }

            // Recursively convert all groupings to children
            if (grouping.Groupings != null && grouping.Groupings.Any())
            {
                foreach (var g in grouping.Groupings)
                {
                    var childNode = ConvertToHeatmapNode(g, modelId);
                    if (childNode != null)
                    {
                        heatmapNode.Children.Add(childNode);
                    }
                }
            }


            // Color-grade the group based on its children (color or rollup color)
            if (heatmapNode.Children.Count > 0)
            {
                // if not all red or unanswered, promote to yellow
                if (heatmapNode.Children.Any(x => (!unansweredColors.Contains(x.Color) || !unansweredColors.Contains(x.RollupColor))))
                {
                    heatmapNode.Color = "yellow";
                }

                // if all green, promote to green
                if (heatmapNode.Children.All(x => x.Color == "green" || x.RollupColor == "green"))
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
                Children = [],
                RollupColor = "lightgray"
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

            if (!source.IsAnswerable)
            {
                heatmapNode.Color = "lightgray";
            }

            return heatmapNode;
        }


        /// <summary>
        /// Builds a short label that will fit in the chiclet.
        /// 
        /// Default is a "Q1" type label.  
        /// 
        /// This method can be enhanced if used for other
        /// models with different question naming conventions.
        /// </summary>
        private string CustomizeTitle(Model.Nested.Question q, int modelId)
        {
            if (modelId == Constants.Constants.Model_CPG)
            {
                return q.DisplayNumber;   // "1.A", "2.H", etc.
            }

            if (modelId == Constants.Constants.Model_CPG2)
            {
                // create labels for OT/IT followups in CPG2
                if (q.IsOT)
                {
                    return "OT";
                }
                if (q.IsIT)
                {
                    return "IT";
                }


                // 5.A
                return q.DisplayNumber;
            }


            // default "Qn"
            int dotIdx = q.DisplayNumber.LastIndexOf(".") + 1;
            return "Q" + q.DisplayNumber.Substring(dotIdx);
        }
    }
}
