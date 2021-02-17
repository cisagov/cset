//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using org.apache.pdfbox.util;
using org.apache.pdfbox.cos;
using org.apache.pdfbox.pdmodel;
using Lucene.Net.Documents;
using System.IO;
using System.Diagnostics;
using SearchIndex2;

namespace SearchIndex
{
    public class PDFParser
    {

        public static Document ParseDocument(string filePath, GEN_FILE doc)
        {
            string author = null;
            string keywords = null;
            string summary = null;
            string text = null;
          
            try
            {
                PDFTextStripper stripper = new PDFTextStripper();
                PDDocument document = PDDocument.load(filePath);
                text = stripper.getText(document);
                PDDocumentInformation info = document.getDocumentInformation();
                author = info.getAuthor();         
                keywords = info.getKeywords();
                summary = info.getSubject();
                document.close();
            }
            catch(Exception ex)
            {
                Debug.WriteLine("Exception in reading file: " + filePath + " ex: " + ex.Message);
            }
            Document lucDoc = new Document();
            string filename = Path.GetFileNameWithoutExtension(doc.File_Name);
            string short_name = doc.Short_Name;
            string title = doc.Title;
            string header = doc.Summary;
            string doc_id = doc.Gen_File_Id.ToString();
            Debug.WriteLine("DocID: " + doc_id);

            StringBuilder keyTextBuilder = new StringBuilder();
            foreach (FILE_KEYWORDS keywordobj in doc.FILE_KEYWORDs.ToList())
            {
                keyTextBuilder.Append(keywordobj.Keyword + " ");
 
            }
            string keyword = keyTextBuilder.ToString();

           lucDoc.Add(new Field(FieldNames.FILE_NAME, filename, Field.Store.YES, Field.Index.ANALYZED));
           if(author != null && author.Trim() != "") 
            lucDoc.Add(new Field(FieldNames.AUTHOR, author, Field.Store.YES, Field.Index.ANALYZED));
             
           if(keywords != null && keywords.Trim() != "") 
            lucDoc.Add(new Field(FieldNames.KEYWORDS, keywords, Field.Store.YES, Field.Index.ANALYZED));

           if(summary != null && summary.Trim() != "") 
            lucDoc.Add(new Field(FieldNames.SUMMARY, summary, Field.Store.YES, Field.Index.ANALYZED));
           lucDoc.Add(new Field(FieldNames.SHORT_NAME, short_name, Field.Store.YES, Field.Index.ANALYZED));
           lucDoc.Add(new Field(FieldNames.TITLE, title, Field.Store.YES, Field.Index.ANALYZED));
       
           if(!String.IsNullOrWhiteSpace(header))
                lucDoc.Add(new Field(FieldNames.HEADER, header, Field.Store.YES, Field.Index.ANALYZED));
            if(text != null && text.Trim() != "")
                lucDoc.Add(new Field(FieldNames.TEXT, text, Field.Store.YES, Field.Index.ANALYZED));

            lucDoc.Add(new Field(FieldNames.DOC_ID, doc_id, Field.Store.YES, Field.Index.NO));
            lucDoc.Add(new Field(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Resource_Doc.ToString(), Field.Store.YES, Field.Index.NOT_ANALYZED));


         return lucDoc;
            

     


          





          
        }

        public static Document Document(System.IO.FileInfo f)
        {

            // make a new, empty document
            Document doc = new Document();

            // Add the path of the file as a field named "path".  Use a field that is 
            // indexed (i.e. searchable), but don't tokenize the field into words.
            doc.Add(new Field("path", f.FullName, Field.Store.YES, Field.Index.NOT_ANALYZED));


            // Add the contents of the file to a field named "contents".  Specify a Reader,
            // so that the text of the file is tokenized and indexed, but not stored.
            // Note that FileReader expects the file to be in the system's default encoding.
            // If that's not the case searching for special characters will fail.
            doc.Add(new Field("contents", new System.IO.StreamReader(f.FullName, System.Text.Encoding.Default)));

            // return the document
            return doc;
        }
    }
}


