using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.AssessmentIO
{
    public class AssessmentExportFile
    {
        public AssessmentExportFile(string fileName, Stream fileContents) 
        { 
            FileName = fileName;
            FileContents = fileContents;
        }

        public string FileName { get; set; }

        public Stream FileContents { get; set; }
    }
}
