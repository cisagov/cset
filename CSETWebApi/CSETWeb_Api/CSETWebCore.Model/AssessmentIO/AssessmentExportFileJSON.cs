using System.IO;

namespace CSETWebCore.Model.AssessmentIO
{
    public class AssessmentExportFileJson
    {
        public AssessmentExportFileJson(string fileName, string jsonFile) 
        { 
            FileName = fileName;
            JSON = jsonFile;
        }

        public string FileName { get; set; }

        public string JSON { get; set; }
    }
}