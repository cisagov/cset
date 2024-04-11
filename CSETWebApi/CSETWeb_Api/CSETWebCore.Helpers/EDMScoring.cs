//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Enum;
using CSETWebCore.Model.Edm;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    public class EDMScoring
    {
        ///trying to think of the best way to do this and am not coming up with a good way
        ///the brute force is a tree and then walk the tree and if any leaf node is incomplete 
        ///then everything up the line is incomplete if anything
        ///However if all nodes are NO or empty then the score is empty
        ///There are three types of nodes top level, mid tier, and leaf. 
        /// A leaf is just a leaf
        /// GREEN -Y, RED -N, YELLOW -Incomplete
        /// A mid tier is only Red if all it's leaves are red 
        /// a mid tier is only Green if all it's leaves are green
        /// a mid tier is Yellow if any other state exists
        /// a top level tier is only green if all its children are green
        /// a top level tier is yellow if all it's top level children are green and its direct children are not all read (ie anything is green or yellow)
        /// a top level tier is red if its top level child is yellow and 
        private Dictionary<String, ScoringNode> midNodes = new Dictionary<String, ScoringNode>();

        private Dictionary<int, LeafNode> leafNodes = new Dictionary<int, LeafNode>();
        private TopLevelScoreNode topNode;

        private CSETContext _context;

        public EDMScoring(CSETContext context)
        {
            _context = context;
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

        //return the tree with the rollup score at each node
        /** leaf nodes return 1, .5, or 0
         * all other nodes are the sum of their lower nodes
         */
        public TopLevelScoreNode getPartialScore()
        {
            this.topNode.CalculatePartialScore();
            var tnode = this.topNode.TopLevelChild;
            while (tnode != null)
            {
                tnode.CalculatePartialScore();
                tnode = ((TopLevelScoreNode)tnode).TopLevelChild;
            }

            return this.topNode;
        }

        public TopLevelScoreNode getPartialScore(int inputVal)
        {
            this.topNode.CalculatePartialScore();
            var tnode = this.topNode.TopLevelChild;
            while (tnode != null)
            {
                tnode.CalculatePartialScore();
                tnode = ((TopLevelScoreNode)tnode).TopLevelChild;
            }

            return this.topNode;
        }

        private TopLevelScoreNode getPercentageScore()
        {
            this.topNode.CalculatePercentageScore();
            var tnode = this.topNode.TopLevelChild;
            while (tnode != null)
            {
                tnode.CalculatePercentageScore();
                tnode = ((TopLevelScoreNode)tnode).TopLevelChild;
            }

            return this.topNode;
        }

        public void LoadDataStructure()
        {
            localLoadStructure(staticLoadTree());
        }

        private void localLoadStructure(TopLevelScoreNode topNode)
        {
            this.topNode = topNode;
            //get the top level nodes
            //then add in all the children
            var result = from a in _context.MATURITY_QUESTIONS
                         join b in _context.MATURITY_GROUPINGS on a.Grouping_Id equals b.Grouping_Id
                         where a.Maturity_Model_Id == 3
                         select new { a, b };
            Dictionary<int, string> questionIDtoTitle = new Dictionary<int, string>();
            foreach (var q in result.ToList())
            {
                questionIDtoTitle.Add(q.a.Mat_Question_Id, q.a.Question_Title);
                ScoringNode t = midNodes[q.b.Title_Id];
                if (q.a.Parent_Question_Id == null)
                {
                    LeafNode l = processLeafNode(q.a.Mat_Question_Id, q.a.Question_Title, t);
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
                        LeafNode l = processLeafNode(q.a.Mat_Question_Id, q.a.Question_Title, outNode);
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
                        LeafNode l = processLeafNode(q.a.Mat_Question_Id, q.a.Question_Title, node);
                        node.Children.Add(l);
                        t.Children.Add(node);
                    }
                }
            }
        }

        private LeafNode processLeafNode(int questionid, string title_id, ScoringNode t)
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


        public TopLevelScoreNode GetPercentageScores(int assessment_id)
        {
            TopLevelScoreNode t = staticAddMilTerms();
            SetAnswers(assessment_id);
            return getPercentageScore();
        }

        public TopLevelScoreNode GetPartialScores(int assessment_id)
        {
            TopLevelScoreNode t = staticAddMilTerms();
            SetAnswers(assessment_id);
            return getPartialScore();
        }

        /// <summary>
        /// This is a recipe for disaster.  These two data structures are a little too shared. 
        /// </summary>
        /// <returns></returns>
        private TopLevelScoreNode staticAddMilTerms()
        {
            cleanoutStructure();
            TopLevelScoreNode t = staticLoadTreeMidStructure();
            localLoadStructure(t);
            return t;
        }

        private TopLevelScoreNode staticLoadTreeMidStructure()
        {
            TopLevelScoreNode mil1 = new TopLevelScoreNode() { Title_Id = "MIL1", Description = "MIL1 - Performed" };
            midNodes.Add(mil1.Title_Id, mil1);
            MidlevelScoreNode rf = new MidlevelScoreNode() { Title_Id = "RF", Description = "Relationship Formation" };
            mil1.Children.Add(rf);
            rf.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G1", Description = "Goal 1 - Acquirer service and asset priorities are established." });
            rf.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "RF:G2",
                Description = "Goal 2 - Forming relationships with external entities is planned."
            });
            rf.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G3", Description = "Goal 3 – Risk management includes external dependencies." });
            rf.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G4", Description = "Goal 4 - External entities are evaluated." });
            rf.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G5", Description = "Goal 5 – Formal agreements include resilience requirements." });
            rf.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G6", Description = "Goal 6 –Technology asset supply chain risks are managed." });
            MidlevelScoreNode rmg = new MidlevelScoreNode()
            { Title_Id = "RMG", Description = "Relationship Management and Governance" };
            mil1.Children.Add(rmg);

            rmg.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G1", Description = "Goal 1 - External dependencies are identified and prioritized." });
            rmg.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G2", Description = "Goal 2 - Supplier risk management is continuous." });
            rmg.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G3", Description = "Goal 3 – Supplier performance is governed and managed." });
            rmg.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "RMG:G4",
                Description = "Goal 4 – Change and capacity management are applied to external dependencies."
            });
            rmg.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G5", Description = "Goal 5 – Supplier transitions are managed." });
            rmg.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "RMG:G6",
                Description = "Goal 6 – Infrastructure and governmental dependencies are managed."
            });
            rmg.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G7", Description = "Goal 7 – External entity access to acquirer assets is managed." });

            MidlevelScoreNode sps = new MidlevelScoreNode()
            { Title_Id = "SPS", Description = "Service Protection and Sustainment" };
            mil1.Children.Add(sps);
            sps.Children.Add(new MidlevelScoreNode()
            { Title_Id = "SPS:G1", Description = "Goal 1 - Disruption planning includes external dependencies." });
            sps.Children.Add(new MidlevelScoreNode()
            { Title_Id = "SPS:G2", Description = "Goal 2 - Planning and controls are maintained and updated." });
            sps.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "SPS:G3",
                Description = "Goal 3 – Situational awareness extends to external dependencies."
            });

            addChildrenToList(mil1, midNodes);

            TopLevelScoreNode mIL2 = new TopLevelScoreNode() { Title_Id = "MIL2", Description = "MIL2 - Planned" };
            mIL2.TopLevelChild = mil1;
            midNodes.Add(mIL2.Title_Id, mIL2);
            TopLevelScoreNode mIL3 = new TopLevelScoreNode() { Title_Id = "MIL3", Description = "MIL3 - Managed" };
            mIL3.TopLevelChild = mIL2;
            midNodes.Add(mIL3.Title_Id, mIL3);
            TopLevelScoreNode mIL4 = new TopLevelScoreNode() { Title_Id = "MIL4", Description = "MIL4 - Measured" };
            mIL4.TopLevelChild = mIL3;
            midNodes.Add(mIL4.Title_Id, mIL4);
            TopLevelScoreNode mIL5 = new TopLevelScoreNode() { Title_Id = "MIL5", Description = "MIL5 - Defined" };
            mIL5.TopLevelChild = mIL4;
            midNodes.Add(mIL5.Title_Id, mIL5);
            return mIL5;
        }


        private void addChildrenToList(ScoringNode node, Dictionary<String, ScoringNode> nodesList)
        {
            foreach (ScoringNode n in node.Children)
            {
                nodesList.Add(n.Title_Id, n);
                if (n.Children.Count > 0)
                    addChildrenToList(n, nodesList);
            }
        }

        private void cleanoutStructure()
        {
            //clean out current structure and then add the new structure.
            midNodes = new Dictionary<String, ScoringNode>();
            leafNodes = new Dictionary<int, LeafNode>();
            topNode = null;
        }




        private TopLevelScoreNode staticLoadTree()
        {
            TopLevelScoreNode mil1 = new TopLevelScoreNode() { Title_Id = "MIL1", Description = "MIL1 - Performed" };
            midNodes.Add(mil1.Title_Id, mil1);
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G1", Description = "Goal 1 - Acquirer service and asset priorities are established." });
            mil1.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "RF:G2",
                Description = "Goal 2 - Forming relationships with external entities is planned."
            });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G3", Description = "Goal 3 – Risk management includes external dependencies." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G4", Description = "Goal 4 - External entities are evaluated." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G5", Description = "Goal 5 – Formal agreements include resilience requirements." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RF:G6", Description = "Goal 6 –Technology asset supply chain risks are managed." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G1", Description = "Goal 1 - External dependencies are identified and prioritized." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G2", Description = "Goal 2 - Supplier risk management is continuous." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G3", Description = "Goal 3 – Supplier performance is governed and managed." });
            mil1.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "RMG:G4",
                Description = "Goal 4 – Change and capacity management are applied to external dependencies."
            });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G5", Description = "Goal 5 – Supplier transitions are managed." });
            mil1.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "RMG:G6",
                Description = "Goal 6 – Infrastructure and governmental dependencies are managed."
            });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "RMG:G7", Description = "Goal 7 – External entity access to acquirer assets is managed." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "SPS:G1", Description = "Goal 1 - Disruption planning includes external dependencies." });
            mil1.Children.Add(new MidlevelScoreNode()
            { Title_Id = "SPS:G2", Description = "Goal 2 - Planning and controls are maintained and updated." });
            mil1.Children.Add(new MidlevelScoreNode()
            {
                Title_Id = "SPS:G3",
                Description = "Goal 3 – Situational awareness extends to external dependencies."
            });
            foreach (ScoringNode s in mil1.Children)
                midNodes.Add(s.Title_Id, s);
            TopLevelScoreNode mIL2 = new TopLevelScoreNode() { Title_Id = "MIL2", Description = "MIL2 - Planned" };
            mIL2.TopLevelChild = mil1;
            midNodes.Add(mIL2.Title_Id, mIL2);
            TopLevelScoreNode mIL3 = new TopLevelScoreNode() { Title_Id = "MIL3", Description = "MIL3 - Managed" };
            mIL3.TopLevelChild = mIL2;
            midNodes.Add(mIL3.Title_Id, mIL3);
            TopLevelScoreNode mIL4 = new TopLevelScoreNode() { Title_Id = "MIL4", Description = "MIL4 - Measured" };
            mIL4.TopLevelChild = mIL3;
            midNodes.Add(mIL4.Title_Id, mIL4);
            TopLevelScoreNode mIL5 = new TopLevelScoreNode() { Title_Id = "MIL5", Description = "MIL5 - Defined" };
            mIL5.TopLevelChild = mIL4;
            midNodes.Add(mIL5.Title_Id, mIL5);
            return mIL5;
        }

        public List<EDMscore> GetScores()
        {
            List<EDMscore> scores = new List<EDMscore>();
            topNode.CalculateScoreStatus(scores);
            return scores;
        }



        public abstract class ScoringNode
        {
            public ScoringNode()
            {
                this.Children = new List<ScoringNode>();
                this.ColorStatus = ScoreStatus.None;
                this.totalCount = 0;
            }

            public ScoreStatus ColorStatus { get; set; }
            public double Score { get; set; }
            public int totalCount { get; set; }
            public int PercentageTotalCount { get; set; }
            public int PercentageCountRight { get; set; }
            public double PercentageScore { get; set; }
            public abstract ScoreStatus CalculateScoreStatus(List<EDMscore> scores);
            public abstract double CalculatePartialScore();
            public abstract int CalculatePercentageScore();

            public ScoreStatus basicScore(List<EDMscore> scores)
            {
                bool yellow = false;
                bool green = false;
                bool red = false;
                foreach (ScoringNode n in this.Children)
                {
                    switch (n.CalculateScoreStatus(scores))
                    {
                        case ScoreStatus.Green:
                            green = true;
                            break;
                        case ScoreStatus.Yellow:
                            yellow = true;
                            break;
                        case ScoreStatus.Red:
                            red = true;
                            break;
                    }
                }

                ScoreStatus temp = ScoreStatus.None;
                //its all red
                if (!green && !yellow)
                {
                    temp = ScoreStatus.Red;
                }
                //all green 
                else if (green && (!red && !yellow))
                {
                    temp = ScoreStatus.Green;
                }
                // there is some kind of mix
                else
                    temp = ScoreStatus.Yellow;

                return temp;
            }

            public int Grouping_Id { get; set; }
            public List<ScoringNode> Children { get; set; }

            public string Title_Id { get; set; }
            public string Description { get; set; }

        }

        public class LeafNode : ScoringNode
        {

            public String Answer { get; set; }
            public int Mat_Question_Id { get; set; }
            public ScoringNode Parent { get; internal set; }


            public override double CalculatePartialScore()
            {
                this.totalCount++;
                switch (Answer)
                {
                    case "Y":
                        this.Score = 1;
                        return Score;
                    case "N":
                    case "U":
                        this.Score = 0;
                        return Score;
                    default:
                        this.Score = 0.5;
                        return Score;
                }
            }

            public override int CalculatePercentageScore()
            {
                this.PercentageTotalCount++;
                switch (Answer)
                {
                    case "Y":
                        this.PercentageCountRight = 1;
                        break;
                    default:
                        this.PercentageCountRight = 0;
                        break;
                }

                this.PercentageScore = this.PercentageCountRight / this.PercentageTotalCount;
                return this.PercentageCountRight;
            }

            public override ScoreStatus CalculateScoreStatus(List<EDMscore> scores)
            {
                if (this.ColorStatus != ScoreStatus.None)
                    return this.ColorStatus;
                //this one just returns its score color
                //RED, YELLOW, or GREEN
                ScoreStatus score = ScoreStatus.None;
                switch (Answer)
                {
                    case "Y":
                        score = ScoreStatus.Green;
                        break;
                    case "N":
                        score = ScoreStatus.Red;
                        break;
                    case "I":
                        score = ScoreStatus.Yellow;
                        break;
                    default:
                        score = ScoreStatus.Red;
                        break;
                }

                this.ColorStatus = score;
                scores.Add(new EDMscore() { Title_Id = this.Title_Id, Color = this.ColorStatus.ToString() });
                return score;
            }
        }

        public class MidlevelScoreNode : ScoringNode
        {
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
                //if (this.ColorStatus != ScoreStatus.None)
                //    return this.ColorStatus;
                //this one looks at all its children and 
                //return red if they are all red
                //yellow if anything is not red but not all green
                //green if they are all green
                ScoreStatus score = basicScore(scores);
                this.ColorStatus = score;
                scores.Add(new EDMscore() { Title_Id = this.Title_Id, Color = this.ColorStatus.ToString() });
                return score;
            }
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
                    this.ColorStatus = basicScore(scores);
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