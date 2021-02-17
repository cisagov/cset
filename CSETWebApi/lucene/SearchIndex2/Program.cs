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
using System.Xml;
using System.IO;
using Lucene.Net.Index;
using Lucene.Net.Analysis;
using Lucene.Net.Store;
using Lucene.Net.Documents;

using System.Diagnostics;
using Lucene.Net.Analysis.Standard;
using SearchIndex2;

namespace SearchIndex
{
    class Program
    {
        //private static String entityConnectionString = @"metadata=res://*/Data.ControlData.csdl|res://*/Data.ControlData.ssdl|res://*/Data.ControlData.msl;provider=System.Data.SqlServerCe.4.0;provider connection string=""Data Source=Data\CSET_Control.mdf; File Mode=shared read;Max Database Size=3072"";";

        static void Main(string[] args)
        {
            //String directoryPath = System.IO.Directory.GetParent(AppDomain.CurrentDomain.BaseDirectory).Parent.Parent.Parent.Parent.Parent.FullName;
            //string combPath = Path.Combine(directoryPath, @"src\CSET_Main\Data");
            //string dataPath = Path.GetFullPath(combPath);
            //AppDomain.CurrentDomain.SetData("DataDirectory", dataPath);

            Program p = new Program();
            p.IndexDocs();

        }

        public void IndexDocs()
        {
            string solutionPath = System.IO.Directory.GetParent(AppDomain.CurrentDomain.BaseDirectory).Parent.Parent.Parent.Parent.FullName;

            string documentDirectory = solutionPath + @"\CSETWeb_Api\CSETWeb_Api\Documents";
            string fullDocumentDirectory = Path.GetFullPath(documentDirectory);

            string luceneIndexDir = solutionPath + @"\CSETWeb_Api\CSETWeb_Api\LuceneIndex2";
            string luceneIndexDestDir = solutionPath + @"\CSETWeb_Api\CSETWeb_Api\LuceneIndex"; 
            
            CsetwebContext entity = new CsetwebContext();
            Dictionary<int, GEN_FILE> dictionaryGenFiles = entity.GEN_FILE.ToDictionary(x => x.Gen_File_Id, x=>x);

            List<REF_LIBRARY_PATH> listLibDocs = entity.REF_LIBRARY_PATH.ToList();
            int count = 0;
            Debug.WriteLine("Number of Resource Nodes: " + listLibDocs.Count);


            if (System.IO.Directory.Exists(luceneIndexDir))
                System.IO.Directory.Delete(luceneIndexDir, true);

            DirectoryInfo di = System.IO.Directory.CreateDirectory(luceneIndexDir);

            DirectoryInfo dir = new DirectoryInfo(luceneIndexDir);


            FSDirectory fsdir = FSDirectory.Open(dir);

            using (IndexWriter writer = new IndexWriter(fsdir, new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_30), true, IndexWriter.MaxFieldLength.UNLIMITED))
            {
              
               
                
                Debug.WriteLine("Documents Count: " + dictionaryGenFiles.Values.Count);
                foreach (GEN_FILE doc in dictionaryGenFiles.Values)
                {
                    //if (count > 30)
                    //   break;

                    string filepath = fullDocumentDirectory + @"\" + doc.File_Name;
                    bool exists = File.Exists(filepath);
                    if (exists)
                    {
                        if (Path.GetExtension(filepath).ToLower() == ".pdf")
                        {
                            Document lucDoc = PDFParser.ParseDocument(filepath, doc);
                            writer.AddDocument(lucDoc);
                            Debug.WriteLine("Count: " + count + " Processed file: " + filepath);
                            count++;
                        }
                        else if (Path.GetExtension(filepath).ToLower() == ".docx")
                        {
                            Document lucDoc = WordParser.ParseDocument(filepath, doc);
                            writer.AddDocument(lucDoc);
                            Debug.WriteLine("Count: " + count + "Processed file: " + filepath);
                            count++;
                        }
                        else
                        {
                            Debug.Assert(false, "Can't read file because bad extension. Extension:" + filepath);
                        }
                    }
                    else
                    {
                        Debug.WriteLine("File doesn't exist:" + filepath);
                    }


                }

                TopicIndexer.IndexTopics(entity, writer);


                writer.Optimize();

            }
            
            System.IO.Directory.Delete(luceneIndexDestDir,true);            
            System.IO.Directory.Move(luceneIndexDir, luceneIndexDestDir);

        }


    }
}


