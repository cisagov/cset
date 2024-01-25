//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using DocumentFormat.OpenXml;

namespace CSETWebCore.ExportCSV
{

    public class DataMap
    {
        public Headers Headers { get; set; }

        public string Name { get; internal set; }
        public DataTable Table { get; set; }

    }

    public class Headers : IEnumerable
    {
        private Dictionary<string, string> fieldToDisplay = new Dictionary<string, string>();

        public List<Header> HeaderList { get; set; }

        public void AddHeader(Header header)
        {
            fieldToDisplay.Add(header.FieldName, header.DisplayName);
            HeaderList.Add(header);
        }

        public IEnumerator GetEnumerator()
        {
            return ((IEnumerable)HeaderList).GetEnumerator();
        }

        public string this[string key]
        {
            get
            {
                return fieldToDisplay[key];
            }
            set
            {
                fieldToDisplay[key] = value;
            }
        }

        public Header this[int index]
        {
            get
            {
                return HeaderList[index];
            }
            set
            {
                HeaderList[index] = value;
            }
        }

        public int Count
        {
            get
            {
                return HeaderList.Count;
            }
        }
    }

    public class Header
    {
        public Header(String fieldName, string displayName)
        {
            this.FieldName = fieldName;
            this.DisplayName = displayName;
        }

        public string FieldName { get; set; }
        public string DisplayName { get; set; }
        public DoubleValue ColumnWidth { get; internal set; }
    }
}