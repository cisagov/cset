//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;

using Lucene.Net.Index;
using Lucene.Net.Documents;
using SearchIndex2;

namespace SearchIndex
{
    public static class TopicIndexer
    {
        public static void IndexTopics(CsetwebContext entity, IndexWriter writer)
        {
            foreach (CATALOG_RECOMMENDATIONS_DATA data in entity.CATALOG_RECOMMENDATIONS_DATA)
            {
                Lucene.Net.Documents.Document lucDoc = new Lucene.Net.Documents.Document();

                string text = "";
                text += " " + data.Heading + " " + data.Requirement + " " + data.Supplemental_Guidance + " " + data.Enhancement;

                lucDoc.Add(new Field(FieldNames.SHORT_NAME, data.Topic_Name, Field.Store.YES, Field.Index.ANALYZED));
                lucDoc.Add(new Field(FieldNames.TEXT, text, Field.Store.YES, Field.Index.ANALYZED));
                lucDoc.Add(new Field(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Catalog_Recommendation.ToString(), Field.Store.YES, Field.Index.NOT_ANALYZED));
                lucDoc.Add(new Field(FieldNames.DOC_ID, data.Data_Id.ToString(), Field.Store.YES, Field.Index.NO));
                writer.AddDocument(lucDoc); 
            }

            foreach (PROCUREMENT_LANGUAGE_DATA data in entity.PROCUREMENT_LANGUAGE_DATA)
            {
                Lucene.Net.Documents.Document lucDoc = new Lucene.Net.Documents.Document();

                string text = "";
                text += " " + data.Basis + " " + data.Language_Guidance + " " + data.Procurement_Language + " " + data.Fatmeasures + " " + data.Satmeasures + " " + data.Maintenance_Guidance;

                lucDoc.Add(new Field(FieldNames.SHORT_NAME, data.Topic_Name, Field.Store.YES, Field.Index.ANALYZED));
                lucDoc.Add(new Field(FieldNames.TEXT, text, Field.Store.YES, Field.Index.ANALYZED));
                lucDoc.Add(new Field(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Procurement_Language.ToString(), Field.Store.YES, Field.Index.NOT_ANALYZED));                lucDoc.Add(new Field(FieldNames.DOC_ID, data.Procurement_Id.ToString(), Field.Store.YES, Field.Index.NO));
                writer.AddDocument(lucDoc);
            }
 
        }


    }
}


