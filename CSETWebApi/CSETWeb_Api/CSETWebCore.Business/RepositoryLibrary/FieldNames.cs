//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Business.RepositoryLibrary
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
}