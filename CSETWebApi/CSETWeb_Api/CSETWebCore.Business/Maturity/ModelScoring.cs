//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Model.Edm;

namespace CSETWebCore.Business.Maturity
{
    public class ModelScoring
    {

        private readonly CSETContext _context;

        public int ModelId { get; set; }

        private TopLevelScoreNode topNode;
        private Dictionary<String, ScoringNode> midNodes = new Dictionary<String, ScoringNode>();

        private Dictionary<int, LeafNode> leafNodes = new Dictionary<int, LeafNode>();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="modelId"></param>
        public ModelScoring(CSETContext context, int modelId) 
        {
            _context = context;
            ModelId = modelId;
        }

        public void SetAnswers(int assessment_id)
        {
            //clean out the top nodes

            //then load the answers;
            var result = from a in _context.ANSWER
                         where a.Assessment_Id == assessment_id && a.Question_Type == "Maturity"
                         select a;
            foreach (var a in result.ToList())
            {
                LeafNode leaf;
                if (leafNodes.TryGetValue(a.Question_Or_Requirement_Id, out leaf))
                {
                    leaf.Answer = a.Answer_Text;
                }
                else
                {
                    //log that we missed the question
                }

            }
        }



        public void LoadDataStructure()
        {

            LocalLoadStructure(topNode);
        }


        private void LocalLoadStructure(TopLevelScoreNode topNode)
        {
            this.topNode = topNode;
            //get the top level nodes
            //then add in all the children
            var result = from a in _context.MATURITY_QUESTIONS
                         join b in _context.MATURITY_GROUPINGS on a.Grouping_Id equals b.Grouping_Id
                         where a.Maturity_Model_Id == this.ModelId
                         select new { a, b };
            Dictionary<int, string> questionIDtoTitle = new Dictionary<int, string>();
            foreach (var q in result.ToList())
            {
                questionIDtoTitle.Add(q.a.Mat_Question_Id, q.a.Question_Title);
                ScoringNode t = midNodes[q.b.Title_Id];
                if (q.a.Parent_Question_Id == null)
                {
                    LeafNode l = ProcessLeafNode(q.a.Mat_Question_Id, q.a.Question_Title, t);
                    t.Children.Add(l);
                }
                else
                {
                    //remove the parent question from leaves dictionary
                    //remove the parent question from it's parent's child collection
                    //add it to the children of t as new mid node
                    //then add all the children to this new mid node

                    //note that at this poing Parent_Question_Id should never be null
                    ScoringNode outNode;
                    string parentTitle = questionIDtoTitle[q.a.Parent_Question_Id ?? 0];
                    if (midNodes.TryGetValue(parentTitle, out outNode))
                    {
                        LeafNode l = ProcessLeafNode(q.a.Mat_Question_Id, q.a.Question_Title, outNode);
                        outNode.Children.Add(l);
                    }
                    else
                    {
                        LeafNode parentLeaf = leafNodes[q.a.Parent_Question_Id ?? 0];
                        parentLeaf.Parent.Children.Remove(parentLeaf);
                        leafNodes.Remove(q.a.Parent_Question_Id ?? 0);

                        MidlevelScoreNode node = new MidlevelScoreNode()
                        {
                            Title_Id = parentTitle,
                            Grouping_Id = q.a.Grouping_Id ?? 0,
                            Description = "Parent of " + q.a.Question_Title
                        };
                        midNodes.Add(parentTitle, node);
                        LeafNode l = ProcessLeafNode(q.a.Mat_Question_Id, q.a.Question_Title, node);
                        node.Children.Add(l);
                        t.Children.Add(node);
                    }
                }
            }
        }

        private LeafNode ProcessLeafNode(int questionid, string title_id, ScoringNode t)
        {
            LeafNode l = new LeafNode()
            {
                Mat_Question_Id = questionid,
                Title_Id = title_id,
                Parent = t
            };
            leafNodes.Add(questionid, l);
            return l;
        }


        public List<EDMscore> GetScores()
        {
            List<EDMscore> scores = new List<EDMscore>();
            topNode.CalculateScoreStatus(scores);
            return scores;
        }


        public class TopLevelScoreNode : ScoringNode
        {
            public ScoringNode TopLevelChild { get; set; }

            public override double CalculatePartialScore()
            {
                this.Score = 0;
                foreach (ScoringNode s in this.Children)
                {
                    Score += s.CalculatePartialScore();
                    this.totalCount += s.totalCount;
                }

                return Score;
            }

            public override int CalculatePercentageScore()
            {
                this.PercentageScore = 0;
                int totalRight = 0;
                foreach (ScoringNode s in this.Children)
                {
                    totalRight += s.CalculatePercentageScore();
                    this.PercentageTotalCount += s.PercentageTotalCount;
                }

                this.PercentageCountRight = totalRight;
                this.PercentageScore = (double)totalRight / (double)this.PercentageTotalCount;
                return this.PercentageCountRight;
            }

            public override ScoreStatus CalculateScoreStatus(List<EDMscore> scores)
            {
                if (this.ColorStatus != ScoreStatus.None)
                    return this.ColorStatus;

                //if this is MIL 1 then it can be yellow 
                //  (Yellow if any of my children are not red)
                //else this is green if all my children are green
                //else red                
                if (this.Title_Id == "MIL1")
                {
                   // this.ColorStatus = BasicScore(scores);
                }
                else
                {
                    bool ok = false;
                    ok = TopLevelChild.CalculateScoreStatus(scores) == ScoreStatus.Green;
                    foreach (ScoringNode n in this.Children)
                    {
                        var node = n as LeafNode;
                        var cStatus = node.CalculateScoreStatus(scores);
                        ok = ok && cStatus == ScoreStatus.Green;
                    }

                    this.ColorStatus = ok ? ScoreStatus.Green : ScoreStatus.Red;
                }

                scores.Add(new EDMscore() { Title_Id = this.Title_Id, Color = this.ColorStatus.ToString() });
                return this.ColorStatus;
            }
        }

    }
}
