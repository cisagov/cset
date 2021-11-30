namespace CSETWebCore.Reports.Models
{
    public class PdfDownloadModel
    {
        public string Action { get; set; }
        public string Controller { get; set; }
        public string View { get; set; }
        public string Filename { get; set; }

        public PdfDownloadModel()
        {
            Filename = "report.pdf";
        }
    }
}