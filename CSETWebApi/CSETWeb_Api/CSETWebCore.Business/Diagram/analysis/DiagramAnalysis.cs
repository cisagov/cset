//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules.MalcolmRules;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Business.Diagram.analysis.rules;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.DataLayer.Model;
using Lucene.Net.Util;
using Newtonsoft.Json;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public enum LinkSecurityEnum
    {
        Trusted, Untrusted
    }

    public class DiagramAnalysis
    {
        private CSETContext _context;
        private int assessment_id;
        private Dictionary<string, int> imageToTypePath;

        public XmlDocument NetworkWarningsXml { get; private set; }
        public List<IDiagramAnalysisNodeMessage> NetworkWarnings { get; private set; }

        public DiagramAnalysis(CSETContext context, int assessment_id)
        {
            this._context = context;
            this.assessment_id = assessment_id;
            imageToTypePath = _context.COMPONENT_SYMBOLS.ToDictionary(x => x.File_Name, x => x.Component_Symbol_Id);
            NetworkWarnings = new List<IDiagramAnalysisNodeMessage>();
        }

        public List<IDiagramAnalysisNodeMessage> PerformAnalysis(XmlDocument xDoc)
        {
            String sal = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment_id).First().Selected_Sal_Level;
            SimplifiedNetwork network = new SimplifiedNetwork(this.imageToTypePath, sal);
            network.ExtractNetworkFromXml(xDoc);

            List<IDiagramAnalysisNodeMessage> msgs = AnalyzeNetwork(network);
            return msgs;
        }

        private List<IDiagramAnalysisNodeMessage> AnalyzeNetwork(SimplifiedNetwork network)
        {
            List<IRuleEvaluate> rules = new List<IRuleEvaluate>();
            rules.Add(new Rule1(network));
            rules.Add(new Rule2(network));
            rules.Add(new Rule3and4(network));
            rules.Add(new Rule5(network));
            rules.Add(new Rule6(network));
            rules.Add(new Rule7(network, _context));

            //NetworkWalk walk = new NetworkWalk();
            //walk.printGraphSimple(network.Nodes.Values.ToList());
            List<IDiagramAnalysisNodeMessage> msgs = new List<IDiagramAnalysisNodeMessage>();
            foreach (IRuleEvaluate rule in rules)
            {
                msgs.AddRange(rule.Evaluate());
            }

            // number and persist warning messages

            var oldWarnings = _context.NETWORK_WARNINGS.Where(x => x.Assessment_Id == assessment_id).ToList();
            _context.NETWORK_WARNINGS.RemoveRange(oldWarnings);
            _context.SaveChanges();

            int n = 0;
            msgs.ForEach(m =>
            {
                StringBuilder sb = new StringBuilder();
                m.SetMessages.ToList().ForEach(m2 =>
                {
                    sb.AppendLine(m2);
                });

                m.Number = ++n;
                _context.NETWORK_WARNINGS.Add(new NETWORK_WARNINGS
                {
                    Assessment_Id = assessment_id,
                    Id = m.Number,
                    WarningText = sb.ToString(),
                    Rule_Violated = m.Rule_Violated
                });
            });

            _context.SaveChanges();

            return msgs;
        }

        // will return a list of the violated rule numbers
        public List<MALCOLM_MAPPING> PerformMalcolmAnalysis(XmlDocument xDoc)
        {
            var sal = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment_id).FirstOrDefault();
            if (sal == null)
            {
                return new List<MALCOLM_MAPPING>();
            }
            SimplifiedNetwork network = new SimplifiedNetwork(this.imageToTypePath, sal.Selected_Sal_Level);
            network.ExtractNetworkFromXml(xDoc);

            return MalcolmAnalyzeNetwork(network);
        }

        public List<MALCOLM_MAPPING> MalcolmAnalyzeNetwork(SimplifiedNetwork network)
        {
            List<IRuleEvaluate> rules = new List<IRuleEvaluate>();
            rules.Add(new Rule8(network));
            rules.Add(new Rule9(network));

            List<IDiagramAnalysisNodeMessage> msgs = new List<IDiagramAnalysisNodeMessage>();
            foreach (IRuleEvaluate rule in rules)
            {
                msgs.AddRange(rule.Evaluate());
            }

            // number and persist warning messages

            List<MALCOLM_MAPPING> malcolmMappingInfo = new List<MALCOLM_MAPPING>();

            foreach (DiagramAnalysisNodeMessage m in msgs.Distinct())
            {
                malcolmMappingInfo.AddRange(_context.MALCOLM_MAPPING.Where(x => x.Rule_Violated == m.Rule_Violated).ToList());
            }

            return malcolmMappingInfo;
        }
    }
}