//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Text;
using System.Xml;

namespace CSETWebCore.Interfaces.Common
{
    public interface IHtmlFromXamlConverter
    {
        string ConvertXamlToHtml(string xamlString);
        bool WriteFlowDocument(XmlTextReader xamlReader, XmlTextWriter htmlWriter);
        void WriteFormattingProperties(XmlTextReader xamlReader, XmlTextWriter htmlWriter, StringBuilder inlineStyle);
        string ParseXamlColor(string color);
        string ParseXamlThickness(string thickness);
        void WriteElementContent(XmlTextReader xamlReader, XmlTextWriter htmlWriter, StringBuilder inlineStyle);
        void AddComplexProperty(XmlTextReader xamlReader, StringBuilder inlineStyle);
        void WriteElement(XmlTextReader xamlReader, XmlTextWriter htmlWriter, StringBuilder inlineStyle);
        bool ReadNextToken(XmlReader xamlReader);
    }
}