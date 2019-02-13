//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.IO;

namespace CSET_Main.DocumentLibrary
{
    public class DocumentObject
    {
        public String Title
        {
            get { return Doc.Title; }
            set 
            {
                Doc.Title = value;
                this.assessmentContext.SaveChanges();
                
            }
        }

        public String DocPath
        {
            get { return Doc.Path; }
            set
            {
                Doc.Path = value;
                this.assessmentContext.SaveChanges();
                
            }
        }

        public String DocPathFileName
        {
            get { return Path.GetFileName(DocPath); }            
           
        }


        public int Document_Id
        {
            get { return Doc.Document_Id; }
            set { Doc.Document_Id = value; }
        }

        private CsetwebContext assessmentContext;
        private DOCUMENT_FILE doc;
        public DOCUMENT_FILE Doc
        {
            get { return doc; } 
            private set
            {
                doc = value;
                
                this.Title = doc.Title;
            }
        }

        

        public DocumentObject()
        {
            
            this.Doc = new DOCUMENT_FILE();
        }

        public DocumentObject(CsetwebContext assessmentContext, DOCUMENT_FILE doc)
        {
            this.assessmentContext = assessmentContext;
            this.doc = doc;
        }

       

    }
}


