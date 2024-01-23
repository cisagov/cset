//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    internal class CSETDataPatches
    {
        /// <summary>
        /// 
        /// </summary>
        public void UpdatePatches(CSETContext context)
        {
            var stuff = new System.Collections.Generic.Dictionary<string, object>();
            DBIO dbio = new DBIO(context);
            dbio.Execute("UPDATE[dbo].[GEN_FILE] SET[File_Type_Id] = 40, [Summary]= 'An Excel spreadsheet representation of the CMMC Model Version 1.02, March 2020' WHERE[Gen_File_Id] = 3960", stuff);


            string tsql = "IF (NOT EXISTS (SELECT * \n" +
            "                 FROM INFORMATION_SCHEMA.TABLES \n" +
            "                 WHERE TABLE_SCHEMA = 'dbo' \n" +
            "                 AND  TABLE_NAME = 'Answer_Order'))\n" +
            "BEGIN\n" +
            "	CREATE TABLE [dbo].[ANSWER_ORDER](\n" +
            "		[Answer_Text] [varchar](50) NOT NULL,\n" +
            "		[answer_order] [int] NOT NULL,\n" +
            "	 CONSTRAINT [PK_ANSWER_ORDER] PRIMARY KEY CLUSTERED \n" +
            "	(\n" +
            "		[Answer_Text] ASC\n" +
            "	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]\n" +
            "	) ON [PRIMARY];\n" +
            "END\n" +
            "if (not exists (select * from ANSWER_ORDER where answer_text = N'N'))\n" +
            "begin\n" +
            "	INSERT [dbo].[ANSWER_ORDER] ([Answer_Text], [answer_order]) VALUES (N'N', 2);\n" +
            "end\n" +
            "if (not exists (select * from ANSWER_ORDER where answer_text = N'U'))\n" +
            "begin\n" +
            "	INSERT [dbo].[ANSWER_ORDER] ([Answer_Text], [answer_order]) VALUES (N'U', 3);\n" +
            "end\n" +
            "if (not exists (select * from ANSWER_ORDER where answer_text = N'Y'))\n" +
            "begin\n" +
            "	INSERT [dbo].[ANSWER_ORDER] ([Answer_Text], [answer_order]) VALUES (N'Y', 1);\n" +
            "end\n";

            dbio.Execute(tsql, stuff);


            tsql = "SET IDENTITY_INSERT [dbo].[MATURITY_MODELS] ON\n" +
            "if (not exists (select * from maturity_models where Maturity_Model_Id = 4))\n" +
            "INSERT INTO [dbo].[MATURITY_MODELS] ([Maturity_Model_Id], [Model_Name], [Questions_Alias], [Answer_Options]) VALUES (4, 'CRR', 'Practices', 'Y,I,N')\n" +
            "if (not exists (select * from maturity_models where Maturity_Model_Id = 5))\n" +
            "INSERT INTO [dbo].[MATURITY_MODELS] ([Maturity_Model_Id], [Model_Name], [Questions_Alias], [Answer_Options]) VALUES (5, 'RRA', 'Practices', 'Y,N')\n" +
            "SET IDENTITY_INSERT [dbo].[MATURITY_MODELS] OFF\n";

            dbio.Execute(tsql, stuff);
        }
    }
}
