using CSETWebCore.DataLayer.Model;
using System.Runtime.InteropServices;
using Excel = Microsoft.Office.Interop.Excel;


namespace CSETWebCore.AutoResponder
{
    internal class ExcelProcess
    {

        internal string BuildSheet(CSETContext _context, string password)
        {
            
            string path = CreateACopyOfTheFile();            
            BuildContactsSheet(path, GetData(_context),password);
            return path;
        }

        private List<ContactData> GetData(CSETContext context)
        {
            /*
             * CSETWebCore.AutoResponder
             SELECT FirstName,LastName,Organization_Name,PrimaryEmail
              FROM [dbo].[ASSESSMENTS] a join ASSESSMENT_CONTACTS c on a.Assessment_Id=c.Assessment_Id
              join DEMOGRAPHIC_ANSWERS d on a.Assessment_Id=d.Assessment_Id
            where a.ASSESSMENT_id > 30 and PrimaryEmail not like '%@inl.gov'
             */
            int tossOutCount = 30;
#if DEBUG
            tossOutCount = 0;
#endif
            var clist = from a in context.ASSESSMENTS
                        join c in context.ASSESSMENT_CONTACTS on a.Assessment_Id equals c.Assessment_Id
                        join d in context.DEMOGRAPHIC_ANSWERS on a.Assessment_Id equals d.Assessment_Id
                        where a.Assessment_Id > tossOutCount && !c.PrimaryEmail.EndsWith("@inl.gov")
                        select new ContactData()
                        {
                            FirstName = c.FirstName,
                            LastName = c.LastName,
                            OrganizationName = c.Organization_Name,
                            Email = c.PrimaryEmail
                        };
            return clist.ToList();
        }

        private string CreateACopyOfTheFile()
        {
            string excelFile = @"Survey contacts.xlsx";
            DateTime today = DateTime.Today;
            string fileName = "Survey Contacts"+ today.ToString("dd-MM-yyyy") + ".xlsx";
            string newFilePath = Path.Combine(Path.GetTempPath(), fileName);
            File.Copy(excelFile, newFilePath,true);
            //copy to a new 
            return newFilePath; 
        }


        private void BuildContactsSheet(string excelFile, List<ContactData> data, string password)
        {
            Excel.Application excel = null;
            Excel.Workbook workbook = null;
            Excel.Worksheet worksheet = null;
            try
            {
                excel = new Excel.Application { Visible = false, DisplayAlerts = false };

                workbook = excel.Workbooks.Open(excelFile);
                worksheet = (Excel.Worksheet)workbook.Worksheets[1];

                foreach(var contact in data)
                {
                    int newRow = worksheet.Range["A" + worksheet.Rows.Count, Type.Missing]
                                      .End[Excel.XlDirection.xlUp].Row + 1;

                    worksheet.Cells[newRow, 1] = contact.FirstName;
                    worksheet.Cells[newRow, 2] = contact.LastName;
                    worksheet.Cells[newRow, 3] = contact.OrganizationName;
                    worksheet.Cells[newRow, 4] = contact.Email;
                }
                // Save changes
                workbook.Password = password;
                workbook.Save();
            }
            catch (Exception ex) // Or System.Runtime.InteropServices.COMException
            {
                // Handle it or log or do nothing
            }
            finally
            {
                // Close Book and Excel and release COM Object
                workbook?.Close(0);
                excel?.Quit();
                Marshal.ReleaseComObject(excel);
            }
        }
    }

    internal class ContactData
    {
        public ContactData()
        {
        }

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string OrganizationName { get; set; }
        public string Email { get; set; }
    }
}
