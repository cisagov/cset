//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Lucene.Net.Documents;

using System.Diagnostics;
using SearchIndex2;

namespace SearchIndex
{
   
    public static class FieldNames
    {
        public static string FILE_NAME { get { return "FileName"; } }
        public static string AUTHOR { get { return "Author"; } }
        public static string KEYWORDS { get { return "Keywords"; } }
        public static string SUMMARY { get { return "Summary"; } }
        public static string TITLE { get { return "Title"; } }
        public static string SHORT_NAME { get { return "ShortName"; } }
        public static string HEADER { get { return "Header"; } }
        public static string TEXT { get { return "Text"; } }
        public static string DOC_ID { get { return "Doc_ID"; } }
        public static string RESOURCE_TYPE { get { return "RESOURCE_TYPE"; } }
        public static string[] Array_Field_Names = new String[] { FILE_NAME, AUTHOR, KEYWORDS, SUMMARY, TITLE, SHORT_NAME, HEADER, TEXT, DOC_ID, RESOURCE_TYPE };
    }

    public enum ResourceTypeEnum
    {
        Procurement_Language, Catalog_Recommendation, Resource_Doc
    }
   
    public static class LocalExtension
    {
        public static IEnumerable<OpenXmlElement> DescendantsTrimmed(
     this OpenXmlElement element, Type trimType)
        {
            return DescendantsTrimmed(element, e => e.GetType() == trimType);
        }

        private static IEnumerable<OpenXmlElement> DescendantsTrimmed(
            this OpenXmlElement element, Func<OpenXmlElement, bool> predicate)
        {
            Stack<IEnumerator<OpenXmlElement>> iteratorStack =
                new Stack<IEnumerator<OpenXmlElement>>();
            iteratorStack.Push(element.Elements().GetEnumerator());
            while (iteratorStack.Count > 0)
            {
                while (iteratorStack.Peek().MoveNext())
                {
                    OpenXmlElement currentOpenXmlElement = iteratorStack.Peek().Current;
                    if (predicate(currentOpenXmlElement))
                    {
                        yield return currentOpenXmlElement;
                        continue;
                    }
                    yield return currentOpenXmlElement;
                    iteratorStack.Push(currentOpenXmlElement.Elements().GetEnumerator());
                }
                iteratorStack.Pop();
            }
        }

        private static Type[] SubRunLevelContent =
    {
        typeof(Break),
        typeof(CarriageReturn),
        typeof(DayLong),
        typeof(DayShort),
        typeof(Drawing),
        typeof(MonthLong),
        typeof(MonthShort),
        typeof(NoBreakHyphen),
        typeof(PageNumber),
        typeof(Picture),
        typeof(PositionalTab),
        typeof(SoftHyphen),
        typeof(SymbolChar),
        typeof(TabChar),
        typeof(Text),
        typeof(YearLong),
        typeof(YearShort),
        typeof(AlternateContent),
    };

        public static IEnumerable<OpenXmlElement> LogicalChildrenContent(
            this OpenXmlElement element)
        {
            if (element is DocumentFormat.OpenXml.Wordprocessing.Document)
                return (IEnumerable<OpenXmlElement>)element.Descendants<Body>().Take(1)
                    .Cast<OpenXmlElement>();
            if (element is Body ||
                element is TableCell ||
                element is TextBoxContent)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(e =>
                        e is Table ||
                        e is Paragraph)
                    .Where(e =>
                        e is Paragraph ||
                        e is Table);
            if (element is Table)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(typeof(TableRow))
                    .Where(e => e is TableRow);
            if (element is TableRow)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(typeof(TableCell))
                    .Where(e => e is TableCell);
            if (element is Paragraph)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(e => e is Run ||
                        e is Picture ||
                        e is Drawing)
                    .Where(e => e is Run ||
                        e is Picture ||
                        e is Drawing);
            if (element is Run)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(e => SubRunLevelContent.Contains(e.GetType()))
                    .Where(e => SubRunLevelContent.Contains(e.GetType()));
            if (element is AlternateContent)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(e =>
                        e is Picture ||
                        e is Drawing ||
                        e is AlternateContentFallback)
                    .Where(e =>
                        e is Picture ||
                        e is Drawing);
            if (element is Picture || element is Drawing)
                return (IEnumerable<OpenXmlElement>)element
                    .DescendantsTrimmed(typeof(TextBoxContent))
                    .Where(e => e is TextBoxContent);
            return new OpenXmlElement[] { };
        }

        public static IEnumerable<OpenXmlElement> LogicalChildrenContent(
            this IEnumerable<OpenXmlElement> source)
        {
            foreach (OpenXmlElement e1 in source)
                foreach (OpenXmlElement e2 in e1.LogicalChildrenContent())
                    yield return e2;
        }

