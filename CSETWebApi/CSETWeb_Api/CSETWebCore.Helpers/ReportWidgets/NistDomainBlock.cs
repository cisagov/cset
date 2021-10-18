using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Renders a 2D block of question scores that have been
    /// supplied.  
    /// 
    /// TODO:  Finish this once it is determined how the 
    /// NIST CSF mapped questions will be supplied to this class.
    /// </summary>
    public class NistDomainBlock
    {
        private XDocument _xMappedAnswers;
        private XDocument _xAllAnswers;

        private XDocument _xSvgDoc;
        private XElement _xSvg;

        public List<XElement> _crrRefs;


        /// <summary>
        /// Constructor.
        /// </summary>
        public NistDomainBlock(List<XElement> crrRefs, XDocument xAllAnswers)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            _crrRefs = crrRefs;
            _xAllAnswers = xAllAnswers;


            _xMappedAnswers = new XDocument(new XElement("MappedAnswers"));


            // TODO:  TBD
            _xSvg.SetAttributeValue("width", 1000);
            _xSvg.SetAttributeValue("height", 400);

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif}";

            // DUMMY PLACEHOLDER ----------------------------------------------
            var xDummy = new XElement("rect");
            _xSvg.Add(xDummy);
            xDummy.SetAttributeValue("width", 120);
            xDummy.SetAttributeValue("height", 200);
            xDummy.SetAttributeValue("fill", "#ddd");
            xDummy.SetAttributeValue("rx", 4);
            // ----------------------------------------------------------------


            Initialize();
        }





        /// <summary>
        /// Feed this guy a list of CRR 
        /// </summary>
        public void Initialize()
        {
            var assetTypes = new List<string>() { "P", "I", "T", "F" };

            foreach (var crrRef in _crrRefs)
            {
                var title = crrRef.Attribute("question-title").Value;
                string[] parts = title.Split(":");
                var domain = parts[0];
                var questionTitle = parts[1];
                var assetType = "";


                // find or create the Domain node
                var xDomain = _xMappedAnswers.XPathSelectElement($"*/Domain[@abbrev='{domain}']");
                if (xDomain == null)
                {
                    xDomain = new XElement("Domain");
                    xDomain.SetAttributeValue("abbrev", domain);
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
                        foreach (var at in assetTypes)
                        {
                            var xAssetType = new XElement("AssetType");
                            xAssetType.SetAttributeValue("letter", at);
                            xAssetType.SetAttributeValue("answer", "");
                            xAssetType.SetAttributeValue("mapped", false); // asset types not mapped will display light gray
                            xQuestion.Add(xAssetType);
                        }
                    }
                }

                // find answer value 
                var answerElement = _xAllAnswers.XPathSelectElement($"//Question[@displaynumber='{title}']");

                if (assetType != "")
                {
                    var xAssetType = xQuestion.Elements("AssetType").First(x => x.Attribute("letter").Value == assetType);
                    xAssetType.SetAttributeValue("mapped", true);
                    xAssetType.SetAttributeValue("answer", answerElement?.Attribute("answer").Value);
                    xAssetType.SetAttributeValue("scorecolor", answerElement?.Attribute("scorecolor").Value);
                }
                else
                {
                    xQuestion.SetAttributeValue("answer", answerElement?.Attribute("answer").Value);
                    xQuestion.SetAttributeValue("scorecolor", answerElement?.Attribute("scorecolor").Value);
                }
            }

        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return _xSvgDoc.ToString();
        }
    }
}
