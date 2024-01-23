//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;


namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Returns a list of domain-specific heatmaps containing 
    /// CRR questions mapped to various CSF functions and categories.
    /// 
    /// TODO:  Finish this once it is determined how the 
    /// NIST CSF mapped questions will be supplied to this class.
    /// </summary>
    public class NistDomainBlock
    {
        /// <summary>
        /// A working document where we build the structure that feeds the heatmap
        /// </summary>
        private XDocument _xMappedAnswers;


        /// <summary>
        /// A list of CRR reference questions that may include multiple domains
        /// </summary>
        private List<XElement> _crrRefs;


        /// <summary>
        /// The collection of SVG images that are built by this class
        /// </summary>
        public List<string> HeatmapList = new List<string>();


        /// <summary>
        /// The asset type letters in their display order
        /// </summary>
        private readonly List<string> assetTypeAbbrevs = new List<string>() { "P", "I", "T", "F" };


        /// <summary>
        /// Initializes an XDocument with the CRR questions in Domain/Question structure.
        /// Each Domain element is then used to render a heatmap SVG for that domain.
        /// </summary>
        public NistDomainBlock(List<XElement> crrRefs, bool isCategory)
        {
            _crrRefs = crrRefs;
            _xMappedAnswers = new XDocument(new XElement("MappedAnswers"));


            foreach (var crrRef in _crrRefs)
            {
                var questionT = crrRef.Attribute("question-title").Value;
                string[] parts = questionT.Split(":");
                var domainAbbrev = parts[0];
                var questionTitle = parts[1];
                var assetType = "";


                // find or create the Domain node
                var xDomain = _xMappedAnswers.XPathSelectElement($"*/Domain[@abbrev='{domainAbbrev}']");
                if (xDomain == null)
                {
                    xDomain = new XElement("Domain");
                    xDomain.SetAttributeValue("abbrev", domainAbbrev);
                    _xMappedAnswers.Root.Add(xDomain);
                }

                if (questionTitle.IndexOf("-") > 0)
                {
                    var parts2 = questionTitle.Split("-");
                    questionTitle = parts2[0];
                    assetType = parts2[1];
                }

                // find or create the Question node
                var xQuestion = xDomain.XPathSelectElement($"Question[@title='{questionTitle}']");
                if (xQuestion == null)
                {
                    xQuestion = new XElement("Question");
                    xQuestion.SetAttributeValue("title", questionTitle);
                    xDomain.Add(xQuestion);

                    // add PITF placeholders
                    if (assetType != "")
                    {
                        foreach (var ata in assetTypeAbbrevs)
                        {
                            var xAssetType = new XElement("AssetType");
                            xAssetType.SetAttributeValue("letter", ata);
                            xAssetType.SetAttributeValue("answer", "");
                            xQuestion.Add(xAssetType);
                        }
                    }
                }


                var answer = crrRef.Attribute("answer")?.Value ?? "";

                if (assetType == "")
                {
                    xQuestion.SetAttributeValue("answer", answer);
                    xQuestion.SetAttributeValue("scorecolor", ScoreColor(answer));
                }
                else
                {
                    var xAssetType = xQuestion.Elements("AssetType").First(x => x.Attribute("letter").Value == assetType);
                    xAssetType.SetAttributeValue("answer", answer);
                    xAssetType.SetAttributeValue("scorecolor", ScoreColor(answer));
                }
            }


            // build a heatmap for each domain
            foreach (var xDomain in _xMappedAnswers.Root.Elements("Domain"))
            {
                var heatmap = new CsfHeatmap(xDomain);
                HeatmapList.Add(heatmap.ToString());
            }

            // build a placeholder heatmap if there are no mapped questions
            // and we are not building heatmaps for a category
            if (!isCategory && crrRefs.Count == 0)
            {
                var xDomain = new XElement("Domain");
                xDomain.SetAttributeValue("abbrev", "");
                xDomain.SetAttributeValue("title", "NA");
                xDomain.SetAttributeValue("na", "true");
                var heatmap = new CsfHeatmap(xDomain);
                HeatmapList.Add(heatmap.ToString());
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answer"></param>
        /// <returns></returns>
        private string ScoreColor(string answer)
        {
            switch (answer)
            {
                case "Y":
                    return "green";
                case "I":
                    return "yellow";
                default:
                    return "red";
            }
        }
    }
}
