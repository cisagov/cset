//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Xml;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Business.Diagram.analysis.rules;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public enum LinkSecurityEnum
    {
        Trusted, Untrusted
    }

    public class DiagramAnalysis
    {
        private CSETContext db;
        private int assessment_id;
        private Dictionary<string, int> imageToTypePath;

        public XmlDocument NetworkWarningsXml { get; private set; }
        public List<IDiagramAnalysisNodeMessage> NetworkWarnings { get; private set; }

        public DiagramAnalysis(CSETContext db, int assessment_id)
        {
            this.db = db;
            this.assessment_id = assessment_id;
            imageToTypePath = db.COMPONENT_SYMBOLS.ToDictionary(x => x.File_Name, x => x.Component_Symbol_Id);
            NetworkWarnings = new List<IDiagramAnalysisNodeMessage>();
        }

        public async Task<List<IDiagramAnalysisNodeMessage>> PerformAnalysis(XmlDocument xDoc)
        {
            String sal = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment_id).First().Selected_Sal_Level;
            SimplifiedNetwork network = new SimplifiedNetwork(this.imageToTypePath, sal);
            network.ExtractNetworkFromXml(xDoc);

            List<IDiagramAnalysisNodeMessage> msgs = await AnalyzeNetwork(network);
            return msgs;
        }

        private async Task<List<IDiagramAnalysisNodeMessage>> AnalyzeNetwork(SimplifiedNetwork network)
        {
            List<IRuleEvaluate> rules = new List<IRuleEvaluate>();
            rules.Add(new Rule1(network));
            rules.Add(new Rule2(network));
            rules.Add(new Rule3and4(network));
            rules.Add(new Rule5(network));
            rules.Add(new Rule6(network));
            rules.Add(new Rule7(network));
            //NetworkWalk walk = new NetworkWalk();
            //walk.printGraphSimple(network.Nodes.Values.ToList());
            List<IDiagramAnalysisNodeMessage> msgs = new List<IDiagramAnalysisNodeMessage>();
            foreach (IRuleEvaluate rule in rules)
            {
                msgs.AddRange(rule.Evaluate());
            }

            // number and persist warning messages
            using (CSETContext context = new CSETContext())
            {
                var oldWarnings = await context.NETWORK_WARNINGS.Where(x => x.Assessment_Id == assessment_id).ToListAsync();
                context.NETWORK_WARNINGS.RemoveRange(oldWarnings);
                await context.SaveChangesAsync();

                int n = 0;
                msgs.ForEach(async m =>
                {
                    StringBuilder sb = new StringBuilder();
                    m.SetMessages.ToList().ForEach(m2 =>
                    {
                        sb.AppendLine(m2);
                    });

                    m.Number = ++n;
                    var newNetworkWarning = new NETWORK_WARNINGS
                    {
                        Assessment_Id = assessment_id,
                        Id = m.Number,
                        WarningText = sb.ToString()
                    };
                    await context.NETWORK_WARNINGS.AddAsync(newNetworkWarning);
                });


                await context.SaveChangesAsync();
            }

            return msgs;
        }
    }
}