        public static IEnumerable<OpenXmlElement> LogicalChildrenContent(
            this OpenXmlElement element, Type typeName)
        {
            return element.LogicalChildrenContent().Where(e => e.GetType() == typeName);
        }

        public static IEnumerable<OpenXmlElement> LogicalChildrenContent(
            this IEnumerable<OpenXmlElement> source, Type typeName)
        {
            foreach (OpenXmlElement e1 in source)
                foreach (OpenXmlElement e2 in e1.LogicalChildrenContent(typeName))
                    yield return e2;
        }

        public static string StringConcatenate(this IEnumerable<string> source)
        {
            StringBuilder sb = new StringBuilder();
            foreach (string s in source)
                sb.Append(s);
            return sb.ToString();
        }
    }

    public class WordParser
    {
        public static string ParagraphText(OpenXmlElement element)
        {
            string paragraphText = "";
            if (element is Paragraph)
            {
                paragraphText = element
                    .LogicalChildrenContent(typeof(Run))
                    .LogicalChildrenContent(typeof(Text))
                    .OfType<Text>()
                    .Select(s => s.Text)
                    .StringConcatenate();
            }
            return paragraphText;
        }

        public static Lucene.Net.Documents.Document ParseDocument(string filePath, GEN_FILE resdoc_Entity)
        {

            StringBuilder textBuilder = new StringBuilder();

            using (WordprocessingDocument doc = WordprocessingDocument.Open(filePath, false))
            {
                OpenXmlElement root = doc.MainDocumentPart.Document;
                Body body = (Body)root.LogicalChildrenContent().First();

               foreach (OpenXmlElement blockLevelContentElement in
                    body.LogicalChildrenContent())
                {
                    if (blockLevelContentElement is Paragraph)
                    {
                        string pText = blockLevelContentElement
                            .LogicalChildrenContent(typeof(Run))
                            .LogicalChildrenContent(typeof(Text))
                            .OfType<Text>()
                            .Select(t => t.Text)
                            .StringConcatenate();
                        textBuilder.Append(pText);
                        textBuilder.Append(Environment.NewLine);
                    }
                }
            }

            string text = textBuilder.ToString();

            Lucene.Net.Documents.Document lucDoc = new Lucene.Net.Documents.Document();
            string filename = Path.GetFileNameWithoutExtension(resdoc_Entity.File_Name);
            string author = null;

            StringBuilder keyTextBuilder = new StringBuilder();
            foreach (FILE_KEYWORDS keywordobj in resdoc_Entity.FILE_KEYWORDS.ToList())
            {
                keyTextBuilder.Append(keywordobj.Keyword + " ");

            }
            string keywords = keyTextBuilder.ToString();
            string summary = null;
            string short_name = resdoc_Entity.Short_Name;
            string title = resdoc_Entity.Title;
            string header = resdoc_Entity.Summary;
            string doc_id = resdoc_Entity.Gen_File_Id.ToString();
            Debug.WriteLine("DocID: " + doc_id);


            lucDoc.Add(new Field(FieldNames.FILE_NAME, filename, Field.Store.YES, Field.Index.ANALYZED));
            if (author != null && author.Trim() != "")
                lucDoc.Add(new Field(FieldNames.AUTHOR, author, Field.Store.YES, Field.Index.ANALYZED));

            if (keywords != null && keywords.Trim() != "")
                lucDoc.Add(new Field(FieldNames.KEYWORDS, keywords, Field.Store.YES, Field.Index.ANALYZED));

            if (summary != null && summary.Trim() != "")
                lucDoc.Add(new Field(FieldNames.SUMMARY, summary, Field.Store.YES, Field.Index.ANALYZED));
            lucDoc.Add(new Field(FieldNames.SHORT_NAME, short_name, Field.Store.YES, Field.Index.ANALYZED));
            lucDoc.Add(new Field(FieldNames.TITLE, title, Field.Store.YES, Field.Index.ANALYZED));

            lucDoc.Add(new Field(FieldNames.HEADER, header, Field.Store.YES, Field.Index.ANALYZED));


            if (text != null && text.Trim() != "")
                lucDoc.Add(new Field(FieldNames.TEXT, text, Field.Store.YES, Field.Index.ANALYZED));

            lucDoc.Add(new Field(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Resource_Doc.ToString(), Field.Store.YES, Field.Index.NOT_ANALYZED));
            lucDoc.Add(new Field(FieldNames.DOC_ID, doc_id, Field.Store.YES, Field.Index.NO));

            return lucDoc;
        }
    }




}


