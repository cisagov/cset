//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.ImportAssessment
{
    public class BulkUploadToSql<T>
    {
        public IList<T> InternalStore { get; set; }
        public string TableName { get; set; }
        public int CommitBatchSize { get; set; } = 2000;
        public string ConnectionString { get; set; }

        public void Commit()
        {
            if (InternalStore.Count > 0)
            {
                DataTable dt;
                int numberOfPages = (InternalStore.Count / CommitBatchSize) + (InternalStore.Count % CommitBatchSize == 0 ? 0 : 1);
                for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++)
                {
                    dt = InternalStore.Skip(pageIndex * CommitBatchSize).Take(CommitBatchSize).ToDataTable();
                    BulkInsert(dt);
                }
            }
        }

        public void BulkInsert(DataTable dt)
        {
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                // make sure to enable triggers
                // more on triggers in next post
                SqlBulkCopy bulkCopy =
                    new SqlBulkCopy
                    (
                    connection,
                    SqlBulkCopyOptions.TableLock |
                    SqlBulkCopyOptions.FireTriggers |                    
                    SqlBulkCopyOptions.UseInternalTransaction,
                    null
                    );
                //bulkCopy.ColumnMappings.Clear();
                foreach (DataColumn col in dt.Columns)
                {
                    //if (!col.ColumnName.Equals("Answer_Id"))
                   bulkCopy.ColumnMappings.Add(col.ColumnName, col.ColumnName);
                }
                // set the destination table name
                bulkCopy.DestinationTableName = TableName;
                connection.Open();

                // write the data in the "dataTable"
                bulkCopy.WriteToServer(dt);
                connection.Close();
            }
        }
        /*
         * [Mark_For_Review] [bit] NULL,
	[Comment] [ntext] NULL,
	[Alternate_Justification] [ntext] NULL,
	[Is_Requirement] [bit] NOT NULL,
	[Question_Or_Requirement_Id] [int] NOT NULL,
	[Component_Id] [int] NOT NULL,
	[Question_Number] [int] NULL,
	[Answer_Text] [varchar](50) NOT NULL,
	[Component_Guid] [char](36) NULL,
	[Is_Component] [bit] NOT NULL,
	[Custom_Question_Guid] [varchar](50) NULL,
	[Is_Framework] [bit] NOT NULL,
	[Answer_Id] [int] IDENTITY(1,1) NOT NULL,
	[Assessment_Id] [int] NOT NULL,
	[Old_Answer_Id] [int] NULL,
         */
    }

    public static class BulkUploadToSqlHelper
    {
        public static DataTable ToDataTable<T>(this IEnumerable<T> data)
        {
            PropertyDescriptorCollection properties =
                TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            return table;
        }
    }
}

